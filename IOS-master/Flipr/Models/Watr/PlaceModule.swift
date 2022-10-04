//
//  PlaceModule.swift
//  Watr
//
//  Created by Ajeesh on 03/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import Foundation
class PlaceModule{

    var activationKey : String!
    var isFlipr : Bool!
    var isStart : Bool!
    var placeid : Int!
    var serial : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: [String:Any]){
        activationKey = dictionary["activationKey"] as? String
        isFlipr = dictionary["isFlipr"] as? Bool
        isStart = dictionary["isStart"] as? Bool
        placeid = dictionary["placeid"] as? Int
        serial = dictionary["serial"] as? String
    }

}
