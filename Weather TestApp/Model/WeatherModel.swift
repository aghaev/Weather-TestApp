//
//  WeatherModel.swift
//  Weather Test App
//
//  Created by Alikhan Aghazade on 30.05.22.
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
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}

