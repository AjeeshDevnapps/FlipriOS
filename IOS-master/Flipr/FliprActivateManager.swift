//
//  FliprActivateManager.swift
//  Flipr
//
//  Created by Ajish on 07/07/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import Foundation
import CoreBluetooth


class FliprActivateManager: NSObject {
    
    static let shared: FliprActivateManager = {
        let instance = FliprActivateManager()
        return instance
    }()
    
    var centralManagerHasBeenInitialized = false
    var centralManager:CBCentralManager!
    var flipr:CBPeripheral?

    var scanForHubsWithSerials:[String]?
    var detectedHubs:[String:CBPeripheral] = [:]
    var scanForHubsCompletionBlock:(_ : (_ hubsInfo:[String:CBPeripheral]) -> Void)?
    
//    var connectedGateway:CBPeripheral?
    
    var activationCompletionBlock:(_ : (_ error:Error?) -> Void)?

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
    
    var serialNo = ""

    
    func scanForFlipr(serial: String?, completion: ((_ error: Error?) -> Void)?) {

        serialNo = serial ?? ""
//        scanForHubsWithSerials = serials
        activationCompletionBlock = completion
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

    
    @objc func setTimeLimit(){
        self.stopScanning = true
    }
    
    
    func stopScanForGateway() {
        centralManager.stopScan()
        activationCompletionBlock = nil
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
extension FliprActivateManager: CBCentralManagerDelegate {
    
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

//            let serialNo:String = Module.currentModule?.serial ?? ""
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
//                                NotificationCenter.default.post(name: K.Notifications.FliprConnecitngForModeValue, object: nil, userInfo: nil)
                    central.connect(flipr!, options: nil)
                    centralManager.stopScan()
                }

            }
           
          
            
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
extension FliprActivateManager: CBPeripheralDelegate {
    
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
                        var activationNeeded = true
                        let data = Data(bytes: &activationNeeded, count: MemoryLayout.size(ofValue: activationNeeded))
//                            let data = "1".data(using: .utf8)
                        flipr?.writeValue(data, for: characteristic, type: .withResponse)

//                        peripheral.readValue(for: characteristic)
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
//                            NotificationCenter.default.post(name: K.Notifications.FliprModeValue, object: nil, userInfo: userInfo)

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
            activationCompletionBlock?(nil)
//            peripheral.readValue(for: characteristic)
        }else{
            activationCompletionBlock?(error)

            print("Mode : \(String(describing: error))")
        }
        
    }
    
    
}
