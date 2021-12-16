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
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!

    @IBOutlet var weatherTableView: UITableView!
    let cellReuseIdentifier = "DayTableViewCell"

    var current: HourEntity?
    var hours: [HourEntity]?
    var days = [DayEntity]()
    
    var placemark: CLPlacemark?

    let manager: WeatherManager! = WeatherManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil),
                                  forCellReuseIdentifier: cellReuseIdentifier)
        weatherTableView.isHidden = true
        currentView.isHidden = true

        manager.initLocationManager(self)
    }
    
    func loadData() {
        let group = DispatchGroup()

        group.enter()
        manager.loadCity { placemark in
            self.placemark = placemark
            group.leave()
        } failed: { error in
            group.leave()
        }
        
        group.enter()
        manager.loadWeather { current, hours, days in
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
        cityLabel.text = placemark?.name
        weatherLabel.text = current?.weather?.weatherDescription
        temperatureLabel.text = current?.temp?.toString()

        weatherTableView.isHidden = false
        weatherTableView.reloadData()
    }
    
//  MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DayTableViewCell
        let day = days[indexPath.row]
        cell.set(day)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

