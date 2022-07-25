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

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitle("Poursuivre".localized(), for: .normal)
        titleLabel.text = "Flipr Start Connecté".localized

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextButtonClicked() {
        
        if AppSharedData.sharedInstance.isAddingDeviceFromPresentedVCFlow{
            let sb = UIStoryboard(name: "Calibration", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewControllerFromFlipr") as! PoolSettingsStartViewController
            self.navigationController?.pushViewController(vc, animated: true)
            //            self.dismiss(animated: true, completion: nil)
        }else{
            let sb = UIStoryboard(name: "Calibration", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewControllerFromFlipr") as! PoolSettingsStartViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }


}
