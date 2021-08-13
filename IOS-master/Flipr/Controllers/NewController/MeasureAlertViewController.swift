//
//  MeasureAlertViewController.swift
//  Flipr
//
//  Created by Ajeesh on 12/08/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class MeasureAlertViewController: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var line1Lbl: UILabel!
    @IBOutlet weak var line2Lbl: UILabel!
    @IBOutlet weak var line3Lbl: UILabel!
    @IBOutlet weak var line4Lbl: UILabel!
    @IBOutlet weak var line5Lbl: UILabel!
    @IBOutlet weak var line6Lbl: UILabel!
    @IBOutlet weak var savoirPlusBtn: UIButton!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var tapView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        topContainerView.roundCorner(corner: 15)
        titleLbl.text = "Mesure ancienne".localized
        line1Lbl.text = "Que signifie mesure ancienne ?".localized
        line2Lbl.text = "La dernière mesure date de plus de 24h. Nous vous invitons à actualiser la mesure avant d'agir sur votre bassin. ".localized
        line3Lbl.text = "Comment effectuer une nouvelle mesure ?".localized
        line4Lbl.text = "Activez le bluetooth de votre smartphone, approchez-vous de votre Flipr, ouvrez le menu rapide et déclenchez une mesure manuelle.".localized
        line5Lbl.text = "Activez la connexion automatique avec Flipr Infinite !".localized
        line6Lbl.text = "Flipr Infinite vous permet d'activer la connexion à distance et automatique via le réseau Sigfox (ou en Wifi si vous avez l'accessoire WifiConnect).".localized
        savoirPlusBtn.setTitle("En savoir plus".localized, for: .normal)

        topContainerView.layer.cornerRadius = 15
        topContainerView.layer.masksToBounds = true
        topContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if let module = Module.currentModule {
            if module.isSubscriptionValid {
                bottomContainerView.isHidden = true
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                }, completion: nil)

//        self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func subscribitionAlertButtonTab(){
        if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

}

