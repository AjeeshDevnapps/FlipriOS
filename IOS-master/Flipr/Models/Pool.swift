//
//  Pool.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 02/05/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

import Foundation
import Alamofire





class Pool {
    
    var id:Int?
    var builtYear:Int?
    var volume:Double?
    var surface:Double?
    var coating:FormValue?
    var integration:FormValue?
    var filtration:FormValue?
    var shape:FormValue?
    var treatment:FormValue?
    var isPublic = false
    var numberOfPlaces:Int?
    var numberOfUsers:Int?
    var latitude:Double?
    var longitude:Double?
    var city:City?
    var mode:FormValue?
    var situation:FormValue?
    var spaKind:FormValue?
    var electrolyzerThreshold:Double?
    
    var hourlyForecast:[[String:Any]]?
    var dailyForecast:[[String:Any]]?
    
    var equipments = [Equipment]()
    
    var shopUrl = "SHOP_URL".localized.remotable
    
    //MARK: Current User Shared Instance
    static var currentPool : Pool? = {
        if let serializedPool = UserDefaults.standard.object(forKey: "CurrentPool") as? [String : Any] {
            let instance = Pool.init(withJSON: serializedPool)
            return instance
        }
        return nil
    }()
    
    convenience init?(withJSON JSON:[String:Any]) {
        
        self.init()
        
        guard let id = JSON["Id"] as? Int else {
            return nil
        }
        self.id = id
        if let value = JSON["BuiltYear"] as? Int {
            self.builtYear = value
        }
        if let value = JSON["NumberOfUsers"] as? Int {
            self.numberOfUsers = value
        }
        if let value = JSON["NumberOfPlaces"] as? Int {
            self.numberOfPlaces = value
        }
        if let value = JSON["Latitude"] as? Double {
            self.latitude = value
        }
        if let value = JSON["Longitude"] as? Double {
            self.longitude = value
        }
        if let value = JSON["Volume"] as? Double {
            self.volume = value
        }
        if let value = JSON["Surface"] as? Double {
            self.surface = value
        }
        if let value = JSON["IsPublic"] as? Bool {
            self.isPublic = value
        }
        if let value = JSON["Integration"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.integration = formValue
            }
        }
        if let value = JSON["Coating"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.coating = formValue
            }
        }
        if let value = JSON["Shape"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.shape = formValue
            }
        }
        if let value = JSON["Filtration"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.filtration = formValue
            }
        }
        if let value = JSON["Treatment"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.treatment = formValue
            }
        }
        if let value = JSON["Mode"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.mode = formValue
            }
        }
        if let value = JSON["City"] as? [String:Any] {
            if let city = City.init(withJSON: value) {
                self.city = city
            }
        }
        if let value = JSON["Location"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.situation = formValue
            }
        }
        if let value = JSON["SpaKind"] as? [String:Any] {
            if let formValue = FormValue.init(withJSON: value) {
                self.spaKind = formValue
            }
        }
        if let value = JSON["ElectrolyzerThreshold"] as? Double {
            self.electrolyzerThreshold = value
        }
        if let value = JSON["ShopUrl"] as? String {
            self.shopUrl = value
        }
    }
    
    var serialized: [String : Any] {
        var JSON : [String:Any] = [:]
        if let id = id {
            JSON["Id"] = id
        }
        if let builtYear = builtYear {
            JSON["BuiltYear"] = builtYear
        }
        if let numberOfPlaces = numberOfPlaces {
            JSON["NumberOfPlaces"] = numberOfPlaces
        }
        if let numberOfUsers = numberOfUsers {
            JSON["NumberOfUsers"] = numberOfUsers
        }
        if let latitude = latitude {
            JSON["Latitude"] = latitude
        }
        if let longitude = longitude {
            JSON["Longitude"] = longitude
        }
        if let volume = volume {
            JSON["Volume"] = volume
        }
        if let surface = surface {
            JSON["Surface"] = surface
        }
        if let coating = coating {
            JSON["Coating"] = coating.serialized
        }
        if let shape = shape {
            JSON["Shape"] = shape.serialized
        }
        if let integration = integration {
            JSON["Integration"] = integration.serialized
        }
        if let treatment = treatment {
            JSON["Treatment"] = treatment.serialized
        }
        if let filtration = filtration {
            JSON["Filtration"] = filtration.serialized
        }
        if let mode = mode {
            JSON["Mode"] = mode.serialized
        }
        JSON["IsPublic"] = isPublic
        
        if let city = city {
            JSON["City"] = city.serialized
        }
        if let situation = situation {
            JSON["Location"] = situation.serialized
        }
        if let spaKind = spaKind {
            JSON["SpaKind"] = spaKind.serialized
        }
        if let threshold = electrolyzerThreshold {
            JSON["ElectrolyzerThreshold"] = threshold
        }
     
        JSON["ShopUrl"] = shopUrl
        
        print("serialzed Pool: \(JSON)")
        return JSON
    }
    
    
    static func saveCurrentPoolLocally() {
        if let pool = Pool.currentPool {
            UserDefaults.standard.set(pool.serialized, forKey: "CurrentPool")
            print("Save pool: \(pool.serialized)")
        }
    }
    
    func create(completion: ((_ error:Error?) -> Void)?) {
        
        print("create Pool: \(self.serialized)")
        
        var serial = Module.currentModule?.serial
        
        if serial == nil {
            if let hubSerial = HUB.currentHUB?.serial {
                serial = hubSerial
            } else {
                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No serial :/".localized])
                completion?(error)
                return
            }
        }
        
        Alamofire.request(Router.createPool(serialId: serial!, attributes: self.serialized)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [String:Any] {
                    print("createPool JSON: \(JSON)")
                    
                    if let id = JSON["Id"] as? Int {
                        self.id = id
                        Pool.currentPool = self
                        Pool.saveCurrentPoolLocally()
                        completion?(nil)
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(error)
                    }
                } else {
                    print("response.result.value: \(value)")
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(error)
                }
                
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
            
        })
        
    }
    
    func update(completion: ((_ error:Error?) -> Void)?) {
        
        print("update Pool: \(self.serialized)")
        Alamofire.request(Router.updatePool(attributes: self.serialized)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            if response.response?.statusCode == 401 {
                NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
            }
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [String:Any] {
                    print("updatePool JSON: \(JSON)")
                    
                    if let id = JSON["Id"] as? Int {
                        let pool = Pool.init(withJSON: JSON)
                        Pool.currentPool = pool
                        Pool.saveCurrentPoolLocally()
                        completion?(nil)
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(error)
                    }
                } else {
                    print("response.result.value: \(value)")
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(error)
                }
                
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
            
        })
        
    }
    
    func getEquipments(completion: ((_ equimentCategories:[EquipmentCategory]?,_ error:Error?) -> Void)?) {
        
        print("get Pool equipments")
        Alamofire.request(Router.getEquipments).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [[String:Any]] {
                    
                    print("get equipments JSON \(JSON)")
                    var equipmentCategories = [EquipmentCategory]()
                    
                    for item in JSON {
                        if let equipmentCategory = EquipmentCategory(withJSON: item) {
                            equipmentCategories.append(equipmentCategory)
                        }
                    }
                    
                    Alamofire.request(Router.getPoolEquipments(poolId: Pool.currentPool!.id!)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                        
                        switch response.result {
                            
                        case .success(let value):
                            
                            if let JSON = value as? [[String:Any]] {
                                
                                print("get Pool equipments JSON \(JSON)")
                                
                                for item in JSON {
                                    if let id = item["Id"] as? Int {
                                        var i = 0
                                        for category in equipmentCategories {
                                            var j = 0
                                            for equipment in category.equipments {
                                                if equipment.id == id {
                                                    equipmentCategories[i].equipments[j].active = true
                                                }
                                                j = j + 1
                                            }
                                            i = i + 1
                                        }
                                    }
                                }
                                
                                completion?(equipmentCategories, nil)
                                
                            } else {
                                print("response.result.value: \(value)")
                                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                                completion?(nil, error)
                            }
                            
                            
                        case .failure(let error):
                            
                            if let serverError = User.serverError(response: response) {
                                completion?(nil, serverError)
                            } else {
                                completion?(nil, error)
                            }
                        }
                        
                    })
                        
                } else {
                    print("response.result.value: \(value)")
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(nil, error)
                }
                
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    completion?(nil, serverError)
                } else {
                    completion?(nil, error)
                }
            }
            
        })
        
    }
    
    func getShopUrl() {
        
        print("get Pool Shoop")
        Alamofire.request(Router.getShopUrl(poolId: self.id!)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [String:Any] {
                    
                    if let url = JSON["url"] as? String{
                        self.shopUrl = url
                    }
                    print("get Shop JSON \(JSON)")
                   
                }
            case .failure(let error):
                
                print("get Shop Error \(error)")
            }
            
        })
        
    }
    
    func getLog(page: Int, completion: ((_ logs:[Log]?,_ error:Error?) -> Void)?) {
        
        print("get Pool log")
        Alamofire.request(Router.getLog(poolId: self.id!, nbItems: 25, page: page)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [[String:Any]] {
                    
                    print("get pool log JSON \(JSON)")
                    var logs = [Log]()
                    for item in JSON {
                        if let log = Log(withJSON: item) {
                            logs.append(log)
                        }
                    }
                    completion?(logs, nil)
                    
                } else {
                    print("response.result.value: \(value)")
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(nil, error)
                }
                
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    completion?(nil, serverError)
                } else {
                    completion?(nil, error)
                }
            }
            
        })
        
    }
    
    func deleteLog(id: Int, completion: ((_ error:Error?) -> Void)?) {
        
        print("delete Pool log")
        Alamofire.request(Router.deleteLog(poolId: self.id!, logId: id)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success:
                
                completion?(nil)
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
            
        })
        
    }
    
    func addLog(attributes: [String : Any], completion: ((_ error:Error?) -> Void)?) {
        
        print("add Pool log w/ attributes: \(attributes)")
        Alamofire.request(Router.addLog(poolId: self.id!, attributes: attributes)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success:
                
                completion?(nil)
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
            
        })
        
    }
    
    func updateLog(id:Int, attributes: [String : Any], completion: ((_ error:Error?) -> Void)?) {
        
        print("add Pool log w/ attributes: \(attributes)")
        Alamofire.request(Router.updateLog(poolId: self.id!,logId:id, attributes: attributes)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success:
                
                completion?(nil)
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
            
        })
        
    }
    
    func getHUBS(completion: ((_ hubs:[HUB]? , _ error:Error?) -> Void)?) {
        
         Alamofire.request(Router.getHUBS(poolId: self.id!)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                           
                       case .success(let value):
                        
                        
                        if let items = value as? [[String:Any]] {
                            var hubs:[HUB] = []
                            for item in items {
                                print("All HUBS JSON: \(item)")
                                if let hub = HUB.init(withJSON: item) {
                                    hubs.append(hub)
                                }
                            }
                            completion?(hubs, nil)
                        } else {
                            print("response.result.value: \(value)")
                            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                            completion?(nil, error)
                        }
                        
                           
                           
                       case .failure(let error):
                           
                           if let serverError = User.serverError(response: response) {
                               completion?(nil, serverError)
                           } else {
                               completion?(nil, error)
                           }
                       }
                       
            })
        
    }
    
}
