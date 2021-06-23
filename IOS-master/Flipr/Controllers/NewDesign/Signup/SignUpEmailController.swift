//
//  SignUpEmailController.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import Foundation
import ActiveLabel
import SafariServices
import IQKeyboardManagerSwift

class SignUpEmailController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var descriptionText: ActiveLabel!
    @IBOutlet weak var textField: CustomTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var titleForTextField: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var controllerTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UISetup()
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false

        navigationController?.isNavigationBarHidden = true
        
        controllerTitle.text = "Create Account".localized
        backButton.setTitle("Login".localized, for: .normal)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK:- Custom Actions
    
    func UISetup() {
        self.title = "Create Account".localized()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        titleForTextField.text = "E-mail address".localized
        descriptionText.text = "Description".localized()
        textField.placeholder = "email@address.com".localized()
        
        textField.addTarget(self, action: #selector(updateTextFieldAppearance), for: .editingChanged)
        textField.addTarget(self, action: #selector(hideKeybaord), for: .editingDidEndOnExit)

        textField.layer.cornerRadius = 5
        textField.externalDelegate = self
        
        self.signUpButton.layer.cornerRadius = 12
    }
    
    @objc func updateTextFieldAppearance() {
        signUpButton.backgroundColor = (textField.text != "") ? #colorLiteral(red: 0.06643301994, green: 0.08944996446, blue: 0.162193656, alpha: 1) : #colorLiteral(red: 0.4690234661, green: 0.4782367945, blue: 0.5128742456, alpha: 1)
    }
    
    @objc func hideKeybaord() {
        textField.resignFirstResponder()
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
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
    
    @IBAction func backAction(_ sender: UIButton) {
        
        goBack()
    }
}
