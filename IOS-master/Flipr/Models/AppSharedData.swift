//
//  AppSharedData.swift
//  Flipr
//
//  Created by Ajeesh T S on 07/03/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import Foundation

@objc public class AppSharedData: NSObject {
    @objc static let sharedInstance = AppSharedData()
    
    var isNeedtoCallHubDetailsApi : Bool = false
    var isNeedtoCallModulesApiForSideMenu : Bool = false
    var serialKey = ""
    var deviceName = ""

    var isAddingDeviceFromPresentedVCFlow : Bool = false
    var selectedEquipmentCode  = 0
    var logout : Bool = false
    @objc var isShowingFirmwereUpdateScreen : Bool = false
    var haveNewFirmwereUpdate : Bool = false

    @objc var diagnosticErrorCount : Int = 0
    
    var placesList = [PlaceDropdown]()
    var invitationList = [PlaceDropdown]()
    var haveInvitation = false
    var havePlace = false
    
    var addPlaceInfo = Pool()
    var addPlaceLocationInfo = LocationInfo()

    var addPlaceName:String!
    var addedPlaceId : Int  = 0
    
    var updatePlaceInfo = PoolSettingsModel()


    var isAddPlaceFlow = false
    var isAddPlaceSuccess = false
    var isAddDeviceStarted = false

    var isFirstCalibrations = false
    
    var deviceSerialNo : String  = ""

    var isFlipr3 = false

    
    var isOwner = false

    
//    var isAddPlace
    
    private override init() {
        
    }
    
    @objc func getCurrentFliprSerial() -> String{
        let serial = Module.currentModule?.serial ?? ""
//        serial = "197BF2"
        var serialNumber  = ""
        if serial.count == 7{
            serialNumber = "Flipr 0\(serial)"
        }
        else if serial.count == 6{
            serialNumber = "Flipr 00\(serial)"
        }
        else{
            if serial.count == 8{
                serialNumber = serial
            }else{
                serialNumber = "Flipr \(serial)"
            }
        }
        return serialNumber
    }
}
