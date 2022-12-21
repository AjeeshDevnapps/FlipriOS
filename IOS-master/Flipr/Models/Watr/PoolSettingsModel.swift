// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - PoolSettingsModel
struct PoolSettingsModel: Codable {
    var owner: Owner?
    var privateName:String?
    var location: String?
    var id, builtYear, volume: Int?
    var surface: Double?
    var coating: TypeInfo?
    var integration: TypeInfo?
    var shape: TypeInfo?
    var filtration: TypeInfo?
    var treatment:TypeInfo?
    var isDefective: Bool?
    var electrolyzerThreshold: Int?
    var isPublic: Bool?
    var numberOfUsers: Int?
    var mode: TypeInfo?
    var numberOfPlaces: Int?
    var latitude, longitude: Double?
    var filtrationMode: Int?
    var isFiltrationCommandOn: Bool?
    var lastIFTTTCheck, recommandedFiltrationDuration, commandTemperature: Double?
    var cityID: Int?
    var type: PoolType?
    var spaKind: String?
    var city: CityInSettings?
    var ownerID: Int?

    enum CodingKeys: String, CodingKey {
        case owner = "Owner"
        case privateName = "PrivateName"
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



struct Owner : Codable {

    let actualRights : [String]?
    let birthday : String?
    let email : String?
    let firstName : String?
    let isActivated : Bool?
    let isDesactivated : Bool?
    let isNewsletter : Bool?
    let isOkToShareData : String?
    let isSocietyCreator : Bool?
    let joinedSocietyDate : String?
    let lang : String?
    let lastName : String?
    let notifyFiltrationDuration : Bool?
    let notifyPoolsHealth : Bool?
    let notifyProbeIssues : Bool?
    let notifyStock : Bool?
    let phoneNumber : String?
    let societyId : String?
    let systemPauseNotifications : Bool?


    enum CodingKeys: String, CodingKey {
        case actualRights = "ActualRights"
        case birthday = "Birthday"
        case email = "Email"
        case firstName = "FirstName"
        case isActivated = "IsActivated"
        case isDesactivated = "IsDesactivated"
        case isNewsletter = "IsNewsletter"
        case isOkToShareData = "IsOkToShareData"
        case isSocietyCreator = "IsSocietyCreator"
        case joinedSocietyDate = "JoinedSocietyDate"
        case lang = "Lang"
        case lastName = "LastName"
        case notifyFiltrationDuration = "NotifyFiltrationDuration"
        case notifyPoolsHealth = "NotifyPoolsHealth"
        case notifyProbeIssues = "NotifyProbeIssues"
        case notifyStock = "NotifyStock"
        case phoneNumber = "PhoneNumber"
        case societyId = "SocietyId"
        case systemPauseNotifications = "SystemPauseNotifications"
    }
   

}
