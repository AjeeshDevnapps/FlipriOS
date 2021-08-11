//
//  FliperListViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 25/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class FliprListViewController: BaseViewController {
    @IBOutlet weak var fliprDetailsContainerView: UIView!
    @IBOutlet weak var serialKeyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serialTitleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

    var serialKey: String!
    var flipType: String!
    var isSignupFlow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        fliprDetailsContainerView.roundCorner(corner: 12)
        fliprDetailsContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        self.serialKeyLabel.text = serialKey
        self.typeLabel.text = flipType
        titleLabel.text = "Choisissez le Flipr Start à associer".localized
        serialTitleLabel.text = "Serial".localized
//        selectButton.addTarget(self, action: #selector(fliprSelectButtonAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func backButtonTapped() {
        if isSignupFlow{
            var isPoped = false
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: EducationScreenContainerViewController.self) {
//                    isPoped = true
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//            if isPoped { return }
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: WelcomeViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            if isPoped { return }
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LandingViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            if isPoped { return }
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController()
        }
    }

    @objc func fliprSelectButtonAction() {
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
            vc.serialKey = serialKey
            vc.flipType = flipType
            vc.isSignupFlow =  self.isSignupFlow
            self.navigationController?.pushViewController(vc)
        }
    }
    

    @IBAction func necxtButtonAction() {
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
            vc.serialKey = serialKey
            vc.flipType = flipType
            vc.isSignupFlow =  self.isSignupFlow
            self.navigationController?.pushViewController(vc)
        }
    }

}
