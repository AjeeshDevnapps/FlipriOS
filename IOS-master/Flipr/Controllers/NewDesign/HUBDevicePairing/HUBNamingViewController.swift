//
//  HUBNamingViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class HUBNamingViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textFieldTitle: UILabel!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        submitButton.layer.cornerRadius = 12
        nameTextField.text = "Pompe à filtration".localized
        titleLabel.text  = "Donnez un nom à votre Flipr Hub".localized
        subtitleLabel.text  = "Ce nom sera utilisé sur votre tableau de bord. Optez de préférence pour un nom court associé à l'équipement connecté.".localized
        textFieldTitle.text = "Nom de votre Flipr Hub".localized
        submitButton.setTitle("Suivant".localized, for: .normal)

        nameTextField.becomeFirstResponder()
        
        nameTextField.addPaddingRightButton(target: self, #imageLiteral(resourceName: "delete-icon"), padding: 10, action: #selector(deleteText))
    }
    
    @objc func deleteText() {
        nameTextField.text = ""
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HUBPairingSuccessViewController") as! HUBPairingSuccessViewController
        navigationController?.pushViewController(vc)
    }
    
   

}
