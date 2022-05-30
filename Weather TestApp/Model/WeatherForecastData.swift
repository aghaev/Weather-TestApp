//
//  WeatherForecasrData.swift
//  Weather Test App
//
//  Created by Alikhan Aghazade on 30.05.22.
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
