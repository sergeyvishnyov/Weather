//
//  WeatherManager.swift
//  Weather
//
//  Created by Sergey Vishnyov on 16.12.21.
//

import UIKit
import CoreLocation

enum ErrorType: String {
    case locationDenied = "Access denied"
    case locationNotAvailable = "Location is not available"
    case errorHttpResponse = "Server Error"
    case errorData = "Data Error"
    case errorUnknown = "Unknown Error"
}

class WeatherManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = WeatherManager()
    var weatherViewController: WeatherViewController? = nil
    
    let locationManager = CLLocationManager()
    var location: CLLocation!
    
    private var urlStr = "http://api.openweathermap.org/data/2.5/onecall?appid=e4b636bde533ce124b0334332e698026&units=metric&exclude=minutely"
        
// MARK: - Location Methods
    func initLocationManager(_ vc: WeatherViewController) {
        weatherViewController = vc
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
//            showError(nil, errorType: .locationNotAvailable)
        }
    }
    
// MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.location == nil {
            let latitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
            let location = CLLocation(latitude: latitude!,
                                      longitude: longitude!)
            print("locations = \(String(describing: latitude)) \(String(describing: longitude))")
            self.location = location
            locationManager.stopUpdatingLocation()
            weatherViewController?.loadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError {
            case CLError.denied:
                showError(nil, errorType: .locationDenied)
            case CLError.locationUnknown:
                showError(nil, errorType: .errorUnknown)
            default:
                showError(nil, errorType: .errorUnknown)
            }
        } else {
            showError(error, errorType: nil)
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            break
//        case .authorizedWhenInUse:
//            break
//        case .authorizedAlways:
//            break
//        case .restricted:
//            break
//        case .denied:
//            break
//        default:
//            break
//        }
//    }
    
// MARK: - API
    func getCity(success: @escaping(_ city: String?) -> (),
                  failed: @escaping() -> ()) {
        CLGeocoder().reverseGeocodeLocation(location,
                                            preferredLocale: Locale(identifier: "en_US"),
                                            completionHandler: {(placemarks, error) -> Void in
            if error == nil {
                var city: String?
                if let placemark = placemarks?.first {
                    city = placemark.locality ?? placemark.name
                    UserDefaults.standard.set(city, forKey: "city")
                }
                success(city)
            } else {
                self.showError(error, errorType: nil)
                failed()
            }
        })
    }
    
// https://openweathermap.org/api/one-call-api — Documentation
    func getWeather(success: @escaping(_ current: HourEntity?, _ hours: [HourEntity], _ days: [DayEntity]) -> (),
                   failed: @escaping() -> ()) {
//        For tests:
//        let lat = "&lat=34.8324" // Minsk
//        let lon = "&lon=27.567444" // Minsk
//        let lat = "&lat=24.7380" // Barcelona
//        let lon = "&lon=2.154007" // Barcelona
        let lat = "&lat=\(location.coordinate.latitude)"
        let lon = "&lon=\(location.coordinate.longitude)"
        urlStr = urlStr + lat + lon
        let url = URL(string: urlStr)!
         
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if let error = error {
                self.showError(error, errorType: nil)
                failed()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.showError(nil, errorType: .errorHttpResponse)
                failed()
                return
            }
            guard let data = data else {
                failed()
                return
            }
            self.parse(data) { current, hours, days in
                UserDefaults.standard.set(data, forKey: "data")
                success(current, hours, days)
            } failed: {
                self.showError(nil, errorType: nil)
                failed()
            }
        }).resume()
    }
    
    func parse(_ data: Data, success: @escaping(_ current: HourEntity?, _ hours: [HourEntity], _ days: [DayEntity]) -> (),
               failed: @escaping() -> ()) {
        if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
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

            var currentHour: HourEntity?
            if let currentDict = dict["current"] as? [String: Any] {
                currentHour = HourEntity.init(currentDict)
                if let hour = hours.first {
                    // current ≈ hour, current exclude Precipitation volume, mm
                    currentHour?.pop = hour.pop
                }
            }
            success(currentHour, hours, days)
         } else {
             self.showError(nil, errorType: .errorData)
             failed()
         }
    }
    
//    MARK: - Errors
    func showError(_ error: Error?, errorType: ErrorType?) {
        var errorDescription: String! = ErrorType.errorUnknown.rawValue
        if error != nil {
            errorDescription = error?.localizedDescription
        } else if errorType != nil {
            errorDescription = errorType?.rawValue
        }
        print(errorDescription as Any)
        let alert = UIAlertController(title: "Warning", message: errorDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        weatherViewController?.present(alert, animated: true, completion: nil)
    }
}

