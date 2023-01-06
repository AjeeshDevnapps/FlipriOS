//
//  FliprShare.swift
//  Flipr
//
//  Created by Ajeesh T S on 03/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import Foundation
import Alamofire


enum FliprRole: String, CaseIterable {
    case guest = "Consultation uniqument"
    case boy = "Consultation et activation des équipements"
    case man = "Consultation et administration des équipements"
}

class FliprShare {
    
    var poolId:String? = ""
    
    func getContacts(email: String, completion: ((_ shares:[ContactsWatr]?,_ error:Error?) -> Void)?) {
//        self.poolId = poolId
        Alamofire.request(Router.contactList(email: email)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [[String:Any]] {
                    var contacts = [ContactsWatr]()
                    print("get contact JSON \(JSON)")
                    for item in JSON {
                        let contact = ContactsWatr(fromDictionary: item)
                            contacts.append(contact)
//                        }
                    }
                    completion?(contacts, nil)
                }
            case .failure(let error):
                if let serverError = User.serverError(response: response) {
                    completion?(nil, serverError)
                } else {
                    completion?(nil, error)
                }
                print("get shares Error \(error)")
            }
            
        })
    }
    

    func viewShares(poolId: String, completion: ((_ shares:[ShareModel]?,_ error:Error?) -> Void)?) {
        self.poolId = poolId
        Alamofire.request(Router.viewShares(poolId: self.poolId!)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [[String:Any]] {
                    var shares = [ShareModel]()
                    print("get shares JSON \(JSON)")
                    for item in JSON {
                        if let share = ShareModel(withJSON: item) {
                            shares.append(share)
                        }
                    }
                    completion?(shares, nil)
                }
            case .failure(let error):
                if let serverError = User.serverError(response: response) {
                    completion?(nil, serverError)
                } else {
                    completion?(nil, error)
                }
                print("get shares Error \(error)")
            }
            
        })
    }
    
    func addShare(poolId: String,  email: String, role: FliprRole, completion: ((_ error:Error?) -> Void)?) {
        self.poolId = poolId
        Alamofire.request(Router.addShare(poolId: self.poolId ?? "", email: email, permissionLevel: role)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(_):
                completion?(nil)
                
            case .failure(let error):
                if response.response?.statusCode == 200 {
                    completion?(nil)
                } else {
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                }
                print("get shares Error \(error)")
            }
            
        })
    }
    
    func updateShare(email: String, role: FliprRole, completion: ((_ error:Error?) -> Void)?) {
//        self.poolId = poolId
        Alamofire.request(Router.updateShare(poolId: self.poolId ?? "", email: email, permissionLevel: role)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(_):
                completion?(nil)

            case .failure(let error):
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
                print("get shares Error \(error)")
            }
            
        })
    }
    
    func deleteShare(email: String, role: FliprRole, completion: ((_ error:Error?) -> Void)?) {
            Alamofire.request(Router.deleteShare(poolId: self.poolId ?? "", email: email)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(_):
                    completion?(nil)

                case .failure(let error):
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                    print("get shares Error \(error)")
                }
            })
        }
    
    
    func deletePlace(placeId: String, completion: ((_ error:Error?) -> Void)?) {
            Alamofire.request(Router.deletePlace(placeId: placeId)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(_):
                    completion?(nil)

                case .failure(let error):
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                    print("get shares Error \(error)")
                }
            })
        }
    
    func deleteShareWithPoolId(email: String, poolID: String, completion: ((_ error:Error?) -> Void)?) {
        Alamofire.request(Router.deleteShare(poolId: poolID , email: email)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(_):
                    completion?(nil)

                case .failure(let error):
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                    print("get shares Error \(error)")
                }
            })
        }
    
    func acceptShareWithPoolId(poolID: String, completion: ((_ error:Error?) -> Void)?) {
        Alamofire.request(Router.acceptShare(poolId: poolID)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(_):
                    completion?(nil)

                case .failure(let error):
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                    print("get shares Error \(error)")
                }
            })
        }
    
    
}


