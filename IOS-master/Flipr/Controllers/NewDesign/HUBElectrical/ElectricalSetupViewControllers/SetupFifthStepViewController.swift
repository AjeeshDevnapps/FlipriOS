//
//  SetupThirdStepViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 06/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class SetupFifthStepViewController: BaseViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    @IBOutlet weak var animationImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    var equipmentCode = ""
    var inf90 = false
    var simultaneous = false
    
    var step: Int = 6
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)

        if step == 6 {
            titleTextLabel.text = "Étape 6".localized
            subtitleTextLabel.text = "Rétablissez le courant.".localized
            submitButton.setTitle("Courant rétabli !".localized, for: .normal)
            let image1 = UIImage(named: "Ilustration-Animation-3")!
            let image2 = UIImage(named: "Ilustration-Animation-4")!
            animationImageView.animationImages = [image1, image2]
            animationImageView.animationDuration = 1.0
            animationImageView.startAnimating()
        } else if step == 2 {
            titleTextLabel.text = "Étape 2".localized
            subtitleTextLabel.text = "Situez l'alimentation électrique de votre équipement et suivez-le jusqu'au coffret.".localized
//            submitButton.setTitle("Courant rétabli !".localized, for: .normal)
            submitButton.setTitle("Suivant".localized, for: .normal)

            let image1 = UIImage(named: "animation1")!
            let image2 = UIImage(named: "animation2")!
            animationImageView.animationDuration = 1.0
            animationImageView.animationImages = [image1, image2]
            animationImageView.startAnimating()
        }

        submitButton.layer.cornerRadius = 12
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if step == 2 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
                vc.equipmentCode = equipmentCode
                vc.inf90 = inf90
                vc.simultaneous = simultaneous
                vc.step = 3
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if step == 6 {
            let fliprStoryboard = UIStoryboard(name: "FliprDevice", bundle: nil)
            let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddHubViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        goBack()
    }
}
