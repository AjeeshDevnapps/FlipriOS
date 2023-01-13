//
//  CompleteProfileViewController.swift
//  Flipr
//
//  Created by Ajeesh on 02/12/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class CompleteProfileViewController: UIViewController {
    @IBOutlet weak var fNameLbl: UITextField!
    @IBOutlet weak var lNameLbl: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = "Complétez votre profil".localized
    }
    
    
    @IBAction func submitButtonAction() {
        let firstName = fNameLbl.text ?? ""
        let lastName = lNameLbl.text ?? ""
        if !firstName.isValidString{
            self.showError(title: "Input Error", message: "Please enter first name")
            return
        }
        if !lastName.isValidString{
            self.showError(title: "Input Error", message: "Please enter last name")
            return
        }
        self.updateUserName(fName: firstName, lName: lastName)
    }

    
    func updateUserName(fName:String, lName:String){
        User.updateAccount(lastName: lName, firstName: fName) {
            (error) in
            
            if error != nil{
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)

            }
            else{
                self.showUnitSelectionView()
            }
        }
    }
    
    
    func showUnitSelectionView(){
        let sb = UIStoryboard.init(name: "Settings", bundle: nil)
        if let unintVC = sb.instantiateViewController(withIdentifier: "PreferenceViewController") as? PreferenceViewController{
            unintVC.isLoginFlow = true
            self.navigationController?.pushViewController(unintVC)
        }
    }
   
}
