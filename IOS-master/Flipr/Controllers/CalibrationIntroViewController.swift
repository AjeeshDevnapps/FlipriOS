//
//  CalibrationIntroViewController.swift
//  Flipr
//
//  Created by Ajish on 15/08/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import SafariServices

class CalibrationIntroViewController: BaseViewController {

    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var buyStripTitleLbl: UILabel!

    var isPresentedFlow = false
    var recalibration = false
    var noStripTest = false
    var isAddingNewDevice = false

    override func viewDidLoad() {
        self.isPresentingView = self.isPresentingView
        super.viewDidLoad()
        self.title = "Calibration".localized
        nextButton.setTitle("Next".localized(), for: .normal)
        let trnText = "4930:64298".localized

        subTitleLbl.text = trnText

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButtonAction(){
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationPh7IntroViewController") as! CalibrationPh7IntroViewController
        vc.isPresentedFlow = self.isPresentedFlow
        vc.recalibration =  self.recalibration
        vc.noStripTest =   self.noStripTest
        vc.isAddingNewDevice =   self.isAddingNewDevice

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func buyStripTextButtonAction(){
        if let url = URL(string: "https://goflipr.com/produit/kit-de-calibration/") {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
    }

}
