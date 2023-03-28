//
//  Ph7CalibrationViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class Ph7CalibrationViewController: BaseViewController {
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var successLbl: UILabel!

    let measuresInterval:Double = 150
    var recalibration = false
    var calibrationType:CalibrationType = .ph7
    var measuresTimer : Timer?
    var dismissEnabled = false
    var isFlipr2 = false
    var isPresentedFlow: Bool = false
    var checkCalibrationStruckTimer : Timer?
    var isCalibrationStrucked = false
    var isAddingNewDevice = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text  = "Calibrage en cours".localized
        msgLbl.text  = "Cette opération prend environs 2 minutes. Veuillez rester à proximité immédiate de votre téléphone et de l’appareil Flipr. Maintenez l’application ouverte et active.".localized
        successLbl.text  = "Calibration Ph7 réussie".localized

        self.calibrate()
        // Do any additional setup after loading the view.
    }
    
    
    override func backButtonTapped() {
        if dismissEnabled{
            self.dismiss(animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "LOGOUT_TITLE".localized, message: "Are you sure you want to log out?".localized, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
            
            let okAction = UIAlertAction(title: "Log out".localized, style: UIAlertAction.Style.destructive)
            {
                (result : UIAlertAction) -> Void in
                print("You pressed OK")
                
                if let manager = BLEManager.shared.centralManager {
                    manager.stopScan()
                }
                
                User.logout()
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    func calibrate(){
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballSpinFadeLoader
        theme.activityIndicatorColor = .black
        self.loaderView.showEmptyStateViewLoading(title: nil,
                                            message: nil,
                                            theme: theme)
        if let module = Module.currentModule {
            if module.isForSpa {
                //backgroundImageView.image = UIImage(named:"BG_spa")
            }
            if let version = module.version {
                if version > 1 {
                    isFlipr2 = true
                }
            }
        }
        
        if calibrationType == .simpleMeasure {
        
        }
        else {
            
        }
        self.perform(#selector(self.checkForDeviceSearchingTimeOut), with: nil, afterDelay: 20)
//        self.perform(#selector(self.checkForDeviceConnectingTimeOut), with: nil, afterDelay: 60)
        isCalibrationStrucked = true
        self.checkCalibrationStruckTimer = Timer.scheduledTimer(timeInterval: 180,
                                                  target: self,
                                                  selector: #selector(self.checkForAppStrucked),
                                                  userInfo: nil,
                                                  repeats: true)

        if self.isAddingNewDevice{
            AppSharedData.sharedInstance.isFirstCalibrations = true
        }else{
            AppSharedData.sharedInstance.isFirstCalibrations = false
        }

        BLEManager.shared.startMeasure { (error) in
            
            BLEManager.shared.doAcq = false
            
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            } else {
                
                UIApplication.shared.isIdleTimerDisabled = true
                
                //timer 2 min et à la fin lire la measure.
                UserDefaults.standard.set(Date()?.addingTimeInterval(self.measuresInterval), forKey: self.calibrationType.rawValue + "CalibrationEndingDate")
                
                let theme = EmptyStateViewTheme.shared
                theme.activityIndicatorType = .ballGridPulse
                
                if self.calibrationType == .simpleMeasure {
//                    self.view.showEmptyStateViewLoading(title: "New measurement".localized.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
                } else {
//                    self.view.showEmptyStateViewLoading(title: "CALIBRATION ".localized + self.calibrationType.rawValue.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
                }
               
                
                
                self.measuresTimer = Timer.scheduledTimer(timeInterval: 0.05,
                                                          target: self,
                                                          selector: #selector(self.updateTime),
                                                          userInfo: nil,
                                                          repeats: true)
            }
            
        }

    }
    
    @objc func checkForAppStrucked() {
    
        if self.isCalibrationStrucked{
            self.invalidateStruckChecktimer()
            if self.isAddingNewDevice{
                AppSharedData.sharedInstance.isFirstCalibrations = false
            }else{
                AppSharedData.sharedInstance.isFirstCalibrations = false
            }

            self.showChlorineFlow()
        }
    }
    
    @objc func checkForDeviceSearchingTimeOut() {
        print("checkForDeviceSearchingTimeOut(), BLEManager.shared.centralManager.isScanning = \(BLEManager.shared.centralManager.isScanning)")
        if BLEManager.shared.centralManager.isScanning {
            BLEManager.shared.centralManager.stopScan()
            self.showError(title: "Could not connect".localized, message: "No flipr was detected".localized)
//            self.view.hideStateView()
//            self.view.hideStateView()
        }
    }
    
    @objc func checkForDeviceConnectingTimeOut() {
        print("checkForDeviceConnectingTimeOut() - BLEManager.shared.isConnecting = \(BLEManager.shared.isConnecting)")
        if BLEManager.shared.isConnecting == true {
            if let flipr = BLEManager.shared.flipr {
                BLEManager.shared.centralManager.cancelPeripheralConnection(flipr)
                self.showError(title: "Could not connect".localized, message: "The app was unable to connect to the flipr (TimeOut issue).".localized)
                self.view.hideStateView()
                self.view.hideStateView()
                BLEManager.shared.doAcqCompletionBlock = nil
                BLEManager.shared.calibrationMeasuresCompletionBlock = nil
            }
        }
    }
    
    @objc func updateTime() {
 
        if let date =  UserDefaults.standard.value(forKey: self.calibrationType.rawValue + "CalibrationEndingDate") as? Date {
            
         
            
            if date.timeIntervalSinceNow < 0 {
                
                UIApplication.shared.isIdleTimerDisabled = false
                
                measuresTimer?.invalidate()
                
                
                let theme = EmptyStateViewTheme.shared
                theme.activityIndicatorType = .ballZigZag
                
                if calibrationType == .simpleMeasure {
                    self.view.showEmptyStateViewLoading(title:"New measurement".localized.uppercased(), message: "Connecting to flipr...".localized, theme: theme)
                } else {
                    self.view.showEmptyStateViewLoading(title: "CALIBRATION ".localized + calibrationType.rawValue.uppercased(), message: "Connecting to flipr...".localized, theme: theme)
                }
                
               
                BLEManager.shared.sendCalibrationMeasure(type: calibrationType, completion: { (error) in
                    
                    BLEManager.shared.calibrationMeasures = false
                    if self.isAddingNewDevice{
                        AppSharedData.sharedInstance.isFirstCalibrations = false
                    }else{
                        AppSharedData.sharedInstance.isFirstCalibrations = false
                    }

                    if error != nil {
                        
//                        self.view.hideStateView()
                        
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                        
                        self.view.hideStateView()
                        
                    } else {
                        if self.calibrationType == .simpleMeasure {
                            self.dismiss(animated: true, completion: nil)
//                            self.navigationController?.dismiss(animated: true, completion: nil)
                        } else {
                            if self.calibrationType == .ph7 {
                                Module.currentModule?.pH7CalibrationDone = true
                                self.loaderView.hideStateView()
                                self.invalidateStruckChecktimer()
                                self.showChlorineFlow()
//                                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
//                                    viewController.calibrationType = .ph4
//                                    viewController.recalibration = self.recalibration
//                                    self.navigationController?.pushViewController(viewController, animated: true)
//                                }
                            } else {
//                                Module.currentModule?.pH4CalibrationDone = true
//
//                                if self.recalibration {
//                                    self.dismiss(animated: true, completion: nil)
//                                } else {
//                                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StripViewControllerID") {
//                                        self.navigationController?.pushViewController(viewController, animated: true)
//                                    }
//                                }
                                
                            }
                            Module.saveCurrentModuleLocally()
                        }
                        
                       
                    }
                })
            } else {
                //print("date.timeIntervalSinceNow \(format(date.timeIntervalSinceNow))")
            }
        }
    }
    
    func format(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        if duration >= 3600 {
            formatter.allowedUnits.insert(.hour)
        }
        
        return formatter.string(from: duration)!
    }
    
    func invalidateStruckChecktimer(){
        self.isCalibrationStrucked = false
        self.checkCalibrationStruckTimer?.invalidate()
    }
    
    
    func showChlorineFlow(){
        self.successView.isHidden = false
        self.view.bringSubviewToFront( self.successView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationChlorineIntroViewController") as! CalibrationChlorineIntroViewController
            vc.recalibration = self.recalibration
            if self.isAddingNewDevice{
                vc.isAddingNewDevice =  self.isAddingNewDevice
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
