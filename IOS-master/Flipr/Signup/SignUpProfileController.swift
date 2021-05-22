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
        self.title = "Complete profile".localized
        passwordTF.textType = .password
        passwordTF.addPaddingRightButton(target: self,#imageLiteral(resourceName: "reveal"),
                                         selectedImage: #imageLiteral(resourceName: "hide"),
                                         padding: 20,
                                         action: #selector(clickedOnRightView))
        passwordTF.rightViewMode = .whileEditing
        passwordTF.externalDelegate = self
        
        
        firstNameTF.placeholder = "First name".localized
        lastNameTF.placeholder = "Last name".localized
        passwordTF.placeholder = ""
        submitButton.layer.cornerRadius = 12
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    @objc func clickedOnRightView(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTF.textType = sender.isSelected ? .generic : .password
    }
    
    //MARK: - IBActions
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        
    }
    
    
    
}
