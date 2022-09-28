//
//  ViewController.swift
//  Clima
//
//  Created by Yan Oliveira on 24/09/22.
//  Copyright © 2019 yloliveira. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextInput: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextInput.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        startLoading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchCurrentWeatherDataBy(latitude: lat, longitude: lon)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        startLoading()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopLoading()
    }
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func inputTextEditingChanged(_ sender: UITextField) {
        if (sender.text!.count > 0) {
            resetInputFieldBorder()
        }
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextInput.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            showInputFieldBorderError()
            stopLoading()
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            startLoading()
            weatherManager.fetchCurrentWeatherDataBy(cityName: cityName)
        }
    }
    
    func showInputFieldBorderError() {
        searchTextInput.layer.borderWidth = 1
        searchTextInput.layer.borderColor = CGColor.init(red: 255, green: 0, blue: 0, alpha: 0.5)
    }
    
    func resetInputFieldBorder() {
        searchTextInput.layer.borderWidth = 0.0
        searchTextInput.layer.borderColor = nil
    }
}


//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func weatherManagerDidFetchCurrentCityWeatherData(_ weatherManager: WeatherManager, _ weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionIconName)
            self.cityLabel.text = weather.cityName
            
            self.stopLoading()
            self.searchTextInput.text = ""
            self.searchTextInput.placeholder = "Digite uma cidade"
        }
    }
    
    func weatherManagerDidFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            self.showInputFieldBorderError()
            self.stopLoading()
        }
    }
}
