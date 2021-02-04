//
//  Equipment.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 01/09/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

struct Equipment {
    
    let id:Int
    let name:String
    var active = false
    
    init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int, let name = JSON["Name"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
    }
    
}

class EquipmentSwitch:UISwitch {
    var section = 0
    var index = 0
}


struct EquipmentCategory {
    
    let id:Int
    let name:String
    var equipments = [Equipment]()
    
    init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int, let name = JSON["Name"] as? String,  let equipments = JSON["Equipments"] as? [[String:Any]] else {
            return nil
        }
        self.id = id
        self.name = name

        for item in equipments {
            if let equipment = Equipment(withJSON: item) {
                    self.equipments.append(equipment)
            }
        }
        
    }
    
}
