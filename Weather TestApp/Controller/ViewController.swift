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
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var detailedView = DetailedView()
    let stackView = UIStackView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        updateUI()
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        view.addSubview(stackView)
        setupStackViewConstraints()
        
        
    }
    
    //MARK: - Enabling only Portrait mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    func updateUI() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    func setupStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.topAnchor.constraint(equalTo: detailedStackView.bottomAnchor, constant: 50).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}

    

//MARK: - UITextFieldDelegate
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
extension ViewController: WeatherManagerDelegate {
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.tempLabel.text = weather.temperatureString
            self.weatherLabel.image = UIImage(systemName: weather.conditionName)
            self.cityName.text = weather.cityName
            self.humidity.text = "\(weather.humidity)%"
            self.tempMax.text = "\(weather.temperatureMax)"
            self.tempMin.text = "\(weather.temperatureMin)"
            
            self.detailedView.dateLabel.text = weather.dateString
            self.detailedView.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.detailedView.maxTempLabel.text = "↑ \(weather.temperatureMax) °C"
            self.detailedView.minTempLabel.text = "↓ \(weather.temperatureMin) °C"
            
            self.detailedView.stackView.addArrangedSubview(self.detailedView.dateLabel)
            self.detailedView.stackView.addArrangedSubview(self.detailedView.weatherImage)
            self.detailedView.stackView.addArrangedSubview(self.detailedView.maxTempLabel)
            self.detailedView.stackView.addArrangedSubview(self.detailedView.minTempLabel)
            self.stackView.addArrangedSubview(self.detailedView.stackView)
            
            print("DispatchQueue.main.async 1")
            self.detailedView.setConstraints()
            print("DispatchQueue.main.async 2")
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        print(1)
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



