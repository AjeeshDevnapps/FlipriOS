//
//  AccountViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 17/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit


private var shadowLayer: CAShapeLayer!
private var cornerRadius: CGFloat = 25.0
private var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor

class AccountViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var subscriptionLabel: UILabel!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var subsriptionImgView: UIImageView!
    @IBOutlet weak var subsriptionButton: UIButton!

    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var subscriptionContainerView: UIView!
    private var shadowLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
        firstNameTxtFld.delegate = self
        lastNameTxtFld.delegate = self
        subsriptionButton.isUserInteractionEnabled = false
        detailsContainerView.clipsToBounds = true
        detailsContainerView.layer.cornerRadius = 15.0
        detailsContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        
        subscriptionContainerView.clipsToBounds = true
        subscriptionContainerView.layer.cornerRadius = 15.0
        subscriptionContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)

        showDetails()
        
        
        
//        getHubInfo()
    }
    
    
    func showDetails(){
        self.emailLabel.text = User.currentUser?.email
        self.firstNameTxtFld.text = User.currentUser?.firstName
        self.lastNameTxtFld.text = User.currentUser?.lastName
        let isSubscriptionValid = Module.currentModule?.isSubscriptionValid ?? false
        if isSubscriptionValid{
            self.subsriptionImgView.image = #imageLiteral(resourceName: "check-1")
            self.subscriptionLabel.text = "Active (Premier)"
        }
        else{
            subsriptionButton.isUserInteractionEnabled = false
            self.subsriptionImgView.image = #imageLiteral(resourceName: "cross")
            self.subscriptionLabel.text = "Inactive - Subscribe here !"
            
        }
        if (Module.currentModule?.moduleType == 1) || (Module.currentModule?.moduleType == 2){
            self.subsriptionImgView.image = #imageLiteral(resourceName: "check - blue")
            self.subscriptionLabel.text = "No subscription needed"
        }

    }
    
    func updateUserName(fName:String, lName:String){
        User.updateAccount(lastName: lName, firstName: fName) {
            (error) in
        }
    }
    
    
    
    func getHubInfo(){
        User.currentUser?.getModule(completion: { (error) in
            
        })
    }
    
    @IBAction func subscriptionButtonClicked(){
        if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
   

}

extension AccountViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        self.updateUserName(fName: firstNameTxtFld.text ?? "", lName:  lastNameTxtFld.text ?? "")
    }
    
   
}




extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
