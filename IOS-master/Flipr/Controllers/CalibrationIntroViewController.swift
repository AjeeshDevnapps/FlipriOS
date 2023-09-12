//
//  CalibrationIntroViewController.swift
//  Flipr
//
//  Created by Ajish on 15/08/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class CalibrationIntroViewController: BaseViewController {

    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var isPresentedFlow = false
    var recalibration = false
    var noStripTest = false
    var isAddingNewDevice = false

    override func viewDidLoad() {
        self.isPresentingView = self.isPresentingView
        super.viewDidLoad()
        self.title = "Calibration".localized
        nextButton.setTitle("Next".localized(), for: .normal)
        let trnText = "CalibrationIntro".localized
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
    
   

}
