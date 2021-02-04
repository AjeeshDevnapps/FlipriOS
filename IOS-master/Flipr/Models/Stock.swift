//
//  Stock.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 26/06/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

struct Stock {
    
    let id:Int
    let product:Product
    var percentageLeft:Double
    
    init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int, let productJSON = JSON["Product"] as? [String:Any], let percentageLeft = JSON["PercentageLeft"] as? Double else {
            return nil
        }
        guard let product = Product(withJSON: productJSON) else {
            return nil
        }
        
        self.id = id
        self.product = product
        self.percentageLeft = percentageLeft
    }
    
}
