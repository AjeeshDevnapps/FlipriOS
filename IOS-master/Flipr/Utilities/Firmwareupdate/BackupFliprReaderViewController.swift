//
//  BackupFliprReaderViewController.swift
//  Flipr
//
//  Created by Ajeesh on 15/06/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class BackupFliprReaderViewController: FirmwareBaseViewController {
    var hud = JGProgressHUD(style:.dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navBarTitleLabel.text = "Upgrade Flipr"
        hud?.show(in: self.view)
        startReading()

    }
    
    func startReading(){
        BLEManager.shared.fliprReadingVerification = true
        BLEManager.shared.startMeasure { [self] (error) in
            BLEManager.shared.doAcq = false
            self.hud?.dismiss(afterDelay: 0)
            if error != nil {
//                self.showError(title: "Error".localized, message: error?.localizedDescription)
                
            } else {
                self.showUpgradeScreen()
                print("Reading successfull")
            }
        }
    }
    
    
    func showUpgradeScreen(){
//        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController

        let sb = UIStoryboard.init(name: "Firmware", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "FirmwareHomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(viewController, completion: nil)
        }
    }
    
}


