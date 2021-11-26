//
//  WeatherForDay.swift
//  Flipr
//
//  Created by Ajeesh on 02/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import Foundation
struct WeatherForDay: Codable {
    let date: String
    let moyRX, moyPH, minTemp, maxTemp: Double?
    let weatherIcon: String?
    let uvIndex: Double?

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case moyRX, moyPH, minTemp, maxTemp
        case weatherIcon = "WeatherIcon"
        case uvIndex = "UvIndex"
    }
}
