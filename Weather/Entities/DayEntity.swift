//
//  DayEntity.swift
//  Weather
//
//  Created by Sergey Vishnyov on 16.12.21.
//

import Foundation

// https://openweathermap.org/api/one-call-api — Documentation

class DayEntity: NSObject {
    var dt: Double?
    var dayWeek: String?
    var tempDay: Double?
    var tempNight: Double?
    var tempMax: Double?
    var tempMin: Double?
    var weather: WeatherEntity?
    
    init(_ dict: [String: Any]) {
        if let dt = dict["dt"] as? Double {
            self.dt = dt
            let date = Date(timeIntervalSince1970: dt)
            
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "EEEE"
            dayWeek = dateFormatter.string(from: date)
//            print(dayWeek)
//            print(date)
        }
        if let temp = dict["temp"] as? [String: Any] {
            tempDay = temp["day"] as? Double
            tempNight = temp["night"] as? Double
            tempMax = temp["max"] as? Double
            tempMin = temp["min"] as? Double
        }
        if let weatherArr = dict["weather"] as? [[String: Any]] {
            if let weatherDict = weatherArr.first {
                weather = WeatherEntity.init(weatherDict)
            }
        }
    }
}
