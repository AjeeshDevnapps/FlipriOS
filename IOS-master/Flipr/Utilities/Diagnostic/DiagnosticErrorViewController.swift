//
//  DiagnosticErrorViewController.swift
//  Flipr
//
//  Created by Ajeesh on 24/05/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class DiagnosticErrorViewController: FirmwareBaseViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var relaunchButton: UIButton!

    @IBOutlet weak var bleLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var mesureCompleteLabel: UILabel!
    @IBOutlet weak var fliprNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!


    @IBOutlet weak var connectionStackView: UIStackView!
    @IBOutlet weak var readingfSuccessStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navBarTitleLabel.text =  "Diagnostic".localized
        self.navigationItem.hidesBackButton = true
        doneButton.setTitle("Close".localized, for: .normal)
        relaunchButton.setTitle("Relaunch".localized, for: .normal)
        descLabel.text = "DiagnosticError".localized
        doneButton.roundCorner(corner: 12)
        relaunchButton.roundCorner(corner: 12)

    }
    

    @IBAction func doneButtonClicked() {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func relaunchButtonClicked() {
        self.navigationController?.popViewController(animated: false, nil)
    }


}
