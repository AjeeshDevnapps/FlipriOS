//
//  DeviceViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 19/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth

enum DeviceWifiCellType {
    case MeasureInfo
    case StatusInfo
}

class DeviceViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    var devicewifiTypeCell = DeviceWifiCellType.MeasureInfo
    var devicesDetails:  [String:Any]?
    var centralManager:CBCentralManager!
    var flipr:CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let vers = devicesDetails?["ModuleType_Id"] as? Int {
            if vers == 1{
                devicewifiTypeCell = DeviceWifiCellType.MeasureInfo
            }else{
                devicewifiTypeCell = DeviceWifiCellType.StatusInfo
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func startBluetoothCheck(){
//        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BluetoothAlertViewController") as? BluetoothAlertViewController {
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func wifiSettingsButtonClicked(){
        
        if devicewifiTypeCell == DeviceWifiCellType.MeasureInfo{
            self.checkBluetoothConnection()
        }else{
//            self.showWifiSettings()
            self.checkBluetoothConnection()

        }
       
    }
    
    
    func checkBluetoothConnection(){
        
        let alertController = UIAlertController(title: "Bluetooth  check", message: "Please stand close to your device(max 1 meeter) and tap Perform check", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Perform Check", style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            self.startBluetoothCheck()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showWifiSettings(){
        let sb = UIStoryboard.init(name: "HUB", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "HUBActivationViewControllerID") as? HUBActivationViewController {
            if let serial = devicesDetails?["Serial"] as? String  {
                vc.serial  = serial
            }
            if let activationKey = devicesDetails?["ActivationKey"] as? String {
                vc.equipmentCode = activationKey
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func forgetDeviceButtonClicked(){
       
        let alertController = UIAlertController(title: "Unbind  Flipr", message: "Do you really want to unbind ? All measure and calibration data will be lost.", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "UNBIND", style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            self.forgetDevice()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }
    

    func forgetDevice(){
        let serial = devicesDetails?["Serial"] as? String
        let activationKey = devicesDetails?["ActivationKey"] as? String
        if serial == nil || activationKey == nil {
            return
        }
        
        Module.deactivate(serial:serial ?? "" , activationKey: activationKey ?? "", completion: { (error) in
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            } else {
                self.navigationController?.popViewController()
            }
            
            
        })
    }


}

extension DeviceViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 275
        }
        else if indexPath.row == 1 {
            return 66
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceInfoTableViewCell",
                                                     for: indexPath) as! DeviceInfoTableViewCell
            
           
            if let name = devicesDetails?["NickName"] as? String  {
                cell.nameLabel.text = name
            }
            if let serial = devicesDetails?["Serial"] as? String  {
                cell.serialLabel.text = serial
            }
            if let activationKey = devicesDetails?["ActivationKey"] as? String {
                cell.keyIdLabel.text = activationKey
            }
          
            if let deviceType = devicesDetails?["ModuleType_Id"] as? Int {
                if deviceType == 1 {
                    cell.modelLabel.text = "Flipr"
                }else{
                    cell.modelLabel.text = "Hub"
                }
            }
            return cell
        }
        
        else if indexPath.row == 1{
            if devicewifiTypeCell == DeviceWifiCellType.MeasureInfo{
                let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceWifiInfoTableViewCell",
                                                         for: indexPath) as! DeviceWifiInfoTableViewCell
                
                if let dateString = devicesDetails?["LastMeasureDateTime"] as? String {
                    if let lastDate = dateString.fliprDate {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEE. dd/MM"
                        cell.valueLabel.text = "\(dateFormatter.string(from: lastDate))"
//                        Module.currentModule?.rawlastMeasure = dateFormatter.string(from: lastDate)
                    }
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceWifiStatusTableViewCell",
                                                         for: indexPath) as! DeviceWifiStatusTableViewCell
                if let value = devicesDetails?["StateEquipment"] as? Bool {
                    cell.statusLabel.text = value ? "Connected" : "Not Connected"
                }
                if let value = devicesDetails?["Behavior"] as? String {
                    cell.modeLabel.text = value
                }
                return cell
            }
           
        }
        
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceActionTableViewCell",
                                                     for: indexPath) as! DeviceActionTableViewCell
            if devicewifiTypeCell == DeviceWifiCellType.MeasureInfo{
                cell.actionTitleLabel.text = "Perform Bluetooth check"
                
            }else{
                cell.actionTitleLabel.text = "WiFi settings"
            }
            return cell
        }
//        else if indexPath.row == 3{
//            let cell = tableView.dequeueReusableCell(withIdentifier:"NotificationCell",
//                                                     for: indexPath) as! NotificationSwitchTableViewCell
//            return cell
//        }
        
       
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"LogOutCell",
                                                     for: indexPath)
            return cell
        }
        
       
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
       
    }
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {

    }
    
    
}


//MARK: - Core bluetooth central manager delegate
extension DeviceViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn {
                print("Bluetooth powered on.")
                print("CBCentralManager start scanning for Flipr devices")
                self.centralManager.scanForPeripherals(withServices:[CBUUID(string: "E302"),CBUUID(string: "F906")], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
                //self.centralManager.scanForPeripherals(withServices:nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
            } else {
                print("Bluetooth not available.")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Flipr device discovered with name:\(peripheral.name) , identifier: \(peripheral.identifier)")
        central.stopScan()
        print("CBCentralManager stop scanning for Flipr devices")
            
        flipr = peripheral
        peripheral.delegate = self
        central.connect(flipr!, options: nil)
        print("Connecting...")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Central manager did connect to Flipr")
        peripheral.discoverServices([CBUUID(string: "E302"),CBUUID(string: "F906")])
        self.showError(title: "", message: "")
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Central manager did fail to connect to Flipr: \(error?.localizedDescription)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Central manager did disconnect from device with name: \(peripheral.name), error: \(error?.localizedDescription)")
    }
    
}

//MARK: - Core bluetooth peripheral delegate
extension DeviceViewController: CBPeripheralDelegate {

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
                peripheral.readValue(for: characteristic)
                i = i+1
            }
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("--- didUpdateValueForCharacteristic : \(characteristic)")
        
        if let value = characteristic.value {
            print("VALUE: \(String(data: value, encoding: .utf8))")
        }
        
    }
}
