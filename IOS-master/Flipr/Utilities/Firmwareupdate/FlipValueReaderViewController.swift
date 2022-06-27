//
//  FlipValueReaderViewController.swift
//  Flipr
//
//  Created by Ajeesh on 25/05/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class FlipValueReaderViewController: FirmwareBaseViewController {
    var hud = JGProgressHUD(style:.dark)
    var measuresTimer : Timer?
    var isViewNotDisappared = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navBarTitleLabel.text = "Upgrade Flipr"
//        fliprNameLabel.text = Module.currentModule?.serial
//
//        if let identifier = Module.currentModule?.serial {
//            fliprNameLabel.text = "Flipr " + identifier
//        }
//        doneButton.roundCorner(corner: 12)
//        relaunchButton.roundCorner(corner: 12)
//        let hud = JGProgressHUD(style:.dark)
        hud?.textLabel.text = "Flipr data fetching".localized
        hud?.show(in: self.view)
        self.measuresTimer = Timer.scheduledTimer(timeInterval: 30.0,
                                                  target: self,
                                                  selector: #selector(self.updateTime),
                                                  userInfo: nil,
                                                  repeats: false)

        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDidRead, object: nil, queue: nil) { (notification) in
            self.readingSuccess()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprNotDiscovered, object: nil, queue: nil) { (notification) in
//            self.showDeviceConnectionError()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.BluetoothNotAvailble, object: nil, queue: nil) { (notification) in
            self.showError()
        }
        
        BLEManager.shared.fliprReadingVerification = true
        BLEManager.shared.startUpCentralManager(connectAutomatically: true, sendMeasure: true)

       // startReading()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.isViewNotDisappared = false
    }
    
    
    func startReading(){
        BLEManager.shared.startMeasure { (error) in
            
            BLEManager.shared.doAcq = false
            
            if error != nil {
                
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                
            } else {
                
                print("Reading successfull")
            }
            
        }

    }
    
    @objc func updateTime() {
        measuresTimer?.invalidate()
        BLEManager.shared.stopScanning = true
        self.showDeviceConnectionError()
        let faileVc = self.storyboard?.instantiateViewController(withIdentifier: "FirmwareUpgradeFailureViewController") as! FirmwareUpgradeFailureViewController
        self.navigationController?.pushViewController(faileVc, completion: nil)
    }

    
    func readingSuccess(){
        NotificationCenter.default.removeObserver(self)
//        self.mesureCompleteLabel.isHidden = false
//        readingfSuccessStackView.isHidden = false
        //        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
        if self.isViewNotDisappared {
            self.isViewNotDisappared = false
            measuresTimer?.invalidate()
            BLEManager.shared.stopScanning = true
            NotificationCenter.default.post(name: K.Notifications.CompletedFirmwereUpgrade, object: nil)

    //        hud?.textLabel.text = "Success"
            hud?.dismiss(afterDelay: 0)
            scheduleNotification()
            let successVC = self.storyboard?.instantiateViewController(withIdentifier: "FirmwareUpgradeSuccessViewController") as! FirmwareUpgradeSuccessViewController
            self.navigationController?.pushViewController(successVC, completion: nil)

        }
    }
    
    
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        
//        content.title = notificationType
        content.body = "Firmware has been updated successfully".localized
        content.sound = UNNotificationSound.default
    //    content.badge = 1
//        content.categoryIdentifier = userActions
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
//        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
//        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
//        let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
//        notificationCenter.setNotificationCategories([category])
    }
    
    func showError(){
        hud?.textLabel.text = "Bluetooth connection error".localized
        hud?.dismiss(afterDelay: 5)
    }
    
    func showDeviceConnectionError(){
        hud?.textLabel.text = "Connection error".localized
        hud?.dismiss(afterDelay: 5)
    }
   
    
    @IBAction func doneButtonClicked() {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func relaunchButtonClicked() {
        self.dismiss(animated: false, completion: nil)
    }
}
