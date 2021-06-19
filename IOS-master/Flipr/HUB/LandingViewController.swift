//
//  LandingViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 16/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var welcomeTitleLbl: UILabel!
    @IBOutlet weak var welcomeSubtitleLbl: UILabel!
    @IBOutlet weak var devicesListHdrLbl: UILabel!
    @IBOutlet weak var statrVw: UIView!
    @IBOutlet weak var hubVw: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        var welcomeMsg = "Bienvenue "
        if let name = User.currentUser?.firstName{
            welcomeMsg.append(name)
        }
        welcomeMsg.append("!")
        welcomeTitleLbl.text  = welcomeMsg
//        titleLabel.text = "Welcome to the Flipr family!".localized()
//        subtitleLabel.text = "Let's setup your first device!".localized()
//
//        doneButton.setTitle("Let's go!".localized(), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModuleTypeSelectionViewControllerID") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupUI() {
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
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
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddFliprViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func clickedOnHub(_ sender: UIButton) {
        let fliprStoryboard = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "ElectricalSetupViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
