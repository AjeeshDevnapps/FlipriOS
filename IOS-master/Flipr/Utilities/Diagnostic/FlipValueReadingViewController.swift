//
//  FlipValueReadingViewController.swift
//  Flipr
//
//  Created by Ajeesh on 22/05/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

@objc public class FlipValueReadingViewController: FirmwareBaseViewController {
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

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitleLabel.text =  "Diagnostic".localized
        self.navigationItem.hidesBackButton = true
        fliprNameLabel.text = Module.currentModule?.serial
        
        if let identifier = Module.currentModule?.serial {
            fliprNameLabel.text = "Flipr " + identifier
        }
        doneButton.roundCorner(corner: 12)
        relaunchButton.roundCorner(corner: 12)
//        let hud = JGProgressHUD(style:.dark)
        
        doneButton.setTitle("Close".localized, for: .normal)
        relaunchButton.setTitle("Relaunch".localized, for: .normal)
        bleLabel.text = "bleConnected".localized
        
        measureLabel.text = "mesureComplete".localized
        mesureCompleteLabel.text = "mesureCompleted100".localized

        hud?.textLabel.text = "Flipr data fetching".localized
        hud?.show(in: self.view)
        
        self.measuresTimer = Timer.scheduledTimer(timeInterval: 30,
                                                  target: self,
                                                  selector: #selector(self.updateTime),
                                                  userInfo: nil,
                                                  repeats: true)

        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDidRead, object: nil, queue: nil) { (notification) in
            self.readingSuccess()
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
        
        
//        BLEManager.shared.fliprReadingVerification = true
        BLEManager.shared.startUpCentralManager(connectAutomatically: true, sendMeasure: true)

        // Do any additional setup after loading the view.
    }
    
    @objc func updateTime() {
        
        measuresTimer?.invalidate()
        BLEManager.shared.stopScanning = true
        self.showDeviceConnectionError()
        let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosticHelpViewController") as! DiagnosticHelpViewController
        self.navigationController?.pushViewController(helpVC, completion: nil)

    }


    func readingSuccess(){
        NotificationCenter.default.removeObserver(self)
        measuresTimer?.invalidate()
        BLEManager.shared.stopScanning = true
        self.relaunchButton.isHidden = true
        self.mesureCompleteLabel.isHidden = false
        readingfSuccessStackView.isHidden = false
        self.iconImageView.image = UIImage(named: "readingSuccess")

        //        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
        hud?.textLabel.text = "Success"
        hud?.dismiss(afterDelay: 0)

    }
    
    
    func showError(){
        self.relaunchButton.isUserInteractionEnabled = false;
        hud?.textLabel.text = "Bluetooth connection error".localized
        hud?.dismiss(afterDelay: 2)

    }
    
    func showDeviceConnectionError(){
        hud?.textLabel.text = "Connection error".localized
        hud?.dismiss(afterDelay: 2)
    }
   
    
    @IBAction func doneButtonClicked() {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func relaunchButtonClicked() {
        errorAttempCount = errorAttempCount + 1
        if errorAttempCount > 3{
            let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "DiagnosticHelpViewController") as! DiagnosticHelpViewController
            self.navigationController?.pushViewController(helpVC, completion: nil)

        }else{
            hud?.textLabel.text = "Flipr data fetching".localized
            hud?.show(in: self.view)
//            BLEManager.shared.fliprReadingVerification = true
            BLEManager.shared.startUpCentralManager(connectAutomatically: true, sendMeasure: false)
        }

    }

}
