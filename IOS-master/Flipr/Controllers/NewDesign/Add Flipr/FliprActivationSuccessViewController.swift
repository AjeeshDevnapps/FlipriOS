//
//  FliprActivationSuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 25/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class FliprActivationSuccessViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButtonClicked() {
        
        if AppSharedData.sharedInstance.isAddingDeviceFromPresentedVCFlow{
            let sb = UIStoryboard(name: "Calibration", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewControllerFromFlipr") as! PoolSettingsStartViewController
//            self.dismiss(animated: true, completion: nil)
        }else{
            
        }
       
    }


}
