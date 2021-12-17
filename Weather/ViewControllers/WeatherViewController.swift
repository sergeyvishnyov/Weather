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
    @IBOutlet var currentViewHeight: NSLayoutConstraint!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!

    @IBOutlet var temperatureView: UIView!
    @IBOutlet var temperatureViewHeight: NSLayoutConstraint!
    @IBOutlet var temperatureLabel: UILabel!

    @IBOutlet var tableView: UITableView!
    var tableViewCellDayHeight = 40.0
    let cellReuseIdentifierDay = "DayTableViewCell"
    let cellReuseIdentifierCurrent = "CurrentTableViewCell"
    let cellReuseIdentifierHour = "HourCollectionViewCell"

    var current: HourEntity?
    var hours = [HourEntity]()
    var days = [DayEntity]()
    
    var placemark: CLPlacemark?

    let manager: WeatherManager! = WeatherManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: cellReuseIdentifierDay, bundle: nil),
                                  forCellReuseIdentifier: cellReuseIdentifierDay)
        tableView.isHidden = true
        currentView.isHidden = true

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
//            print(current, hours, days)
            self.current = current
            self.hours = hours
            self.days = days
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
        weatherLabel.text = current?.weather?.weatherDescription
        temperatureLabel.text = current?.temp?.toString()

        tableView.isHidden = false
        tableView.reloadData()
    }
    
//  MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hoursCollectionView = Bundle.main.loadNibNamed("HoursCollectionView",
                                                       owner: nil,
                                                       options: nil)?.first as! HoursCollectionView
        hoursCollectionView.register(UINib(nibName: cellReuseIdentifierHour, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifierHour)
        hoursCollectionView.hours = hours
        hoursCollectionView.alpha = section == 0 ? 0 : 1
        return hoursCollectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellDayHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? (days.count > 0 ? 1 : 0) : days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierDay) as! DayTableViewCell
        let day = days[indexPath.row]
        cell.set(day)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
//        print(offsetY)

        let indexpath = IndexPath(row: 0, section: 0)
        if let currentCell = tableView.cellForRow(at: indexpath) as? DayTableViewCell {
            if offsetY > 0 {
                let height = tableViewCellDayHeight * 2
                temperatureView.alpha = (height - offsetY) / height
                let alpha = (tableViewCellDayHeight - offsetY) / tableViewCellDayHeight
                currentCell.alpha = alpha
            } else {
                temperatureView.alpha = 1
                currentCell.alpha = 1
                
                currentViewHeight.constant = 200 - offsetY
            }
        }
    }

}

