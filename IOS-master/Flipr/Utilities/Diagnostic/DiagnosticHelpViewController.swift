//
//  DiagnosticHelpViewController.swift
//  Flipr
//
//  Created by Ajeesh on 24/05/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class DiagnosticHelpViewController: FirmwareBaseViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var relaunchButton: UIButton!
    @IBOutlet weak var connectionStackView: UIStackView!
    @IBOutlet weak var readingfSuccessStackView: UIStackView!

    @IBOutlet weak var bleLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var mesureCompleteLabel: UILabel!
    @IBOutlet weak var fliprNameLabel: UILabel!
    
    @IBOutlet weak var batteryHelpLabel: UILabel!
    @IBOutlet weak var upgradeLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitleLabel.text =  "Diagnostic".localized
        self.batteryHelpLabel.text = "Commander une batterie".localized
        self.upgradeLabel.text = "Flipr Firmware Update".localized
        self.navigationItem.hidesBackButton = true
        doneButton.setTitle("Close".localized, for: .normal)
        relaunchButton.setTitle("Relaunch".localized, for: .normal)
        bleLabel.text = "bleConnected".localized
        measureLabel.text = "mesureComplete".localized
        mesureCompleteLabel.text = "deviceNotConnecting".localized

        doneButton.roundCorner(corner: 12)
        relaunchButton.roundCorner(corner: 12)
        if let identifier = Module.currentModule?.serial {
            fliprNameLabel.text = "Flipr " + identifier
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func doneButtonClicked() {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func relaunchButtonClicked() {
        self.navigationController?.popToRootViewController(animated: false)
    }
   

    @IBAction func helpButtonClicked() {
        if let url = URL(string:"https://goflipr.com/produit/batterie-flipr/".remotable) {
                           UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                       }
    }

    @IBAction func upgradeButtonClicked() {
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: K.Notifications.showFirmwereUpgradeScreen, object: nil)
    }
    
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
       return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
   }

}
