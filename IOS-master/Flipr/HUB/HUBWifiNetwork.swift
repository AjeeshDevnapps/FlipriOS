//
//  HUBWifiNetwork.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/03/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import Foundation

class HUBWifiNetwork {
    var ssid = ""
    var bssid = ""
    var securityType = 0
    var isHidden = false
    var isHUBConnected = false
    var index = -1
    
    init?(withJSON JSON:[String:Any]) {
        print("withJSON: \(JSON)")
        guard let ssid = JSON["r"] as? String, let bssid = JSON["b"] as? String, let securityType = JSON["q"] as? Int, let index = JSON["g"] as? Int, let isHUBConnected = JSON["e"] as? Bool else {
            return nil
        }
        self.ssid = ssid
        self.bssid = bssid
        self.securityType = securityType
        self.index = index
        self.isHUBConnected = isHUBConnected
    }
    
    var addSerialized: [String : Any] {
        print("bssid class: \(type(of: bssid))")
        let JSON : [String:Any] = ["r":ssid,"b":NSByteString(bssid),"q":securityType,"g":-1]
        return JSON
    }

}

extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    var hexadecimal: Data? {
        var data = Data(capacity: characters.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}
