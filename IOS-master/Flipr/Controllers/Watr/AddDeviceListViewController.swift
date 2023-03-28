//
//  AddDeviceListViewController.swift
//  Flipr
//
//  Created by Ajeesh on 22/12/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class AddDeviceListViewController: UIViewController {
    @IBOutlet weak var welcomeTitleLbl: UILabel!
    @IBOutlet weak var welcomeSubtitleLbl: UILabel!
    @IBOutlet weak var devicesListHdrLbl: UILabel!
    @IBOutlet weak var statrVw: UIView!
    @IBOutlet weak var hubVw: UIView!
    @IBOutlet weak var dipRVw: UIView!
    @IBOutlet weak var watrVw: UIView!
    var isSignupFlow = false
    var isPushFlow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        welcomeTitleLbl.text = "Votre emplacement est prêt!".localized
        welcomeSubtitleLbl.text = "L'application est prête à accueillir votre premier appareil.".localized
        devicesListHdrLbl.text = "Choisir un appareil à associer".localized

        statrVw.roundCorner(corner: 12)
        hubVw.roundCorner(corner: 12)
        statrVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        hubVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        dipRVw.roundCorner(corner: 12)
        watrVw.roundCorner(corner: 12)
        dipRVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 10.0, opacity: 0.21)
        watrVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 10.0, opacity: 0.21)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clickedOnAnalyser() {
        let fliprStoryboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddFliprViewController") as! AddFliprViewController
        viewController.isPushFlow = self.isPushFlow
        viewController.isSignupFlow = self.isSignupFlow
        AppSharedData.sharedInstance.isAddDeviceStarted = true
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    @IBAction func clickedOnController() {
    
        let fliprStoryboard = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "ElectricalSetupViewController") as! ElectricalSetupViewController
        viewController.isSignupFlow = self.isSignupFlow
        AppSharedData.sharedInstance.isAddDeviceStarted = true
        self.navigationController?.pushViewController(viewController, animated: true)

    }

    @IBAction func clickedOnDipR() {
    
    }
    
    @IBAction func clickedOnWatr() {
    
    }
}
