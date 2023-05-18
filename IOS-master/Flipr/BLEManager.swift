//
//  BLEManager.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 29/03/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import CoreBluetooth
import Alamofire
import SwifterSwift

struct BLENotifications {
    static let BluetoothReady = "fr.isee-u.flipr.bluetoothReady"
    static let FoundDevice = "fr.isee-u.flipr.founddevice"
    static let ConnectionComplete = "fr.isee-u.flipr.connectioncomplete"
    static let ServiceScanComplete = "fr.isee-u.flipr.servicescancomplete"
    static let CharacteristicScanComplete = "fr.isee-u.flipr.characteristicsscancomplete"
    static let DisconnectedDevice = "fr.isee-u.flipr.disconnecteddevice"
    static let UpdatedData = "fr.isee-u.flipr.updatedcapsense"
    
    static let measuresPostedSuccesfully = "fr.isee-u.flipr.measuresPostedSuccesfully"
    static let measuresPostDidFail = "fr.isee-u.flipr.measuresPostDidFail"
    
    static let BateryLevelDidRead = "fr.isee-u.flipr.bateryLevelDidRead"
}

struct FliprBLEParameters {
    static let measuresServiceUUID = CBUUID(string: "E302")
    static let measuresCharactersticUUID = CBUUID(string:"0006")
    
    static let deviceServiceUUID = CBUUID(string: "F906")
    static let infoCharactersticUUID = CBUUID(string:"07C1")
    static let bateryCharactersticUUID = CBUUID(string:"549D")
    static let modeCharactersticUUID = CBUUID(string:"73B4")
    static let doAcqCharactersticUUID = CBUUID(string:"940D")
    
    static let historicalServiceUUID = CBUUID(string: "A9F4")
    static let historicalReadCharactersticUUID = CBUUID(string:"6284")
    static let historicalWriteCharactersticUUID = CBUUID(string:"5D1E")
}

class BLEManager: NSObject {
    
    static let shared: BLEManager = {
        let instance = BLEManager()
        return instance
    }()
    
    var centralManagerHasBeenInitialized = false
    
    var centralManager:CBCentralManager!
    var flipr:CBPeripheral?
    var connectAfterDiscovery = false
    var sendMeasureAfterConnection = false
    var sendMeasuresCompletionBlock:(_ : (_ error:Error?) -> Void)?
    
    var activationNeeded = false
    var turnOn = false
    var turnOff = false
    
    var doAcq = false
    var doAcqCharacteristic:CBCharacteristic?
    var doAcqCompletionBlock:(_ : (_ error:Error?) -> Void)?
    
    var calibrationMeasures = false
    var calibrationType: CalibrationType = .ph7
    var measuresCharacteristic:CBCharacteristic?
    var calibrationMeasuresCompletionBlock:(_ : (_ error:Error?) -> Void)?
    
    
    
    var module:Module?
    
    var isConnecting = false
    var stopScanning = false
    
    var fliprReadingVerification = false
    var isHandling409 = false
    var currentMeasuringSerial:String = ""

    var fliprList = [CBPeripheral]()


    func startUpCentralManager(connectAutomatically connect:Bool, sendMeasure send:Bool) {
        fliprList.removeAll()
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
    
    
    @objc func setTimeLimit(){
        self.stopScanning = true
    }
    
    func activateFlipr(activate: Bool, completion: ((_ error: Error?) -> Void)?) {
        
        if activate {
            turnOn = true
        } else {
            turnOff = true
        }
        startUpCentralManager(connectAutomatically: true, sendMeasure: false)
        
    }
    
    
    func disConnectCurrentDevice(){
        if self.flipr != nil{
            let dispatchTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.centralManager.cancelPeripheralConnection(self.flipr!)
            }
        }
    }
    
