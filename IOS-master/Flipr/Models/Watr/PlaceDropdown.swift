//
//  PlaceDropdown.swift
//  Flipr
//
//  Created by Ajeesh on 03/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import Foundation
class PlaceDropdown{

    var guestUser : String!
    var isPending : Bool!
    var name : String!
    var privateName : String!
    var permissionLevel : String!
    var placeCity : String!
    var placeId : Int!
    var placeOwner : Int!
    var placeOwnerFirstName : String!
    var placeOwnerLastName : String!
    var placeType : String!
    var typeIcon : String!
    var numberOfModules : Int = 0




    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: [String:Any]){
        if let noOfModules = dictionary["NumberOfModules"] as? Int{
            numberOfModules = noOfModules
        }
        guestUser = dictionary["GuestUser"] as? String

        isPending = dictionary["IsPending"] as? Bool
        name = dictionary["Name"] as? String
        permissionLevel = dictionary["PermissionLevel"] as? String
        placeCity = dictionary["PlaceCity"] as? String
        placeId = dictionary["PlaceId"] as? Int
        placeOwner = dictionary["PlaceOwner"] as? Int
        placeOwnerFirstName = dictionary["PlaceOwnerFirstName"] as? String
        placeOwnerLastName = dictionary["PlaceOwnerLastName"] as? String
        placeType = dictionary["PlaceType"] as? String
        typeIcon = dictionary["TypeIcon"] as? String
        privateName = dictionary["PrivateName"] as? String
    }

}
