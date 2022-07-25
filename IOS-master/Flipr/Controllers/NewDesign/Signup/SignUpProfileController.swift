//
//  SignUpProfileController.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
class SignUpProfileController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        self.title = "Complete your profile".localized
        submitButton.isEnabled = false
        passwordTF.textType = .password
        passwordTF.addPaddingRightButton(target: self,#imageLiteral(resourceName: "reveal"),
                                         selectedImage: #imageLiteral(resourceName: "hide"),
                                         padding: 20,
                                         action: #selector(clickedOnRightView))
        passwordTF.rightViewMode = .whileEditing
        passwordTF.externalDelegate = self
        
        submitButton.setTitle("Submit".localized, for: .normal)
        firstNameLabel.text = "First name".localized
        lastNameLbl.text = "Last name".localized
        passwordLbl.text = "Password".localized
        firstNameTF.placeholder = "First name".localized
        lastNameTF.placeholder = "Last name".localized
        passwordTF.placeholder = ""
        submitButton.layer.cornerRadius = 12
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1213650182, green: 0.1445809603, blue: 0.213222146, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        self.setCustomBackbtn()
        navigationController?.setNavigationBarHidden(false, animated: true)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if firstNameTF.text != "" && lastNameTF.text != "" && passwordTF.text != "" {
            submitButton.backgroundColor = #colorLiteral(red: 0.06643301994, green: 0.08944996446, blue: 0.162193656, alpha: 1)
            submitButton.isEnabled = true
        } else {
            submitButton.backgroundColor = #colorLiteral(red: 0.4690234661, green: 0.4782367945, blue: 0.5128742456, alpha: 1)
            submitButton.isEnabled = false
        }
        return true
    }
    
    @objc func clickedOnRightView(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTF.textType = sender.isSelected ? .generic : .password
    }
    
    //MARK: - IBActions
    
    @IBAction func submitButton(_ sender: UIButton) {
        guard let firstName = firstNameTF.text,
              let lastName = lastNameTF.text,
              let password = passwordTF.text else { return }
//        guard password.isAlphaNumeric else {
//            self.showAlert(title: "Check password", message: "Password should be alphanumeric")
//            return
//        }
        let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < 6 {
            self.showError(title: "Error".localized, message: "The password must be at least 6 characters long".localized)
            return
        }
        
                self.view.showEmptyStateViewLoading(title: nil, message: nil)
        User.updateUserProfile(lastName: lastName, firstName: firstName, password: trimmed) { error in
            self.view.hideStateView()
            if error == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                vc.isSignupFlow = true
                self.navigationController?.pushViewController(vc)
            } else {
                self.showError(title: "Error", message: error?.localizedDescription)
            }
        }
    }
}
