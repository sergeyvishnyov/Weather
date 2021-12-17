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
    var tempDay: Double?
    var tempNight: Double?
//    var tempMax: Double?
//    var tempMin: Double?
    var weather: WeatherEntity?
    
    init(_ dict: [String: Any]) {
        dt = dict["dt"] as? Double
        if let temp = dict["temp"] as? [String: Any] {
            tempDay = temp["day"] as? Double
            tempNight = temp["night"] as? Double
//            tempMax = temp["max"] as? Double
//            tempMin = temp["min"] as? Double
        }
        if let weatherArr = dict["weather"] as? [[String: Any]] {
            if let weatherDict = weatherArr.first {
                weather = WeatherEntity.init(weatherDict)
            }
        }
    }
}
