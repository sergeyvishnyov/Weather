//
//  HourEntity.swift
//  Weather
//
//  Created by Sergey Vishnyov on 15.12.21.
//

import Foundation

// https://openweathermap.org/api/one-call-api — Documentation

class HourEntity: NSObject {
    var dt: Double? // Time of the forecasted data, Unix, UTC
    var sunrise: Int? // Sunrise time, Unix, UTC
    var sunset: Int? // Sunset time, Unix, UTC
    var temp: Double? // Temperature. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit
    var feels_like: Double? // Temperature. This accounts for the human perception of weather. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
    var pressure: Double? // Atmospheric pressure on the sea level, hPa
    var humidity: Double? // Humidity, %
    var dew_point: Double? // Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
    var uvi: Double? // UV index
    var clouds: Double? // Cloudiness, %
    var visibility: Double? // Average visibility, metres
    var wind_speed: Double? // Wind speed. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour
    var wind_deg: Double? // Wind direction, degrees (meteorological)
    var wind_gust: Double? // (where available) Wind gust. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour.
    var pop: Double? // Probability of precipitation

    var weather: WeatherEntity? // Weather

    init(_ dict: [String: Any]) {
        dt = dict["dt"] as? Double
        sunrise = dict["sunrise"] as? Int
        sunset = dict["sunset"] as? Int
        temp = dict["temp"] as? Double
        feels_like = dict["feels_like"] as? Double
        pressure = dict["pressure"] as? Double
        humidity = dict["humidity"] as? Double
        dew_point = dict["dew_point"] as? Double
        uvi = dict["uvi"] as? Double
        clouds = dict["clouds"] as? Double
        visibility = dict["visibility"] as? Double
        wind_speed = dict["wind_speed"] as? Double
        wind_deg = dict["wind_deg"] as? Double
        wind_gust = dict["wind_gust"] as? Double
        wind_gust = dict["pop"] as? Double
        if let weatherArr = dict["weather"] as? [[String: Any]] {
            if let weatherDict = weatherArr.first {
                weather = WeatherEntity.init(weatherDict)
            }
        }
    }
}
