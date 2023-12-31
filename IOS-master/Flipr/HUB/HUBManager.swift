//
//  HUBManager.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 05/03/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import Foundation
import CoreBluetooth

struct HUBBLENotifications {
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

struct HUBBLEParameters {
    
    static let wifiServiceUUID = CBUUID(string: "A9D7166A-D72E-40A9-A002-48044CC30100")
    static let channelCharactersticUUID = CBUUID(string:"A9D7166A-D72E-40A9-A002-48044CC30101")
    static let receptionCharactersticUUID = CBUUID(string:"A9D7166A-D72E-40A9-A002-48044CC30102")
    static let sendCharactersticUUID = CBUUID(string:"A9D7166A-D72E-40A9-A002-48044CC30103")

}

class HUBManager: NSObject {
    
    static let shared: HUBManager = {
        let instance = HUBManager()
        return instance
    }()
    
    var centralManagerHasBeenInitialized = false
    var centralManager:CBCentralManager!
    
    var scanForHubsWithSerials:[String]?
    var detectedHubs:[String:CBPeripheral] = [:]
    var scanForHubsCompletionBlock:(_ : (_ hubsInfo:[String:CBPeripheral]) -> Void)?
    
    var connectedHub:CBPeripheral?
    var connectCompletionBlock:(_ : (_ error:Error?) -> Void)?
    var cancelConnectionCompletionBlock:(_ : (_ error:Error?) -> Void)?
    var getAvailableWifiCompletionBlock:(_ : (_ networks: HUBWifiNetwork?, _ error:Error?) -> Void)?
    var setWifiCompletionBlock:(_ : (_ error:Error?) -> Void)?
    
    var channelCharacteristic:CBCharacteristic?
    var receptionCharacteristic:CBCharacteristic?
    var sendCharacteristic:CBCharacteristic?
    
    var module:Module?
    
    var isConnecting = false
    
    var stopScanning = false

    
    func scanForHubs(serials: [String]?, completion: ((_ hubsInfo:[String:CBPeripheral]) -> Void)?) {
        scanForHubsWithSerials = serials
        scanForHubsCompletionBlock = completion
        if !centralManagerHasBeenInitialized {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManagerHasBeenInitialized = true
        } else {
            self.stopScanning = false
            perform(#selector(setTimeLimit), with: nil, afterDelay: 60)
            //let services = [FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID]
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            print("CBCentralManager start scanning for Hub devices (already initialized)")
        }
    }
    
    @objc func setTimeLimit(){
        self.stopScanning = true
    }
    
    
    func stopScanForHubs() {
        centralManager.stopScan()
        scanForHubsWithSerials = nil
        scanForHubsCompletionBlock = nil
    }
    
    
    func connect(serial: String, completion: ((_ error: Error?) -> Void)?) {
        
        connectCompletionBlock = completion
        if let peripheral = detectedHubs[serial] {
            connectedHub = peripheral
            connectedHub?.delegate = self
            centralManager.connect(connectedHub!, options: nil)
        } else {
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Could not connect to HUB with serial:".localized + serial])
            completion?(error)
        }
    }
    
    func cancelHubConnection(completion: ((_ error: Error?) -> Void)?) {
        cancelConnectionCompletionBlock = completion
        if let hub = connectedHub {
            centralManager.cancelPeripheralConnection(hub)
        } else {
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Could not disconnect from HUB".localized])
            completion?(error)
        }
    }
    
    func deleteWifi(index: Int, completion: ((_ error: Error?) -> Void)?) {
        
        if let hub = connectedHub, let sendChar = sendCharacteristic {
            
            getAvailableWifiCompletionBlock = nil
            setWifiCompletionBlock = completion
            
            let encoded = CBOR.encode(["w":7,"g":index] as NSDictionary)
            
            let data = Data(bytes: encoded!)
            print("WRITE data: \(data.hexEncodedString())")
            hub.writeValue(data, for: sendChar, type: .withResponse)
        } else {
            //send error no hub connected or char discovered
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No HUB connected :/".localized])
            completion?(error)
        }
    }
    
    func getAvailableWifi(completion: ((_ network:HUBWifiNetwork?, _ error: Error?) -> Void)?) {
        
        getAvailableWifiCompletionBlock = completion
        if let hub = connectedHub, let sendChar = sendCharacteristic {
        
            let encoded = CBOR.encode(["w":1,"h":10,"t":10] as NSDictionary)
            
            let data = Data(bytes: encoded!)
            print("WRITE data: \(data.hexEncodedString())")
            hub.writeValue(data, for: sendChar, type: .withResponse)
        } else {
            
            if connectedHub == nil {
                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No HUB connected :/".localized])
                getAvailableWifiCompletionBlock?(nil,error)
            } else if sendCharacteristic == nil {
                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"BLE Service's characteristic not found :/".localized])
                getAvailableWifiCompletionBlock?(nil,error)
            }
            
            getAvailableWifiCompletionBlock = nil
        }
    }
    
