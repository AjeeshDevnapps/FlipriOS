//
//  Module.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 18/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import Alamofire

class Module {
    
    var serial:String
    var activationKey:String?
    var nickName:String?
    var pH4CalibrationDone = false
    var pH7CalibrationDone = false
    var isForSpa = false
    
    var rawlastMeasure:String?
    var rawPH:String?
    var rawRedox:String?
    var rawConductivity:String?
    var rawWaterTemperature:String?
    
    var version:Int?
    
    var isStart = false
    var isSubscriptionValid = false
    
    var activationDate = Date(timeIntervalSince1970: 0)
    
    //MARK: Current User Shared Instance
    static var currentModule : Module? = {
        if let serializedModule = UserDefaults.standard.object(forKey: "CurrentModule") as? [String : Any] {
            let instance = Module.init(withJSON: serializedModule)
            return instance
        }
        return nil
    }()
    
    init(serial: String) {
        self.serial = serial
    }
    
    convenience init?(withJSON JSON:[String:Any]) {
        guard let serial = JSON["Serial"] as? String else {
            return nil
        }
        self.init(serial: serial)
        if let activationKey = JSON["ActivationKey"] as? String {
            self.activationKey = activationKey
        }
        if let name = JSON["NickName"] as? String {
            nickName = name
        } else {
            nickName = "Flipr " + serial
        }
        if let pH4Calibration = JSON["pH4CalibrationDone"] as? Bool {
            pH4CalibrationDone = pH4Calibration
        }
        if let pH7Calibration = JSON["pH7CalibrationDone"] as? Bool {
            pH7CalibrationDone = pH7Calibration
        }
        if let spa = JSON["IsForSpa"] as? Bool {
            isForSpa = spa
        }
        if let subscription = JSON["IsSubscriptionValid"] as? Bool {
            isSubscriptionValid = subscription
        }
        if let vers = JSON["Version"] as? Int {
            version = vers
        }
        if let status = JSON["Status"] as? [String:Any] {
            if let dateTime = status["DateTime"] as? String {
                if let date = dateTime.fliprDate {
                    activationDate = date
                }
            }
        } else {
            //From serialzation
            if let dateTime = JSON["ActivationDate"] as? String {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                if let date = formatter.date(from: dateTime) {
                    activationDate = date
                }
            }
        }
    }
    
    var serialized: [String : Any] {
        var JSON : [String:Any] = ["Serial":self.serial]
        if let activationKey = self.activationKey {
            JSON.updateValue(activationKey, forKey: "ActivationKey")
        }
        if let nickName = self.nickName {
            JSON.updateValue(nickName, forKey: "NickName")
        }
        JSON.updateValue(pH4CalibrationDone, forKey: "pH4CalibrationDone")
        JSON.updateValue(pH7CalibrationDone, forKey: "pH7CalibrationDone")
        JSON.updateValue(isForSpa, forKey: "IsForSpa")
        if let version = self.version {
            JSON.updateValue(version, forKey: "Version")
        }
        JSON.updateValue(isSubscriptionValid, forKey: "IsSubscriptionValid")
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        JSON.updateValue(formatter.string(from: activationDate), forKey: "ActivationDate")
        return JSON
    }
    
    static func deleteCurrentModule(completion: ((_ error:Error?) -> Void)?) {
        
        if let module = Module.currentModule, let activationKey = Module.currentModule?.activationKey {
            Alamofire.request(Router.addModule(serial: module.serial, activationKey: activationKey, delete:true)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    completion?(nil)
                    Module.currentModule = nil
                    UserDefaults.standard.removeObject(forKey:"CurrentModule")
                    
                case .failure(let error):
                    
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                }
                
            })
        } else {
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No current module :/"])
            completion?(error)
        }
        
        
        
    }
    
    static func activate(serial: String, activationKey: String, completion: ((_ error:Error?) -> Void)?) {
        
        Alamofire.request(Router.addModule(serial: serial, activationKey: activationKey, delete:false)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [String:Any] {
                    print("JSON: \(JSON)")
                    
                    if let isForSpa = JSON["IsForSpa"] as? Bool {
                        Module.currentModule = Module.init(serial: serial)
                        Module.currentModule?.activationKey = activationKey
                        Module.currentModule?.nickName = "Flipr " + serial
                        Module.currentModule?.isForSpa = isForSpa
                        if let fliprVersion = JSON["Version"] as? Int {
                            Module.currentModule?.version = fliprVersion
                        }
                        Module.saveCurrentModuleLocally()
                        
                        completion?(nil)
                        
                        BLEManager.shared.activationNeeded = true
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(error)
                    }
                    
                    /*
                    if let success = JSON["Success"] as? Bool {
                        if success == true {
                            Module.currentModule = Module.init(serial: serial)
                            Module.currentModule?.activationKey = activationKey
                            Module.currentModule?.nickName = "Flipr " + serial
                            Module.saveCurrentModuleLocally()
                            
                            completion?(nil)
                            
                            BLEManager.shared.activationNeeded = true
                            
                        } else {
                            if let errorMessage = JSON["Message"] as? String {
                                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:errorMessage])
                                completion?(error)
                            } else {
                                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Erreur inconnue :/"])
                                completion?(error)
                            }
                        }
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(error)
                    }
                     */
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
    
    func getAlerts(completion: ((_ alert:Alert?, _ priorityAlerts:[Alert],_ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.getAlerts(serial: self.serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Get module alerts - response.result.value: \(value)")
                
                if let alerts = value as? [[String:Any]] {
                    
                    var mainAlert:Alert?
                    var priorityAlerts = [Alert]()
                    
                    for JSON in alerts {
                        if let alert = Alert.init(withJSON: JSON) {
                            if alert.iconUrl != nil {
                                priorityAlerts.append(alert)
                            } else {
                                if mainAlert == nil {
                                    mainAlert = alert
                                }
                            }
                            
                        }
                    }
                    completion?(mainAlert,priorityAlerts,nil)
                } else {
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(nil,[],error)
                }
                
            case .failure(let error):
                
                print("Get module alerts did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(nil, [],serverError)
                } else {
                    completion?(nil, [],error)
                }
            }
        })
    }
    
    func postponeAlerts(value:Int,completion: ((_ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.postponeAlerts(serial: self.serial, value:value)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Postpone alerts - response.result.value: \(value)")
                
                completion?(nil)
                
            case .failure(let error):
                
                print("Get module alerts did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
        })
    }
    
    static func saveCurrentModuleLocally() {
        if let module = Module.currentModule {
            UserDefaults.standard.set(module.serialized, forKey: "CurrentModule")
            print("Save module: \(module.serialized)")
        }
    }
    
}
