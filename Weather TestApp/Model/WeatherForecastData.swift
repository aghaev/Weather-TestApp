//
//  WeatherForecasrData.swift
//  Weather Test App
//
//  Created by Aydin Aghayev on 05/27/22.
//

import Foundation

struct WeatherForecastData: Codable {
    let city: City
    let list: [List]
}

struct City: Codable {
    let name : String
}

struct List: Codable {
    let dt: Double
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

struct Main: Codable {
    let temp: Double
    let temp_max: Double
    let temp_min: Double
    let humidity: Int
    
    var tempMaxString: String {
        return String(format: "%.0f", temp_max)
    }
    
    var tempMinString: String {
        return String(format: "%.0f", temp_min)
    }
}

struct Weather: Codable {
    let description: String
    let id: Int
    
    var conditionName: String {
        switch id {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.sun.rain"
        case 600...622:
            return "snowflake"
        case 701...781:
            return "sun.dust"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803:
            return "smoke"
        case 804:
            return "smoke"
        default:
            return "cloud"
        }
    }
}
