//
//  EmailVerifyMessageViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 06/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class EmailVerifyMessageViewController: UIViewController {

    @IBOutlet weak var checkEmailTitleLbl: UILabel!
    @IBOutlet weak var reenterButton: UIButton!
    @IBOutlet weak var openMailButton: UIButton!
    @IBOutlet weak var checkEmailMsgLbl: UILabel!
    
    var email: String!
    var password: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)

        checkEmailTitleLbl.text = "Check Email title".localized
        checkEmailMsgLbl.text = "Check Email message".localized + " " + email
        reenterButton.setTitle("Reenter email".localized, for: .normal)
        openMailButton.setTitle("Opem mail".localized, for: .normal)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            
            self.verifyUserActivation()
        }
        
        openMailButton.layer.cornerRadius = 12
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func reEnterEmail(_ sender: UIButton) {
    
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    @IBAction func openMail(_ sender: UIButton) {
//        let mailURL = URL(string: "message://")!
//           if UIApplication.shared.canOpenURL(mailURL) {
//               UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
//            }
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpProfileController") as! SignUpProfileController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func verifyUserActivation() {
        
        //TODO:
        //ici faire :
        // 1/ le readAccountActivation
        // 2/ ensuite signin pour avoir le token (dc sauvegarde du PWD)
        // 3/ puis GET ACCOUNT pour avoir bien toute les infos
        // !!!!! GENIAAAALLLL !!!!
        
        
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballScaleMultiple
        self.view.showEmptyStateViewLoading(title: nil, message: nil, theme: theme)
        
        User.isAccountActivated(email: email) { (activated, error) in
            
            let darkTheme = EmptyStateViewTheme.shared
            darkTheme.titleColor = K.Color.DarkBlue
            darkTheme.messageColor = .lightGray
            
            if error == nil {
                if activated {
                    
                    User.currentUser?.isActivated = true
                    User.saveCurrentUserLocally()
                    
                    User.signin(email: self.email, password: self.password, completion: { (error) in
                        if error == nil {
                            let hubStoryboard = UIStoryboard(name: "HUB", bundle: nil)
                            let viewController = hubStoryboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
                            self.navigationController?.pushViewController(viewController, animated: true)
                        } else {
                            self.showError(title: "Erreur", message: error?.localizedDescription)
                            self.view.showEmptyStateView(image: UIImage(named:"Email"), title: "Welcome ;-)".localized, message: "To validate your account, please click on the activation link that has just been sent to you at: ".localized + self.email, theme: darkTheme)
                        }
                    })
                    
                } else {
                    
                    self.view.showEmptyStateView(image: UIImage(named:"Email"), title: "Welcome ;-)".localized, message: "To validate your account, please click on the activation link that has just been sent to you at: ".localized + self.email, theme: darkTheme)
                }
            } else {
                self.showError(title: "Erreur", message: error?.localizedDescription)
                self.view.showEmptyStateView(image: UIImage(named:"Email"), title: "Welcome ;-)".localized, message: "To validate your account, please click on the activation link that has just been sent to you at: ".localized + self.email, theme: darkTheme)
            }
        }
        
        /*
        User.currentUser!.getAccount(completion: { (error) in
            if error == nil {
                if User.currentUser!.isActivated {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ActivationViewControllerID") {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                } else {
                    self.view.showEmptyStateView(image: UIImage(named:"Email"), title: "Welcome ;-)".localized, message: "To validate your account, please click on the activation link that has just been sent to you at: ".localized + User.currentUser!.email)
                }
            } else {
                self.showError(title: "Erreur", message: error?.localizedDescription)
                self.view.showEmptyStateView(image: UIImage(named:"Email"), title: "Welcome ;-)".localized, message: "To validate your account, please click on the activation link that has just been sent to you at: ".localized + User.currentUser!.email)
            }
        })
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
