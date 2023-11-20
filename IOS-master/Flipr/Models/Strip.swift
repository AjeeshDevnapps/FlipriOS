//
//  Strip.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 28/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import Alamofire

class Strip {
    var chloreBrome:Double?
    var totalChlore:Double?
    var alcalinity:Double?
    var pH:Double?
    var hydrotimetricTitle:Double?
    var cyanudricAcid:Double?
    var totalBr:Double?

    var testTime = Date()
    //olf version is 1
    var version = 1
    
    var stripVersion = 0

    var placeId = ""
    
/*
    func send(completion: ((_ error:Error?) -> Void)?) {
        
        if (chloreBrome == nil) || (totalChlore == nil) || (alcalinity == nil) || (pH == nil) || (hydrotimetricTitle == nil) || (cyanudricAcid == nil) {
            completion?(NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Toutes les valeurs sont obligatoires".localized]))
            return
        }
        
        if let serial = Module.currentModule?.serial { //, let poolId = Pool.currentPool?.id {
            
            let params:[String : Any] = ["DeviceId":serial,"ChloreBrome":chloreBrome!,"TotalChlore":totalChlore!,"Alcalinity":alcalinity!,"PH":pH!,"HydrotimetricTitle":hydrotimetricTitle!,"CyanudricAcid":cyanudricAcid!,"Version":version]
            
            print("Send Strip Test with parmams: \(params)")
            
            Alamofire.request(Router.addStripTest(params: params)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    completion?(nil)
                    
                    
                case .failure(let error):
                    
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                }
                
            })
            
        } else {
            completion?(NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No current module :/"]))
            return
        }
        
        
        
    }
    
    */
    
    
    func send(completion: ((_ error:Error?) -> Void)?) {
        
        if (chloreBrome == nil) || (totalChlore == nil) || (alcalinity == nil) || (pH == nil) || (hydrotimetricTitle == nil) || (cyanudricAcid == nil) {
            completion?(NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Toutes les valeurs sont obligatoires".localized]))
            return
        }
        
        var placeId:Int?
        
        if AppSharedData.sharedInstance.isAddPlaceFlow{
            placeId = AppSharedData.sharedInstance.addedPlaceId
        }else{
            placeId = Module.currentModule?.placeId
        }
        
        if let placeID = placeId { //, let poolId = Pool.currentPool?.id {
            
            var params:[String : Any] = ["placeId":placeID,"TotalChlBr":totalChlore!,"FreeChlorine":chloreBrome!,"TAC":alcalinity!,"PH":pH!,"TH":hydrotimetricTitle!,"Stabilizer":cyanudricAcid!,"StripVersion":stripVersion]
            
            if totalBr != nil{
                params = ["placeId":placeID,"TotalChlBr":totalChlore!,"FreeChlorine":chloreBrome!,"TAC":alcalinity!,"PH":pH!,"TH":hydrotimetricTitle!,"Stabilizer":cyanudricAcid!,"StripVersion":stripVersion, "TotalBr" : totalBr!]
            }
            print("Send Strip Test with parmams: \(params)")
            
            Alamofire.request(Router.addStripTest(params: params)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    completion?(nil)
                    
                    
                case .failure(let error):
                    
                    if let serverError = User.serverError(response: response) {
                        completion?(serverError)
                    } else {
                        completion?(error)
                    }
                }
                
            })
            
        } else {
            completion?(NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No current module :/"]))
            return
        }
        
        
        
    }
    
}
