//
//  RemoteControl.swift
//
//  Created by Benjamin McMurrich on 27/06/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit

let remoteControlValuesKey = "RemoteControlValues"
let ISEEU_REMOTE_CONTROL_FILE_URL = "https://s3-eu-west-1.amazonaws.com/remote-control-iseeu/\(Bundle.main.bundleIdentifier!).json"

class RemoteControl: NSObject {
    
    static func sync(_ url:String) {
        RemoteControl.sync(url, completion: nil)
    }
    
    static func sync(_ url:String, completion:((_ error: Error?) -> Void)?) {
        
        debugPrint("[RemoteControl] Sync remotable values with URL: \(url)")
        
        if let url = URL(string: url.remotable("REMOTE_CONTROL_FILE_URL")) {
            
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.urlCache = nil
            
            let session = URLSession.init(configuration: config)
            
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                
                if error == nil {
                    let JSON: Any?
                    do {
                        JSON = try JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.allowFragments)
                        
                    } catch let error as NSError {
                        print("[RemoteControl] Error serializing JSON: \(error)")
                        JSON = nil
                        DispatchQueue.main.async {
                            completion?(error)
                        }
                        return
                    } catch {
                        fatalError()
                    }
                    
                    if let remoteControlValues = JSON as? [String:Any] {
                        
                        debugPrint("[RemoteControl] Remotable values: \(remoteControlValues)")
                        
                        let defaults = UserDefaults.standard
                        defaults.set(JSON, forKey: remoteControlValuesKey)
                        
                        DispatchQueue.main.async {
                            completion?(nil)
                        }
                        
                    } else {
                        debugPrint("[RemoteControl] JSON non-conform: \(String(describing: JSON))")
                        DispatchQueue.main.async {
                            //To do create error
                            completion?(nil)
                        }
                    }
                    
                } else {
                    debugPrint("[RemoteControl] syncing did fail: \(String(describing: error))")
                    DispatchQueue.main.async {
                        completion?(error)
                    }
                }
                
            }) 
            
            task.resume()
        }
        
    }
}

extension Bool {
    
    func remotable(_ key: String) -> Bool {
        
        let defaults = UserDefaults.standard
        if let remoteValues = defaults.dictionary(forKey: remoteControlValuesKey) {
            if let value = remoteValues[key] as? Bool {
                return value
            }
        }
        return self
        
    }
}

extension Int {
    
    func remotable(_ key: String) -> Int {
        
        let defaults = UserDefaults.standard
        if let remoteValues = defaults.dictionary(forKey: remoteControlValuesKey) {
            if let value = remoteValues[key] as? Int {
                return value
            }
        }
        return self
    }
}

extension Double {
    
    func remotable(_ key: String) -> Double {
        
        let defaults = UserDefaults.standard
        if let remoteValues = defaults.dictionary(forKey: remoteControlValuesKey) {
            if let value = remoteValues[key] as? Double {
                return Double(value)
            }
        }
        return self
    }
}

extension String
{
    var remotable: String {
        get {
            return self.remotable(self)
        }
    }
    
    func remotable(_ key: String) -> String {

        let defaults = UserDefaults.standard
        if let remoteValues = defaults.dictionary(forKey: remoteControlValuesKey) {
            if let value = remoteValues[key] as? String {
                return value
            }
        }
        return self
        
    }
}
