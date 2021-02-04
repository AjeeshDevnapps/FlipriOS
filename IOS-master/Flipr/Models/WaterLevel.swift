//
//  WaterLevel.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 17/04/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import Foundation

struct WaterLevel {
    
    let id:Int
    let date:Date
    var fillPercentage:Double
    
    init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int, let dateTime = JSON["Date"] as? String, let fillPercentage = JSON["FillPercentage"] as? Double else {
            return nil
        }
        
        if let date = dateTime.fliprDate {
            self.id = id
            self.date = date
            self.fillPercentage = fillPercentage
        } else {
            return nil
        }
        
    }
    
}
