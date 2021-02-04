//
//  Product.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/06/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import Alamofire

struct Product {
    
    var id:Int?
    let EAN:Int64
    var productType:ProductType
    var name:String? = nil
    var brand:ProductAttribute? = nil
    
    var conditioning:ProductAttribute? = nil
    
    var conditioningUnit:ProductAttribute? = nil
    var doseUnit:ProductAttribute? = nil
    
    var applicationMethod:ProductAttribute? = nil
    
    var quantity = 0.0
    var pebleWeight = 0.0
    var initialDosage = 0.0
    var chocDosage = 0.0
    var weeklyDosage = 0.0
    var adjustment = 0.0
    var referenceWaterVolumeForDosage = 0.0
    
    var isStabilized = false
    var isMultiFunction = false
    var isSlowDissolution = false
    var isReducer = false
    var isReducerApplicable = false
    
    var isValidated = false
    
    var doseUnitId:Int?
    
    /*
    init(EAN:Int64, type:ProductAttribute, name:String?, brandName:String?) {
        self.EAN = EAN
        self.productType = type
        self.name = name
        //self.brandName = brandName
    }
    */
    
    init?(withJSON JSON:[String:Any]) {
        guard let EAN = JSON["EAN"] as? Int64, let productType = JSON["ProductType"] as? [String:Any] else {
            return nil
        }
        guard let type = ProductType(JSON: productType) else {
            return nil
        }
        
        self.EAN = EAN
        self.productType = type
        
        if let id = JSON["Id"] as? Int {
            self.id = id
        }
        
        if let id = JSON["DoseUnit_Id"] as? Int {
            self.doseUnitId = id
        }
        
        if let name = JSON["Name"] as? String {
            self.name = name
        }
        if let brand = JSON["Brand"] as? [String:Any] {
            if let attribute = ProductAttribute(JSON: brand) {
                self.brand = attribute
            }
        }
        
        if let applicationMethods = JSON["ApplicationMethod"] as? [[String:Any]] {
            if applicationMethods.count > 0 {
                if let attribute = ProductAttribute(JSON: applicationMethods.first!) {
                    self.applicationMethod = attribute
                }
            }
        }
        
        if let conditioningUnit = JSON["ConditioningUnit"] as? [String:Any] {
            if let attribute = ProductAttribute(JSON: conditioningUnit) {
                self.conditioningUnit = attribute
            }
        }
        if let conditioning = JSON["Conditionning"] as? [String:Any] {
            if let attribute = ProductAttribute(JSON: conditioning) {
                self.conditioning = attribute
            }
        }
        if let doseUnit = JSON["DoseUnit"] as? [String:Any] {
            if let attribute = ProductAttribute(JSON: doseUnit) {
                self.doseUnit = attribute
            }
        }
        if let value = JSON["IsValidated"] as? Bool {
            self.isValidated = value
        }
        
        if let value = JSON["InitialDosage"] as? Double {
            self.initialDosage = value
        }
        if let value = JSON["InitialDosage"] as? Double {
            self.initialDosage = value
        }
        if let value = JSON["WeeklyDosage"] as? Double {
            self.weeklyDosage = value
        }
        if let value = JSON["Adjustment"] as? Double {
            self.adjustment = value
        }
        if let value = JSON["ReferenceWaterVolumeForDosage"] as? Double {
            self.referenceWaterVolumeForDosage = value
        }
        
        if let value = JSON["ChockDosage"] as? Double {
            self.chocDosage = value
        }
        
        if let value = JSON["IsMultiFunction"] as? Bool {
            self.isMultiFunction = value
        }
        if let value = JSON["IsReducer"] as? Bool {
            self.isReducer = value
            isReducerApplicable = true
        } else {
            isReducerApplicable = false
        }
        if let value = JSON["IsSlowDissolution"] as? Bool {
            self.isSlowDissolution = value
        }
        if let value = JSON["IsStabilized"] as? Bool {
            self.isStabilized = value
        }
        
        if let value = JSON["PebbleWeight"] as? Double {
            self.pebleWeight = value
        }
        if let value = JSON["Quantity"] as? Double {
            self.quantity = value
        }

    }
    
