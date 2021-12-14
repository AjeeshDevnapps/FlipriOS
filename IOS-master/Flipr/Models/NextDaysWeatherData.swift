//
//  NextDaysWeatherData.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import Foundation

struct NextDaysWeatherData: Codable {
    let cloudCover: Double?
    let weatherIcon: String?
    let tempMax: Double?
    let day, tempMaxTime: String?
    let tempMin: Double?
    let tempMinTime: String?

    enum CodingKeys: String, CodingKey {
        case cloudCover = "CloudCover"
        case weatherIcon = "WeatherIcon"
        case tempMax = "TempMax"
        case day = "Day"
        case tempMaxTime = "TempMaxTime"
        case tempMin = "TempMin"
        case tempMinTime = "TempMinTime"
    }
}
