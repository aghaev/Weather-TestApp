//
//  WeatherData.swift
//  Weather Test App
//
//  Created by Alikhan Aghazade on 30.05.22.
//

import Foundation

struct WeatherData: Codable {
    let dt: Double
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let temp_max: Double
    let temp_min: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let id: Int
}
