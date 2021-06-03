//
//  HUBPairingSuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class HUBPairingSuccessViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var addAnotherButton: UIButton!
    @IBOutlet weak var configurationButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        addAnotherButton.layer.cornerRadius = 12
        configurationButton.layer.cornerRadius = 12
        
        if scrollView.contentSize.height < scrollView.frame.height {
           scrollView.isScrollEnabled = false;
        } else {
            scrollView.isScrollEnabled = true;
        }
    }
    
    @IBAction func addAnotherDevice(_ sender: UIButton) {
        let sb = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ElectricalSetupViewController") as! ElectricalSetupViewController
        self.navigationController?.pushViewController(vc)
    }
    
    @IBAction func configurationButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "HUBOnboarding", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HUBOnboardingViewController") as! HUBOnboardingViewController
        navigationController?.pushViewController(vc)
    }
}