    func setWifi(network: HUBWifiNetwork, password:String, completion: ((_ error: Error?) -> Void)?) {
        
        getAvailableWifiCompletionBlock = nil
        setWifiCompletionBlock = completion
        if let hub = connectedHub, let sendChar = sendCharacteristic {
            
            var info = network.addSerialized
            info["w"] = 3
            info["m"] = password
            
            print("WRITE JSON: \(info)")
            
            let encoded = CBOR.encode(info as NSDictionary)
            let data = Data(bytes: encoded!)
            //let data = "A6617703616246C81451F3E583616720616D6B4E4D5130514846465441306171036172704855415745492D423532382D45353833".data!
            print("WRITE data: \(data.hexEncodedString().uppercased())")
            print("WRITE data: A6617703616246C81451F3E583616720616D6B4E4D5130514846465441306171036172704855415745492D423532382D45353833 GOOOOOOOD")
            hub.writeValue(data, for: sendChar, type: .withResponse)

        } else {
            //send error no hub connected or char discovered
            let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"No HUB connected :/".localized])
            setWifiCompletionBlock?(error)
            setWifiCompletionBlock = nil
        }
    }
    
    func startUpCentralManager(connectAutomatically connect:Bool, sendMeasure send:Bool) {
        
        if !centralManagerHasBeenInitialized {
            centralManager = CBCentralManager(delegate: self, queue: nil)
            centralManagerHasBeenInitialized = true
        } else {
            let services = [FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID]
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            print("CBCentralManager start scanning for Hub devices (already initialized)")
        }
    }

}

//MARK: - Core bluetooth central manager delegate
extension HUBManager: CBCentralManagerDelegate {
    
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
       
        if self.stopScanning{
//            central.stopScan()
            NotificationCenter.default.post(name: K.Notifications.HUBNotDiscovered, object: nil)
            return
        }
        
