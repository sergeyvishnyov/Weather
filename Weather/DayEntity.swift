//
//  DayEntity.swift
//  Weather
//
//  Created by Sergey Vishnyov on 15.12.21.
//

import Foundation

// https://openweathermap.org/api/one-call-api — Documentation

class DayEntity: NSObject {
    var dt: Float? // Time of the forecasted data, Unix, UTC
    var sunrise: Float? // Sunrise time, Unix, UTC
    var sunset: Float? // Sunset time, Unix, UTC
    var temp: Float? // Temperature. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit
    var feels_like: Float? // Temperature. This accounts for the human perception of weather. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
    var pressure: Float? // Atmospheric pressure on the sea level, hPa
    var humidity: Float? // Humidity, %
    var dew_point: Float? // Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
    var uvi: Float? // UV index
    var clouds: Float? // Cloudiness, %
    var visibility: Float? // Average visibility, metres
    var wind_speed: Float? // Wind speed. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour
    var wind_deg: Float? // Wind direction, degrees (meteorological)
    var wind_gust: Float? // (where available) Wind gust. Units – default: metre/sec, metric: metre/sec, imperial: miles/hour.
    var pop: Float? // Probability of precipitation

    init(_ dict: [String: Any]) {
        dt = dict["dt"] as? Float
        sunrise = dict["sunrise"] as? Float
        sunset = dict["sunset"] as? Float
        temp = dict["temp"] as? Float
        feels_like = dict["feels_like"] as? Float
        pressure = dict["pressure"] as? Float
        humidity = dict["humidity"] as? Float
        dew_point = dict["dew_point"] as? Float
        uvi = dict["uvi"] as? Float
        clouds = dict["clouds"] as? Float
        visibility = dict["visibility"] as? Float
        wind_speed = dict["wind_speed"] as? Float
        wind_deg = dict["wind_deg"] as? Float
        wind_gust = dict["wind_gust"] as? Float
        wind_gust = dict["pop"] as? Float
    }
}
