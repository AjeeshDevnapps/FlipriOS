//
//  HUBActivationViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 05/03/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit

class HUBActivationViewController: UIViewController {
    
    var serial:String!
    var equipmentCode:String!
    
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var activationKeyTextField: UITextField!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activationButton: UIButton!
    @IBOutlet weak var activationButtonWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Authentification"
        self.infoLabel.text = "The key, preceded by 'ID' is inside one of the two removable covers.".localized
        self.serialLabel.text = "S/N : \(serial ?? "Unknown")"
        
    }
    
    
    @IBAction func activationButtonAction(_ sender: Any) {
        
        guard let activationKey = activationKeyTextField.text else {
            return
        }
        
        
        
        if activationKey.characters.count == 0 {
            showError(title: "Error".localized, message: "Invalid security key format".localized)
        } else {
            
            self.activationKeyTextField.resignFirstResponder()
            
            activationButtonWidthConstraint.constant = 44
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                
                self.activationButton.showActivityIndicator(type: .ballClipRotatePulse)
                
                HUB.activate(serial:self.serial, activationKey: activationKey, equipmentCode: self.equipmentCode, completion: { (error) in
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    } else {
                        self.showSuccess(title: nil, message: nil)
                        
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
                            viewController.serial = self.serial
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                        
                        /*
                        HUBManager.shared.connect(serial: self.serial) { (error) in
                            if error == nil {
                                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
                                    viewController.serial = self.serial
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                            } else {
                                self.showError(title: "Error".localized, message: error?.localizedDescription)
                            }
                        }*/
                    }
                    
                    self.activationButton.hideActivityIndicator()
                    self.activationButtonWidthConstraint.constant = 200
                    UIView.animate(withDuration: 0.25, animations: {
                        self.view.layoutIfNeeded()
                    })
                    
                })
            }

            
        }
        
    }
    
    @IBAction func connectButtonAction(_ sender: Any) {
        
        
        /*
        
        if HUBManager.shared.connectedHub != nil {
            HUBManager.shared.cancelHubConnection { (error) in
                if error == nil {
                    self.connectButton.setTitle("Connect", for: .normal)
                }
            }
        } else {
            if let serial = self.serial {
                HUBManager.shared.connect(serial: serial) { (error) in
                    if error == nil {
                        self.connectButton.setTitle("Disconnect", for: .normal)
                    }
                }
            }
        }
        */
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
