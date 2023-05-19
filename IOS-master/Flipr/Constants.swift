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
    
    struct AppConstant{
        static let CurrentServerIsDev = "IsCurrentServerDev"
    }
    
    struct Color {
        static let DarkBlue = UIColor(red: 34/255.0, green: 58/255.0, blue: 77/255.0, alpha: 1)
        static let LightBlue = UIColor(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)
        static let Green = UIColor(red: 19/255.0, green: 200/255.0, blue: 166/255.0, alpha: 1)
        static let Red = UIColor(red: 248/255.0, green: 58/255.0, blue: 89/255.0, alpha: 1)
        static let themeBlack = UIColor.init(hexString: "111729")
        static let white = UIColor.white
        static let clear = UIColor.clear

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
        static let FliprNotDiscovered = Notification.Name("fr.isee-u.FliprNotDiscovered")
        static let FliprSerialRead = Notification.Name("fr.isee-u.FliprSerialRead")
        static let FliprConnected = Notification.Name("fr.isee-u.FliprConnected")
        static let FliprDidRead = Notification.Name("fr.isee-u.FliprDidRead")
        static let FliprBatteryDidRead = Notification.Name("fr.isee-u.FliprBateryDidRead")
        static let FliprMeasuresPosted = Notification.Name("fr.isee-u.FliprMeasuresPosted")
        static let UserDidLogout = Notification.Name("fr.isee-u.UserDidLogout")
        static let AlertDidClose = Notification.Name("fr.isee-u.AlertDidClose")
        static let BackFromWintering = Notification.Name("fr.isee-u.BackFromWintering")
        static let FliprMeasures409Error = Notification.Name("fr.isee-u.FliprMeasures409Error")

        static let BluetoothNotAvailble = Notification.Name("fr.isee-u.BluetoothNotAvailble")
        static let BluetoothOff = Notification.Name("fr.isee-u.BluetoothOff")
        static let BluetoothOn = Notification.Name("fr.isee-u.BluetoothOn")

        static let HUBNotDiscovered = Notification.Name("fr.isee-u.HUBNotDiscovered")
        static let HUBDiscovered = Notification.Name("fr.isee-u.HUBDiscovered")
        static let HUBSerialRead = Notification.Name("fr.isee-u.HUBSerialRead")
        static let HUBConnected = Notification.Name("fr.isee-u.HUBConnected")
        static let HUBDidRead = Notification.Name("fr.isee-u.HUBDidRead")
        static let HUBMeasuresPosted = Notification.Name("fr.isee-u.HUBMeasuresPosted")
        static let NotificationSetttingsChanged = Notification.Name("fr.isee-u.NotificationSetttingsChanged")
        static let NotificationPhDefalutValueChangedChanged = Notification.Name("fr.isee-u.NotificationPhDefalutValueChangedChanged")
        static let NotificationTmpDefalutValueChangedChanged = Notification.Name("fr.isee-u.NotificationTmpDefalutValueChangedChanged")
        static let NotificationThresholdDefalutValueChangedChanged = Notification.Name("fr.isee-u.NotificationThresholdDefalutValueChangedChanged")

        static let PoolSettingsUpdated = Notification.Name("fr.isee-u.PoolSettingsUpdated")
        static let WavethemeSettingsChanged = Notification.Name("fr.isee-u.WavethemeSettingsChanged")
        static let UpdateHubViews = Notification.Name("fr.isee-u.UpdateHubViews")
        static let ReloadProgrameList = Notification.Name("fr.isee-u.ReloadProgrameList")
        static let CompletedFirmwereUpgrade = Notification.Name("CompletedUpgrade")
        static let showFirmwereUpgradeScreen = Notification.Name("fr.isee-u.ShowFirmwereUpgradeScreen")
        static let FirmwereUpgradeError = Notification.Name("fr.isee-u.FirmwereUpgradeError")
        static let FirmwereUpgradeStarted = Notification.Name("fr.isee-u.FirmwereUpgradeStarted")

        static let showLastMeasurementScreen = Notification.Name("fr.isee-u.showLastMeasurementScreen")
        static let ServerChanged = Notification.Name("fr.isee-u.serverChanged")
        static let MeasureUnitSettingsChanged = Notification.Name("fr.isee-u.MeasureUnitSettingsChanged")

        static let PlaceDeleted = Notification.Name("fr.isee-u.PlaceDeleted")
        static let FliprDeviceDeleted = Notification.Name("fr.isee-u.FliprDeviceDeleted")
        static let HubDeviceDeleted = Notification.Name("fr.isee-u.HubDeviceDeleted")
        static let GatewayDiscovered = Notification.Name("fr.isee-u.GatewayDiscovered")

        static let GatewayNoteDiscovered = Notification.Name("fr.isee-u.GatewayNoteDiscovered")
        static let FliprModeValue = Notification.Name("fr.isee-u.FliprModeValue")
        static let FliprConnecitngForModeValue = Notification.Name("fr.isee-u.FliprConnecitngForModeValue")


    }
}
