//
//  LoginViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!

    @IBOutlet weak var keyLbl: UILabel!
    @IBOutlet weak var signupLbl: UILabel!
    @IBOutlet weak var signupLblBold: UILabel!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Connexion"
        self.setupViews()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.passwordTextField.text = ""
    }
    
    func setupViews(){
        self.emailContainerView.roundCorner(corner: 8)
        self.passwordContainerView.roundCorner(corner: 8)
    }
    
    
    func showEmailViewBorder(isActive:Bool){
        self.emailContainerView.layer.borderColor = isActive ? UIColor(red: 0.067, green: 0.09, blue: 0.161, alpha: 1).cgColor : UIColor(red: 0.89, green: 0.91, blue: 0.937, alpha: 1).cgColor
    }
    
    func showPasswordViewBorder(isActive:Bool){
        self.passwordContainerView.layer.borderColor = isActive ? UIColor(red: 0.067, green: 0.09, blue: 0.161, alpha: 1).cgColor : UIColor(red: 0.89, green: 0.91, blue: 0.937, alpha: 1).cgColor
    }
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        if let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController{
            self.navigationController?.pushViewController(forgotVC)
        }
        
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = emailTextField.text else {
            self.showError(title: "Error".localized, message: "All fields are mandatory".localized)
            return
        }
        
        if !email.isValidEmail {
            self.showError(title: "Error".localized, message: "Invalid email address format".localized)
            emailTextField.becomeFirstResponder()
            return
        }
        else
        
        if password.count == 0 {
            self.showError(title: "Error".localized, message: "Please enter your password".localized)
            passwordTextField.becomeFirstResponder()
            return
        }
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.signInButton.showActivityIndicator(type: .ballClipRotatePulse)
            User.signin(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (error) in
                if error == nil {
                    
                    let omnisenseUser = OSUser();
                    omnisenseUser.email = User.currentUser?.email
                    omnisenseUser.firstName = User.currentUser?.firstName
                    omnisenseUser.lastName = User.currentUser?.lastName
                    omnisenseUser.phone = User.currentUser?.phone
                    omnisenseUser.registered = true
                    Omnisense.setCurrentUser(omnisenseUser)
                    
                    if Module.currentModule != nil {
                        
                        UserDefaults.standard.set(Date()?.addingTimeInterval(-200), forKey:"FirstMeasureStartDate")
                        
                        BLEManager.shared.activationNeeded = true
                        
                        Module.currentModule?.pH7CalibrationDone = true
                        Module.currentModule?.pH4CalibrationDone = true
                        Module.saveCurrentModuleLocally()
                        self.presentDashboard(animated: false)
                        
                        /*
                        let alertController = UIAlertController(title: "Calibration".localized, message: "Have you ever done a calibration of your Flipr?".localized, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction =  UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.cancel) {(result : UIAlertAction) -> Void in
                            
                            Module.currentModule?.pH7CalibrationDone = true
                            Module.currentModule?.pH4CalibrationDone = true
                            Module.saveCurrentModuleLocally()
                            
                            let alertController = UIAlertController(title: "Test strip calibration".localized, message: "Have you ever done the test strip calibration?".localized, preferredStyle: UIAlertControllerStyle.alert)
                            
                            let cancelAction =  UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.cancel) {(result : UIAlertAction) -> Void in
                                self.presentDashboard(animated: false)
                            }
                            
                            let okAction = UIAlertAction(title: "No, never".localized, style: UIAlertActionStyle.default) {(result : UIAlertAction) -> Void in
                                self.presentStripController(animated: true)
                            }
                            alertController.addAction(cancelAction)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                        let okAction = UIAlertAction(title: "No, never".localized, style: UIAlertActionStyle.default) {(result : UIAlertAction) -> Void in
                            self.presentCalibrationViewController(type: .ph7, animated: true)
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        */
                    } else if User.currentUser?.isActivated == false {
                        //self.presentEmailVerificationController(animated: false)
                        if let emailVerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationViewControllerID") as? EmailVerificationViewController {
                            emailVerificationViewController.email = email
                            emailVerificationViewController.password = password
                            self.navigationController?.pushViewController(emailVerificationViewController, animated: true)
                        }
                    } else if HUB.currentHUB != nil {
                        self.presentDashboard(animated: false)
                    } else {
                        self.presentLandingController(animated: false)
                    }
                } else {
                    self.showError(title: "Error".localized, message: error?.localizedDescription)
                }
                self.signInButton.hideActivityIndicator()
//                self.signInButtonWidthConstraint.constant = 200
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    
    
    func presentDashboard(animated:Bool) {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
         let dashboard = mainSB.instantiateViewController(withIdentifier: "DashboardViewControllerID") 
            dashboard.modalTransitionStyle = .flipHorizontal
            dashboard.modalPresentationStyle = .fullScreen
            self.present(dashboard, animated: animated, completion: {
//                self.signInStackView.alpha = 1
            })
            
//        }
    }
    
    func presentLandingController(animated:Bool) {
        let hubStoryboard = UIStoryboard(name: "HUB", bundle: nil)
        let viewController = hubStoryboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    

}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        switch textField {
        case emailTextField:
            self.showEmailViewBorder(isActive: true)
            self.showPasswordViewBorder(isActive: false)
        case passwordTextField:
            self.showPasswordViewBorder(isActive: true)
            self.showEmailViewBorder(isActive: false)
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            self.showEmailViewBorder(isActive: false)
        case passwordTextField:
            self.showPasswordViewBorder(isActive: false)
        default:
            break
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            self.showEmailViewBorder(isActive: false)
        case passwordTextField:
            self.showPasswordViewBorder(isActive: false)
        default:
            break
        }
        return true
    }
}