    func startMeasure(completion: ((_ error: Error?) -> Void)?) {
//        var serialNo = ""
        doAcq = true
        doAcqCompletionBlock = completion
        let name = self.flipr?.name ?? ""
        var occuranceString = "Flipr 00"
        if name.hasPrefix("Flipr 00") {
            occuranceString = "Flipr 00"
        }
        else if name.hasPrefix("Flipr 0"){
            occuranceString = "Flipr 0"
        }
        var currentSavedserial = name.replacingOccurrences(of: occuranceString, with: "").trimmed

        if AppSharedData.sharedInstance.isFirstCalibrations
        {
            if AppSharedData.sharedInstance.deviceSerialNo.isValidString && currentSavedserial.isValidString{
                if currentSavedserial == AppSharedData.sharedInstance.deviceSerialNo{
                    if doAcqCharacteristic != nil {
                        if flipr?.state == .connected {
                            let data = "1".data(using: .utf8)
                            flipr?.writeValue(data!, for: doAcqCharacteristic!, type: .withResponse)
                        } else {
                            isConnecting = true
            //                print("Connecting...")
                            print("Connecting... startMeasure \(flipr?.name ?? "")")

                            centralManager.connect(flipr!, options: nil)
                        }
                    } else if flipr != nil {
                        if flipr?.state == .connected {
                            flipr?.discoverServices([FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID,FliprBLEParameters.historicalServiceUUID])
                        } else {
            //                print("Connecting...")
                            print("Connecting... startMeasure \(flipr?.name ?? "")")

                            isConnecting = true
                            centralManager.connect(flipr!, options: nil)
                        }
                    } else {
                        startUpCentralManager(connectAutomatically: true, sendMeasure: false)
                    }

                }else{
                    startUpCentralManager(connectAutomatically: true, sendMeasure: false)
                }
            }else{
                startUpCentralManager(connectAutomatically: true, sendMeasure: false)
            }
           
            
            
        }else{
            
            let currentModuleDevice = Module.currentModule?.serial ?? "TmpSerialNo"
           
            if currentSavedserial == currentModuleDevice{
                if doAcqCharacteristic != nil {
                    if flipr?.state == .connected {
                        let data = "1".data(using: .utf8)
                        flipr?.writeValue(data!, for: doAcqCharacteristic!, type: .withResponse)
                    } else {
                        isConnecting = true
        //                print("Connecting...")
                        print("Connecting... startMeasure \(flipr?.name ?? "")")

                        centralManager.connect(flipr!, options: nil)
                    }
                } else if flipr != nil {
                    if flipr?.state == .connected {
                        flipr?.discoverServices([FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID,FliprBLEParameters.historicalServiceUUID])
                    } else {
        //                print("Connecting...")
                        print("Connecting... startMeasure \(flipr?.name ?? "")")

                        isConnecting = true
                        centralManager.connect(flipr!, options: nil)
                    }
                } else {
                    startUpCentralManager(connectAutomatically: true, sendMeasure: false)
                }
            }else{
                startUpCentralManager(connectAutomatically: true, sendMeasure: false)
            }
           
        }
    }
    
    
    func searchAddingNewDevice(){
        
    }
    
    
    func sendCalibrationMeasure(type:CalibrationType, completion: ((_ error: Error?) -> Void)?) {
        
        calibrationMeasures = true

        calibrationType = type
        
        calibrationMeasuresCompletionBlock = completion
        
        if measuresCharacteristic != nil {
            if flipr?.state == .connected {
                flipr?.readValue(for: measuresCharacteristic!)
            } else {
                print("Connecting... sendCalibrationMeasure \(flipr?.name ?? "")")
                isConnecting = true
                centralManager.connect(flipr!, options: nil)
            }
        } else if flipr != nil {
            if flipr?.state == .connected {
                flipr?.discoverServices([FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID,FliprBLEParameters.historicalServiceUUID])
            } else {
//                print("Connecting...")
                print("Connecting... sendCalibrationMeasure \(flipr?.name ?? "")")

                isConnecting = true
                centralManager.connect(flipr!, options: nil)
            }
        } else {
            startUpCentralManager(connectAutomatically: true, sendMeasure: false)
        }
        
    }
    
