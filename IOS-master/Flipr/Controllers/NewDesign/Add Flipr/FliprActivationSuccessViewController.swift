//
//  FliprActivationSuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 25/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class FliprActivationSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButtonClicked() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
//            vc.serialKey = serialKey
//            vc.flipType = flipType
//            self.navigationController?.pushViewController(vc)
        }
    }


}
