//
//  WeatherManager.swift
//  Weather
//
//  Created by Sergey Vishnyov on 16.12.21.
//

import UIKit
import CoreLocation

class WeatherManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = WeatherManager()
    var weatherViewController: WeatherViewController? = nil
    
    let locationManager = CLLocationManager()
    var location: CLLocation!
    
    private var urlStr = "http://api.openweathermap.org/data/2.5/onecall?appid=e4b636bde533ce124b0334332e698026&lang=ru&units=metric&exclude=minutely"
        
// MARK: - Location Methods
    func initLocationManager(_ vc: WeatherViewController) {
        weatherViewController = vc
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            print("Location is not available")
        }
    }

//    func isLoactionEnabled() -> Bool {
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined, .restricted, .denied:
//                print("No access")
//                return false
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access")
//                return true
//            }
//        } else {
//            print("Location services are not enabled")
//            return false
//        }
//    }
    
// MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.location == nil {
            let latitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
            let location = CLLocation(latitude: latitude!,
                                      longitude: longitude!)
            print("locations = \(latitude) \(longitude)")
            self.location = location
            locationManager.stopUpdatingLocation()
            weatherViewController?.loadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError {
            case CLError.locationUnknown:
                print("LocationUnknown")
            case CLError.denied:
                print("Denied")
            default:
                print("Other Core Location error")
            }
        } else {
            print("Other error: ", error.localizedDescription)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse:
            NotificationCenter.default.post(name: Notification.Name("didChangeAuthorizationWhenInUse"), object: nil)
            break
        case .authorizedAlways:
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
    
// MARK: - API
    func getCity(success: @escaping(_ placemark: CLPlacemark?) -> (),
                  failed: @escaping(_ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error == nil {
                var placemark: CLPlacemark?
                if let placemarkFirst = placemarks?.first {
                    placemark = placemarkFirst
                }
                success(placemark)
            } else {
                failed(error)
            }
        })
    }
    
    func getWeather(success: @escaping(_ current: HourEntity?, _ hours: [HourEntity], _ days: [DayEntity]) -> (),
                   failed: @escaping(_ error: Any?) -> ()) {
        let lat = "&lat=\(location.coordinate.latitude)"
        let lon = "&lon=\(location.coordinate.longitude)"
        urlStr = urlStr + lat + lon
        let url = URL(string: urlStr)!
         
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                failed(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                failed(response)
                return
            }
            guard let data = data else {
                failed(nil)
                return
            }

             if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                 var currentHour: HourEntity?
                 if let currentDict = dict["current"] as? [String: Any] {
                     currentHour = HourEntity.init(currentDict)
                 }
                 
                 var hours = [HourEntity]()
                 if let hoursArr = dict["hourly"] as? [[String: Any]] {
                     for hourDict in hoursArr {
                         let hour = HourEntity.init(hourDict)
                         hours.append(hour)
                     }
                 }
                 
                 var days = [DayEntity]()
                 if let daysArr = dict["daily"] as? [[String: Any]] {
                     for dayDict in daysArr {
                         let day = DayEntity.init(dayDict)
                         days.append(day)
                     }
                 }
                 
                 success(currentHour, hours, days)
             } else {
                 failed(nil)
             }
         }).resume()
    }
}

