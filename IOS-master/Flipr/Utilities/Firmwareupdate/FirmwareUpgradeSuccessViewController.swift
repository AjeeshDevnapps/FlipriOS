//
//  FirmwareUpgradeSuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh on 27/04/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

@objc public class FirmwareUpgradeSuccessViewController: FirmwareBaseViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descLabel: UILabel!

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitleLabel.text = "Upgrade Flipr"
        descLabel.text = "Successful update".localized

        doneButton.setTitle("Close".localized, for: .normal)

        
        self.navigationItem.hidesBackButton = true
        doneButton.roundCorner(corner: 12)
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doneButtonClicked() {
        AppSharedData.sharedInstance.isShowingFirmwereUpdateScreen = false
        self.dismiss(animated: false, completion: nil)
    }
   

}
