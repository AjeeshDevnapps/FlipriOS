//
//  EmailVerificationViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit

class EmailVerificationViewController: UIViewController {
    
    var email:String!
    var password:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        if email == nil {
            if let value = UserDefaults.standard.value(forKey: "CurrentUserEmail") as? String {
                email =  value
            }
        }
        if password == nil {
            if let value = UserDefaults.standard.value(forKey: "CurrentUserPassword") as? String {
                password = value
            }
        }
        */
        
        //Au cas où l'app crash :/
        //verifyUserActivation()

        
        self.view.showEmptyStateView(image: UIImage(named:"Email"), title: "Welcome ;-)".localized, message: "To validate your account, please click on the activation link that has just been sent to you at: ".localized + email)
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            
            self.verifyUserActivation()
        }
        
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
