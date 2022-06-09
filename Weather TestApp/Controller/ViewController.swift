//
//  ViewController.swift
//  Weather Test App
//
//  Created by Aydin Aghayev on 05/27/22
//

import UIKit
import CoreLocation
import SwiftDate

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
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.setLocalizedDateFormatFromTemplate("dd MMM")
        
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
            
            // Adding values to elements that are defined in storyboard
            self.dateLabel.text = self.formatter.string(from: Date())
            self.tempLabel.text = "\(weather.temperatureString)°C"
            self.weatherLabel.image = UIImage(systemName: weather.conditionName)
            self.cityName.text = weather.cityName
            self.humidity.text = "\(weather.humidity)%"
            self.tempMax.text = "\(weather.temperatureMax)"
            self.tempMin.text = "\(weather.temperatureMin)"
            
            self.changeBackgroundColor(weather.temperature)
            
            // The locator is triggered every time the system adds new elements to the array, so we clear the nested views before adding a new one.
            self.stackView.arrangedSubviews.forEach {
                self.stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            
            // Creating stack views programmatically and adding values to their elements
            self.addVStackToHstack(weather.list)
        }
    }
    
    func addVStackToHstack(_ list: [List]) {
        for element in self.groupElementsByDate(list) {
            
            let date = Date(timeIntervalSince1970: element.dt)
            let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
            let endDate = Calendar.current.date(byAdding: .day, value: 5, to: startDate)!
            
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .init()))!
            let fiveDaysLater = Calendar.current.date(byAdding: .day, value: 4, to: tomorrow)!
            
            if (startDate...endDate).overlaps(tomorrow...fiveDaysLater) {
                let detailedView = DetailedView()

                let config = UIImage.SymbolConfiguration(scale: .large)
                // Adding values to  elements
                detailedView.dateLabel.text = formatter.string(from: .init(timeIntervalSince1970: element.dt))
                detailedView.weatherImage.image = UIImage(systemName: element.weather.last!.conditionName)?.applyingSymbolConfiguration(config)
                detailedView.maxTempLabel.text = "\(element.main.tempMaxString) °C"
                detailedView.minTempLabel.text = "\(element.main.tempMinString) °C"
                
                detailedView.stackView.addArrangedSubview(detailedView.dateLabel)
                detailedView.stackView.addArrangedSubview(detailedView.weatherImage)
                detailedView.stackView.addArrangedSubview(detailedView.maxTempLabel)
                detailedView.stackView.addArrangedSubview(detailedView.minTempLabel)
                
                stackView.addArrangedSubview(detailedView.stackView)
                configureHStackView()
                
                detailedView.setConstraints()
            }
        }
    }
    
    func configureHStackView() {
       stackView.axis = .horizontal
       stackView.distribution = .fillEqually
       stackView.spacing = 0
    }
    
    func changeBackgroundColor(_ temp: Double) {
        if temp > 17.0 {
            view.backgroundColor = UIColor(named: "WarmColor")
            searchTextField.backgroundColor = UIColor(named: "WarmColor")
        } else {
            view.backgroundColor = UIColor(named: "ColdColor")
            searchTextField.backgroundColor = UIColor(named: "ColdColor")
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
        
        //getting first date after sorting
        let unixDateOfFirstElementList = averageByDate.keys.sorted { $0 < $1 }.first
        // creating date from unix timestamp
        let date = Date(timeIntervalSince1970: unixDateOfFirstElementList!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date
        let localDate = "\(dateFormatter.string(from: date).dropLast(9))"
        
        //crating today variable
        let qdate = Date()
        let calendar = Calendar.current
        let day = String(calendar.component(.day, from: qdate))
        
        //comparing if JSON response containing today date, if it does removing them
        if localDate == day {
            return Array(averageByDate.values.sorted { $0.dt < $1.dt }.dropFirst())
        } else {
            return Array(averageByDate.values.sorted { $0.dt < $1.dt })
        }
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



