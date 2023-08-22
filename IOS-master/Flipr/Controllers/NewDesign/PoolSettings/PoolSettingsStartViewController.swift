//
//  PoolSettingsStartViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 20/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class PoolSettings: Pool {
    static let shared = PoolSettings()
}

class PoolSettingsStartViewController: BaseViewController {
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var viewSubTitleLbl: UILabel!
    @IBOutlet weak var slLblFirst: UILabel!
    @IBOutlet weak var slLblSecond: UILabel!
    @IBOutlet weak var slLblThird: UILabel!
    @IBOutlet weak var titleFirst: UILabel!
    @IBOutlet weak var titleSecond: UILabel!
    @IBOutlet weak var titleThird: UILabel!
    @IBOutlet weak var subTitle1: UILabel!
    @IBOutlet weak var subTitle2: UILabel!

    @IBOutlet weak var subTitle3: UILabel!
    @IBOutlet weak var accessory1Btn: UIButton!
    @IBOutlet weak var accesory3Btn: UIButton!
    @IBOutlet weak var accesory2Btn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    var isCaliberated: Bool = true
    var isPoolConnected: Bool = true
    var isPoolDescribed: Bool = false
    var isPresentedFlow: Bool = false
    var recalibration = false
    
    var isAddingNewDevice = false


    
    override func viewDidLoad() {
        super.viewDidLoad()

        slLblFirst.roundCorner(corner: slLblFirst.width / 2)
        slLblSecond.roundCorner(corner: slLblSecond.width / 2)
        slLblThird.roundCorner(corner: slLblThird.width / 2)
        submitBtn.roundCorner(corner: 12)
        
        viewTitleLbl.text  = "Continuons le parametrage de votre Flipr Start".localized
        viewSubTitleLbl.text  = "Flipr à besoin d'être calibré et de connaître votre bassin pour fonctionner de façon optimale.".localized
        titleFirst.text = "Connectez votre piscine".localized
        titleSecond.text = "Calibration".localized
//        titleThird.text = "Describe your pool".localized
        
        subTitle1.text = ""
        subTitle2.text = "3 steps".localized
//        subTitle3.text = "3rd subtitle".localized
        
        accessory1Btn.setTitle("Effectué".localized, for: .normal)
        
        accessory1Btn.isHidden = !isPoolConnected
        accesory2Btn.setTitle("Effectué".localized, for: .normal)
        accesory2Btn.isHidden = !isCaliberated
        accesory3Btn.isHidden = true
        titleThird.isHidden = true
        subTitle3.isHidden = true
        slLblThird.isHidden = true


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if self.isPresentedFlow{
            self.dismiss(animated: true, completion: nil)
        }else{
            goBack()
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationIntroViewController") as! CalibrationIntroViewController
        if isAddingNewDevice{
            vc.isAddingNewDevice =  self.isAddingNewDevice
        }
        vc.recalibration = self.recalibration
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
    func setCustomBackbtn() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_back-1"), style: .plain, target: self, action: #selector(goBack))
        backButton.tintColor = .black
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    @objc func goBack() {
        backTwo()
//        self.navigationController?.popViewController(animated: true)
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}
