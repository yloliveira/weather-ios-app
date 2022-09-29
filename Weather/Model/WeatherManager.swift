//
//  WeatherManager.swift
//  Clima
//
//  Created by Yan Oliveira on 24/09/22.
//  Copyright © 2022 yloliveira. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func weatherManagerDidFetchCurrentCityWeatherData(_ weatherManager: WeatherManager, _ weather: CurrentWeather) -> Void
    func weatherManagerDidFailWithError(_ error: Error) -> Void
}

struct WeatherManager {
    private let httpClient = HttpClient(baseUrl: "https://api.openweathermap.org/data/2.5/weather?appid=&units=metric")
    
    var delegate: WeatherManagerDelegate?
    
    func fetchCurrentWeatherDataBy(cityName: String) {
        let urlString = "&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchCurrentWeatherDataBy(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        httpClient.performGetRequest(with: urlString) { (data, response, error) in
            if error != nil {
                delegate?.weatherManagerDidFailWithError(error!)
                return
            }
            if let safeData = data {
                if let JSONData = self.parseJSON(safeData) {
                    let weather = CurrentWeather(conditionId: JSONData.weather[0].id, cityName: JSONData.name, temperature: JSONData.main.temp)
                    self.delegate?.weatherManagerDidFetchCurrentCityWeatherData(self, weather)
                }
            }
        }
    }
    
    private func parseJSON(_ data: Data) -> OpenWeatherCurrentData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(OpenWeatherCurrentData.self, from: data)
            return decodedData
        } catch {
            delegate?.weatherManagerDidFailWithError(error)
            return nil
        }
    }
}
