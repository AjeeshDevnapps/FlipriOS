//
//  HUB.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import Foundation
import Alamofire

class HUB {
    
    var serial:String
    var activationKey:String?
    var name:String?
    var isSubscriptionValid = false
    var version:Int?
    
    var equipementName:String = ""
    var equipementCode = 84
    var equipementState = false
    var behavior:String = "manual"
    
    var plannings:[Planning] = []
    
    var activationDate = Date(timeIntervalSince1970: 0)
    var response :[String:Any]?
    
    init(serial: String) {
        self.serial = serial
    }
    
    //MARK: Current User Shared Instance
    static var currentHUB : HUB? = {
        if let serializedHUB = UserDefaults.standard.object(forKey: "CurrentHUB") as? [String : Any] {
            let instance = HUB.init(withJSON: serializedHUB)
            return instance
        }
        return nil
    }()
    
    static func saveCurrentHUBLocally() {
        if let hub = HUB.currentHUB {
            UserDefaults.standard.set(hub.serialized, forKey: "CurrentHUB")
            print("Save hub: \(hub.serialized)")
        }
    }
    
    convenience init?(withJSON JSON:[String:Any]) {
        guard let serial = JSON["Serial"] as? String else {
            return nil
        }
        self.init(serial: serial)
        self.response = JSON
        if let activationKey = JSON["ActivationKey"] as? String {
            self.activationKey = activationKey
        }
        if let value = JSON["name"] as? String {
            name = value
        } else {
            name = "Flipr HUB " + serial
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
        
        if let value = JSON["NameEquipment"] as? String {
            equipementName = value
        }
        if let value = JSON["CodeEquipment"] as? Int {
            equipementCode = value
        }
        if let value = JSON["StateEquipment"] as? Bool {
            equipementState = value
        }
        if let value = JSON["Behavior"] as? String {
            behavior = value
        }
    }
    
    var serialized: [String : Any] {
        var JSON : [String:Any] = ["Serial":self.serial]
        if let activationKey = self.activationKey {
            JSON.updateValue(activationKey, forKey: "ActivationKey")
        }
        /*
        if let nickName = self.name {
            JSON.updateValue(nickName, forKey: "NickName")
        }*/
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
    
    static func activate(serial: String, activationKey: String, equipmentCode:String, completion: ((_ error:Error?) -> Void)?) {
        
        Alamofire.request(Router.addModule(serial: serial, activationKey: activationKey, delete:false)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [String:Any] {
                    print("HUB activation JSON: \(JSON)")
                    if let type = JSON["ModuleType_Id"] as? Int {
                        if type == 2 {
                            let hub = HUB.init(serial: serial)
                            HUB.currentHUB = hub
                            HUB.saveCurrentHUBLocally()
                            
                            Alamofire.request(Router.addModuleEquipment(serial: serial, code: equipmentCode)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                                
                                completion?(nil)
                                
                            })
                            
                            
                        } else {
                            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"This is not a HUB".localized])
                            completion?(error)
                        }
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
    
    func getState(completion: ((_ value:Bool? , _ error:Error?) -> Void)?) {
        
         Alamofire.request(Router.getHUBState(serial: serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                           
                       case .success(let value):
                        
                        
                        if let JSON = value as? [String:Any] {
                            print("HUB get State: \(JSON)")
                            if let value = JSON["stateEquipment"] as? Bool {
                                completion?(value, nil)
                            } else {
                                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                                completion?(nil, error)
                            }
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
    
    func updateState(value:Bool,completion: ((_ error:Error?) -> Void)?) {
        
        var stringValue = "false"
        if value {
            stringValue = "true"
        }
        
         Alamofire.request(Router.updateHUBState(serial: serial, value: stringValue)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                           
                       case .success(let valueJSON):
                        
                        self.behavior = "manual"
                        self.equipementState = value
                        completion?(nil)
                        
                        print("XXX \(valueJSON)")
                        
                        /*
                        if let JSON = valueJSON as? [String:Any] {
                            
                            print("XXX \(JSON)")
                            
                            if let sendToDevice = JSON["SendToDevice"] as? Bool {
                                if sendToDevice {
                                    self.behavior = "manual"
                                    completion?(nil)
                                } else {
                                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"The server could not reach the device".localized])
                                    completion?(error)
                                }
                            } else {
                                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                                completion?(error)
                            }
                        } else {
                            print("response.result.value: \(value)")
                            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                            completion?(error)
                        }
                        */
                        
                        
                       case .failure(let error):
                           
                           if let serverError = User.serverError(response: response) {
                               completion?(serverError)
                           } else {
                               completion?(error)
                           }
                       }
                       
            })
        
    }
    
    func updateBehavior(value:String, completion: ((_ message:String?, _ error:Error?) -> Void)?) {
        
         Alamofire.request(Router.updateHUBBehavior(serial: serial, value: value)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                           
                       case .success(let valueJ):
                        
                        
                        if let JSON = valueJ as? [String:Any] {
                            
                            print("update state JSON: \(JSON)")
                            
                            var message = ""
                            if let text = JSON["messageModeAutoFiltration"] as? String {
                                message = text
                            }
                            
                           if let errorCode = JSON["ErrorCode"] as? String {
                               if errorCode == "200" {
                                    
                                   self.behavior = value
                                   completion?(message,nil)
                               } else if let message = JSON["ErrorMessage"] as? String {
                                   completion?(nil,NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:message]))
                               } else {
                                   completion?(nil,NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:"Oups, we're sorry but something went wrong."]))
                               }
                           } else {
                                completion?(message,nil)
                            }
                        } else {
                            completion?(nil,nil)
                        }
                        
                        
                       case .failure(let error):
                           
                           if let serverError = User.serverError(response: response) {
                               completion?(nil,serverError)
                           } else {
                               completion?(nil,error)
                           }
                       }
                       
            })
        
    }
    
    func getAutomMessage(completion: ((_ message:String?) -> Void)?) {
        
         Alamofire.request(Router.getHUBState(serial: serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                           
                       case .success(let value):
                        
                        
                        if let JSON = value as? [String:Any] {
                            
                            print("update state JSON: \(JSON)")
                            
                            if let text = JSON["messageModeAutoFiltration"] as? String {
                                completion?(text)
                                return
                            }
                            
                        }
                        completion?(nil)
                        
                       case .failure(let error):
                           
                           completion?(nil)
                       }
                       
            })
        
    }
    
    func updateEquipmentName(value:String, completion: ((_ error:Error?) -> Void)?) {
        
         Alamofire.request(Router.updateHUBName(serial: serial, value: value)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                           
                       case .success(let value):
                        
                        if let JSON = value as? [String:Any] {
                           if let errorCode = JSON["ErrorCode"] as? String {
                               if errorCode == "200" {
                                   completion?(nil)
                               } else if let message = JSON["Message"] as? String {
                                   completion?(NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:message]))
                               } else {
                                   completion?(NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:"Oups, we're sorry but something went wrong."]))
                               }
                           }
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
    
    func getPlannings(completion: ((_ error:Error?) -> Void)?) {
        
         Alamofire.request(Router.getHUBPlannings(serial: serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                        
                       case .success(let value):
                        
                         print("GET Planning results: \(value)")
                         
                         self.plannings.removeAll()
                         if let JSON = value as? [String:Any] {
                            if let items = JSON["plannings"] as? [[String:Any]] {
                               for item in items {
                                   if let planning = Planning(withJSON: item) {
                                       self.plannings.append(planning)
                                   }
                               }
                            }
                         }
                         
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
    
    func deletePlanning(planningId:Int, completion: ((_ error:Error?) -> Void)?) {
        
        print("delete Planning with Id: \(planningId)")
        
        Alamofire.request(Router.deleteHUBPlanning(serial: serial, id: planningId)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                        
                       case .success(let value):
                        
                         print("deletee Planning results: \(value)")
                         if let JSON = value as? [String:Any] {
                            if let errorCode = JSON["ErrorCode"] as? String {
                                if errorCode == "200" {
                                    completion?(nil)
                                } else if let message = JSON["Message"] as? String {
                                    completion?(NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:message]))
                                } else {
                                    completion?(NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:"Oups, we're sorry but something went wrong."]))
                                }
                            }
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
    
    func syncPlannings(completion: ((_ error:Error?) -> Void)?) {
        
        Alamofire.request(Router.updateHUBPlannings(serial: serial, attributes: serializedPlannings)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                       
                       switch response.result {
                        
                       case .success(let value):
                        
                         print("UPDate Planning results: \(value)")
                         
                         self.plannings.removeAll()
                         if let JSON = value as? [[String:Any]] {
                            for item in JSON {
                                if let planning = Planning(withJSON: item) {
                                    self.plannings.append(planning)
                                }
                            }
                         }
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
    
    var serializedPlannings: [String : Any] {
        var JSONPlannings:[[String:Any]] = []
        for planning in plannings {
            JSONPlannings.append(planning.serialized)
        }
        let JSON:[String:Any] = ["plannings":JSONPlannings]
        return JSON
    }
    
    func remove(completion: ((_ error:Error?) -> Void)?) {
        Alamofire.request(Router.removeModule(serialId: self.serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                print("Delete HUB response.result.value: \(value)")
                
                completion?(nil)
                
            case .failure(let error):
                
                print("Delete HUB did fail with error: \(error)")
                
                completion?(error)
            }
            
        })
    }
    
}
