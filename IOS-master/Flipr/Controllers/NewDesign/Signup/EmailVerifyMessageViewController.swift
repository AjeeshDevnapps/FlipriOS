//
//  EmailVerifyMessageViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 06/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class EmailVerifyMessageViewController: BaseViewController {
    @IBOutlet weak var verifiedMailButton: UIButton!
    @IBOutlet weak var checkEmailTitleLbl: UILabel!
    @IBOutlet weak var reenterButton: UIButton!
    @IBOutlet weak var openMailButton: UIButton!
    @IBOutlet weak var checkEmailMsgLbl: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var email: String!
    var password: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        verifiedMailButton.layer.cornerRadius = 12

        checkEmailTitleLbl.text = "Check your inbox!".localized
        reenterButton.setTitle("Reenter email".localized, for: .normal)
        openMailButton.setTitle("Open mail".localized, for: .normal)
        verifiedMailButton.setTitle("Verified".localized, for: .normal)

        let regularAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let boldAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)]
        let text = NSMutableAttributedString(string: "To confirm your email address, click on the button in the email we sent to".localized, attributes: regularAttrs)
        text.append(NSAttributedString(string: " "))
        text.append(NSAttributedString(string: email, attributes: boldAttrs))
        
        checkEmailMsgLbl.attributedText = text
        
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            
            self.verifyUserActivation()
        }
        openMailButton.layer.cornerRadius = 12
    }

    
    @IBAction func backAction(_ sender: UIButton) {
        goBack()
    }
    
    @IBAction func verifyButtonclicked (_ sender: UIButton) {
        verifyUserActivation()
    }
    
    @IBAction func reEnterEmail(_ sender: UIButton) {
        goBack()
//        self.navigationController?.popViewController()
//        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    @IBAction func openMail(_ sender: UIButton) {
        let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
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
            self.view.hideStateView()
            let darkTheme = EmptyStateViewTheme.shared
            darkTheme.titleColor = K.Color.DarkBlue
            darkTheme.messageColor = .lightGray
            
            if error == nil {
                if activated {
                    if let tempPassword = UserDefaults.standard.value(forKey: "TempPass") as? String, let currentUserEmail = UserDefaults.standard.value(forKey: "CurrentUserEmail") as? String {
                        self.view.showEmptyStateViewLoading(title: nil, message: nil, theme: theme)
                        User.signin(email: currentUserEmail, password: tempPassword) { error in
                            self.view.hideStateView()
                            if error == nil {
                                
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpProfileController") as! SignUpProfileController
                                self.navigationController?.pushViewController(viewController, animated: true)
                            } else {
                                self.showError(title: "Erreur", message: error?.localizedDescription)
                            }
                        }
                    }
                }else{
                    self.showError(title: "Erreur", message: "Oups, we're sorry but something went wrong :/".localized)
                }
            } else {
                self.showError(title: "Erreur", message: error?.localizedDescription)
            }
        }
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
