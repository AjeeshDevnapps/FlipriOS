//
//  SignUpEmailController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import Foundation
import ActiveLabel
import SafariServices

class SignUpEmailController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var descriptionText: ActiveLabel!
    @IBOutlet weak var textField: CustomTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var titleForTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetup()
        
        let cguType = ActiveType.custom(pattern: "\\s" + "Terms of Use".localized + "\\b")
        let pudType = ActiveType.custom(pattern: "\\s" + "Data Use Policy".localized + "\\b")
        descriptionText.enabledTypes = [cguType, pudType]
        descriptionText.customColor[cguType] = K.Color.LightBlue
        descriptionText.customColor[pudType] = K.Color.LightBlue
        descriptionText.handleCustomTap(for: cguType) { (element) in
            if let url = URL(string: "TERMS_OF_USE_URL".localized) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(vc, animated: true)
            }
        }
        descriptionText.handleCustomTap(for: pudType) { (element) in
            if let url = URL(string: "DATA_USE_POLICY_URL".localized) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(vc, animated: true)
            }
        }
        
        descriptionText.text = "By validating, you agree to the Terms of Use and the Data Use Policy.".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    //MARK:- Custom Actions
    
    func UISetup() {
        self.title = "Create Account".localized()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1213650182, green: 0.1445809603, blue: 0.213222146, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)

        titleForTextField.text = "Email Address".localized()
        descriptionText.text = "Description".localized()
        textField.placeholder = "email@address.com".localized()
        
        textField.addTarget(self, action: #selector(updateTextFieldAppearance), for: .editingChanged)
        textField.layer.cornerRadius = 5
        textField.externalDelegate = self
        
        self.signUpButton.layer.cornerRadius = 12
    }
    
    @objc func updateTextFieldAppearance() {
        signUpButton.backgroundColor = (textField.text != "") ? #colorLiteral(red: 0.06643301994, green: 0.08944996446, blue: 0.162193656, alpha: 1) : #colorLiteral(red: 0.4690234661, green: 0.4782367945, blue: 0.5128742456, alpha: 1)
    }
    
    //MARK:-  IBActions
    @IBAction func signUp(_ sender: UIButton) {
        let enteredEmail = textField.text ?? ""
        if enteredEmail.isValidEmail {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
            viewController.email = enteredEmail
            navigationController?.pushViewController(viewController)
        } else {
            showAlert(title: "Email incorrect".localized, message: "Invalid email address format".localized)
        }
    }
}
