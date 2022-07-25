//
//  SignUpViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 13/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import SafariServices
import ActiveLabel
import IQKeyboardManagerSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var legalLabel: ActiveLabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordConfirmLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
            passwordConfirmationTextField.textContentType = .oneTimeCode
        }
        
        setLocalizedLabel()
        
        scrollView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.alpha = 1
        })
        
        // Do any additional setup after loading the view.
        
        let cguType = ActiveType.custom(pattern: "\\s" + "Terms of Use".localized + "\\b")
        let pudType = ActiveType.custom(pattern: "\\s" + "Data Use Policy".localized + "\\b")
        legalLabel.enabledTypes = [cguType, pudType]
        legalLabel.customColor[cguType] = K.Color.LightBlue
        legalLabel.customColor[pudType] = K.Color.LightBlue
        legalLabel.handleCustomTap(for: cguType) { (element) in
            if let url = URL(string: "TERMS_OF_USE_URL".localized) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(vc, animated: true)
            }
        }
        legalLabel.handleCustomTap(for: pudType) { (element) in
            if let url = URL(string: "DATA_USE_POLICY_URL".localized) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(vc, animated: true)
            }
        }
        
        legalLabel.text = "By validating, you agree to the Terms of Use and the Data Use Policy.".localized
        
    }
    
    func setLocalizedLabel() {
        titleLabel.text = "LET'S MET".localized
        welcomeLabel.text = "Welcome to Flipr!".localized
        introLabel.text = "At first, we will create your account. Fill in the form below carefully.".localized
        emailLabel.text = "Email".localized
        passwordLabel.text = "Password".localized
        passwordConfirmLabel.text = "Confirm password".localized
        nameLabel.text = "Last name".localized
        firstNameLabel.text = "First name".localized
        phoneLabel.text = "Phone".localized
        
        emailTextField.placeholder = "Your email address".localized
        lastNameTextField.placeholder = "Your last name".localized
        firstNameTextField.placeholder = "Your first name".localized
        phoneTextField.placeholder = "Your phone number".localized
        
        signUpButton.setTitle("Validate!".localized, for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpButtonAction(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmation = passwordConfirmationTextField.text,
            let lastName = lastNameTextField.text,
            let firstName = firstNameTextField.text,
            let phone = phoneTextField.text
            else {
            self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
            return
        }

        if !email.isValidEmail {
            self.showError(title: "Error".localized, message: "Invalid email address format".localized)
            return
        }
        
        if password.count < 6 {
            self.showError(title: "Error".localized, message: "The password must be at least 6 characters long".localized)
            return
        }
        
        if password != confirmation {
            self.showError(title: "Error".localized, message: "Confirm password does not match password".localized)
            return
        }
        
        resignAllTextFields()
        
        signUpButtonWidthConstraint.constant = 44
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.signUpButton.showActivityIndicator(type: .ballClipRotatePulse)
            User.signup(email: email, password: password, lastName: lastName, firstName: firstName, phone: phone, completion: { (error) in
                if error == nil {
//                    
//                    let omnisenseUser = OSUser();
//                    omnisenseUser.email = email
//                    omnisenseUser.firstName = firstName
//                    omnisenseUser.lastName = lastName
//                    omnisenseUser.phone = phone
//                    omnisenseUser.registered = true
//                    omnisenseUser.optin = true
//                    Omnisense.setCurrentUser(omnisenseUser)
                    
                    if let emailVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationViewControllerID") as? EmailVerificationViewController {
                        emailVerificationViewController.email = email
                        emailVerificationViewController.password = password
                        self.navigationController?.pushViewController(emailVerificationViewController, animated: true)
                    }
                } else {
                    self.showError(title: "Error".localized, message: error?.localizedDescription)
                }
                self.signUpButton.hideActivityIndicator()
                self.signUpButtonWidthConstraint.constant = 200
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            })
        }
        
    }
    
    func resignAllTextFields() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmationTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpViewController: UITextFieldDelegate  {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
            passwordConfirmationTextField.textContentType = .oneTimeCode
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
            passwordConfirmationTextField.textContentType = .oneTimeCode
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            passwordConfirmationTextField.becomeFirstResponder()
        }
        if textField == passwordConfirmationTextField {
            lastNameTextField.becomeFirstResponder()
        }
        if textField == lastNameTextField {
            firstNameTextField.becomeFirstResponder()
        }
        if textField == firstNameTextField {
            phoneTextField.becomeFirstResponder()
        }
        if textField == phoneTextField {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        return true
    }
    
}
