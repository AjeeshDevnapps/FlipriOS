//
//  ActivationViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 18/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit

class ActivationViewController: UIViewController {
    
    @IBOutlet weak var serialTextField: UITextField!
    @IBOutlet weak var activationStackView: UIStackView!
    @IBOutlet weak var activationKeyTextField: UITextField!
    
    @IBOutlet weak var activationButton: UIButton!
    @IBOutlet weak var activationButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var preLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    var fromMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preLabel.text = "For more security, fill in your security key".localized;
        postLabel.text = "It is located inside the packaging".localized;
        serialTextField.placeholder = "Enter the serial number here".localized
        activationKeyTextField.placeholder = "Enter your key here".localized
        
        activationButton.setTitle("Ready to dive!".localized, for: .normal)
        
        
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .orbit
        theme.titleColor = K.Color.DarkBlue
        theme.messageColor = .lightGray
        self.view.showEmptyStateViewLoading(title: "Searching for flipr...".localized, message: "Be sure to be close to your Flipr and your Bluetooth is turned on.".localized, theme: theme)
        
        BLEManager.shared.startUpCentralManager(connectAutomatically: false, sendMeasure: false)
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDiscovered, object: nil, queue: nil) { (notification) in
            
            if let serial = notification.userInfo?["serial"] as? String {
                self.serialTextField.text = serial
                self.view.hideStateView()
                UIView.animate(withDuration: 0.25, animations: {
                    self.activationStackView.alpha = 1
                })
            }
            /*
            let theme = EmptyStateViewTheme.shared
            theme.activityIndicatorType = .ballZigZag
            self.view.showEmptyStateViewLoading(title: "Flipr détecté", message: "Connexion en cours...", theme: theme)
             */
        }
        
        /*
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprSerialRead, object: nil, queue: nil) { (notification) in
            
            if let serial = notification.userInfo?["serial"] as? String {
                self.serialLabel.text = "Flipr N°" + serial
                self.view.hideStateView()
                UIView.animate(withDuration: 0.25, animations: {
                    self.activationStackView.alpha = 1
                })
            }
        }
        */
        
        activationStackView.alpha = 0
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func activationButtonAction(_ sender: Any) {
        
        guard let activationKey = activationKeyTextField.text else {
            return
        }
        
        if activationKey.characters.count == 0 {
            showError(title: "Error".localized, message: "Invalid security key format".localized)
        } else {
            
            self.activationKeyTextField.resignFirstResponder()
            self.serialTextField.resignFirstResponder()
            
            activationButtonWidthConstraint.constant = 44
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
                
                self.activationButton.showActivityIndicator(type: .ballClipRotatePulse)
                
                Module.activate(serial:self.serialTextField.text!, activationKey: activationKey, completion: { (error) in
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    } else {
                    
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                            viewController.calibrationType = .ph7
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
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

    @IBAction func backButtonAction(_ sender: Any) {
        if fromMenu {
            BLEManager.shared.centralManager.stopScan()
            dismiss(animated: true, completion: nil)
        } else {
            User.logout()
            BLEManager.shared.centralManager.stopScan()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    


}
