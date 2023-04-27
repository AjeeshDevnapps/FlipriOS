//
//  ChangeDelayViewController.swift
//  Flipr
//
//  Created by Ajeesh on 27/04/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class ChangeDelayViewController: UIViewController {
    @IBOutlet weak var valueTextFld: UITextField!
//    @IBOutlet weak var titleVC: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Delay"
        if let curretnValue = UserDefaults.standard.string(forKey: "DelayTime") {
            valueTextFld.placeholder = "\(curretnValue)"
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func submitAction(_ sender: UIButton) {
        var value = 0
        if let intValStr = valueTextFld.text {
            if intValStr.isValidString{
                value = Int(intValStr) ?? 0
            }
        }
        UserDefaults.standard.set(value, forKey: "DelayTime")
        self.dismiss(animated: true)
    }
    

}
