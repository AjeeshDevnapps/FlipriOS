//
//  BluetoothAlertViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 22/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothAlertViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tapView: UIView!
    var centralManager:CBCentralManager!
    var flipr:CBPeripheral?
    var isShowingActivityInticator = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.showConnectionCheckingIndicator()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        // Do any additional setup after loading the view.
    }
    
    
    func setupViews(){
        containerView.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: false, completion: nil)
    }
    
    func showConnectionCheckingIndicator(){
        perform(#selector(stopSearching), with: nil, afterDelay: 50)
        self.activityIndicator.isHidden = false
        self.messageLabel.text  = "Performing connection, please do not close app or lock your phone."
        self.startActivityIndicator()
    }
    
    
    func showSuccess(){
        stopActivityIndicator()
        self.activityIndicator.isHidden = true
        self.statusImageView.isHidden = false
        self.statusImageView.image = #imageLiteral(resourceName: "check")
        self.messageLabel.text  = "Device successfully connected via bluetooth."
    }
    
    func showFailure(){
        stopActivityIndicator()
        self.activityIndicator.isHidden = true
        self.statusImageView.isHidden = false
        self.statusImageView.image = #imageLiteral(resourceName: "cross")
        self.messageLabel.text  = "Failed to connect to device via Bluetooth, please check connection."
    }
    
    func startActivityIndicator(){
        self.isShowingActivityInticator = true
        self.activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        self.isShowingActivityInticator = false
        self.activityIndicator.stopAnimating()
    }
    
    @objc func stopSearching(){
        if self.isShowingActivityInticator{
            self.centralManager.stopScan()
            self.showFailure()
        }
    }
}




//MARK: - Core bluetooth central manager delegate
extension BluetoothAlertViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn {
                print("Bluetooth powered on.")
                print("CBCentralManager start scanning for Flipr devices")
                self.centralManager.scanForPeripherals(withServices:[CBUUID(string: "E302"),CBUUID(string: "F906")], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
                //self.centralManager.scanForPeripherals(withServices:nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
            } else {
                print("Bluetooth not available.")
                self.showFailure()
                self.messageLabel.text  = "Bluetooth not connected."
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
        self.showSuccess()
        peripheral.discoverServices([CBUUID(string: "E302"),CBUUID(string: "F906")])
        self.showError(title: "", message: "")
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.showFailure()
        print("Central manager did fail to connect to Flipr: \(error?.localizedDescription)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.showFailure()
        print("Central manager did disconnect from device with name: \(peripheral.name), error: \(error?.localizedDescription)")
    }
    
}

//MARK: - Core bluetooth peripheral delegate
extension BluetoothAlertViewController: CBPeripheralDelegate {
    
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

