//
//  Weather.swift
//  Clima
//
//  Created by Yan Oliveira on 24/09/22.
//  Copyright © 2022 yloliveira. All rights reserved.
//

struct CurrentWeather {
    var conditionId: Int
    var cityName: String
    var temperature: Float
    var temperatureString: String {
        return String(format: "%0.f", temperature)
    }
    var conditionIconName: String {
        switch self.conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "clould.snow"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
