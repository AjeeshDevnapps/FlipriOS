//
//  NewMeasurementViewController.swift
//  Flipr
//
//  Created by Ajeesh on 09/06/23.
//  Copyright © 2023 I See U. All rights reserved.
//



import UIKit
import JGProgressHUD

class NewMeasurementViewController:BaseViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var relaunchButton: UIButton!

    @IBOutlet weak var bleLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var mesureCompleteLabel: UILabel!
    @IBOutlet weak var fliprNameLabel: UILabel!

    @IBOutlet weak var connectionStackView: UIStackView!
    @IBOutlet weak var readingfSuccessStackView: UIStackView!
    
    @IBOutlet weak var iconImageView: UIImageView!

    var errorAttempCount = 0
    
    var hud = JGProgressHUD(style:.dark)
    var measuresTimer : Timer?
    var isRemovedObserver = false

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "New Measurement".localized
//        self.navigationItem.hidesBackButton = true
//        relaunchButton.roundCorner(corner: 12)
//        let hud = JGProgressHUD(style:.dark)
        
//        relaunchButton.setTitle("Relaunch".localized, for: .normal)
        
        addCloseButton()
        hud?.textLabel.text = "Flipr data fetching".localized
        hud?.show(in: self.view)

//        bleLabel.text = "bleConnected".localized
        
//        measureLabel.text = "mesureComplete".localized
//        mesureCompleteLabel.text = "mesureCompleted100".localized
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprMeasures409Error, object: nil, queue: nil) { (notification) in
            NotificationCenter.default.removeObserver(self)
            BLEManager.shared.disConnectCurrentDevice()
            self.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprMeasuresPosted, object: nil, queue: nil) { (notification) in
            BLEManager.shared.disConnectCurrentDevice()
            self.readingSuccess()
        }
/*
        hud?.textLabel.text = "Flipr data fetching".localized
        hud?.show(in: self.view)
        addCloseButton()
        self.measuresTimer = Timer.scheduledTimer(timeInterval: 60,
                                                  target: self,
                                                  selector: #selector(self.updateTime),
                                                  userInfo: nil,
                                                  repeats: true)

        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDidRead, object: nil, queue: nil) { (notification) in
            BLEManager.shared.stopScanning = true
//            self.readingSuccess()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprMeasuresPosted, object: nil, queue: nil) { (notification) in
            self.readingSuccess()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprMeasures409Error, object: nil, queue: nil) { (notification) in
            self.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprNotDiscovered, object: nil, queue: nil) { (notification) in
//            self.showDeviceConnectionError()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.BluetoothNotAvailble, object: nil, queue: nil) { (notification) in
            self.showError()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.BluetoothOn, object: nil, queue: nil) { (notification) in
            self.relaunchButton.isUserInteractionEnabled = true;
        }
        BLEManager.shared.isHandling409 = true
        BLEManager.shared.startUpCentralManager(connectAutomatically: true, sendMeasure: true)
        
        */
//        startReading()

//        readLastMeasurement()
        newMeasurement()
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTime() {
        
        measuresTimer?.invalidate()
        BLEManager.shared.stopScanning = true
        self.showDeviceConnectionError()
//        let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosticHelpViewController") as! DiagnosticHelpViewController
//        self.navigationController?.pushViewController(helpVC, completion: nil)

    }
    
