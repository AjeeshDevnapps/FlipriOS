//
//  Planning.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 04/06/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import Foundation

class Planning {
    
    var id = 0
    var name = ""
    var isActivated = false
    var order = 0
    var days = "0000000"
    var listStartingMinuteduration:[String:String] = [:]
    
    init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["id"] as? Int, let name = JSON["name"] as? String, let isActivated = JSON["isActivated"] as? Bool, let order = JSON["order"] as? Int, let days = JSON["days"] as? String else {
            return nil
        }
        
        if days.count != 7 {
            return nil
        }
        
        self.id = id
        self.name = name
        self.order = order
        self.isActivated = isActivated
        self.days = days
        
        if let list = JSON["list_StartingMinute_duration"] as? [String:String] {
            self.listStartingMinuteduration = list
        }
        
    }
    
    var serialized: [String : Any] {
        var JSON : [String:Any] = [:]
        JSON["id"] = id
        JSON["name"] = name
        JSON["isActivated"] = isActivated
        JSON["order"] = order
        JSON["days"] = days
        JSON["list_StartingMinute_duration"] = listStartingMinuteduration
        return JSON
    }
    
    var timeSlot:[Int] {
        
        var slot = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        let keys = self.listStartingMinuteduration.keys
        for key in keys {
            let index = Int(key)!/60
            slot[index] = 1
            
            let duration = Int(listStartingMinuteduration[key]!)!/60
            for i in index...(index+duration-1) {
                if i < slot.count {
                     slot[i] = 1
                }
            }
        }
        
        return slot
    }
    
}
