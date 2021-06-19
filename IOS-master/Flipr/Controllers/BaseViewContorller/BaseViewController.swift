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
    let imageView = UIImageView(image: UIImage(named: "bkWaves.pdf"))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor.init(hexString: "#F2F9FE")
        imageView.frame = CGRect(x: 0, y: self.view.height - 316, width: self.view.frame.width, height: 316)
        view.addSubview(imageView)
        setCustomBackButton()

        // Do any additional setup after loading the view.
    }
    
     func setCustomBackButton() {
//        if self.navigationController != nil{
//            self.navigationController?.navigationBar.tintColor = UIColor.init(hexString: "#111729")
//            navigationItem.backBarButtonItem = UIBarButtonItem(
//                title: backButtonTitle, style: .plain, target: nil, action: nil)
//        }
////
//        let backImage = UIImage(named: "chevron-left")
//
//        self.navigationController?.navigationBar.backIndicatorImage = backImage
//
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
//
//        /*** If needed Assign Title Here ***/
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: backButtonTitle, style:.plain, target: self, action:#selector(backButtonTapped))
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_back-1"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    
    @objc func backButtonTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }

   
}
