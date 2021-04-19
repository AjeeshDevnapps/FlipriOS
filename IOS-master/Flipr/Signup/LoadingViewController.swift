//
//  LoadingViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 06/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            let verificationVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerifyMessageViewController") as! EmailVerifyMessageViewController
            verificationVC.email = self.email
            self.navigationController?.pushViewController(verificationVC)
        }
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
