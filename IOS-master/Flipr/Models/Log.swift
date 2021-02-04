//
//  Log.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 25/07/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import Foundation

struct Log {
    
    let id:Int
    let title:String
    let type:LogType
    let date:Date
    let iconUrl:String
    let userComment:String?
    let systemComment:String?
    var product:Product?
    var quantity:Double?
    
    init?(withJSON JSON:[String:Any]) {
        guard let log = JSON["Log"] as? [String:Any], let type = JSON["Type"] as? [String:Any] else {
            return nil
        }
        if let id = log["Id"] as? Int {
            self.id = id
        } else {
            return nil
        }
        if let value = log["Title"] as? String {
            self.title = value
        } else {
            return nil
        }
        if let value = log["Date"] as? Double {
            self.date = Date(timeIntervalSince1970: value/1000)
        } else {
            return nil
        }
        if let value = JSON["SystemComment"] as? String {
            self.systemComment = value
        } else {
           self.systemComment = nil
        }
        if let value = log["UserComment"] as? String {
            self.userComment = value
        } else {
            self.userComment = nil
        }
        if let value = JSON["IconUrl"] as? String {
            iconUrl = value
        } else {
            iconUrl = ""
        }
        if let typeE = LogType(withJSON: type) {
            self.type = typeE
        } else {
            return nil
        }
        
        if let value = JSON["Product"] as? [String:Any] {
            self.product = Product(withJSON: value)
        }
        
        if let value = log["Quantity"] as? Double {
            self.quantity = value
        }
        
//        if let date = Date(integerLiteral: dateTime) {
//            self.date = date
//        } else {
//            return nil
//        }
        
    }
    
}
