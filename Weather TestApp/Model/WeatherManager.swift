//
//  WeatherManager.swift
//  Weather Test App
//
//  Created by Alikhan Aghazade on 29.05.22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    private let API_KEY = ""
    private let url = "https://api.openweathermap.org/data/2.5/"
    
    //api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
    //api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
    //40.587518116908925, 49.65305325525847
    
    func fetchWeather(cityName: String) {
        let urlString = "\(url)weather?q=\(cityName)&appid=\(API_KEY)&units=metric"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(url)forecast?lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)&units=metric"
        performForecastRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let data = data {
                    if let weather = self.parseJson(data) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performForecastRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let data = data {
                    if let weather = self.parseForecastJson(data) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let tempMax = decodedData.main.temp_max
            let tempMin = decodedData.main.temp_min
            let humidity = decodedData.main.humidity
            let date = decodedData.dt
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, temperatureMax: tempMax, temperatureMin: tempMin, humidity: humidity, date: date)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    func parseForecastJson(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherForecastData.self, from: data)
            let id = decodedData.list[2].weather[0].id
            let temp = decodedData.list[1].main.temp
            let name = decodedData.city.name
            let tempMax = decodedData.list[1].main.temp_max
            let tempMin = decodedData.list[1].main.temp_min
            let humidity = decodedData.list[1].main.humidity
            let date = decodedData.list[1].dt
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, temperatureMax: tempMax, temperatureMin: tempMin, humidity: humidity, date: date)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

