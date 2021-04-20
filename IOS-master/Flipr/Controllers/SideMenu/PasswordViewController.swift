//
//  PasswordViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 18/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class PasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordTxtFld: UITextField!
    @IBOutlet weak var newPasswordTxtFld: UITextField!
    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var oldPasswordTxtFldContainerView: UIView!
    @IBOutlet weak var newPasswordTxtFldContainerView: UIView!
    @IBOutlet weak var confirmPasswordTxtFldContainerView: UIView!
    @IBOutlet weak var forgotButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Password".localized
      

        saveButton.setTitle("Save".localized, for: .normal)
        forgotButton.setTitle("Forgot password?".localized, for: .normal)
        oldPasswordTxtFld.placeholder = "Old Password".localized
        newPasswordTxtFld.placeholder = "New Password".localized
        newPasswordTxtFld.placeholder = "Type new password again".localized

        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI(){
        
        
        oldPasswordTxtFld.placeholderColor(color: UIColor.init(hexString: "#203D52"))
        oldPasswordTxtFldContainerView.layer.cornerRadius = 25.0
        oldPasswordTxtFldContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 25.0, opacity: 0.21)
        
        newPasswordTxtFld.placeholderColor(color: UIColor.init(hexString: "#203D52"))
        newPasswordTxtFldContainerView.layer.cornerRadius = 25.0
        newPasswordTxtFldContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 25.0, opacity: 0.21)

        confirmPasswordTxtFld.placeholderColor(color: UIColor.init(hexString: "#203D52"))
        confirmPasswordTxtFldContainerView.layer.cornerRadius = 25.0
        confirmPasswordTxtFldContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 25.0, opacity: 0.21)
        
        saveButton.layer.cornerRadius = 30.0
        saveButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.init(hexString: "#3DA0FF"), radius: 30.0, opacity: 0.5)


    }

    @IBAction func passwordChangeButtonClicked(){
    
        guard let oldpwd = oldPasswordTxtFld.text, !oldpwd.isEmpty , let newpwd = newPasswordTxtFld.text, !newpwd.isEmpty , let confmpwd = confirmPasswordTxtFld.text, !confmpwd.isEmpty  else {
            self.showError(title: "Error".localized, message: "All fields are mandatory".localized)
            return
        }
        
        if oldpwd.count == 0 {
            self.showError(title: "Error".localized, message: "Please enter old password".localized)
            oldPasswordTxtFld.becomeFirstResponder()
            return
        }
        
        if newpwd.count == 0 {
            self.showError(title: "Error".localized, message: "Please enter new password".localized)
            oldPasswordTxtFld.becomeFirstResponder()
            return
        }
        
        if confmpwd.count == 0 {
            self.showError(title: "Error".localized, message: "Please enter confirm password".localized)
            oldPasswordTxtFld.becomeFirstResponder()
            return
        }
        
        if newpwd != confmpwd{
            self.showError(title: "Error".localized, message: "Password miss match".localized)
            return
        }
        
        User.changePassword(oldPassword: oldpwd, newPassword:newpwd ) { (isSuccess, msg, error) in
            if error == nil {
                if isSuccess {
                    self.showSuccess(title: "Success".localized, message: "Password has been updated successfully".localized)
                    self.navigationController?.popViewController()
                }else{
                    self.showError(title: "Error".localized, message: msg ?? "")
                }
            }
            else {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func forgotPasswordButtonClicked(){
    
        var loginTextField: UITextField?
        
        let alertController = UIAlertController(title: "Forgot password?".localized, message: "Enter your account email address to receive a reset link.".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send".localized, style: .default, handler: { (action) -> Void in
//            print("Send Button Pressed, email : \(loginTextField?.text)")
            
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
            loginTextField?.keyboardType = .emailAddress
            loginTextField?.placeholder = "Email address...".localized
        }
        present(alertController, animated: true, completion: nil)
    }

}
