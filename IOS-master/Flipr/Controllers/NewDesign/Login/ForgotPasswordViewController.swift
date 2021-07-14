//
//  ForgotPasswordViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 03/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!

    override func viewDidLoad() {
        self.backButtonTitle = "Login".localized
        emailLbl.text = "E-mail address".localized
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        self.titleLbl.text = "Reset my password".localized
        submitButton.setTitle("Reset".localized, for: .normal)
        self.setupViews()
        // Do any additional setup after loading the view.
    }
    
    
    
    func setupViews(){
        self.emailContainerView.roundCorner(corner: 8)
        self.submitButton.roundCorner(corner: 12)
        for navItem in(self.navigationController?.navigationBar.subviews)! {
             for itemSubView in navItem.subviews {
                 if let largeLabel = itemSubView as? UILabel {
                     largeLabel.text = "Reset my password".localized
                     largeLabel.numberOfLines = 0
                     largeLabel.lineBreakMode = .byWordWrapping
                 }
             }
        }
    }
    
    
    func showEmailViewBorder(isActive:Bool){
        self.emailContainerView.layer.borderColor = isActive ? UIColor(red: 0.067, green: 0.09, blue: 0.161, alpha: 1).cgColor : UIColor(red: 0.89, green: 0.91, blue: 0.937, alpha: 1).cgColor
    }
    
    
    
    @IBAction func signInButtonAction(_ sender: Any) {
        
        guard let email = emailTextField.text else {
            self.showError(title: "Error".localized, message: "Your email address".localized)
            return
        }
        
        if !email.isValidEmail {
            self.showError(title: "Error".localized, message: "Invalid email address format".localized)
            emailTextField.becomeFirstResponder()
            return
        }
        
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        User.resetPassword(email: email, completion: { (error) in
            if (error != nil) {
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 3)
            } else {
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.textLabel.text = "Email successfully sent to ".localized + email
                hud?.dismiss(afterDelay: 3)
                self.navigationController?.popViewController()
            }
        })
    }

    

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        self.showEmailViewBorder(isActive: true)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.showEmailViewBorder(isActive: false)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.showEmailViewBorder(isActive: false)
        return true
    }
}
