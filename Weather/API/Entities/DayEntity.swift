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
    var sunset: Double?
    var sunrise: Double?
    var weather: WeatherEntity?
    
    init(_ dict: [String: Any]) {
        dt = dict["dt"] as? Double
        if let temp = dict["temp"] as? [String: Any] {
            tempDay = temp["day"] as? Double
            tempNight = temp["night"] as? Double
        }
        sunset = dict["sunset"] as? Double
        sunrise = dict["sunrise"] as? Double
        if let weatherArr = dict["weather"] as? [[String: Any]] {
            if let weatherDict = weatherArr.first {
                weather = WeatherEntity.init(weatherDict)
            }
        }
    }
}
