//
//  PoolSettingsRouter.swift
//  Flipr
//
//  Created by Ajeesh T S on 11/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import Foundation
import Alamofire

class PoolSettingsRouter {
    
    var poolId:String? = ""

    func getPoolSettings(poolId: String, completion: ((_ settings:PoolSettingsModel?,_ error:Error?) -> Void)?) {
        self.poolId = poolId
        Alamofire.request(Router.getPoolSettings(poolId: self.poolId ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(_):
                if let data = response.data {
                    do {
                        let setting = try JSONDecoder().decode(PoolSettingsModel.self, from: data)
                        completion?(setting, nil)
                    } catch let error {
                        completion?(nil, error)
                    }
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
}
