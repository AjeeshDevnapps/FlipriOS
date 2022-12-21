//
//  CreatePlaceViewController.swift
//  Flipr
//
//  Created by Ajeesh on 21/12/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class CreatePlaceViewController: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    let hud = JGProgressHUD(style:.dark)
    var poolSettings: PoolSettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPlace()
        // Do any additional setup after loading the view.
    }
    
    
    func createPlace(){
        hud?.show(in: self.view)
        User.currentUser?.createPlace( completion: { (settings,error) in
            if (error != nil) {
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud?.textLabel.text = error?.localizedDescription
                self.hud?.dismiss(afterDelay: 3)
            } else {
                self.hud?.dismiss(afterDelay: 0)
                self.poolSettings = settings
                self.showAddDeviceScreen()
            }
        })
    }
    
    

    func showAddDeviceScreen(){
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddDeviceListViewController") as? AddDeviceListViewController {
            navigationController?.pushViewController(viewController)
        }
    }
   

}
