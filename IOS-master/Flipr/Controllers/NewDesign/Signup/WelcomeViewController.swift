//
//  WelcomeViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 14/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var welcomeTitleLbl: UILabel!
    @IBOutlet weak var welcomeSubtitleLbl: UILabel!
    @IBOutlet weak var devicesListHdrLbl: UILabel!
    @IBOutlet weak var statrVw: UIView!
    @IBOutlet weak var hubVw: UIView!
    var isSignupFlow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    override func backButtonTapped(){
        if isSignupFlow{
            var isPoped = false
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: EducationScreenContainerViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            if isPoped {return}
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LoginViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            if isPoped {return}
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func setupUI() {
        var welcomeMsg = "Bienvenue".localized
        if let name = User.currentUser?.firstName{
            welcomeMsg.append(" ")
            welcomeMsg.append(name)
        }
        welcomeMsg.append("!")
        welcomeTitleLbl.text  = welcomeMsg
        welcomeSubtitleLbl.text  = "The Flipr App is ready to welcome your first device.".localized
        devicesListHdrLbl.text = "Choose a device to associate".localized
        
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1213650182, green: 0.1445809603, blue: 0.213222146, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)

//        self.setCustomBackbtn()
        
        statrVw.roundCorner(corner: 12)
        hubVw.roundCorner(corner: 12)
        statrVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        hubVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
    }
    
    @IBAction func clickedOnStr(_ sender: UIButton) {
        let fliprStoryboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddFliprViewController") as! AddFliprViewController
        viewController.isSignupFlow = self.isSignupFlow
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func clickedOnHub(_ sender: UIButton) {
        let fliprStoryboard = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "ElectricalSetupViewController") as! ElectricalSetupViewController
        viewController.isSignupFlow = self.isSignupFlow
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
