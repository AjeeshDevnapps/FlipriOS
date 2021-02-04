//
//  LandingViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 16/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Welcome to the Flipr family!".localized()
        subtitleLabel.text = "Let's setup your first device!".localized()
        
        doneButton.setTitle("Let's go!".localized(), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModuleTypeSelectionViewControllerID") {
            self.navigationController?.pushViewController(vc, animated: true)
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
