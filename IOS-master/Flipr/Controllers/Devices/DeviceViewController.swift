//
//  DeviceViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 19/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth
import JGProgressHUD
import Alamofire

enum DeviceWifiCellType {
    case Flipr
    case Hub
}

class DeviceViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    
    var devicewifiTypeCell = DeviceWifiCellType.Flipr
    var devicesDetails:  [String:Any]?
    var centralManager:CBCentralManager!
    var flipr:CBPeripheral?
    var hubName = ""
    var hubState = 0
    var hubBehavior = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.devicewifiTypeCell == .Hub{
            if AppSharedData.sharedInstance.isNeedtoCallHubDetailsApi{
                self.getHubDetails()
            }
        }
    }
    
    
    func getHubDetails(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        Pool.currentPool?.getHUBS(completion: { (hubs, error) in
            if error != nil {
                //                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                //                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss()
            } else if hubs != nil {
                AppSharedData.sharedInstance.isNeedtoCallHubDetailsApi = false
                if hubs!.count > 0 {
                    //                    self.hubs = hubs!
                    for hubObj in hubs! {
                        if let hubDetails = hubObj.response{
                            self.hubDetails(data: hubDetails)
                        }
                    }
                }
                hud?.dismiss()
            }
        })
    }
    
    func hubDetails(data:[String:Any]){
        if let value = data["NameEquipment"] as? String  {
            self.hubName = value
        }
        if let value = data["Behavior"] as? String  {
            self.hubBehavior = value
        }
        if let value = data["StateEquipment"] as? Int  {
            self.hubState = value
        }
        //        self.settingTable.reloadData()
        let indexPathRow:Int = 1
        let indexPosition = IndexPath(row: indexPathRow, section: 0)
        let indexPositionStatus = IndexPath(row: 2, section: 0)
        settingTable.reloadRows(at: [indexPosition,indexPositionStatus], with: .none)
        
        
    }
    
    func startBluetoothCheck(){
        //        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BluetoothAlertViewController") as? BluetoothAlertViewController {
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func wifiSettingsButtonClicked(){
        
        if devicewifiTypeCell == DeviceWifiCellType.Flipr{
            self.checkBluetoothConnection()
        }else{
            //            self.showWifiSettings()
            self.checkBluetoothConnection()
        }
        
    }
    
    
    @IBAction func changeDeviceName(){
        
        var nameTextField: UITextField?
        
        let alertController = UIAlertController(title: "Rename".localized, message: "Enter the new name".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Save".localized, style: .default, handler: { (action) -> Void in
            print("Send Button Pressed, email : \(nameTextField?.text)")
            guard let newName = nameTextField!.text, !newName.isEmpty else{
                self.showError(title: "Error".localized, message: "Please enter valid name")
                return
            }
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            HUB.currentHUB!.updateEquipmentName(value: nameTextField!.text!, completion: { (error) in
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    //                    AppSharedData.sharedInstance.isNeedtoCallHubDetailsApi = false
                    HUB.currentHUB!.equipementName = nameTextField!.text!
                    self.hubName = nameTextField!.text!
                    //                        self.hubButton.setTitle(nameTextField!.text!, for: .normal)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 0)
                    self.settingTable.reloadData()
                }
            })
            
        })
        
        //sendAction.isEnabled = (loginTextField?.text?.isEmail)!
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            nameTextField = textField
            //                nameTextField?.text =  self.hubName
            nameTextField?.placeholder = "Name...".localized
        }
        present(alertController, animated: true, completion: nil)
        /*
         let alert = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
         alert.addTextField { (textField) in
         if let name = self.devicesDetails?["NickName"] as? String  {
         textField.placeholder  = name
         }
         }
         let submitAction = UIAlertAction(title: "Update", style: .default) { [unowned alert] _ in
         let newName = alert.textFields![0]
         if newName.isEmpty{
         self.showError(title: "Error".localized, message: "Please enter valid name")
         }
         }
         let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.default)
         alert.addAction(cancelAction)
         alert.addAction(submitAction)
         present(alert, animated: true)
         */
    }
    
    func checkBluetoothConnection(){
        
        let alertController = UIAlertController(title: "Bluetooth check", message: "Please stand close to your device (max 1 meter) and tap Perform check.", preferredStyle: .alert)
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.default)
        
        let okAction = UIAlertAction(title: "Perform Check", style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            self.startBluetoothCheck()
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
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
        
        let alertController = UIAlertController(title: "Unbind Flipr", message: "Do you really want to unbind ? All measure and calibration data will be lost.", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.default)
        
        let okAction = UIAlertAction(title: "UNBIND", style: UIAlertAction.Style.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            self.forgetDevice()
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func forgetDevice(){
        let serial = devicesDetails?["Serial"] as? String
        let activationKey = devicesDetails?["ActivationKey"] as? String
        if serial == nil || activationKey == nil {
            return
        }
     
        Alamofire.request(Router.forgetModuleEquipment(serial: serial ?? "", code: "20")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                print("Delete HUB response.result.value: \(value)")
                self.navigationController?.popViewController()

            case .failure(let error):
                
                print("Delete HUB did fail with error: \(error)")
                
            }
            
        })
        
      /*
        Module.deactivate(serial:serial ?? "" , activationKey: activationKey ?? "", completion: { (error) in
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            } else {
                self.navigationController?.popViewController()
            }
            
            
        })
        
        */
    }
    
    
}

