//
//  PoolSettingsStartViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 20/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class PoolSettings: Pool {
    static let shared = PoolSettings()
}

class PoolSettingsStartViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        slLblFirst.roundCorner(corner: slLblFirst.width / 2)
        slLblSecond.roundCorner(corner: slLblSecond.width / 2)
        slLblThird.roundCorner(corner: slLblThird.width / 2)
        submitBtn.roundCorner(corner: 12)
        
        titleFirst.text = "Connect your pool".localized
        titleSecond.text = "Calibration".localized
        titleThird.text = "Describe your pool".localized
        
        subTitle1.text = ""
        subTitle2.text = "3 steps".localized
        subTitle3.text = "3rd subtitle".localized
        
        accessory1Btn.isHidden = !isPoolConnected
        accesory2Btn.isHidden = !isCaliberated
        accesory3Btn.isHidden = false
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
}

extension UIViewController {
    func setCustomBackbtn() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_back-1"), style: .plain, target: self, action: #selector(goBack))
        backButton.tintColor = .black
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
