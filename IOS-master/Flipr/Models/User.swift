//
//  User.swift
//  User
//
//  Created by Benjamin McMurrich on 16/12/2016.
//  Copyright © 2016 @ben_mcm. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Crashlytics

class User {
    
    var email:String
    var token:String?
    var firstName:String?
    var lastName:String?
    var phone:String?
    var isActivated = false
    
    var hubs:[HUB] = []
    
    //MARK: Current User Shared Instance
    static var currentUser : User? = {
        if let serializedUser = UserDefaults.standard.object(forKey: "CurrentUser") as? [String : Any] {
            let instance = User.init(withSerializedUser: serializedUser)
            return instance
        }
        return nil
    }()
    
    init(email: String, token:String?) {
        self.email = email
        self.token = token
        Crashlytics.sharedInstance().setUserIdentifier(email)
        Crashlytics.sharedInstance().setUserEmail(email)
    }
    
    convenience init?(withSerializedUser user:[String:Any]) {
        guard let email = user["email"] as? String, let token = user["token"] as? String  else {
            return nil
        }
        self.init(email: email, token:token)
        self.update(withAttibutes: user)
    }
    
    var serialized: [String : Any] {
        var user: [String : Any] = ["email":self.email,"token":self.token]
        if let firstName = self.firstName {
            user.updateValue(firstName, forKey: "FirstName")
        }
        if let lastName = self.lastName {
            user.updateValue(lastName, forKey: "LastName")
        }
        if let phone = self.phone {
            user.updateValue(phone, forKey: "PhoneNumber")
        }
        user["IsActivated"] = isActivated
        
        return user
    }
    
    func update(withAttibutes user:[String : Any]) {
        
        //let omnisenseUser = OSUser();
        //omnisenseUser.email = User.currentUser?.email
        
        if let token = user["token"] as? String {
            self.token = token
        }
        if let firstName = user["FirstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = user["LastName"] as? String {
            self.lastName = lastName
        }
        if self.firstName != nil && self.lastName != nil {
            Crashlytics.sharedInstance().setUserName(self.firstName! + " " + self.lastName!)
        }
        if let phone = user["PhoneNumber"] as? String {
            self.phone = phone
        }
        if let isActivated = user["IsActivated"] as? Bool {
            self.isActivated = isActivated
        }
    }
    
    static func saveCurrentUserLocally() {
        if let user = User.currentUser {
            UserDefaults.standard.set(user.serialized, forKey: "CurrentUser")
            print("Save user: \(user.serialized)")
        }
    }
    
    static func signup(email: String, completion: ((_ error:Error?) -> Void)?) {
        
        Alamofire.request(Router.createNewUser(email: email)).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case.success(let value):
                if let JSON = value as? [String: Any] {
                    print("JSON: \(JSON)")
                    if let success = JSON["Success"] as? Bool {
                        if success == false {
                            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Oups, we're sorry but something went wrong :/".localized])
                            completion?(error)
                        } else {
                            if let password = JSON["Pass"] as? String {
                                UserDefaults.standard.set(password, forKey: "TempPass")
                                UserDefaults.standard.set(email, forKey: "CurrentUserEmail")
                            }
                             completion?(nil)
                        }
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(error)
                    }
                } else {
                   print("response.result.value: \(response.result.value)")
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
        }
    }
    
