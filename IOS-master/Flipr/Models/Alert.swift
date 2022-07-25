//
//  Alert.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 09/05/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class Alert {
    
    var id: String
    var title:String
    var subtitle:String
    var steps = [String]()
    var status = 0
    var iconUrl:String?
    var shop : [String:Any]?
    
    init(id: String, title:String, subtitle:String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
    
    convenience init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["Id"] as? String, let title = JSON["Title"] as? String, let subtitle = JSON["Subtitle"] as? String else {
            return nil
        }
        self.init(id: id, title: title, subtitle: subtitle)
        if let steps = JSON["Steps"] as? [String] {
            self.steps = steps
        }
        if let status = JSON["Status"] as? Int {
            self.status = status
        }
        if let url = JSON["IconUrl"] as? String {
            self.iconUrl = url
        }
        if let shop = JSON["Shop"] as? [String:Any] {
            self.shop = shop
        }
    }
    
    var serialized: [String : Any] {
        var JSON : [String:Any] = ["Id":id,"Title":title,"Subtitle":subtitle]
        JSON["Steps"] = steps
        JSON["Status"] = status
        return JSON
    }
    
    var isStockAlert:Bool {
        if let shop = shop {
            if let locomotion = shop["Locomotion"] as? String, let satisfaction = shop["Satisfaction"] as? String {
                if locomotion.count > 1, satisfaction.count > 1 {
                    return true
                }
            }
        }
        return false
    }
    
    func close(completion: ((_ error: Error?) -> Void)?) {
        
        print("Close alert: \(self.serialized)")
        
        Alamofire.request(Router.closeAlert(serial: Module.currentModule!.serial, alertId: self.id)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                print("Close alert - response.result.value: \(value)")
                
                completion?(nil)
                
            case .failure(let error):
                
                print("Close alert did fail with error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    completion?(serverError)
                } else {
                    completion?(error)
                }
            }
        })
    }
    
}

class AlertButton: UIButton {
    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var alert:Alert? {
        didSet {
            if alert?.status == 0 {
//                self.backgroundColor = K.Color.Red
            } else {
//                self.backgroundColor = K.Color.Green
            }
            if let url = alert?.iconUrl {
                self.af_setImage(for: .normal, url: URL(string: url)!)
            }
            
        }
    }

}
