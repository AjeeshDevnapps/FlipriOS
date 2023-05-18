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
    @IBOutlet weak var skipButton: UIButton!

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.setTitle("Skip".localized(), for: .normal)
        submitButton.setTitle("Ajouter une passerelle".localized(), for: .normal)
        titleLabel.text = "Si vous disposez d’une Passerelle (Gateway), nous vous recommandons de la configurer dès maintenant. \n\nSi vous désirez effectuer cette installation plus tard, vous pourrez l’ajouter à partir du menu “Paramètres”.".localized

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonClicked() {
        if let vc = UIStoryboard(name: "Gateway", bundle: nil).instantiateViewController(withIdentifier: "GateWayListingViewController") as? GateWayListingViewController{
            self.navigationController?.pushViewController(vc)
        }
        
    }
    
    @IBAction func skipButtonClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: false)
        })

//        let sb = UIStoryboard(name: "Calibration", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewControllerFromFlipr") as! PoolSettingsStartViewController
//        vc.isAddingNewDevice = true
//        self.navigationController?.pushViewController(vc, animated: true)

    }


}
