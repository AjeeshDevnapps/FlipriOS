//
//  GetLastMeasurementManager.swift
//  Flipr
//
//  Created by Ajish on 03/08/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import Foundation
import CoreBluetooth
import Alamofire
import SwifterSwift


class GetLastMeasurementManager: NSObject {
    static let shared: GetLastMeasurementManager = {
        let instance = GetLastMeasurementManager()
        return instance
    }()
    var stopScanning = false
    var centralManager:CBCentralManager!
    var flipr:CBPeripheral?
    var connectAfterDiscovery = false
    var isConnecting = false
    var activationNeeded = false
    
    
    var calibrationMeasuresCompletionBlock:(_ : (_ error:Error?) -> Void)?
    var doAcq = false
    var doAcqCharacteristic:CBCharacteristic?
    var doAcqCompletionBlock:(_ : (_ error:Error?) -> Void)?
    
    var calibrationMeasures = false
    var calibrationType: CalibrationType = .ph7
    var measuresCharacteristic:CBCharacteristic?
    var sendMeasuresCompletionBlock:(_ : (_ error:Error?) -> Void)?
    var currentMeasuringSerial:String = ""
    var oldMeasureValue:String?
    var newMeasureValue:String?
    
    var sendMeasureAfterConnection = false
    var fliprReadingVerification = false
    var isHandling409 = false
    var centralManagerHasBeenInitialized = false
    var isReadP0Value = false
    var readingCount = 0
    var isPh4Calibration = false
    var isRead20SecondDelay = false
    var isV3 = false
    var isStoppedForRedo = false
    var isReconnectedAfterFail = false

    
    
