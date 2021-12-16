//
//  Weather.swift
//  Weather
//
//  Created by Sergey Vishnyov on 16.12.21.
//

import Foundation

// https://openweathermap.org/api/one-call-api — Documentation

class WeatherEntity: NSObject {
    var weatherId: Double? // Weather condition id
    var main: String? // Group of weather parameters (Rain, Snow, Extreme etc.)
    var weatherDescription: String? // Weather condition within the group
    var iconUrl: URL? // Weather icon id // https://openweathermap.org/weather-conditions#How-to-get-icon-URL

    init(_ dict: [String: Any]) {
        weatherId = dict["id"] as? Double
        main = dict["main"] as? String
        weatherDescription = dict["description"] as? String
        if let icon = dict["icon"] as? String {
            iconUrl = URL(string: "http://openweathermap.org/img/wn/" + icon + "@2x.png")
        }
    }
}
