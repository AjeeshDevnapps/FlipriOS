// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - PoolSettingsModel
struct PoolSettingsModel: Codable {
    let owner: String?
    let id, builtYear, volume: Int?
    let surface: Double?
    let coating: TypeInfo?
    let integration: TypeInfo?
    let shape: TypeInfo?
    let filtration: TypeInfo?
    let treatment, location: TypeInfo?
    let isDefective: Bool?
    let electrolyzerThreshold: Int?
    let isPublic: Bool?
    let numberOfUsers: Int?
    let mode: TypeInfo?
    let numberOfPlaces: Int?
    let latitude, longitude: Double?
    let filtrationMode: Int?
    let isFiltrationCommandOn: Bool?
    let lastIFTTTCheck, recommandedFiltrationDuration, commandTemperature: Double?
    let cityID: Int?
    let type: PoolType?
    let spaKind: String?
    let city: CityInSettings?
    let ownerID: Int?

    enum CodingKeys: String, CodingKey {
        case owner = "Owner"
        case id = "Id"
        case builtYear = "BuiltYear"
        case volume = "Volume"
        case surface = "Surface"
        case coating = "Coating"
        case integration = "Integration"
        case shape = "Shape"
        case filtration = "Filtration"
        case treatment = "Treatment"
        case location = "Location"
        case isDefective = "IsDefective"
        case electrolyzerThreshold = "ElectrolyzerThreshold"
        case isPublic = "IsPublic"
        case numberOfUsers = "NumberOfUsers"
        case mode = "Mode"
        case numberOfPlaces = "NumberOfPlaces"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case filtrationMode = "FiltrationMode"
        case isFiltrationCommandOn = "IsFiltrationCommandOn"
        case lastIFTTTCheck = "LastIFTTTCheck"
        case recommandedFiltrationDuration = "RecommandedFiltrationDuration"
        case commandTemperature = "CommandTemperature"
        case cityID = "City_Id"
        case type = "Type"
        case spaKind = "SpaKind"
        case city = "City"
        case ownerID = "Owner_Id"
    }
}

// MARK: - City
struct CityInSettings: Codable {
    let id: Int?
    let isSigfoxRelayLocation: Bool?
    let country: Country?
    let zipCode, name: String?
    let longitude, latitude: Double?
    let altitude: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case isSigfoxRelayLocation = "IsSigfoxRelayLocation"
        case country = "Country"
        case zipCode = "ZipCode"
        case name = "Name"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case altitude = "Altitude"
    }
}

// MARK: - Country
struct Country: Codable {
    let code, name: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
    }
}

// MARK: - Coating
struct TypeInfo: Codable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

// MARK: - TypeClass
struct PoolType: Codable {
    let id: Int?
    let isAvailableAsPlace: Bool?
    let typeIcon, name: String?
    let integrations, equipments, filtrations: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isAvailableAsPlace = "IsAvailableAsPlace"
        case typeIcon = "TypeIcon"
        case name = "Name"
        case integrations = "Integrations"
        case equipments = "Equipments"
        case filtrations = "Filtrations"
    }
}
