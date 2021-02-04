//
//  CalibrationViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 21/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import AVKit

enum CalibrationType: String {
    case ph7 = "ph7"
    case ph4 = "ph4"
    case simpleMeasure = "simpleMeasure"
}

class CalibrationViewController: UIViewController {
    
    let measuresInterval:Double = 150
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var helpImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var initializeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var recalibration = false
    
    var calibrationType:CalibrationType = .ph7
    var measuresTimer : Timer?
    
    var dismissEnabled = false
    
    var isFlipr2 = false
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            backButton.isHidden = false
            titleLabel.text = "New measurement".localized.uppercased()
            
            videoButton.isHidden = true
            headerLabel.text = "\n\n\n\n\n\n\n".localized.uppercased()
            footerLabel.text = "Move closer to your Flipr and press the button to initialize the measurement".localized
                
            helpImageView.image = UIImage(named: "mesure")
            
            //InititateButtonAction(self)
        } else {
            
            titleLabel.text = "CALIBRATION ".localized + calibrationType.rawValue.uppercased()
            
            
            if isFlipr2 {
                videoButton.isHidden = false
                if calibrationType == .ph7 {
                    headerLabel.text = "CALIBRATION_BLUE".localized
                    footerLabel.text = ""
                } else {
                    
                    headerLabel.text = "CALIBRATION_RED".localized
                    footerLabel.text = ""
                }
                helpImageView.image = UIImage(named: calibrationType.rawValue)
            } else {
                videoButton.isHidden = true
                if calibrationType == .ph7 {
                    headerLabel.text = "Pour the contents of the blue bottle into the slot with the marker \"1\"".localized
                    footerLabel.text = "Place Flipr in slot \"1\" and start the initialization".localized
                } else {
                    headerLabel.text = "Pour the contents of the red bottle into the slot with the marker \"2\"".localized
                    footerLabel.text = "Place Flipr in slot \"2\" and start the initialization".localized
                }
                helpImageView.image = UIImage(named: calibrationType.rawValue)
            }
            
            initializeButton.setTitle("Initialize".localized, for: .normal)
            
            
        }
        
        progressView.isHidden = true
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        //TODO : test si mesure en cour pour mettre pop-up avertissement.
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func InititateButtonAction(_ sender: Any) {
        
        backButton.isEnabled = false
        
        let theme = EmptyStateViewTheme.shared
        theme.titleColor = .white
        theme.activityIndicatorType = .ballZigZag
        
        if calibrationType == .simpleMeasure {
            self.view.showEmptyStateViewLoading(title: "New measurement".localized.uppercased(), message: "Connecting to flipr...".localized, theme: theme)
        } else {
            self.view.showEmptyStateViewLoading(title: "CALIBRATION ".localized + calibrationType.rawValue.uppercased(), message: "Connecting to flipr...".localized, theme: theme)
        }
        
        stackView.alpha = 0
        
        self.perform(#selector(self.checkForDeviceSearchingTimeOut), with: nil, afterDelay: 20)
        self.perform(#selector(self.checkForDeviceConnectingTimeOut), with: nil, afterDelay: 60)
        
        BLEManager.shared.startMeasure { (error) in
            
            BLEManager.shared.doAcq = false
            
            if error != nil {
                self.stackView.alpha = 1
                self.view.hideStateView()
                
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                
                self.view.hideStateView()
                self.stackView.alpha = 1
                self.progressView.isHidden = true
            } else {
                
                UIApplication.shared.isIdleTimerDisabled = true
                
                //timer 2 min et à la fin lire la measure.
                UserDefaults.standard.set(Date()?.addingTimeInterval(self.measuresInterval), forKey: self.calibrationType.rawValue + "CalibrationEndingDate")
                
                let theme = EmptyStateViewTheme.shared
                theme.activityIndicatorType = .ballGridPulse
                
                if self.calibrationType == .simpleMeasure {
                    self.view.showEmptyStateViewLoading(title: "New measurement".localized.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
                } else {
                    self.view.showEmptyStateViewLoading(title: "CALIBRATION ".localized + self.calibrationType.rawValue.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
                }
               
                
                self.progressView.isHidden = false
                self.progressView.setProgress(0, animated: false)
                
                self.measuresTimer = Timer.scheduledTimer(timeInterval: 0.05,
                                                          target: self,
                                                          selector: #selector(self.updateTime),
                                                          userInfo: nil,
                                                          repeats: true)
            }
            
            self.backButton.isEnabled = true
        }
    }
    
    @objc func checkForDeviceSearchingTimeOut() {
        print("checkForDeviceSearchingTimeOut(), BLEManager.shared.centralManager.isScanning = \(BLEManager.shared.centralManager.isScanning)")
        if BLEManager.shared.centralManager.isScanning {
            BLEManager.shared.centralManager.stopScan()
            self.showError(title: "Could not connect".localized, message: "No flipr was detected".localized)
            self.stackView.alpha = 1
            self.view.hideStateView()
            self.view.hideStateView()
            self.stackView.alpha = 1
            self.progressView.isHidden = true
            self.backButton.isEnabled = true
        }
    }
    
    @objc func checkForDeviceConnectingTimeOut() {
        print("checkForDeviceConnectingTimeOut() - BLEManager.shared.isConnecting = \(BLEManager.shared.isConnecting)")
        if BLEManager.shared.isConnecting == true {
            if let flipr = BLEManager.shared.flipr {
                BLEManager.shared.centralManager.cancelPeripheralConnection(flipr)
                self.showError(title: "Could not connect".localized, message: "The app was unable to connect to the flipr (TimeOut issue).".localized)
                self.stackView.alpha = 1
                self.view.hideStateView()
                self.view.hideStateView()
                self.stackView.alpha = 1
                self.progressView.isHidden = true
                self.backButton.isEnabled = true
                
                BLEManager.shared.doAcqCompletionBlock = nil
                BLEManager.shared.calibrationMeasuresCompletionBlock = nil
            }
        }
    }
    
    @objc func updateTime() {
 
        if let date =  UserDefaults.standard.value(forKey: self.calibrationType.rawValue + "CalibrationEndingDate") as? Date {
            
            self.progressView.setProgress(Float((measuresInterval - date.timeIntervalSinceNow)/measuresInterval), animated: true)
            
            if date.timeIntervalSinceNow < 0 {
                
                UIApplication.shared.isIdleTimerDisabled = false
                
                measuresTimer?.invalidate()
                
                stackView.alpha = 0
                
                let theme = EmptyStateViewTheme.shared
                theme.activityIndicatorType = .ballZigZag
                
                if calibrationType == .simpleMeasure {
                    self.view.showEmptyStateViewLoading(title:"New measurement".localized.uppercased(), message: "Connecting to flipr...".localized, theme: theme)
                } else {
                    self.view.showEmptyStateViewLoading(title: "CALIBRATION ".localized + calibrationType.rawValue.uppercased(), message: "Connecting to flipr...".localized, theme: theme)
                }
                
                
                BLEManager.shared.sendCalibrationMeasure(type: calibrationType, completion: { (error) in
                    
                    BLEManager.shared.calibrationMeasures = false
                    
                    if error != nil {
                        
                        self.stackView.alpha = 1
                        self.view.hideStateView()
                        
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                        
                        self.view.hideStateView()
                        self.stackView.alpha = 1
                        self.progressView.isHidden = true
                        
                    } else {
                        if self.calibrationType == .simpleMeasure {
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        } else {
                            if self.calibrationType == .ph7 {
                                Module.currentModule?.pH7CalibrationDone = true
                                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                                    viewController.calibrationType = .ph4
                                    viewController.recalibration = self.recalibration
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                            } else {
                                Module.currentModule?.pH4CalibrationDone = true
                                
                                if self.recalibration {
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StripViewControllerID") {
                                        self.navigationController?.pushViewController(viewController, animated: true)
                                    }
                                }
                                
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        if recalibration || calibrationType == .simpleMeasure {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            if dismissEnabled {
                self.dismiss(animated: true, completion: nil)
            } else {
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
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playVideoButtonAction(_ sender: Any) {
        if let videoURL = URL(string: "http://videoapp.goflipr.com/democalib.mp4".localized.remotable("CALIBRATION_VIDEO_URL")) {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.navigationController?.present(playerViewController, animated: true, completion: nil)
            playerViewController.player!.play()
        }
        
    }
    
    
}