    func startUpCentralManager(connectAutomatically connect:Bool, sendMeasure send:Bool) {
        //        fliprList.removeAll()
        self.stopScanning = false
        perform(#selector(setTimeLimit), with: nil, afterDelay: 30)
        sendMeasureAfterConnection = send
        connectAfterDiscovery = connect
        if !centralManagerHasBeenInitialized {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManagerHasBeenInitialized = true
        } else {
            //            let services = [FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID]
            //            centralManager.scanForPeripherals(withServices: services, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            print("CBCentralManager start scanning for Flipr devices (already initialized)")
        }
    }
    
    func resetValues(){
        self.isV3 = false
        self.oldMeasureValue =  nil
        self.isReadP0Value = false
        self.isReadP0Value = false
        self.readingCount = 0
        self.isPh4Calibration = false
        self.isRead20SecondDelay = false
        self.isV3 = false
        self.isStoppedForRedo = false
        self.isReconnectedAfterFail = false
    }
    
    func connectDevice(completion: ((_ error: Error?) -> Void)?) {
        self.calibrationMeasuresCompletionBlock = completion
        // already connected
        
        self.stopScanning = false
        perform(#selector(setTimeLimit), with: nil, afterDelay: 30)
        if !centralManagerHasBeenInitialized {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManagerHasBeenInitialized = true
        } else {
            //            let services = [FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID]
            //            centralManager.scanForPeripherals(withServices: services, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            print("CBCentralManager start scanning for Flipr devices (already initialized)")
        }
    }
    
    @objc func setTimeLimit(){
        self.stopScanning = true
    }
    
    
    func readLastMeasurement(completion: ((_ error: Error?) -> Void)?) {
        self.calibrationMeasuresCompletionBlock = completion
        self.isPh4Calibration = true
        let tmp = self.newMeasureValue
        self.oldMeasureValue = tmp
        self.stopScanning = false
        if flipr?.state == .connected{
            self.writeAcqValue()
        }else{
            if !centralManagerHasBeenInitialized {
                centralManager = CBCentralManager(delegate: self, queue: nil)
                centralManagerHasBeenInitialized = true
            } else {
                //            let services = [FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID]
                //            centralManager.scanForPeripherals(withServices: services, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
                centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
                print("CBCentralManager start scanning for Flipr devices (already initialized)")
            }
        }
       
    }
    
    func removeConnection(){
        if let activeFlipr = flipr {
            centralManager.cancelPeripheralConnection(activeFlipr)
        }
    }
    
}


//MARK: - Core bluetooth central manager delegate
extension GetLastMeasurementManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn {
                print("Bluetooth powered on.")
                NotificationCenter.default.post(name: K.Notifications.BluetoothOn, object: nil, userInfo: nil)
                /*
                 let services = [FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID]
                 
                 let lastPeripherals = centralManager.retrieveConnectedPeripherals(withServices: services)
                 
                 if lastPeripherals.count > 0{
                 let device = lastPeripherals.last! as CBPeripheral;
                 flipr = device;
                 centralManager.connect(flipr!, options: nil)
                 print("Connecting to retrieved connected peripheral...")
                 }
                 else {*/
                centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
                print("CBCentralManager start scanning for Flipr devices")
                //}
                
                //self.centralManager.scanForPeripherals(withServices:[FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
                //self.centralManager.scanForPeripherals(withServices:nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
            }
            //            else if central.state == CBManagerState.poweredOff {
            //                NotificationCenter.default.post(name: K.Notifications.BluetoothOff, object: nil, userInfo: nil)
            //            }
            
            else {
                NotificationCenter.default.post(name: K.Notifications.BluetoothNotAvailble, object: nil, userInfo: nil)
                print("Bluetooth not available.")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //   print("advertisementData: %@",advertisementData)
        
        //        print("peripheral: %@",peripheral)
        
        if self.stopScanning{
            central.stopScan()
            NotificationCenter.default.post(name: K.Notifications.FliprNotDiscovered, object: nil)
            return
        }
        if let name = peripheral.name {
            
            //            print("Name: %@",name)
            if !name.hasPrefix("Flipr 0") {
                if !name.hasPrefix("F"){
                    return
                }
            }
            
            //            print("Flipr device discovered with name:\(peripheral.name) , identifier: \(peripheral.identifier)")
            var occuranceString = "Flipr 00"
            
            var serialNo:String = Module.currentModule?.serial ?? ""
            if AppSharedData.sharedInstance.isFirstCalibrations {
                serialNo = AppSharedData.sharedInstance.deviceSerialNo
            }
            
            if name.hasPrefix("Flipr 00") {
                occuranceString = "Flipr 00"
            }
            else if name.hasPrefix("Flipr 0"){
                occuranceString = "Flipr 0"
            }
            
            var serial = name.replacingOccurrences(of: occuranceString, with: "").trimmed
            
            
            
            //            self.currentMeasuringSerial = serial ?? ""
            //            print("Flipr device discovered with serial:\(serial) , Module.currentModule?.serial: \(Module.currentModule?.serial)")
            /*
             if let currentModuleSerial = Module.currentModule?.serial {
             if serial != currentModuleSerial {
             return
             }
             }
             */
            
            
            
            self.stopScanning = false
            if AppSharedData.sharedInstance.isFirstCalibrations{
                
            }
            let currentModuleSerial = serialNo
            if serial != currentModuleSerial {
                return
            }
            flipr = peripheral
            peripheral.delegate = self
            isConnecting = true
            self.currentMeasuringSerial = serial ?? ""
            
            if currentModuleSerial.hasPrefix("F"){
                self.isV3 = true
            }else{
                self.isV3 = false
            }
            
            print("Discover n Connecting...\(flipr?.name ?? "")")
            if flipr?.state == .disconnected ||  flipr?.state == .disconnecting{
                central.connect(flipr!, options: nil)
                self.stopScanning = true
            }
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnecting = false
        stopScanning = true
        print("Central manager did connect to Flipr: \(peripheral.identifier)")
        //        NotificationCenter.default.post(name: K.Notifications.FliprConnected, object: nil)
        peripheral.discoverServices([FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID,FliprBLEParameters.historicalServiceUUID,FliprBLEParameters.modeCharactersticUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Central manager did fail to connect to Flipr: \(error?.localizedDescription)")
        /*
         isConnecting = false
         self.doAcqCompletionBlock?(error)
         self.doAcqCompletionBlock = nil
         self.calibrationMeasuresCompletionBlock?(error)
         self.calibrationMeasuresCompletionBlock = nil
         self.sendMeasuresCompletionBlock?(error)
         self.sendMeasuresCompletionBlock = nil
         */
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Central manager did disconnect from device with name: \(peripheral.name), error: \(error?.localizedDescription)")
        if !isStoppedForRedo{
            reconnectAndStartReadMeasuremnet()
        }
        /*
         if isConnecting == false {
         self.doAcqCompletionBlock?(error)
         self.doAcqCompletionBlock = nil
         self.calibrationMeasuresCompletionBlock?(error)
         self.calibrationMeasuresCompletionBlock = nil
         self.sendMeasuresCompletionBlock?(error)
         self.sendMeasuresCompletionBlock = nil
         } else {
         //Si isConnecting est (encore) à true, il s'agit d'une déconnection manuelle
         isConnecting = false
         }
         */
    }
    
}

//MARK: - Core bluetooth peripheral delegate
extension GetLastMeasurementManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let services = peripheral.services {
            print("Found \(services.count) service(s)")
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if self.isReconnectedAfterFail{
            if service.uuid == FliprBLEParameters.measuresServiceUUID {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == FliprBLEParameters.measuresCharactersticUUID {
                            peripheral.readValue(for: characteristic)
                            //peripheral.setNotifyValue(true, for: characteristic)
                        }
                    }
                }
            }
            return
        }
        
        if service.uuid == FliprBLEParameters.measuresServiceUUID {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.uuid == FliprBLEParameters.measuresCharactersticUUID {
//                        if !self.isPh4Calibration{
                            self.measuresCharacteristic = characteristic
                            self.isReadP0Value = true
                            perform(#selector(readMeasurementValue), with: nil, afterDelay: 1.0)
//                        }else{
//
//                        }
                    }
                }
            }
        }
        
        if service.uuid == FliprBLEParameters.deviceServiceUUID {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.uuid == FliprBLEParameters.infoCharactersticUUID || characteristic.uuid == FliprBLEParameters.bateryCharactersticUUID  || characteristic.uuid == FliprBLEParameters.modeCharactersticUUID {
                    }
                    if characteristic.uuid == FliprBLEParameters.doAcqCharactersticUUID {
                        doAcqCharacteristic = characteristic
//                        if self.isPh4Calibration{
//                            perform(#selector(writeAcqValue), with: nil, afterDelay: 1.0)
//                        }
                    }
                }
            }
        }
    }
    
    
    @objc func readMeasurementValue(){
        if measuresCharacteristic != nil{
            flipr?.readValue(for: measuresCharacteristic!)
        }
    }
    
    
    @objc func writeAcqValue(){
        if doAcqCharacteristic != nil{
            let data = "1".data(using: .utf8)
            flipr?.writeValue(data!, for: doAcqCharacteristic!, type: .withResponse)
        }
    }
    
    
    func compareMeasurement(){
        var newPh:Double = 0
        if isV3{
            newPh = self.convertPayloadV3(payload: self.newMeasureValue ?? "")
        }else{
            newPh = self.convertPayloadV2(payload: self.newMeasureValue ?? "")
        }
        if (oldMeasureValue != newMeasureValue) && (newPh > 2) && (newPh < 9) {
            self.isReconnectedAfterFail = false
            self.isStoppedForRedo = true
            self.sendMeasure(measures: self.newMeasureValue ?? "", type: "0")

//            if (newPh > 5){
//                print("********** Got ph 7")
//                self.sendMeasure(measures: self.newMeasureValue ?? "", type: "2")
////                self.centralManager.cancelPeripheralConnection(self.flipr!)
//                return
//                //ph 7
//            }else{
//                print("************* Got ph 4")
//                self.sendMeasure(measures: self.newMeasureValue ?? "", type: "1")
////                self.centralManager.cancelPeripheralConnection(self.flipr!)
//                return
//                //ph 4
//            }
        }else{
            perform(#selector(readMeasurementValue), with: nil, afterDelay: 5.0)
        }
        readingCount =  readingCount + 1
        let limit = isV3 ? 19 : 39
        
        if readingCount > limit{
            self.isStoppedForRedo = true
            self.isReconnectedAfterFail = true
            print("Redo")
            self.centralManager.cancelPeripheralConnection(self.flipr!)
            self.calibrationMeasuresCompletionBlock?(NSError.init(domain: "Error", code: 999))
        }
//        else{
//            perform(#selector(readMeasurementValue), with: nil, afterDelay: 5.0)
//        }
    }
    
    
    
    func calculatePh(payload: String) -> Double{
        // Extract octets from payload
        let octet3 = Int(payload.prefix(6).suffix(2), radix: 16)!
        let octet4 = Int(payload.prefix(8).suffix(2), radix: 16)!
        
        // Calculate
        let rawPh = 7 - (((Double(octet4 * 256 + octet3) / 2) - 900) / 59.2)
        return rawPh
    }
    
    
    func convertPayloadV2(payload: String) -> (Double) {
        // Extract octets from payload
        let octet3Str = payload.prefix(6).suffix(2)
        let octet4Str = payload.prefix(8).suffix(2)
        let octet3 = Int(octet3Str, radix: 16)!
        let octet4 = Int(octet4Str, radix: 16)!

        let octet0Str = payload.prefix(2)
        let octet1Str = payload.prefix(4).suffix(2)
        let octet0 = Int(octet0Str, radix: 16)!
        let octet1 = Int(octet1Str, radix: 16)!

        // Compute the temperature
        let temp = Double(octet1 * 256 + octet0) / 16.0

        let voltage = octet4 * 256 + octet3

        // Calculate pH
        let ph = (1026.337 - Double(voltage) / 2.0) / (0.941358216 * (59.16 / 298.15) * (temp + 273.15)) + 7
        return (ph)
    }
    
    
    func convertPayloadV3(payload: String) -> (Double) {
        // Extract octets from payload
        let octet3Str = payload.prefix(6).suffix(2)
        let octet4Str = payload.prefix(8).suffix(2)
        let octet3 = Int(octet3Str, radix: 16)!
        let octet4 = Int(octet4Str, radix: 16)!

        let octet0Str = payload.prefix(2)
        let octet1Str = payload.prefix(4).suffix(2)
        let octet0 = Int(octet0Str, radix: 16)!
        let octet1 = Int(octet1Str, radix: 16)!

        // Compute the temperature
        let temp = Double(octet1 * 256 + octet0) * 0.06

        // Calculate PH brut
        let phBrut = Double(octet4 * 256 + octet3) - ((temp - 25) * 0.2)

        // Calculate raw pH
        let rawPh = ((octet4 * 256 + octet3) / 2 - 900)
        let valtmp = Double(rawPh) / 59.2
        return (7 - valtmp)
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let value = characteristic.value {
            switch characteristic.uuid {
            case FliprBLEParameters.measuresCharactersticUUID:
                if  self.isReadP0Value{
                    self.oldMeasureValue = value.hexEncodedString()
                    self.isReadP0Value = false
                    if self.isStoppedForRedo{
                        
                    }else{
                        self.writeAcqValue()
                    }
                }else{
                    self.newMeasureValue = value.hexEncodedString()
                    self.compareMeasurement()
                }
                print("Measures charateric value: \(value.hexEncodedString())")
                break
            case FliprBLEParameters.doAcqCharactersticUUID:
                break
            default: break
            }
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        print("Write ERROR: \(error)")
        
        if characteristic.uuid == FliprBLEParameters.doAcqCharactersticUUID {
            print("self.doAcqCompletionBlock ERROR: \(error)")
          
            if !self.isStoppedForRedo{
                readingCount = 0
                perform(#selector(readMeasurementValueAfter20sDelay), with: nil, afterDelay: 20.0)
            }
        }
        //        else if characteristic.uuid == FliprBLEParameters.modeCharactersticUUID {
        //            print("Activate threw Mode Characterictic ERROR: \(error)")
        //            activationNeeded = false
        //        }
        
    }
    
    
    
    @objc func readMeasurementValueAfter20sDelay(){
        self.isRead20SecondDelay = true
        if flipr?.state == .connected {
            if measuresCharacteristic != nil{
                flipr?.readValue(for: measuresCharacteristic!)
            }
        }else{
            centralManager.connect(flipr!, options: nil)
        }
    }
    
    
    func toCheckPh(newMeasure:String){
        
    }
    
    
    func reconnectAndStartReadMeasuremnet()
    {
        isReconnectedAfterFail = true
        centralManager.connect(flipr!, options: nil)
    }
    
    
}


extension GetLastMeasurementManager{
    
    func sendMeasure(measures:String, type:String) {
        
        if self.currentMeasuringSerial != Module.currentModule?.serial{
            
        }else{
            debugPrint("Sending measurement...")
        }
        
        var placeId:Int = Module.currentModule?.placeId ?? 0
        if AppSharedData.sharedInstance.isFirstCalibrations {
            placeId = AppSharedData.sharedInstance.addedPlaceId
        }
        
        Alamofire.request(Router.sendModuleMetrics(placeId:"\(placeId)" , serialId: self.currentMeasuringSerial, data: measures, type:type))
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                if (response.result.error == nil) {
                    if AppSharedData.sharedInstance.isFirstCalibrations {
                        
                    }else{
                        //                                NotificationCenter.default.post(name: K.Notifications.FliprMeasuresPosted, object: nil)
                    }
                    debugPrint("HTTP Response Body: \(response.data)")
                    
                    //self.calibrationMeasuresCompletionBlock?(nil)
                    //self.calibrationMeasuresCompletionBlock = nil
                    
                    if type == "0" {
                        UserDefaults.standard.set(Date(), forKey:"LastMeasureSentDate")
                    }
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                    if response.response?.statusCode == 409 {
                        if self.isHandling409{
                            self.isHandling409 = false
                            //                                    NotificationCenter.default.post(name: K.Notifications.FliprMeasures409Error, object: nil)
                        }
                        debugPrint("same data")
                    }
                }
                
                if type == "0" {
                    let dispatchTime = DispatchTime.now() + .seconds(2)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                        self.centralManager.cancelPeripheralConnection(self.flipr!)
                    }
                    
                }
                
//                if self.isPh4Calibration{
//                    let tmp = self.newMeasureValue
//                    self.oldMeasureValue = tmp
//                    self.centralManager.cancelPeripheralConnection(self.flipr!)
//                    self.oldMeasureValue =  nil
//                    self.isReadP0Value = false
//                }
                self.calibrationMeasuresCompletionBlock?(response.result.error)
                self.calibrationMeasuresCompletionBlock = nil
                //                self.sendMeasuresCompletionBlock?(response.result.error)
                //                self.sendMeasuresCompletionBlock = nil
            }
        
        
    }
    
    
}

