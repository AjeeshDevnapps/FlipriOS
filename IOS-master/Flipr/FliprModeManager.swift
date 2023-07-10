//
//  FliprModeManager.swift
//  Flipr
//
//  Created by Ajeesh on 18/05/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import Foundation
import CoreBluetooth


struct FlipModeBLENotifications {
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

struct FlipModeBLEParameters {
    
    static let gatewaySSIDUUID = CBUUID(string: "9500")
    static let gatewayPasswordUUID = CBUUID(string:"9501")
    static let receptionCharactersticUUID = CBUUID(string:"A9D7166A-D72E-40A9-A002-48044CC30102")
    static let wifiServiceUUID = CBUUID(string:"0A02F906-0000-1000-8000-00805F9B34FB")

}


class FliprModeManager: NSObject {
    
    static let shared: FliprModeManager = {
        let instance = FliprModeManager()
        return instance
    }()
    
    var centralManagerHasBeenInitialized = false
    var centralManager:CBCentralManager!
    var flipr:CBPeripheral?

    var scanForHubsWithSerials:[String]?
    var detectedHubs:[String:CBPeripheral] = [:]
    var scanForHubsCompletionBlock:(_ : (_ hubsInfo:[String:CBPeripheral]) -> Void)?
    
//    var connectedGateway:CBPeripheral?
    var connectCompletionBlock:(_ : (_ error:Error?) -> Void)?
    var cancelConnectionCompletionBlock:(_ : (_ error:Error?) -> Void)?
    var getAvailableWifiCompletionBlock:(_ : (_ networks: HUBWifiNetwork?, _ error:Error?) -> Void)?
    var setModeCompletionBlock:(_ : (_ error:Error?) -> Void)?
    var setPasswordCompletionBlock:(_ : (_ error:Error?) -> Void)?

    
    var modeCharacteristic:CBCharacteristic?
//    var receptionCharacteristic:CBCharacteristic?
//    var passwordCharacteristic:CBCharacteristic?
    
    var wifiPassword:String?

    var module:Module?
    
    var isConnecting = false
    
    var stopScanning = false
    
    var isWriteMode = false
    
