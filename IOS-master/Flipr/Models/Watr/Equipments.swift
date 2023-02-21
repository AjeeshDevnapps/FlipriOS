//
//  Equipments.swift
//  Flipr
//
//  Created by Ajeesh on 21/02/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import Foundation
class Equipments{

    var lastMeasureDateTime : String!
    var mode : String!
    var model : String!
    var moduleName : String!
    var moduleType : Int!
    var percentageBattery : Float!
    var placeName : String!
    var serial : String!
    var state : Int!
    var statut : Bool!
    var tensionBattery : Float!
    var userFirstName : String!
    var userLastName : String!
    var version : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        lastMeasureDateTime = dictionary["LastMeasureDateTime"] as? String
        mode = dictionary["Mode"] as? String
        model = dictionary["Model"] as? String
        moduleName = dictionary["ModuleName"] as? String
        moduleType = dictionary["ModuleType"] as? Int
        percentageBattery = dictionary["PercentageBattery"] as? Float
        placeName = dictionary["PlaceName"] as? String
        serial = dictionary["Serial"] as? String
        state = dictionary["State"] as? Int
        statut = dictionary["Statut"] as? Bool
        tensionBattery = dictionary["TensionBattery"] as? Float
        userFirstName = dictionary["UserFirstName"] as? String
        userLastName = dictionary["UserLastName"] as? String
        version = dictionary["Version"] as? Int
    }

}
