//
//  WeatherForHour.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 26/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import Foundation

struct WeatherForHour: Codable {
    let cloudCover: Double?
    let temp,precipitationProbability,windSpeed: Double?
    let weatherIcon: String?
    let hourTemperature: String?

    enum CodingKeys: String, CodingKey {
        case cloudCover = "CloudCover"
        case temp = "Temperature"
        case weatherIcon = "WeatherIcon"
        case hourTemperature = "HourTemperature"
        case precipitationProbability = "PrecipitationProbability"
        case windSpeed = "WindSpeed"

    }
}
