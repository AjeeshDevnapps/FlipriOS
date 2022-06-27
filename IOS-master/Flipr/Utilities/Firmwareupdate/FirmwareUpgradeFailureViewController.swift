//
//  FirmwareUpgradeFailureViewController.swift
//  Flipr
//
//  Created by Ajeesh on 28/04/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit


@objc public class FirmwareUpgradeFailureViewController: FirmwareBaseViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descLabel: UILabel!

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitleLabel.text = "Upgrade Flipr"
        self.navigationItem.hidesBackButton = true
        doneButton.roundCorner(corner: 12)
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        descLabel.text = "Update Failed".localized
        doneButton.setTitle("Relaunch".localized, for: .normal)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doneButtonClicked() {
        AppSharedData.sharedInstance.isShowingFirmwereUpdateScreen = false
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: K.Notifications.FirmwereUpgradeError, object: nil)
    }
}