    func post(measures:String, type:String) {
        
        if self.currentMeasuringSerial != Module.currentModule?.serial{
//            return;
//            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Measuring diff device :/"])
//            self.calibrationMeasuresCompletionBlock?(error)
//            self.calibrationMeasuresCompletionBlock = nil
//            self.sendMeasuresCompletionBlock?(error)
//            self.sendMeasuresCompletionBlock = nil
//            return;
        }else{
//            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Diff Device"])
//            self.calibrationMeasuresCompletionBlock?(error)
//            self.calibrationMeasuresCompletionBlock = nil
//            self.sendMeasuresCompletionBlock?(error)
//            self.sendMeasuresCompletionBlock = nil
//            return;
            debugPrint("Sending measurement...")
        }
    
        
//        var measureBackup = "0"
//        var isZerioValue = false
//        if let intVal = Int(measures){
//            if intVal == 0{
//                isZerioValue = true
//            }
//        }
//        if isZerioValue {
//            if let backupData = UserDefaults.standard.object(forKey: "LastMeasureBackupData") as? String{
//                measureBackup = backupData
//            }
//        }else{
//            measureBackup = measures
//            UserDefaults.standard.set(measures, forKey: "LastMeasureBackupData")
//        }
//
        if let identifier = Module.currentModule?.serial {
            NotificationCenter.default.post(name: K.Notifications.FliprDidRead, object: nil)
            if fliprReadingVerification{
                fliprReadingVerification = false
                return
//                UserDefaults.standard.set(measures, forKey: "LastMeasureBackupData")
//                fliprReadingVerification = false
//                self.centralManager.cancelPeripheralConnection(self.flipr!)
//                return
                //self.centralManager.cancelPeripheralConnection(self.flipr!)
            }
            else{
                var placeId:Int = Module.currentModule?.placeId ?? 0
                if AppSharedData.sharedInstance.isFirstCalibrations {
                    placeId = AppSharedData.sharedInstance.addedPlaceId
                }
                
                Alamofire.request(Router.sendModuleMetrics(placeId:"\(placeId)" , serialId: identifier, data: measures, type:type))
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                        
                        if (response.result.error == nil) {
                            if AppSharedData.sharedInstance.isFirstCalibrations {
                                
                            }else{
                                NotificationCenter.default.post(name: K.Notifications.FliprMeasuresPosted, object: nil)
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
                                    NotificationCenter.default.post(name: K.Notifications.FliprMeasures409Error, object: nil)
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
                        
                        self.calibrationMeasuresCompletionBlock?(response.result.error)
                        self.calibrationMeasuresCompletionBlock = nil
                        self.sendMeasuresCompletionBlock?(response.result.error)
                        self.sendMeasuresCompletionBlock = nil
                }

            }
            
            
        } else {
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Numéro de série du Flipr introuvable :/"])
            self.calibrationMeasuresCompletionBlock?(error)
            self.calibrationMeasuresCompletionBlock = nil
            self.sendMeasuresCompletionBlock?(error)
            self.sendMeasuresCompletionBlock = nil
        }
    }
}

//MARK: - Core bluetooth central manager delegate
extension BLEManager: CBCentralManagerDelegate {
    
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
        
//        print("advertisementData: %@",advertisementData)
        
//        print("peripheral: %@",peripheral)

