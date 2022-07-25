//
//  FirmwereUpdateAlertViewController.swift
//  Flipr
//
//  Created by Ajeesh on 25/04/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class FirmwereUpdateAlertViewController: UIViewController {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var remindLaterButton: UIButton!
    @IBOutlet weak var cancelUpdateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tapView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        updateButton.roundCorner(corner: 12)
        remindLaterButton.roundCorner(corner: 12)
        cancelUpdateButton.roundCorner(corner: 12)
        descLabel.text = "Le logiciel interne de l'analyseur Flipr doit être mis à jour afin d'améliorer ses performances.".localized
        remindLaterButton.setTitle("Me rappeler la prochaine fois".localized, for: .normal)
        cancelUpdateButton.setTitle("Ne plus me proposer".localized, for: .normal)

        updateButton.titleLabel?.text = "Faire la mise à jour".localized

        // Do any additional setup after loading the view.
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                }, completion: nil)
    }
    
    @IBAction func updateButtonClicked() {
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: K.Notifications.showFirmwereUpgradeScreen, object: nil)

//        self.showFliprFirmwereUpgradeScreen()
    }

    @IBAction func remindButtonClicked() {
        AppSharedData.sharedInstance.isShowingFirmwereUpdateScreen = false
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func disAllowButtonClicked() {
        AppSharedData.sharedInstance.isShowingFirmwereUpdateScreen = false
//        UserDefaults.standard.set(true, forKey: disAllowFirmwereUpdateKey)
        UserDefaults.standard.set(true, forKey: disAllowFirmwereUpdatePromptKey)

        self.dismiss(animated: false, completion: nil)
    }
   
    
    
    func showFliprFirmwereUpgradeScreen(){
        
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

}
