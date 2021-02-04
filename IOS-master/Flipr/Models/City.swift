//
//  City.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 03/05/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

class City {
    
    var zipCode:String?
    var name:String
    var latitude:Double
    var longitude:Double
    var countryCode = "FR"
    
    init(name: String, latitude:Double, longitude:Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init?(withJSON JSON:[String:Any]) {
        guard let name = JSON["Name"] as? String, let latitude = JSON["Latitude"] as? Double, let longitude = JSON["Longitude"] as? Double else {
            return nil
        }
        self.init(name: name, latitude: latitude, longitude: longitude)
        if let zipCode = JSON["ZipCode"] as? String {
            self.zipCode = zipCode
        }
        if let country = JSON["Country"] as? [String:Any] {
            if let code = country["Code"] as? String {
                self.countryCode = code
            }
        }
    }
    
    var serialized: [String : Any] {
        var JSON : [String:Any] = ["Name":name,"Latitude":latitude,"Longitude":longitude]
        if let zipCode = self.zipCode {
            JSON["ZipCode"] = zipCode
        }
        JSON["Country"] = ["Code":countryCode]
        return JSON
    }
    
}