        if self.stopScanning{
            central.stopScan()
            NotificationCenter.default.post(name: K.Notifications.FliprNotDiscovered, object: nil)
            return
        }
        if let name = peripheral.name {
            
//            print("Name: %@",name)
            if !name.hasPrefix("Flipr 0") && !name.hasPrefix("FliprHUB") {
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
            
            if name.hasPrefix("FliprHUB") {
                serial = name.replacingOccurrences(of: "FliprHUB", with: "").trimmed
            }
            
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
//            flipr = peripheral
//            peripheral.delegate = self
            
//            central.stopScan()
//            print("CBCentralManager stop scanning for Flipr devices")
            fliprList.append(peripheral)
            let userInfo = ["serial": serial]
            NotificationCenter.default.post(name: K.Notifications.FliprDiscovered, object: nil, userInfo: userInfo)
            
            if connectAfterDiscovery {
//                print("Connecting...")
                
                
                if AppSharedData.sharedInstance.isFirstCalibrations{
                    
                }
//                if let currentModuleSerial = Module.currentModule?.serial {
//                    if serial != currentModuleSerial {
//                        return
//                    }
//                }
                
                 let currentModuleSerial = serialNo
                if serial != currentModuleSerial {
                    return
                }
                flipr = peripheral
                peripheral.delegate = self
                isConnecting = true
                self.currentMeasuringSerial = serial ?? ""
                print("Discover n Connecting...\(flipr?.name ?? "")")
                if flipr?.state == .disconnected ||  flipr?.state == .disconnecting{
                    central.connect(flipr!, options: nil)
                }
            }
            
        }
        
       

    }
    
    
    func connectPerpheral(serial:String){
        for item in fliprList{
            if let name  = item.name{
                var occuranceString = "Flipr 00"

                if name.hasPrefix("Flipr 00") {
                    occuranceString = "Flipr 00"
                }
                else if name.hasPrefix("Flipr 0"){
                    occuranceString = "Flipr 0"
                }
                let ItemSerial = name.replacingOccurrences(of: occuranceString, with: "").trimmed
                if ItemSerial == serial{
                    centralManager.connect(item, options: nil)
                    print("Connecting...\(flipr?.name ?? "")")
                }
            }
        }
    }
    
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnecting = false
        stopScanning = true
        print("Central manager did connect to Flipr: \(peripheral.identifier)")
        NotificationCenter.default.post(name: K.Notifications.FliprConnected, object: nil)
        peripheral.discoverServices([FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID,FliprBLEParameters.historicalServiceUUID,FliprBLEParameters.modeCharactersticUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Central manager did fail to connect to Flipr: \(error?.localizedDescription)")
        isConnecting = false
        self.doAcqCompletionBlock?(error)
        self.doAcqCompletionBlock = nil
        self.calibrationMeasuresCompletionBlock?(error)
        self.calibrationMeasuresCompletionBlock = nil
        self.sendMeasuresCompletionBlock?(error)
        self.sendMeasuresCompletionBlock = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Central manager did disconnect from device with name: \(peripheral.name), error: \(error?.localizedDescription)")
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
       
    }
    
}

//MARK: - Core bluetooth peripheral delegate
extension BLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let services = peripheral.services {
            print("Found \(services.count) service(s)")
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        /*
        print("========= SERVICE ==========")
        print("\(service)")
        print("----------------------------")
        if let characteristics = service.characteristics {
            var i = 1
            for characteristic in characteristics {
                print("- CHARACTERISTIC [\(i)] : \(characteristic)")
                peripheral.readValue(for: characteristic)
                i = i+1
            }
        }
        */
        
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
        
