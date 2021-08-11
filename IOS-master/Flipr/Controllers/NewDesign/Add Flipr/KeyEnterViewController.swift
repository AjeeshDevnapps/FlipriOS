//
//  KeyEnterViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 25/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class KeyEnterViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var otpTextField5: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var serialTitleLabel: UILabel!

    
    
    let grayBorder = UIColor.init(hexString: "#E3E8EF").cgColor
    let blackBorder = UIColor.init(hexString: "#111729").cgColor
    var serialKey: String!
    var flipType: String!
    var activationKey = ""
    var isHub = false
    var equipmentCode:String!
    var fliprAddingError = false
    var isSignupFlow = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI(){
        
        titleLabel.text = "Renseignez la clé de sécurité de votre Flipr Start".localized
        subTitleLabel.text = "La clé de sécurité à 5 chiffres (Key) se trouve à l'intérieur de la boîte de votre Flipr Start.".localized
        serialTitleLabel.text = "Clé de sécurité (Key)".localized

        
        submitButton.isUserInteractionEnabled = false
        if isHub{
            submitButton.setTitle("Connecter Flipr Hub".localized(), for: .normal)
        }else{
            submitButton.setTitle("Connecter Flipr Start".localized(), for: .normal)
        }

        otpTextField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTextField5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        otpTextField1.addTarget(self, action: #selector(self.didBeginEdit(textField:)), for: UIControl.Event.editingDidBegin)
        otpTextField2.addTarget(self, action: #selector(self.didBeginEdit(textField:)), for: UIControl.Event.editingDidBegin)
        otpTextField3.addTarget(self, action: #selector(self.didBeginEdit(textField:)), for: UIControl.Event.editingDidBegin)
        otpTextField4.addTarget(self, action: #selector(self.didBeginEdit(textField:)), for: UIControl.Event.editingDidBegin)
        otpTextField5.addTarget(self, action: #selector(self.didBeginEdit(textField:)), for: UIControl.Event.editingDidBegin)

        
        self.setIntialSetup(textField: otpTextField1)
        self.setIntialSetup(textField: otpTextField2)
        self.setIntialSetup(textField: otpTextField3)
        self.setIntialSetup(textField: otpTextField4)
        self.setIntialSetup(textField: otpTextField5)
        submitButton.roundCorner(corner: 12)
    }

    
    func setIntialSetup(textField:UITextField){
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor =  grayBorder
    }
    
    @objc override func backButtonTapped() {
        if fliprAddingError{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func blackborder(textField:UITextField){
        textField.layer.borderColor =  blackBorder
        if otpTextField1 != textField{
            otpTextField1.layer.borderColor =  grayBorder
        }
        if otpTextField2 != textField{
            otpTextField2.layer.borderColor =  grayBorder
        }
        if otpTextField3 != textField{
            otpTextField3.layer.borderColor =  grayBorder
        }
        if otpTextField4 != textField{
            otpTextField4.layer.borderColor =  grayBorder
//            otpTextField4.layer.borderWidth = 1
        }
        if otpTextField5 != textField{
            otpTextField5.layer.borderColor =  grayBorder
        }
    }
    
    @objc func didBeginEdit(textField: UITextField){
        self.blackborder(textField: textField)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField5.becomeFirstResponder()
            case otpTextField5:
                otpTextField5.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case otpTextField1:
                otpTextField1.becomeFirstResponder()
//                self.blackborder(textField: otpTextField1)
            case otpTextField2:
                otpTextField1.becomeFirstResponder()
//                self.blackborder(textField: otpTextField1)
            case otpTextField3:
                otpTextField2.becomeFirstResponder()
//                self.blackborder(textField: otpTextField2)
            case otpTextField4:
                otpTextField3.becomeFirstResponder()
//                self.blackborder(textField: otpTextField3)
            case otpTextField5:
                otpTextField4.becomeFirstResponder()
//                self.blackborder(textField: otpTextField4)
            default:
                break
            }
        }
        
        let otp1 = otpTextField1.text ?? ""
        let otp2 = otpTextField2.text ?? ""
        let otp3 = otpTextField3.text ?? ""
        let otp4 = otpTextField4.text ?? ""
        let otp5 = otpTextField5.text ?? ""

        guard !otp1.isEmpty, !otp2.isEmpty, !otp3.isEmpty, !otp4.isEmpty, !otp5.isEmpty else {
            submitButton.backgroundColor =  #colorLiteral(red: 0.5333333333, green: 0.5450980392, blue: 0.5803921569, alpha: 1)
            return
        }
        activationKey.append(otp1)
        activationKey.append(otp2)
        activationKey.append(otp3)
        activationKey.append(otp4)
        activationKey.append(otp5)
        self.setIntialSetup(textField: otpTextField1)
        self.setIntialSetup(textField: otpTextField2)
        self.setIntialSetup(textField: otpTextField3)
        self.setIntialSetup(textField: otpTextField4)
        self.setIntialSetup(textField: otpTextField5)
        submitButton.isUserInteractionEnabled = true
        submitButton.backgroundColor =  #colorLiteral(red: 0.06643301994, green: 0.08944996446, blue: 0.162193656, alpha: 1)
    }
    
    
    @IBAction func activate() {
        
        if activationKey.count == 0 {
            showError(title: "Error".localized, message: "Invalid security key format".localized)
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                if self.isHub{
                    self.activateHub()
                }else{
                    self.activateFlipr()
                }
            }
        }
    }
    
    
    func activateFlipr(){
        self.submitButton.showActivityIndicator(type: .ballClipRotatePulse)
        Module.activate(serial:self.serialKey, activationKey: self.activationKey, completion: { (error) in
            self.submitButton.hideActivityIndicator()
            if error != nil {
                self.fliprAddingError = true
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            } else {
                self.showSuccessScreen()
            }
        })
    }
    
    
    func activateHub(){
        self.equipmentCode = "\(AppSharedData.sharedInstance.selectedEquipmentCode)"
        self.submitButton.showActivityIndicator(type: .ballClipRotatePulse)
        HUB.activate(serial:self.serialKey, activationKey: activationKey, equipmentCode: self.equipmentCode, completion: { (error) in
            if error != nil {
                self.fliprAddingError = true
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            } else {
                self.showSuccess(title: nil, message: nil)
                
                let sb = UIStoryboard(name: "HUBDevicePairing", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "WifiListViewController") as! WifiListViewController
                vc.serial = self.serialKey
                self.navigationController?.pushViewController(vc)
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
//                    viewController.serial = self.serialKey
//                    self.navigationController?.pushViewController(viewController, animated: true)
//                }
            }
            
            self.submitButton.hideActivityIndicator()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            
        })

    }
    
    
    func showSuccessScreen(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FliprActivationSuccessViewController") as? FliprActivationSuccessViewController{
            self.navigationController?.pushViewController(vc)
        }
    }
    
}

