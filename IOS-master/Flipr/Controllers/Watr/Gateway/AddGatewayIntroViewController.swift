//
//  AddGatewayIntroViewController.swift
//  Flipr
//
//  Created by Ajeesh on 05/04/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class AddGatewayIntroViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        submitButton.setTitle("Poursuivre".localized(), for: .normal)
//        titleLabel.text = "Flipr Start Connecté".localized

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonClicked() {
        if let vc = UIStoryboard(name: "Gateway", bundle: nil).instantiateViewController(withIdentifier: "GateWayListingViewController") as? GateWayListingViewController{
            self.navigationController?.pushViewController(vc)
        }
        
    }
    
    @IBAction func skipButtonClicked() {
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewControllerFromFlipr") as! PoolSettingsStartViewController
        vc.isAddingNewDevice = true
        self.navigationController?.pushViewController(vc, animated: true)

    }


}
