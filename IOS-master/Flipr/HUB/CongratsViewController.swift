//
//  CongratsViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 24/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit

class CongratsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var otherDevicesButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    @IBAction func otherDevicesButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModuleTypeSelectionViewControllerID") as? ModuleTypeSelectionViewController {
            vc.allowBack = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: false)
        })
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