extension DeviceViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.devicewifiTypeCell == .Hub{
            return 4
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            if devicewifiTypeCell == DeviceWifiCellType.Flipr{
                return 155
            }else{
                return 135
            }
        }
        
        if indexPath.row == 1 {
            return 275
        }
        else if indexPath.row == 2 {
            return 66
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if devicewifiTypeCell == DeviceWifiCellType.Flipr{
                return tableView.dequeueReusableCell(withIdentifier:"FliprDevice",
                                                     for: indexPath)
            }else{
                return tableView.dequeueReusableCell(withIdentifier:"HubDevice",
                                                     for: indexPath)
            }
            
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceInfoTableViewCell",
                                                     for: indexPath) as! DeviceInfoTableViewCell
            if devicewifiTypeCell == DeviceWifiCellType.Flipr{
                cell.titleLabel.text = "Details".localized
                cell.editButton.isHidden = true
                cell.nameLabel.isHidden = true
            }
            else{
                cell.titleLabel.text = "Name"
                cell.nameLabel.text = self.hubName.capitalizingFirstLetter()
                //                UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: {
                cell.editButton.isHidden = false
                cell.nameLabel.isHidden = false
                //                }, completion: nil)
            }
            //            if let name = devicesDetails?["NickName"] as? String  {
            //                cell.nameLabel.text = name
            //            }
            
            if let serial = devicesDetails?["Serial"] as? String  {
                cell.serialLabel.text = serial
            }
            if let activationKey = devicesDetails?["ActivationKey"] as? String {
                cell.keyIdLabel.text = activationKey
            }
            
            if let deviceType = devicesDetails?["ModuleType_Id"] as? Int {
                if deviceType == 1 {
                    cell.modelLabel.text = "Flipr"
                    if let info = devicesDetails?["CommercialType"] as? [String: AnyObject] {
                        if let type = info["Value"] as? String  {
                            cell.modelLabel.text?.append(" ")
                            cell.modelLabel.text?.append(type)
                            if type == "Pro" {
                                cell.modelLabel.text = "Start MAX"
                            }else{
                                cell.modelLabel.text?.append(type)
                            }
                        }
                    }
                }else{
                    cell.modelLabel.text = "Hub"
                }
            }
            return cell
        }
        
        else if indexPath.row == 2{
            if devicewifiTypeCell == DeviceWifiCellType.Flipr{
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
                cell.statusLabel.text = self.hubState == 1 ? " Connected" : " Not Connected"
                cell.wifeView.backgroundColor = self.hubState == 1 ? UIColor.init(hexString: "#13C8A6") : UIColor.init(hexString: "#3DA0FF")
                cell.modeLabel.text = " " + self.hubBehavior.capitalizingFirstLetter()
                return cell
            }
            
        }
        
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceActionTableViewCell",
                                                     for: indexPath) as! DeviceActionTableViewCell
            if devicewifiTypeCell == DeviceWifiCellType.Flipr{
                cell.actionTitleLabel.text = "Perform Bluetooth check".localized
                
            }else{
                cell.actionTitleLabel.text = "WiFi settings".localized
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
