//
//  ViewController.swift
//  Weather Test App
//
//  Created by Aydin Aghayev on 27.05.22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var weatherLabel: UIImageView!
    @IBOutlet weak var detailedStackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    //MARK: - Enabling only Portrait mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
}

//MARK: - UITextFieldDelegate
// Detecting user input and making request
extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
// Recieving data from WeatherManager and adding them to views elements
extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("dd MMM")
            
            // Adding values to elements that are defined in storyboard
            self.dateLabel.text = formatter.string(from: Date())
            self.tempLabel.text = "\(weather.temperatureString)°C"
            self.weatherLabel.image = UIImage(systemName: weather.conditionName)
            self.cityName.text = weather.cityName
            self.humidity.text = "\(weather.humidity)%"
            self.tempMax.text = "\(weather.temperatureMax)"
            self.tempMin.text = "\(weather.temperatureMin)"
            
            // The locator is triggered twice, the view is duplicated, so stack destroyed before adding elements
            self.stackView.arrangedSubviews.forEach {
                self.stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            
            // Creating stack views programmatically and adding values to their elements
            for element in self.groupElementsByDate(weather.list) {
                let date = Date(timeIntervalSince1970: element.dt)
                let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
                let endDate = Calendar.current.date(byAdding: .day, value: 5, to: startDate)!
                
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .init()))!
                let fiveDaysLater = Calendar.current.date(byAdding: .day, value: 4, to: tomorrow)!
                
                if (startDate...endDate).overlaps(tomorrow...fiveDaysLater) {
                    let detailedView = DetailedView()

                    detailedView.dateLabel.text = formatter.string(from: .init(timeIntervalSince1970: element.dt))
                    
                    let config = UIImage.SymbolConfiguration(scale: .large)
                    let image = UIImage(systemName: element.weather.last!.conditionName)
                    
                    // Adding values to  elements
                    detailedView.weatherImage.image = image?.applyingSymbolConfiguration(config)
                    detailedView.maxTempLabel.text = "↑ \(element.main.tempMaxString) °C"
                    detailedView.minTempLabel.text = "↓ \(element.main.tempMinString) °C"
                    
                    detailedView.stackView.addArrangedSubview(detailedView.dateLabel)
                    detailedView.stackView.addArrangedSubview(detailedView.weatherImage)
                    detailedView.stackView.addArrangedSubview(detailedView.maxTempLabel)
                    detailedView.stackView.addArrangedSubview(detailedView.minTempLabel)
                    
                    self.stackView.addArrangedSubview(detailedView.stackView)
                    self.stackView.axis = .horizontal
                    self.stackView.distribution = .fillEqually
                    self.stackView.spacing = 8
                    
                    detailedView.setConstraints()
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    // Filtering Data, creating dictionary with asosiated value [date : values]
    private func groupElementsByDate(_ list: [List]) -> [List] {
        let dateList: [List] = list.map {
            let date = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: $0.dt))
            return List(dt: date.timeIntervalSince1970, main: $0.main, weather: $0.weather, dt_txt: $0.dt_txt)
        }
        
        let groupedByDate = Dictionary(grouping: dateList, by: \.dt)
        let averageByDate: [Double: List] = groupedByDate.mapValues {
            let average = $0.map(\.main.temp).reduce(0.0, +) / Double($0.count)
            let min = $0.map(\.main.temp_min).min() ?? 0.0
            let max = $0.map(\.main.temp_max).max() ?? 0.0
            let humidity: Double = Double($0.map(\.main.humidity).reduce(0, +)) / Double($0.count)
            
            return List(
                dt: $0.first!.dt,
                main: .init(temp: average, temp_max: max, temp_min: min, humidity: Int(humidity)),
                weather: $0.first!.weather,
                dt_txt: $0.first!.dt_txt
            )
        }
        return Array(averageByDate.values.sorted { $0.dt < $1.dt })
    }
}

//MARK: - CLLocationManagerDelegate
// Detecting user location and making request
extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



