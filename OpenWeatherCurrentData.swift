//
//  OpenWeatherCurrentData.swift
//  Clima
//
//  Created by Yan Oliveira on 24/09/22.
//  Copyright © 2022 yloliveira. All rights reserved.
//

import Foundation

struct OpenWeatherCurrentData: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Decodable {
    let id: Int
}

struct Main: Decodable {
    let temp: Float
}
