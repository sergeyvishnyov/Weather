//
//  WeatherViewController.swift
//  Weather
//
//  Created by Sergey Vishnyov on 15.12.21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var currentView: UIView!
    var currentViewHeightOriginal: Double!
    @IBOutlet var currentViewHeight: NSLayoutConstraint!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!

    @IBOutlet var temperatureView: UIView!
    @IBOutlet var temperatureViewHeight: NSLayoutConstraint!
    @IBOutlet var temperatureLabel: UILabel!

    @IBOutlet var tableView: UITableView!
    var tableViewHeaderHeight: Double! = 120.0
    var dayTableViewCellHeight = 40.0
    var currentTableViewCellHeight = 64.0
    let cellReuseIdentifierDay = "DayTableViewCell"
    let cellReuseIdentifierCurrent = "CurrentTableViewCell"
    let cellReuseIdentifierHour = "HourCollectionViewCell"
    let cellReuseIdentifierSun = "SunCollectionViewCell"

    var currentHour: HourEntity?
    var hours = [HourEntity]()
    var days = [DayEntity]()
    var today: DayEntity?

    let currentTypes = CurrentType.allCases
    
    var placemark: CLPlacemark?

    let manager: WeatherManager! = WeatherManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: cellReuseIdentifierDay, bundle: nil),
                                  forCellReuseIdentifier: cellReuseIdentifierDay)
        tableView.register(UINib(nibName: cellReuseIdentifierCurrent, bundle: nil),
                                  forCellReuseIdentifier: cellReuseIdentifierCurrent)
        tableView.isHidden = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0 // remove extra padding above tableView headers in iOS 15
        }

        currentView.isHidden = true
        currentViewHeightOriginal = currentView.frame.size.height
        
        manager.initLocationManager(self)
    }
    
    func loadData() {
        let group = DispatchGroup()

        group.enter()
        manager.getCity { placemark in
            self.placemark = placemark
            group.leave()
        } failed: { error in
            group.leave()
        }
        
        group.enter()
        manager.getWeather { current, hours, days in
            self.currentHour = current
            self.hours = hours

            for i in 1...hours.count - 1 {
                let hour = self.hours[i-1]
                let nextHour = self.hours[i]
                for day in days {
                    if hour.dt == nil { continue }
                    if (day.sunset)! > hour.dt! && (day.sunset)! < nextHour.dt! {
                        let sunHour = HourEntity()
                        sunHour.sunset = day.sunset
                        self.hours.insert(sunHour, at: i)
                    }
                    if (day.sunrise)! > hour.dt! && (day.sunrise)! < nextHour.dt! {
                        let sunHour = HourEntity()
                        sunHour.sunrise = day.sunrise
                        self.hours.insert(sunHour, at: i)
                    }
                }
            }

            self.days = days
            if let today = days.first {
                self.today = today
                self.days.removeFirst()
            }
            group.leave()
        } failed: { error in
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    func updateUI () {
        activityIndicatorView.stopAnimating()
        
        currentView.isHidden = false
        cityLabel.text = placemark?.locality ?? placemark?.name
        weatherLabel.text = currentHour?.weather?.weatherDescription
        temperatureLabel.text = currentHour?.temp?.toString()

        tableView.isHidden = false
        tableView.reloadData()
    }
    
//  MARK: - UITableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let hoursCollectionView = Bundle.main.loadNibNamed("HoursCollectionView",
                                                           owner: nil,
                                                           options: nil)?.first as! HoursCollectionView
            hoursCollectionView.register(UINib(nibName: cellReuseIdentifierHour, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifierHour)
            hoursCollectionView.register(UINib(nibName: cellReuseIdentifierSun, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifierSun)
            hoursCollectionView.hours = hours
            return hoursCollectionView
        } else {
            return UIView.init()
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row >= days.count ? currentTableViewCellHeight : dayTableViewCellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : days.count + currentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= days.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierCurrent) as! CurrentTableViewCell
            let currentType = currentTypes[indexPath.row - days.count]
            cell.set(currentType, currentHour)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierDay) as! DayTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0,
                                               left: indexPath.row == days.count - 1 ? 0 : tableView.viewWidth,
                                               bottom: 0,
                                               right: 0)
            if indexPath.section == 0 {
                cell.set(today!, isToday: true)
            } else {
                let day = days[indexPath.row]
                cell.set(day, isToday: false)
            }
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
//        print(offsetY)
        let indexpath = IndexPath(row: 0, section: 0)
        if let currentCell = tableView.cellForRow(at: indexpath) as? DayTableViewCell {
            if offsetY > 0 {
                let height = dayTableViewCellHeight * 2
                temperatureView.alpha = (height - offsetY) / height
                let alpha = (dayTableViewCellHeight - offsetY) / dayTableViewCellHeight
                currentCell.alpha = alpha
            } else {
                temperatureView.alpha = 1
                currentCell.alpha = 1
                currentViewHeight.constant = currentViewHeightOriginal - offsetY
            }
        }
    }

}