    var writingValue:UInt8 = 1

    
    func scanForFlipr(serials: [String]?, completion: ((_ hubsInfo:[String:CBPeripheral]) -> Void)?) {
        scanForHubsWithSerials = serials
        scanForHubsCompletionBlock = completion
        if !centralManagerHasBeenInitialized {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManagerHasBeenInitialized = true
        } else {
            self.stopScanning = false
            perform(#selector(setTimeLimit), with: nil, afterDelay: 60)
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            print("CBCentralManager start scanning for GateWay devices (already initialized)")
        }
    }

    
    
    func readModeValue(){
        if flipr != nil {
            if modeCharacteristic !=  nil{
                flipr!.readValue(for: modeCharacteristic!)
            }
        }

    }
    
    
    @objc func setTimeLimit(){
        self.stopScanning = true
    }
    
    
    func stopScanForGateway() {
        centralManager.stopScan()
        scanForHubsWithSerials = nil
        scanForHubsCompletionBlock = nil
    }
    
    
    func connect(completion: ((_ error: Error?) -> Void)?) {
        
        connectCompletionBlock = completion
        if flipr != nil {
            flipr?.delegate = self
            centralManager.connect(flipr!, options: nil)
//            connectCompletionBlock?(nil)
//            connectedGateway?.discoverServices([GATEWAYBLEParameters.gatewayPasswordUUID,GATEWAYBLEParameters.gatewayPasswordUUID])
        } else {
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Could not connect to Gaetway with serial:".localized + (flipr?.name ?? "")])
            completion?(error)
        }
    }
    
    
    /*
    
    func connect(serial: String, completion: ((_ error: Error?) -> Void)?) {
        
        connectCompletionBlock = completion
        if let peripheral = detectedHubs[serial] {
            flipr = peripheral
            flipr?.delegate = self
            centralManager.connect(flipr!, options: nil)
//            connectCompletionBlock?(nil)
//            connectedGateway?.discoverServices([GATEWAYBLEParameters.gatewayPasswordUUID,GATEWAYBLEParameters.gatewayPasswordUUID])
        } else {
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Could not connect to Gaetway with serial:".localized + serial])
            completion?(error)
        }
    }
    */
    
    func cancelGatewayConnection(completion: ((_ error: Error?) -> Void)?) {
        cancelConnectionCompletionBlock = completion
        if let hub = flipr {
            centralManager.cancelPeripheralConnection(hub)
        } else {
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Could not disconnect from HUB".localized])
            completion?(error)
        }
    }
    
    
    
    func removeConnection(){
        if let gateway = flipr {
            centralManager.cancelPeripheralConnection(gateway)
        }
    }
    
     
    
    func startUpCentralManager(connectAutomatically connect:Bool, sendMeasure send:Bool) {
        
        if !centralManagerHasBeenInitialized {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManagerHasBeenInitialized = true
        } else {
            let services = [FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID]
            centralManager.scanForPeripherals(withServices: services, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            print("CBCentralManager start scanning for Hub devices (already initialized)")
        }
    }
    
    
    func setMode(mode:UInt8, completion: ((_ error: Error?) -> Void)?) {
        
        getAvailableWifiCompletionBlock = nil
        setModeCompletionBlock = completion
        if let fliprConnected = flipr, let sendChar = modeCharacteristic {
//            let data = mode.data(using: .utf8)
            var tmpVal:UInt8 = mode
            let data = Data(bytes: &tmpVal, count: MemoryLayout.size(ofValue: tmpVal))

//            let data = Data(bytes: &activationNeeded, count: MemoryLayout.size(ofValue: activationNeeded))

            flipr?.writeValue(data, for: modeCharacteristic!, type: .withResponse)
            setModeCompletionBlock?(nil)
        } else {
            //send error no hub connected or char discovered
            let error = NSError(domain: "Flipr Mode", code: -1, userInfo: [NSLocalizedDescriptionKey:"No flipr connected :/".localized])
            setModeCompletionBlock?(error)
//            setWifiCompletionBlock = nil
        }
    }

}

//MARK: - Core bluetooth central manager delegate
extension FliprModeManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn {
                print("Bluetooth powered on.")
                
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
                    print("CBCentralManager start scanning for Hub devices")
                //}
                
                //self.centralManager.scanForPeripherals(withServices:[FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
                //self.centralManager.scanForPeripherals(withServices:nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
            } else {
                NotificationCenter.default.post(name: K.Notifications.BluetoothNotAvailble, object: nil, userInfo: nil)
                print("Bluetooth not available.")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
       print(advertisementData)
        if self.stopScanning{
//            central.stopScan()
//            NotificationCenter.default.post(name: K.Notifications.GatewayNoteDiscovered, object: nil)
            return
        }
        
        if let name = peripheral.name {
            
            if !name.hasPrefix("Flipr 0"){
                //&& !name.hasPrefix("FliprHUB") {
                if !name.hasPrefix("F"){
                    return
                }
            }
            
//            print("Flipr device discovered with name:\(peripheral.name) , identifier: \(peripheral.identifier)")
            var occuranceString = "Flipr 00"

            let serialNo:String = Module.currentModule?.serial ?? ""
            if name.hasPrefix("Flipr 00") {
                occuranceString = "Flipr 00"
            }
            else if name.hasPrefix("Flipr 0"){
                occuranceString = "Flipr 0"
            }
            
            var serial = name.replacingOccurrences(of: occuranceString, with: "").trimmed
          
//            let userInfo = ["serial": serial]
//            NotificationCenter.default.post(name: K.Notifications.GatewayDiscovered, object: nil, userInfo: userInfo)
            if serial == serialNo{
                flipr = peripheral
                peripheral.delegate = self
                isConnecting = true
                if flipr?.state == .disconnected ||  flipr?.state == .disconnecting{
                                NotificationCenter.default.post(name: K.Notifications.FliprConnecitngForModeValue, object: nil, userInfo: nil)
                    central.connect(flipr!, options: nil)
                    centralManager.stopScan()
                }


//                if flipr == nil{
//                    central.connect(peripheral, options: nil)
//
//                }else{
//                    if peripheral.state == .disconnected ||  peripheral.state == .disconnecting{
//                        central.connect(peripheral, options: nil)
//                        centralManager.stopScan()
//                    }
//                }
                
               
            }
           
            
            //let serial = "DC89C0"
           /*
            if !detectedHubs.keys.contains(serial) {
                if let searchedSerials = scanForHubsWithSerials {
                    if searchedSerials.contains(serial) {
                        detectedHubs[serial] = peripheral
                        scanForHubsCompletionBlock?(detectedHubs)
                    }
                } else {
                    detectedHubs[serial] = peripheral
                    scanForHubsCompletionBlock?(detectedHubs)
                }
                
                print("Hub device discovered with serial:\(serial)")
            }
        */
            
        }

    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Central manager did connect to Flipr")
        self.stopScanning = true
//        connectCompletionBlock?(nil)
        peripheral.discoverServices([FliprBLEParameters.deviceServiceUUID,FliprBLEParameters.modeCharactersticUUID])
//                peripheral.discoverServices(nil)
//        peripheral.discoverServices([GATEWAYBLEParameters.gatewayPasswordUUID])
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Central manager did fail to connect to Hub: \(error?.localizedDescription)")
        connectCompletionBlock?(error)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Central manager did disconnect from device with name: \(peripheral.name), error: \(error?.localizedDescription)")
        cancelConnectionCompletionBlock?(error)
//        setWifiCompletionBlock?(error)
//        flipr = nil
        cancelConnectionCompletionBlock = nil
    }
    
}

//MARK: - Core bluetooth peripheral delegate
extension FliprModeManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let services = peripheral.services {
            print("Found \(services.count) service(s)")
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("========= SERVICE ==========")
        print("\(service)")
        print("----------------------------")
        if service.uuid == FliprBLEParameters.deviceServiceUUID {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    print("Device characteristic UUID: \(characteristic.uuid)")
                    if characteristic.uuid == FliprBLEParameters.modeCharactersticUUID {
                        self.modeCharacteristic = characteristic
                        if isWriteMode{
                            var tmpVal:UInt8 = self.writingValue
                            let data = Data(bytes: &tmpVal, count: MemoryLayout.size(ofValue: tmpVal))
                            flipr?.writeValue(data, for: modeCharacteristic!, type: .withResponse)
                            connectCompletionBlock?(nil)
                        }else{
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
            case FliprBLEParameters.modeCharactersticUUID:
                print("Mode charateristic value: \(value.hexEncodedString())")
                let userInfo = ["Mode": value.hexEncodedString()]
                NotificationCenter.default.post(name: K.Notifications.FliprModeValue, object: nil, userInfo: userInfo)
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
        
        if characteristic.uuid == FliprBLEParameters.modeCharactersticUUID {
            print("did write MODE !!!: \(String(describing: error))")
//            peripheral.readValue(for: characteristic)
        }else{
            print("Mode : \(String(describing: error))")
        }
        
    }
    
    
}

