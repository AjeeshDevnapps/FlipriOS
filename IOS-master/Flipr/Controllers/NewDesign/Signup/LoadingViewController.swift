//
//  LoadingViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 06/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {

    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballSpinFadeLoader
        theme.activityIndicatorColor = .black
        self.view.showEmptyStateViewLoading(title: nil,
                                            message: nil,
                                            theme: theme)
        
        self.invokeUserCreation()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            let verificationVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerifyMessageViewController") as! EmailVerifyMessageViewController
//            verificationVC.email = self.email
//            self.navigationController?.pushViewController(verificationVC)
//        }
    }
    
    func invokeUserCreation() {
        User.signup(email: email) { error in
            if error == nil {
                let verificationVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerifyMessageViewController") as! EmailVerifyMessageViewController
                verificationVC.email = self.email
                self.navigationController?.pushViewController(verificationVC, completion: {
                    if let index = self.navigationController?.viewControllers.index(of: self) {
                        self.navigationController?.viewControllers.remove(at: index)
                    }
                })
            } else {
                self.showAlert(title: "Error".localized, message: error?.localizedDescription) { _ in
                    self.navigationController?.popViewController()
                }
            }
        }
    }

}
