//
//  LoginViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
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
    var isNeedToHideBackButton = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Connection".localized
        self.setupViews()
        if isNeedToHideBackButton{
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
        }
        // Do any additional setup after loading the view.
    }
    
    
    func setuplocalisation(){
        emailLbl.text = "E-mail address".localized
        passwordLbl.text = "Password".localized
        keyLbl.text = "I forgot my password".localized
        signupLbl.text = "No account yet? ".localized
        signupLblBold.text = "Register".localized

//        subHeadingLbl.text = "Don't worry about the quality of your pond water Create an account".localized
//        nextButton.setTitle("Create an account".localized, for: .normal)
        signInButton.setTitle("Login".localized, for: .normal)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        self.passwordTextField.text = ""
    }
    
    func setupViews(){
        self.navigationController?.isNavigationBarHidden = false
        self.emailContainerView.roundCorner(corner: 8)
        self.passwordContainerView.roundCorner(corner: 8)
        setuplocalisation()
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
    
    @IBAction func signupButtonAction(_ sender: Any) {
        let signupView = UIStoryboard.init(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SignUpEmailController") as! SignUpEmailController
        self.navigationController?.pushViewController(signupView)
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            self.showError(title: "Error".localized, message: "All fields are mandatory".localized)
            return
        }
        
        if !email.isValidEmail {
            self.showError(title: "Error".localized, message: "Invalid email address format".localized)
            emailTextField.becomeFirstResponder()
            return
        }
        else
        
        if password.count < 1 {
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
       /*
        let mainSB = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let dashboard = mainSB.instantiateViewController(withIdentifier: "NewDashboardViewController")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: animated, completion: {
        })
        */
        
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let dashboard = mainSB.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: animated, completion: {
        })
    
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

extension LoginViewController{
    
    func presentActivationController(animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ActivationViewControllerID") {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func presentStripController(animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StripViewControllerID") {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func presentEmailVerificationController(animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationViewControllerID") {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func presentCalibrationViewController(type:CalibrationType, animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
            viewController.calibrationType = type
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
}
