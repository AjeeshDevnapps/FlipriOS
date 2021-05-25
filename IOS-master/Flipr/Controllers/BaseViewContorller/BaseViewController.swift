//
//  BaseViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var backButtonTitle = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor.init(hexString: "#F2F9FE")
        self.setCustomBackButton()
        // Do any additional setup after loading the view.
    }
    
     func setCustomBackButton() {
//        if self.navigationController != nil{
//            self.navigationController?.navigationBar.tintColor = UIColor.init(hexString: "#111729")
//            navigationItem.backBarButtonItem = UIBarButtonItem(
//                title: backButtonTitle, style: .plain, target: nil, action: nil)
//        }
//
        let backImage = UIImage(named: "chevron-left")

        self.navigationController?.navigationBar.backIndicatorImage = backImage

        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage

        /*** If needed Assign Title Here ***/
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: backButtonTitle, style:.plain, target: self, action:#selector(backButtonTapped))
    }
    
    
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }

   
}
