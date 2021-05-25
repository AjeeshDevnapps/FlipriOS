//
//  ModuleTypeSelectionViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 16/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit

class ModuleTypeSelectionViewController: UIViewController {
    
    var allowBack = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if allowBack {
            navigationController?.popViewController(animated: true, nil)
        } else {
            User.logout()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func hubButtonAction(_ sender: Any) {
           if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HubTypeSelectionViewControllerID") {
               self.navigationController?.pushViewController(vc, animated: true)
           }
           
       }
    
    @IBAction func startButtonAction(_ sender: Any) {
        let fliprStoryboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddFliprViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
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