//    func addCloseButton(){
//        let backBTN = UIBarButtonItem(image: UIImage(named: "close_icon white"),
//                                      style: .plain,
//                                      target: self,
//                                      action:  #selector(self.closeView) )
//        navigationItem.rightBarButtonItem = backBTN
//        navigationItem.leftBarButtonItem = nil
//    }
    
    func addCloseButton(){
        let backBTN = UIBarButtonItem(image: UIImage(named: "close_icon white"),
                                      style: .plain,
                                      target: self,
                                      action:  #selector(self.closeView) )
        navigationItem.leftBarButtonItem = backBTN
    }

    
    func readLastMeasurement(){
        if let currentFlipr = BLEManager.shared.flipr{
            var name = currentFlipr.name ?? ""
            var occuranceString = "Flipr 00"

            if name.hasPrefix("Flipr 00") {
                occuranceString = "Flipr 00"
            }
            else if name.hasPrefix("Flipr 0"){
                occuranceString = "Flipr 0"
            }
            
            let serial = name.replacingOccurrences(of: occuranceString, with: "").trimmed
            
            if Module.currentModule?.serial == serial{
                BLEManager.shared.calibrationType = .simpleMeasure
                BLEManager.shared.calibrationMeasures = true
                BLEManager.shared.isHandling409 = true
                BLEManager.shared.activationNeeded = false
                BLEManager.shared.startMeasure { (error) in
                    BLEManager.shared.doAcq = false
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    }
                    else {
                    }
                }
            }else{
                connectCurrentModuleFlipr()
            }
        }else{
            print("No flipr in shared data")
            connectCurrentModuleFlipr()
        }
    }
    
    
    func newMeasurement(){
//        let theme = EmptyStateViewTheme.shared
//        theme.activityIndicatorType = .ballSpinFadeLoader
//        theme.activityIndicatorColor = .black
//        self.view.showEmptyStateViewLoading(title: nil,
//                                            message: nil,
//                                            theme: theme)
        NewMeasurementManager.shared.resetValues()
        NewMeasurementManager.shared.connectDevice{ (error) in
            
            
            if error != nil{
//                self.hud?.textLabel.text = ""
                self.hud?.dismiss(afterDelay: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    self.dismiss(animated: true)
                }
            }else{
                NotificationCenter.default.post(name: K.Notifications.FliprMeasuresPosted, object: nil)
                self.view.hideStateView()
                
//                self.readingSuccess()
            }
            self.dismiss(animated: true)
        }

    }
    
    
    @objc func dismissAfterDelay(){
        
    }
    
    func connectCurrentModuleFlipr(){
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprConnected, object: nil, queue: nil) { (notification) in
            NotificationCenter.default.removeObserver(self)
            if self.isRemovedObserver == false{
                self.startMeasureReading()
            }
            self.isRemovedObserver = true
            
        }
        BLEManager.shared.startUpCentralManager(connectAutomatically: true, sendMeasure: false)

    }
    
    
    func startMeasureReading(){
        BLEManager.shared.calibrationType = .simpleMeasure
        BLEManager.shared.calibrationMeasures = true
        BLEManager.shared.isHandling409 = true
        BLEManager.shared.activationNeeded = false

        BLEManager.shared.startMeasure { (error) in
            BLEManager.shared.doAcq = false
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            }
            else {
            }
        }
    }
    
    func startReading(){
        
        BLEManager.shared.calibrationType = .simpleMeasure
        BLEManager.shared.calibrationMeasures = true
        BLEManager.shared.isHandling409 = true
        BLEManager.shared.activationNeeded = false

        BLEManager.shared.startMeasure { (error) in
             
            BLEManager.shared.doAcq = false
            
            if error != nil {
              
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                
              
            } else {
//                self.readingSuccess()
//                self.showError(title: "Success", message: "Value read")
                
//                UIApplication.shared.isIdleTimerDisabled = true
                
//                //timer 2 min et à la fin lire la measure.
//                UserDefaults.standard.set(Date()?.addingTimeInterval(self.measuresInterval), forKey: self.calibrationType.rawValue + "CalibrationEndingDate")
//
//                let theme = EmptyStateViewTheme.shared
//                theme.activityIndicatorType = .ballGridPulse
//
//                if self.calibrationType == .simpleMeasure {
//                    self.view.showEmptyStateViewLoading(title: "New measurement".localized.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
//                } else {
//                    self.view.showEmptyStateViewLoading(title: "CALIBRATION ".localized + self.calibrationType.rawValue.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
//                }
//
//
//                self.progressView.isHidden = false
//                self.progressView.setProgress(0, animated: false)
//
//                self.measuresTimer = Timer.scheduledTimer(timeInterval: 0.05,
//                                                          target: self,
//                                                          selector: #selector(self.updateTime),
//                                                          userInfo: nil,
//                                                          repeats: true)
            }
            
        }

        
        
//        BLEManager.shared.startMeasure { (error) in
//
//            BLEManager.shared.doAcq = false
//
//            if error != nil {
//
//                self.showError(title: "Error".localized, message: error?.localizedDescription)
//
//            } else {
//
//                print("Reading successfull")
//            }
//
//        }

    }
    

    func readingSuccess(){
        NotificationCenter.default.removeObserver(self)
        measuresTimer?.invalidate()
        BLEManager.shared.stopScanning = true
//        self.relaunchButton.isHidden = true
//        self.mesureCompleteLabel.isHidden = false
//        readingfSuccessStackView.isHidden = false
//        self.iconImageView.image = UIImage(named: "readingSuccess")

        //        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
//        hud?.textLabel.text = "Success"
        hud?.dismiss(afterDelay: 0)
        self.dismiss(animated: true, completion: nil)

    }
    
    
    func showError(){
//        self.relaunchButton.isUserInteractionEnabled = false;
//        hud?.textLabel.text = "Bluetooth connection error".localized
//        hud?.dismiss(afterDelay: 2)

    }
    
    func showDeviceConnectionError(){
        hud?.textLabel.text = "Connection error".localized
        hud?.dismiss(afterDelay: 2)
    }
   
    
    @IBAction func doneButtonClicked() {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func relaunchButtonClicked() {
        newMeasurement()
//        errorAttempCount = errorAttempCount + 1
//        if errorAttempCount > 3{
//            let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosticHelpViewController") as! DiagnosticHelpViewController
//            self.navigationController?.pushViewController(helpVC, completion: nil)
//
//        }else{
        /*
            hud?.textLabel.text = "Flipr data fetching".localized
            hud?.show(in: self.view)
//            BLEManager.shared.fliprReadingVerification = true
            BLEManager.shared.startUpCentralManager(connectAutomatically: true, sendMeasure: false)
         */
//        }

    }
    
    @objc func closeView(){
        measuresTimer?.invalidate()
        BLEManager.shared.stopScanning = true
        self.dismiss(animated: false, completion: nil)
    }

}

