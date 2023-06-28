//
//  FliprActivationSuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 25/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class FliprActivationSuccessViewController: BaseViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var serialKey: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitle("Poursuivre".localized(), for: .normal)
        titleLabel.text = "Flipr Start Connecté".localized

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextButtonClicked() {
        var isFlipr3 = false
        if serialKey != nil && serialKey.count > 0{
            if serialKey.hasPrefix("F"){
                isFlipr3 = true
                AppSharedData.sharedInstance.isFlipr3 = true
            }else{
                AppSharedData.sharedInstance.isFlipr3 = false
            }
        }

        AppSharedData.sharedInstance.deviceSerialNo = serialKey
        
        
//        if isFlipr3 == false{
            if AppSharedData.sharedInstance.isAddingDeviceFromPresentedVCFlow{
                let sb = UIStoryboard(name: "Calibration", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewControllerFromFlipr") as! PoolSettingsStartViewController
                vc.isAddingNewDevice = true
                self.navigationController?.pushViewController(vc, animated: true)
                //            self.dismiss(animated: true, completion: nil)
            }else{
                let sb = UIStoryboard(name: "Calibration", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewControllerFromFlipr") as! PoolSettingsStartViewController
                vc.isAddingNewDevice = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
//        }
//        else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddGatewayIntroViewController") as! AddGatewayIntroViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
        
       
        
    }

    
    func showStripView(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripViewControllerID") as! StripViewController
//        vc.recalibration = self.recalibration
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
