//
//  ShareModel.swift
//  Flipr
//
//  Created by Ajeesh T S on 03/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//
/*
{
"PlaceOwner": 14862,
"PlaceOwnerFirstName": "Gael",
"PlaceOwnerLastName": "Marronnier",
"PlaceCity": "Vigoulet-Auzil",
"GuestUser": "test@mailinator.com",
"PlaceId": 10994,
"PermissionLevel": "View",
"PlaceType": "SwimmingPool",
"Name": "Piscine",
"TypeIcon": "piscine.png",
"IsPending": true
}
*/

import Foundation

struct ShareModel {
    
    var placeOwnerId:Int
    var placeOwnerFirstName:String
    var placeOwnerLastName:String
    var placeCity:String
    var guestUser:String
    var placeId:Int
    var permissionLevel:String
    var placeType:String
    var name:String
    var typeIcon: String
    var isPending: Bool
    
    init?(withJSON JSON:[String:Any]) {
        
        if let id = JSON["PlaceOwnerId"] as? Int {
            self.placeOwnerId = id
        } else {
            self.placeOwnerId = 0
        }
        
        if let value = JSON["placeOwnerFirstName"] as? String {
            self.placeOwnerFirstName = value
        } else {
            self.placeOwnerFirstName = ""
        }
        
        if let value = JSON["PlaceOwnerLastName"] as? String {
            self.placeOwnerLastName = value
        } else {
            self.placeOwnerLastName = ""
        }
        
        if let value = JSON["PlaceCity"] as? String {
            self.placeCity = value
        } else {
            self.placeCity = ""
        }
        
        if let value = JSON["GuestUser"] as? String {
            self.guestUser = value
        } else {
            self.guestUser = ""
        }
        
        if let value = JSON["PlaceId"] as? Int {
            self.placeId = value
        } else {
            self.placeId = 0
        }
        
        if let value = JSON["PermissionLevel"] as? String {
            permissionLevel = value
        } else {
            permissionLevel = ""
        }
        
        if let value = JSON["PlaceType"] as? String {
            self.placeType = value
        } else {
            self.placeType = ""
        }
        
        if let value = JSON["Name"] as? String {
            self.name = value
        } else {
            self.name = ""
        }
        
        if let value = JSON["TypeIcon"] as? String {
            self.typeIcon = value
        } else {
            self.typeIcon = ""
        }
        
        if let value = JSON["IsPending"] as? Bool {
            self.isPending = value
        } else {
            self.isPending = false
        }

    }
}
