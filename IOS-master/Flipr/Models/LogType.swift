//
//  LogType.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 25/07/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import Foundation

import Foundation

struct LogType {
    
    let id:Int
    let value:String
    let hexColor:String
    let isAutoEntry:Int
    
    init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int, let value = JSON["value"] as? String, let color = JSON["Color"] as? String else {
            return nil
        }
        self.id = id
        self.value = value
        self.hexColor = color
        if let value = JSON["IsAutoEntry"] as? Bool {
            if value == true {
                isAutoEntry = 1
            } else {
                isAutoEntry = 0
            }
        } else {
            isAutoEntry = -1
        }
        
    }
    
    func color() -> UIColor {
        var cString:String = self.hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
