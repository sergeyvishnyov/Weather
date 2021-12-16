//
//  DayEntity.swift
//  Weather
//
//  Created by Sergey Vishnyov on 16.12.21.
//

import Foundation

// https://openweathermap.org/api/one-call-api — Documentation

class DayEntity: NSObject {
    var dt: Int?
    var tempDay: Float?
    var tempNight: Float?
    var tempMax: Float?
    var tempMin: Float?
    var weather: WeatherEntity?
    
    init(_ dict: [String: Any]) {
        dt = dict["dt"] as? Int
        tempDay = dict["day"] as? Float
        tempNight = dict["night"] as? Float
        tempMax = dict["max"] as? Float
        tempMin = dict["min"] as? Float
        if let weatherArr = dict["weather"] as? [[String: Any]] {
            if let weatherDict = weatherArr.first {
                weather = WeatherEntity.init(weatherDict)
            }
        }
    }
}
