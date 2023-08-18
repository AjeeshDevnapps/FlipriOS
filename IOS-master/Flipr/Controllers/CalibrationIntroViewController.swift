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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calibration".localized
        nextButton.setTitle("Next".localized(), for: .normal)
        let trnText = "addV3Intro".localized
        subTitleLbl.text = trnText

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButtonAction(){
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationPh7IntroViewController") as! CalibrationPh7IntroViewController
        vc.isPresentedFlow = true
        vc.recalibration = true
        vc.noStripTest = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   

}