        if let name = peripheral.name {
            
            
            if !name.hasPrefix("Flipr HUB") && !name.hasPrefix("FliprHUB") {
                return
            }
            
            print("Hub device discovered with name:\(peripheral.name) , identifier: \(peripheral.identifier)")
            
            let serial = name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "FliprHUB", with: "").trimmed
            //let serial = "DC89C0"
            
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
        
        }

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Central manager did connect to Hub")
        connectCompletionBlock?(nil)
        peripheral.discoverServices([HUBBLEParameters.wifiServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Central manager did fail to connect to Hub: \(error?.localizedDescription)")
        connectCompletionBlock?(error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Central manager did disconnect from device with name: \(peripheral.name), error: \(error?.localizedDescription)")
        cancelConnectionCompletionBlock?(error)
        setWifiCompletionBlock?(error)
        connectedHub = nil
        cancelConnectionCompletionBlock = nil
    }
    
}

//MARK: - Core bluetooth peripheral delegate
extension HUBManager: CBPeripheralDelegate {
    
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
        if let characteristics = service.characteristics {
            var i = 1
            for characteristic in characteristics {
                print("- CHARACTERISTIC [\(i)] : \(characteristic)")
                i = i+1
                //peripheral.readValue(for: characteristic)
                if characteristic.uuid == HUBBLEParameters.channelCharactersticUUID {
                    channelCharacteristic = characteristic
                    //let data = Data(bytes:[UInt8(1)])
                    //peripheral.writeValue(data, for: characteristic, type: .withResponse)
                    if let data = Data(hexString: "01") {
                        peripheral.writeValue(data, for: characteristic, type: .withResponse)
                    }
                }
                if characteristic.uuid == HUBBLEParameters.receptionCharactersticUUID {
                    receptionCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                if characteristic.uuid == HUBBLEParameters.sendCharactersticUUID {
                    sendCharacteristic = characteristic
                }
            }
        }
        
        
        /*
        if service.uuid == HUBBLEParameters.measuresServiceUUID {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.uuid == HUBBLEParameters.measuresCharactersticUUID {
                        peripheral.readValue(for: characteristic)
                        //peripheral.setNotifyValue(true, for: characteristic)
                    }
                }
            }
        }
        
        if service.uuid == HUBBLEParameters.deviceServiceUUID {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    print("Device characteristic UUID: \(characteristic.uuid)")
                    if characteristic.uuid == HUBBLEParameters.infoCharactersticUUID || characteristic.uuid == HUBBLEParameters.bateryCharactersticUUID  || characteristic.uuid == HUBBLEParameters.modeCharactersticUUID {
                        peripheral.readValue(for: characteristic)
                    }
                    if characteristic.uuid == HUBBLEParameters.doAcqCharactersticUUID {
                        doAcqCharacteristic = characteristic
                        if doAcq {
                            let data = "1".data(using: .utf8)
                            hub?.writeValue(data!, for: doAcqCharacteristic!, type: .withResponse)
                            //doAcqCompletionBlock?(nil)
                            //doAcqCompletionBlock = nil
                        }
                    }
                    if characteristic.uuid == HUBBLEParameters.modeCharactersticUUID {
                        if activationNeeded {
                            let data = Data(bytes: &activationNeeded, count: MemoryLayout.size(ofValue: activationNeeded))
                            hub?.writeValue(data, for: characteristic, type: .withResponse)
                        }
                        if turnOn || turnOff {
                            var value = true
                            if turnOff {
                                value = false
                            }
                            let data = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
                            print("CMD Activate Flipr: \(data.hexEncodedString())")
                            hub?.writeValue(data, for: characteristic, type: .withResponse)
                            turnOn = false
                            turnOff = false
                            peripheral.readValue(for: characteristic)
                        }
                    }
                }
            }
        }*/
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let value = characteristic.value {
            switch characteristic.uuid {
            case HUBBLEParameters.channelCharactersticUUID:
                print("Channel charateristic value: \(value), hex: \(value.hexEncodedString())")
                break
            case HUBBLEParameters.receptionCharactersticUUID:
                print("Reception charateristic value: \(value), hex: \(value.hexEncodedString())")
                if value.bytes.count > 0 {
                    let decoded = CBOR.decode(value.bytes)
                    print("Reception charateristic decoded value: \(decoded)")
                    if let dict = decoded as? [String:Any] {
                        print("wifi name: \(dict["r"])")
                        if dict["r"] == nil {
                            print("KEK")
                            
                            print(dict["s"])
                            if("\(dict["s"])" == "Optional(1)")
                            {
                                let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Password error :/".localized])
                                setWifiCompletionBlock?(error)
                                setWifiCompletionBlock = nil
                            }else{
                                setWifiCompletionBlock?(nil)
                                setWifiCompletionBlock = nil
                            }
                        } else {
                            if let network = HUBWifiNetwork(withJSON: dict) {
                                getAvailableWifiCompletionBlock?(network ,error)
                            }
                        }
                    }
                }
                break
            case HUBBLEParameters.sendCharactersticUUID:
                print("Send charateristic value: \(value), hex: \(value.hexEncodedString())")
                break
            default:
                print("Unknown charateristic value: \(value), hex: \(value.hexEncodedString())")
                break
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic.uuid == HUBBLEParameters.channelCharactersticUUID {
            print("did write !!!: \(error)")
            peripheral.readValue(for: characteristic)
        }
        if characteristic.uuid == HUBBLEParameters.sendCharactersticUUID {
            print("did write sendCharacterstic: \(error)")
            if let receptChar = receptionCharacteristic {
                print("manually read receptionCharacteristic")
                //peripheral.readValue(for: receptChar)
            }
        }
        
        /*
        if characteristic.uuid == HUBBLEParameters.doAcqCharactersticUUID {
            print("self.doAcqCompletionBlock ERROR: \(error)")
            self.doAcqCompletionBlock?(error)
            self.doAcqCompletionBlock = nil
        } else if characteristic.uuid == HUBBLEParameters.modeCharactersticUUID {
            print("Activate threw Mode Characterictic ERROR: \(error)")
            activationNeeded = false
        }*/
    }
}