        if service.uuid == FliprBLEParameters.deviceServiceUUID {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    print("Device characteristic UUID: \(characteristic.uuid)")
                    if characteristic.uuid == FliprBLEParameters.infoCharactersticUUID || characteristic.uuid == FliprBLEParameters.bateryCharactersticUUID  || characteristic.uuid == FliprBLEParameters.modeCharactersticUUID {
                        peripheral.readValue(for: characteristic)
                    }
                    if characteristic.uuid == FliprBLEParameters.doAcqCharactersticUUID {
                        doAcqCharacteristic = characteristic
                        if doAcq {
                            let data = "1".data(using: .utf8)
                            flipr?.writeValue(data!, for: doAcqCharacteristic!, type: .withResponse)
                            //doAcqCompletionBlock?(nil)
                            //doAcqCompletionBlock = nil
                        }
                    }
                    if characteristic.uuid == FliprBLEParameters.modeCharactersticUUID {
                        if activationNeeded {
                            let data = Data(bytes: &activationNeeded, count: MemoryLayout.size(ofValue: activationNeeded))
//                            let data = "1".data(using: .utf8)
                            flipr?.writeValue(data, for: characteristic, type: .withResponse)
                        }
                        if turnOn || turnOff {
                            var value = true
                            if turnOff {
                                value = false
                            }
                            let data = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
                            print("CMD Activate Flipr: \(data.hexEncodedString())")
                            flipr?.writeValue(data, for: characteristic, type: .withResponse)
                            turnOn = false
                            turnOff = false
                            peripheral.readValue(for: characteristic)
                        }
                    }
                }
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        if let value = characteristic.value {
            switch characteristic.uuid {
            case FliprBLEParameters.measuresCharactersticUUID:
                print("Measures charateric value: \(value.hexEncodedString())")

                if calibrationMeasures {
                    if calibrationType == .simpleMeasure {
                        print("Posting measurement ... type 0 \(peripheral.name)")

                        post(measures: value.hexEncodedString(), type: "0")
                    } else if calibrationType == .ph7 {
                        print("Posting measurement ... type 2 \(peripheral.name)")

                        post(measures: value.hexEncodedString(), type: "2")
                    } else {
                        print("Posting measurement ... type 1 \(peripheral.name)")

                        post(measures: value.hexEncodedString(), type: "1")
                    }
                } else if sendMeasureAfterConnection {
                    print("Posting measurement ... type 0 \(peripheral.name)")

                    post(measures: value.hexEncodedString(), type: "0")
                    sendMeasureAfterConnection = false
                }
                
                else if fliprReadingVerification {
                    print("Posting measurement ... type 0 \(peripheral.name)")

                    post(measures: value.hexEncodedString(), type: "0")
//                    sendMeasureAfterConnection = false
                }
                
                break
            case FliprBLEParameters.infoCharactersticUUID:
                print("Info charateristic value: \(value.hexEncodedString())")
                //let userInfo = ["serial": value.hexEncodedString()]
                //NotificationCenter.default.post(name: K.Notifications.FliprSerialRead, object: nil, userInfo: userInfo)
                break
            case FliprBLEParameters.bateryCharactersticUUID:
                
                /*
                print("Battery charateristic value: \(value.hexEncodedString())")
            
                let str = value.hexEncodedString()
                let index = str.index(str.startIndex, offsetBy: 2)
                let permutedValue = str.substring(from: index) + str.substring(to: index)
                if let baterieLevel = UInt64(permutedValue, radix:16) {
                    print("Battery level: \(baterieLevel) mV = \(baterieLevel * 100 / 3600)%")
                    UserDefaults.standard.set(String(baterieLevel * 100 / 3600), forKey: "BatteryLevel")
                    let userInfo = ["level": baterieLevel * 100 / 3600]
                    NotificationCenter.default.post(name: K.Notifications.FliprBatteryDidRead, object: nil, userInfo: userInfo)
                }
                */
                
                break
            case FliprBLEParameters.modeCharactersticUUID:
                print("Mode charateristic value: \(value.hexEncodedString())")
                if value.hexEncodedString() == "01"{
                    
                }else{
                    
                }
                break
            default:
                print("Unknown charateristic value: \(value)")
                break
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {

        if characteristic.uuid == FliprBLEParameters.doAcqCharactersticUUID {
            print("self.doAcqCompletionBlock ERROR: \(error)")
            self.doAcqCompletionBlock?(error)
            self.doAcqCompletionBlock = nil
        } else if characteristic.uuid == FliprBLEParameters.modeCharactersticUUID {
            print("Activate threw Mode Characterictic ERROR: \(error)")
            activationNeeded = false
        }
    }
}

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Int {
    mutating func hexData() -> Data {
         return Data(bytes: &self, count: MemoryLayout.size(ofValue: self))
    }
}
