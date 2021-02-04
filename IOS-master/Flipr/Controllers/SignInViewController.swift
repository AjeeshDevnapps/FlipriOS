//
//  SignInViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 13/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD
import SwifterSwift

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var demoButton: UIButton!
    
    @IBOutlet weak var signInStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var firstUseLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeBackLabel.text = "Welcome back!".localized
        demoButton.setTitle("Use the demo account".localized, for: .normal)
        emailTextField.placeholder = "Your email address".localized
        passwordTextField.placeholder = "Your password".localized
        signInButton.setTitle("Let's go!".localized, for: .normal)
        forgotPasswordButton.setTitle("Forgot password?".localized, for: .normal)
        firstUseLabel.text = "First use?".localized
        signupButton.setTitle("This way!".localized, for: .normal)
        
        signInStackView.alpha = 1
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showSignInStackView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.signInStackView.alpha = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.passwordTextField.text = ""
    }
    
    func showSignInStackView() {
        UIView.animate(withDuration: 0.25) { 
            self.signInStackView.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        var loginTextField: UITextField?
        
        let alertController = UIAlertController(title: "Forgot password?".localized, message: "Enter your account email address to receive a reset link.".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send".localized, style: .default, handler: { (action) -> Void in
            print("Send Button Pressed, email : \(loginTextField?.text)")
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            User.resetPassword(email: (loginTextField?.text)!, completion: { (error) in
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.textLabel.text = "Email successfully sent to ".localized + (loginTextField?.text)!
                    hud?.dismiss(afterDelay: 3)
                }
            })
            
        })
        
        //sendAction.isEnabled = (loginTextField?.text?.isEmail)!
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            loginTextField = textField
            loginTextField?.text = self.emailTextField.text
            loginTextField?.keyboardType = .emailAddress
            loginTextField?.placeholder = "Email address...".localized
        }
        present(alertController, animated: true, completion: nil)
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
        } else
        
        if password.count == 0 {
            self.showError(title: "Error".localized, message: "Please enter your password".localized)
            passwordTextField.becomeFirstResponder()
            return
        }
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        signInButtonWidthConstraint.constant = 44
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
                self.signInButtonWidthConstraint.constant = 200
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    
    func presentDashboard(animated:Bool) {
        if let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewControllerID") {
            dashboard.modalTransitionStyle = .flipHorizontal
            dashboard.modalPresentationStyle = .fullScreen
            self.present(dashboard, animated: animated, completion: {
                self.signInStackView.alpha = 1
            })
            
        }
    }
    
    func presentLandingController(animated:Bool) {
        let hubStoryboard = UIStoryboard(name: "HUB", bundle: nil)
        let viewController = hubStoryboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.signInButton.hideActivityIndicator()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func useDemoAccount(_ sender: Any) {
        emailTextField.text = "demo@goflipr.com"
        passwordTextField.text = "dauphin"
        signInButtonAction(self)
    }
    

}
