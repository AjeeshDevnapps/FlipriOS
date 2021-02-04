//
//  Constants.swift
//  ApiFeed
//
//  Created by Benjamin McMurrich on 24/01/2017.
//  Copyright © 2017 @ben_mcm. All rights reserved.
//

import Foundation
import UIKit

struct K {
    struct Color {
        static let DarkBlue = UIColor(red: 34/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1)
        static let LightBlue = UIColor(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)
        static let Green = UIColor(red: 19/255.0, green: 200/255.0, blue: 166/255.0, alpha: 1)
        static let Red = UIColor(red: 248/255.0, green: 58/255.0, blue: 89/255.0, alpha: 1)
    }
    struct Server {
        // PROD
        static let BaseUrl = "https://api.goflipr.com".remotable("BASE_URL")
        
        // Integration
        //static let BaseUrl = "https://api.goflipr.com/integration".remotable("BASE_URL")
        //static let BaseUrl = "https://api-flipr.azurewebsites.net/Integration".remotable("BASE_URL") //GOOD
        
        static let ApiPath = "/v1.4/".remotable("API_PATH")
    }
    struct Notifications {
        static let SessionExpired = Notification.Name("fr.isee-u.SessionExpired")
        static let FliprDiscovered = Notification.Name("fr.isee-u.FliprDiscovered")
        static let FliprSerialRead = Notification.Name("fr.isee-u.FliprSerialRead")
        static let FliprConnected = Notification.Name("fr.isee-u.FliprConnected")
        static let FliprDidRead = Notification.Name("fr.isee-u.FliprDidRead")
        static let FliprBatteryDidRead = Notification.Name("fr.isee-u.FliprBateryDidRead")
        static let FliprMeasuresPosted = Notification.Name("fr.isee-u.FliprMeasuresPosted")
        static let UserDidLogout = Notification.Name("fr.isee-u.UserDidLogout")
        static let AlertDidClose = Notification.Name("fr.isee-u.AlertDidClose")
        static let BackFromWintering = Notification.Name("fr.isee-u.BackFromWintering")
        
        static let HUBDiscovered = Notification.Name("fr.isee-u.HUBDiscovered")
        static let HUBSerialRead = Notification.Name("fr.isee-u.HUBSerialRead")
        static let HUBConnected = Notification.Name("fr.isee-u.HUBConnected")
        static let HUBDidRead = Notification.Name("fr.isee-u.HUBDidRead")
        static let HUBMeasuresPosted = Notification.Name("fr.isee-u.HUBMeasuresPosted")
        static let NotificationSetttingsChanged = Notification.Name("fr.isee-u.NotificationSetttingsChanged")
        static let NotificationPhDefalutValueChangedChanged = Notification.Name("fr.isee-u.NotificationPhDefalutValueChangedChanged")
        static let NotificationTmpDefalutValueChangedChanged = Notification.Name("fr.isee-u.NotificationTmpDefalutValueChangedChanged")
        static let NotificationThresholdDefalutValueChangedChanged = Notification.Name("fr.isee-u.NotificationThresholdDefalutValueChangedChanged")


    }
}
