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
        
//
//        let day1DateLabel = UILabel()
//        day1DateLabel.text = "Jun 1"
//
//        let day1WeatherImage = UIImageView()
//        day1WeatherImage.image = UIImage(systemName: "sun.max")
//        day1WeatherImage.tintColor = .black
//
//        let day1MaxTemp = UILabel()
//        day1MaxTemp.text = "↑ 30°C"
//
//        let day1MinTemp = UILabel()
//        day1MinTemp.text = "↓ 22°C"
//
//        let day1 = UIStackView(arrangedSubviews: [day1DateLabel, day1WeatherImage, day1MaxTemp, day1MinTemp])
//        day1.axis = .horizontal
//        day1.distribution = .fillProportionally
//        day1.alignment = .center
//        day1.spacing = 0
//
//        day1WeatherImage.leadingAnchor.constraint(equalTo: day1.leadingAnchor, constant: 73).isActive = true
//        day1MaxTemp.leftAnchor.constraint(equalTo: day1WeatherImage.rightAnchor, constant: 23).isActive = true
//        day1MinTemp.leftAnchor.constraint(equalTo: day1MaxTemp.rightAnchor, constant: -33).isActive = true
//        day1WeatherImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        let day2DateLabel = UILabel()
//        day2DateLabel.text = "Jun 2"
//        let day2WeatherImage = UIImageView()
//        day2WeatherImage.image = UIImage(systemName: "sun.max")
//        day2WeatherImage.tintColor = .black
//        let day2MaxTemp = UILabel()
//        day2MaxTemp.text = "↑ 30°C"
//        let day2MinTemp = UILabel()
//        day2MinTemp.text = "↓ 20°C"
//        let day2 = UIStackView(arrangedSubviews: [day2DateLabel, day2WeatherImage, day2MaxTemp, day2MinTemp])
//        day2.axis = .horizontal
//        day2.distribution = .fillProportionally
//        day2.alignment = .center
//        day2.spacing = 0
//        day2WeatherImage.leadingAnchor.constraint(equalTo: day2.leadingAnchor, constant: 73).isActive = true
//        day2MaxTemp.leftAnchor.constraint(equalTo: day2WeatherImage.rightAnchor, constant: 23).isActive = true
//        day2MinTemp.leftAnchor.constraint(equalTo: day2MaxTemp.rightAnchor, constant: -33).isActive = true
//        day2WeatherImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        let day3DateLabel = UILabel()
//        day3DateLabel.text = "Jun 3"
//        let day3WeatherImage = UIImageView()
//        day3WeatherImage.image = UIImage(systemName: "sun.max")
//        day3WeatherImage.tintColor = .black
//        let day3MaxTemp = UILabel()
//        day3MaxTemp.text = "↑ 30°C"
//        let day3MinTemp = UILabel()
//        day3MinTemp.text = "↓ 20°C"
//        let day3 = UIStackView(arrangedSubviews: [day3DateLabel, day3WeatherImage, day3MaxTemp, day3MinTemp])
//        day3.axis = .horizontal
//        day3.distribution = .fillProportionally
//        day3.alignment = .center
//        day3.spacing = 0
//        day3WeatherImage.leadingAnchor.constraint(equalTo: day3.leadingAnchor, constant: 73).isActive = true
//        day3MaxTemp.leftAnchor.constraint(equalTo: day3WeatherImage.rightAnchor, constant: 23).isActive = true
//        day3MinTemp.leftAnchor.constraint(equalTo: day3MaxTemp.rightAnchor, constant: -33).isActive = true
//        day3WeatherImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        let day4DateLabel = UILabel()
//        day4DateLabel.text = "Jun 4"
//        let day4WeatherImage = UIImageView()
//        day4WeatherImage.image = UIImage(systemName: "sun.max")
//        day4WeatherImage.tintColor = .black
//        let day4MaxTemp = UILabel()
//        day4MaxTemp.text = "↑ 30°C"
//        let day4MinTemp = UILabel()
//        day4MinTemp.text = "↓ 20°C"
//        let day4 = UIStackView(arrangedSubviews: [day4DateLabel, day4WeatherImage, day4MaxTemp, day4MinTemp])
//        day4.axis = .horizontal
//        day4.distribution = .fillProportionally
//        day4.alignment = .center
//        day4.spacing = 0
//        day4WeatherImage.leadingAnchor.constraint(equalTo: day4.leadingAnchor, constant: 73).isActive = true
//        day4MaxTemp.leftAnchor.constraint(equalTo: day4WeatherImage.rightAnchor, constant: 23).isActive = true
//        day4MinTemp.leftAnchor.constraint(equalTo: day4MaxTemp.rightAnchor, constant: -33).isActive = true
//        day4WeatherImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        let day5DateLabel = UILabel()
//        day5DateLabel.text = "Jun 5"
//        let day5WeatherImage = UIImageView()
//        day5WeatherImage.image = UIImage(systemName: "sun.max")
//        day5WeatherImage.tintColor = .black
//        let day5MaxTemp = UILabel()
//        day5MaxTemp.text = "↑ 30°C"
//        let day5MinTemp = UILabel()
//        day5MinTemp.text = "↓ 20°C"
//        let day5 = UIStackView(arrangedSubviews: [day5DateLabel, day5WeatherImage, day5MaxTemp, day5MinTemp])
//        day5.axis = .horizontal
//        day5.distribution = .fillProportionally
//        day5.alignment = .center
//        day5.spacing = 0
//        day5WeatherImage.leadingAnchor.constraint(equalTo: day5.leadingAnchor, constant: 73).isActive = true
//        day5MaxTemp.leftAnchor.constraint(equalTo: day5WeatherImage.rightAnchor, constant: 23).isActive = true
//        day5MinTemp.leftAnchor.constraint(equalTo: day5MaxTemp.rightAnchor, constant: -33).isActive = true
//        day5WeatherImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//
//        stackView.addArrangedSubview(day1)
//        stackView.addArrangedSubview(day2)
//        stackView.addArrangedSubview(day3)
//        stackView.addArrangedSubview(day4)
//        stackView.addArrangedSubview(day5)
//
//
//
//        // stackView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//
//        // autolayout constraint
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: detailedStackView.bottomAnchor, constant: 50),
//            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
//        ])
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
            self.detailedView.maxTempLabel.text = "\(weather.temperatureMax)"
            self.detailedView.minTempLabel.text = "\(weather.temperatureMin)"
            
            
            self.stackView.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.axis = .vertical
            self.stackView.distribution = .fillProportionally
            
            
            self.detailedView.stackView.addArrangedSubview(self.detailedView.dateLabel)
            self.detailedView.stackView.addArrangedSubview(self.detailedView.weatherImage)
            self.detailedView.stackView.addArrangedSubview(self.detailedView.maxTempLabel)
            self.detailedView.stackView.addArrangedSubview(self.detailedView.minTempLabel)
            self.stackView.addArrangedSubview(self.detailedView.stackView)
            self.view.addSubview(self.stackView)
            self.stackView.topAnchor.constraint(equalTo: self.detailedStackView.bottomAnchor, constant: 50).isActive = true
            self.stackView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
            self.stackView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
            self.stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
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