    static func signup(email: String, password: String, lastName: String,firstName: String, phone: String, completion: ((_ error:Error?) -> Void)?) {
        
        Alamofire.request(Router.createUser(email: email, password: password, lastName: lastName, firstName: firstName, phone: phone)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [String:Any] {
                    print("JSON: \(JSON)")
                    
                    if let success = JSON["Success"] as? Bool {
                        if success == false {
                            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Oups, we're sorry but something went wrong :/".localized])
                            completion?(error)
                        } else {
                            UserDefaults.standard.set(email, forKey: "CurrentUserEmail")
                            //UserDefaults.standard.set(password, forKey: "CurrentUserPassword")
                            completion?(nil)
                            //User.signin(email: email, password: password, completion: completion)
                        }
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(error)
                    }
                } else {
                    print("response.result.value: \(response.result.value)")
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

    static func signin(email: String, password: String, completion: ((_ error:Error?) -> Void)?) {

        
        Alamofire.request(Router.authentifyUser(email: email, password: password)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [String:Any] {
                    print("JSON: \(JSON)")
                    if let token = JSON["access_token"] as? String {
                        
                        //self.registerForRemoteNotifications(application: application)
                        
                        User.currentUser = User.init(email: email, token: token)
                        User.saveCurrentUserLocally()
                        
                        Alamofire.request(Router.updateLanguage).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                print("Update language response: \(value)")
                            case .failure(let error):
                                print("Update language error: \(error.localizedDescription)")
                            }
                        })
                        
                        User.currentUser?.getModule(completion: { (devices,error) in
                            if error != nil {
                                completion?(error)
                            } else {
                                if Module.currentModule != nil || HUB.currentHUB != nil {
                                    User.currentUser?.getPool(completion: { (error) in
                                        if error != nil {
                                            completion?(error)
                                        } else {
                                            User.currentUser?.getAccount(completion: completion)
                                        }
                                    })
                                } else {
                                    User.currentUser?.getAccount(completion: completion)
                                }
                                /*
                                User.currentUser?.getPool(completion: { (error) in
                                    if error != nil {
                                        completion?(error)
                                    } else {
                                        User.currentUser?.getAccount(completion: completion)
                                    }
                                })
                                //User.currentUser?.getAccount(completion: completion)
                                */
                            }
                        })
                        
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No access token :/".localized])
                        completion?(error)
                    }
                } else {
                    print("response.result.value: \(response.result.value)")
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
    
    static func resetPassword(email: String, completion: ((_ error:Error?) -> Void)?) {
        Alamofire.request(Router.resetPassword(email: email)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
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

    static func serverError(response: DataResponse<Any>) -> Error? {
        
        if let data = response.data {
            
            if let statusCode = response.response?.statusCode {
                if statusCode >= 500 {
                    return NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:"Oups, we're sorry but something went wrong :/".localized])
                }
            }
            
            print("Error Data: \(data)")
            if let JSON = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                print("Error JSON: \(JSON)")
                if let message = JSON?["error_description"] as? String {
                    return NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:message])
                }
                if let message = JSON?["Message"] as? String {
                    return NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:message])
                }
            }
            
        }
        
        return nil
    }
    
    static func isAccountActivated(email:String,completion: ((_ activated: Bool, _ error: Error?) -> Void)?) {
        
            Alamofire.request(Router.readAccountActivation(email: email)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    print("User isAccountActivated - response.result.value: \(value)")
                    if let user = value as? [String:Any] {
                        if let activated = user ["Value"] as? Bool {
                            if activated == true {
                                completion?(true,nil)
                            } else {
                                completion?(false,nil)
                            }
                        } else {
                            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                            completion?(false, error)
                        }
                        
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(false, error)
                    }
                    
                case .failure(let error):
                    
                    print("User isAccountActivated did fail with error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        completion?(false, serverError)
                    } else {
                        completion?(false, error)
                    }
                }
            })
    }
    
    
    
    static func changePassword(oldPassword:String, newPassword:String,completion: ((_ isSuccess: Bool, _ message: String?, _ error: Error?) -> Void)?) {
        
            Alamofire.request(Router.changePassword(oldPassword: oldPassword, newPassword: newPassword)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    print("User change password - response.result.value: \(value)")
                    if let resultResponse = value as? [String:Any] {
                        if let activated = resultResponse ["Success"] as? Bool {
                            let message = resultResponse["Message"] as? String
                            if activated == true {
                                completion?(true,message,nil)
                            } else {
                               
                                completion?(false,message,nil)
                            }
                        } else {
                            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                            completion?(false, nil, error)
                        }
                        
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        completion?(false, nil, error)
                    }
                    
                case .failure(let error):
                    
                    print("User change password did fail with error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        completion?(false,nil, serverError)
                    } else {
                        completion?(false,nil, error)
                    }
                }
            })
    }
    
    
    
    
    func getAccount(completion: ((_ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.readUser).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Read User - response.result.value: \(value)")
                if let user = value as? [String:Any] {
                    User.currentUser?.update(withAttibutes: user)
                    User.saveCurrentUserLocally()
                    
                    completion?(nil)
                } else {
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(error)
                }
                
            case .failure(let error):
                
                print("Read User did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
        })
    }
    
    
    static func updateAccount(lastName:String, firstName:String, completion: ((_ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.updateUserInfo(lastName: lastName,firstName:firstName)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Read User - response.result.value: \(value)")
                if let user = value as? [String:Any] {
                    User.currentUser?.update(withAttibutes: user)
                    User.saveCurrentUserLocally()
                    
                    completion?(nil)
                } else {
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(error)
                }
                
            case .failure(let error):
                
                print("Read User did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
        })
    }
    
    static func updateUserProfile(lastName:String, firstName:String, password: String, completion: ((_ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.updateUserProfile(firstName: firstName, lastName: lastName, password: password)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Read User - response.result.value: \(value)")
                if let user = value as? [String:Any] {
                    User.currentUser?.update(withAttibutes: user)
                    User.saveCurrentUserLocally()
                    
                    completion?(nil)
                } else {
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(error)
                }
                
            case .failure(let error):
                
                print("Read User did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
        })
    }

    func getModuleList(completion: ((_ devices: [[String:Any]]?, _ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.getModules).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Get user modules - response.result.value: \(value)")

                if let modules = value as? [[String:Any]] {
                    
                    //On filtre sur ModuleType_Id = 1 pour retirer les HUB
                    var fliprs:[[String:Any]] = []
                    for mod in modules {
                        if let type = mod["ModuleType_Id"] as? Int {
                            if type == 1 {
                                fliprs.append(mod)
                            }
                            if type == 2 {
//                                let hub = HUB.init(withJSON: mod)
//                                HUB.currentHUB = hub
//                                HUB.saveCurrentHUBLocally()
                            }
                        }
                    }
                    
                    if let JSON = fliprs.first {
//                        let module = Module.init(withJSON: JSON)
//                        Module.currentModule = module
//                        Module.saveCurrentModuleLocally()
                    }
                    completion?(modules,nil)
                } else {
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(nil, error)
                }
                
            case .failure(let error):
                
                print("Get user modules did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(nil,serverError)
                } else {
                    completion?(nil,error)
                }
            }
        })
    }

    
    func getModule(completion: ((_ devices: [[String:Any]]?, _ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.getModules).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Get user modules - response.result.value: \(value)")

                if let modules = value as? [[String:Any]] {
                    
                    //On filtre sur ModuleType_Id = 1 pour retirer les HUB
                    var fliprs:[[String:Any]] = []
                    for mod in modules {
                        if let type = mod["ModuleType_Id"] as? Int {
                            if type == 1 {
                                fliprs.append(mod)
                            }
                            if type == 2 {
                                let hub = HUB.init(withJSON: mod)
                                HUB.currentHUB = hub
                                HUB.saveCurrentHUBLocally()
                            }
                        }
                    }
                    
                    if let JSON = fliprs.first {
                        let module = Module.init(withJSON: JSON)
                        Module.currentModule = module
                        Module.saveCurrentModuleLocally()
                    }
                    completion?(fliprs,nil)
                } else {
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(nil, error)
                }
                
            case .failure(let error):
                
                print("Get user modules did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(nil,serverError)
                } else {
                    completion?(nil,error)
                }
            }
        })
    }
    
    func getPool(completion: ((_ error: Error?) -> Void)?) {
        
        Alamofire.request(Router.getPools).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Get user pools - response.result.value: \(value)")
                
                if let pools = value as? [[String:Any]] {
                    if let JSON = pools.first {
                        let pool = Pool.init(withJSON: JSON)
                        Pool.currentPool = pool
                        Pool.saveCurrentPoolLocally()
                    }
                    completion?(nil)
                } else {
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    completion?(error)
                }
                
            case .failure(let error):
                
                print("Get user pool did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
        })
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
        UserDefaults.standard.removeObject(forKey: "CurrentModule")
        UserDefaults.standard.removeObject(forKey: "CurrentPool")
        UserDefaults.standard.removeObject(forKey: "CurrentHUB")
        UserDefaults.standard.set("orange", forKey: "CurrentTheme")
        UserDefaults.standard.removeObject(forKey: "FirstHubSerialKey")
        UserDefaults.standard.removeObject(forKey: "SecondHubSerialKey")

        

        User.currentUser = nil
        Module.currentModule = nil
        Pool.currentPool = nil
        HUB.currentHUB = nil
        AppSharedData.sharedInstance.isNeedtoCallModulesApiForSideMenu = true
        AppSharedData.sharedInstance.serialKey = ""
        AppSharedData.sharedInstance.deviceName = ""
        UserDefaults.standard.synchronize()
    }
    
    func sync(completion: ((_ success:Bool) -> Void)?) throws {
        print("Save user: \(self.serialized)")
        
        //self.update(withAttibutes: ["first_name":"Ben","last_name":"McMurrich"])
        
        // Save locally if current user
        if let currentUser = User.currentUser {
            if self.email == currentUser.email {
                User.saveCurrentUserLocally()
            }
        }
    }
    
    func save(completion: ((_ success:Bool) -> Void)?) throws {
        
        // Save locally if current user
        if let currentUser = User.currentUser {
            if self.email == currentUser.email {
                User.saveCurrentUserLocally()
            }
        }
    }
    
    static func subscribe(receiptData:Data, completion: ((_ error:Error?) -> Void)?) {
        
        Alamofire.request(Router.sendSubscriptionReceipt(data: receiptData)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("User did subscribe with success - response.result.value: \(value)")
                
                completion?(nil)
                
            case .failure(let error):
                
                print("User did fail to subscribe with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
        })
    }
    
}