    var serialized: [String : Any] {
        var product: [String : Any] = ["EAN":self.EAN,"ProductType":self.productType.serialized]
        if let value = self.name {
            product["Name"] = value
        }
        if let value = self.brand {
            product["Brand"] = value.serialized
        }
        if let value = self.conditioning {
            product["Conditionning"] = value.serialized
        }
        if let value = self.conditioningUnit {
            product["ConditioningUnit"] = value.serialized
        }
        if let value = self.doseUnit {
            product["DoseUnit"] = value.serialized
        }
        if let value = self.applicationMethod {
            product["ApplicationMethod"] = [value.serialized]
        }

        product["Quantity"] = self.quantity
        product["PebbleWeight"] = self.pebleWeight
        product["InitialDosage"] = self.initialDosage
        product["ChockDosage"] = self.chocDosage
        product["WeeklyDosage"] = self.weeklyDosage
        product["ReferenceWaterVolumeForDosage"] = self.referenceWaterVolumeForDosage
        product["Adjustment"] = self.adjustment
        
        product["IsStabilized"] = self.isStabilized
        product["IsMultiFunction"] = self.isMultiFunction
        product["IsSlowDissolution"] = self.isSlowDissolution
        
        if isReducerApplicable {
            product["IsReducer"] = self.isReducer
        }
        
        return product
    }
    
    /*
    var apiSerialized: [String : Any] {
        var product: [String : Any] = ["EAN":self.EAN,"ProductType":self.productType.apiSerialized]
        if let value = self.name {
            product["Name"] = value
        }
        return product
    }*/
    
}

enum ProductAttributeType: String {
    case type = "type"
    case brand = "brand"
    case conditioning = "conditioning"
    case applicationMethod = "applicationmethod"
    case doseUnit = "dosageunits"
    case conditioningUnit = "units"
    
    var title:String {
        switch self {
        case .type:
            return "Product type".localized
        case .brand:
            return "Brand".localized
        case .conditioning:
            return "Product form".localized
        case .applicationMethod:
            return "Application method".localized
        case .doseUnit:
            return "Unit of dosage".localized
        case .conditioningUnit:
            return "Unit of measure".localized
        }
    }
}

struct ProductAttribute {

    let id: Int
    let name:String
    
    init?(JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int,
            let name = JSON["Name"] as? String
            else {
                return nil
        }
        self.id = id
        self.name = name
    }
    
    var serialized: [String : Any] {
        if id == 0 { return ["Name":name] }
        return ["Id":id,"Name":name]
    }
}

struct ProductType {
    
    let id: Int
    let name:String
    var hasChockDosage = false
    var hasInitialDosage = false
    var hasAdjustment = false
    
    var hasDifferentDissolutionSpeeds = false
    var canBeMultifunction = false
    var canBeStabilized = false
    var canIncrementOrDecrementMeasure = false
    
    init?(JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int,
            let name = JSON["Name"] as? String
            else {
                return nil
        }
        self.id = id
        self.name = name
        
        if let value = JSON["HasChockDosage"] as? Bool {
            self.hasChockDosage = value
        }
        if let value = JSON["HasInitialDosage"] as? Bool {
            self.hasInitialDosage = value
        }
        if let value = JSON["HasAdjustment"] as? Bool {
            self.hasAdjustment = value
        }
        if let value = JSON["HasDifferentDissolutionSpeeds"] as? Bool {
            self.hasDifferentDissolutionSpeeds = value
        }
        if let value = JSON["CanBeMultifunction"] as? Bool {
            self.canBeMultifunction = value
        }
        if let value = JSON["CanBeStabilized"] as? Bool {
            self.canBeStabilized = value
        }
        if let value = JSON["CanIncrementOrDecrementMeasure"] as? Bool {
            self.canIncrementOrDecrementMeasure = value
        }
        
    }
    
    var serialized: [String : Any] {
        if id == 0 { return ["Name":name] }
        return ["Id":id,"Name":name,"HasChockDosage":hasChockDosage,"HasInitialDosage":hasInitialDosage,"HasAdjustment":hasAdjustment,"HasDifferentDissolutionSpeeds":hasDifferentDissolutionSpeeds,"CanBeMultifunction":canBeMultifunction,"CanBeStabilized":canBeStabilized,"CanIncrementOrDecrementMeasure":canIncrementOrDecrementMeasure]
    }
}

