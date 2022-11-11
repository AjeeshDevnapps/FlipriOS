//
//  PlaceType.swift
//  Flipr
//
//  Created by Ajeesh T S on 30/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import Foundation

typealias PlaceTypes = [PlaceType]

struct PlaceType: Codable {
    let id: Int?
    let isAvailableAsPlace: Bool?
    let typeIcon, name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isAvailableAsPlace = "IsAvailableAsPlace"
        case typeIcon = "TypeIcon"
        case name = "Name"
    }
}
