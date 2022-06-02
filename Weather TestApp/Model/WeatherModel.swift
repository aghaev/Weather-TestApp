//
//  WeatherModel.swift
//  Weather Test App
//
//  Created by Aydin Aghayev on 05/27/22.
//

import Foundation

struct WeatherModel {
    let list: [List]
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let temperatureMax: Double
    let temperatureMin: Double
    let humidity: Int
    let date: Double
    
    
    // Changing UNIX timestamp to human date
    var dateString: String {
        let dateString = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        
        return "\(dateFormatter.string(from: dateString).dropLast(6))"
    }
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
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

