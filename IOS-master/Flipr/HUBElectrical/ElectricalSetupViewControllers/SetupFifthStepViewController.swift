//
//  SetupThirdStepViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 06/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class SetupFifthStepViewController: UIViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)

        titleTextLabel.text = "Étape 6".localized
        subtitleTextLabel.text = "Rétablissez le courant.".localized
        submitButton.setTitle("Courant rétabli !".localized, for: .normal)
        let image1 = UIImage(named: "Ilustration-Animation-3")!
        let image2 = UIImage(named: "Ilustration-Animation-4")!

//        imageView.animationImages = [image1, image2]
//        imageView.animationDuration = 2.0
//        imageView.animationRepeatCount = 1
//        imageView.startAnimating()
        self.imageView.image = image1
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            DispatchQueue.main.async {
                self.imageView.image = image2
            }
        })
        submitButton.layer.cornerRadius = 12
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
    }
    @IBAction func backAction(_ sender: Any) {
        goBack()
    }
}
