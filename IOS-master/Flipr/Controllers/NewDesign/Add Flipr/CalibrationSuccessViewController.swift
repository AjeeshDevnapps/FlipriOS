//
//  CalibrationSuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class CalibrationSuccessViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    var recalibration = false

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.roundCorner(corner: 12)

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func nextButton(_ sender: UIButton) {
        showPoolSettings()
        return
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballZigZag
        self.view.showEmptyStateViewLoading(title: "Launch of the 1st measure".localized, message: "Connecting to flipr...".localized, theme: theme)
        
        BLEManager.shared.startMeasure { (error) in
            
            BLEManager.shared.doAcq = false
            
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                self.view.hideStateView()
            }
            else {
                UserDefaults.standard.set(Date(), forKey:"FirstMeasureStartDate")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
                dashboard.modalTransitionStyle = .flipHorizontal
                dashboard.modalPresentationStyle = .fullScreen
                self.present(dashboard, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                })
//                if let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewControllerID") {
//                    dashboard.modalTransitionStyle = .flipHorizontal
//                    dashboard.modalPresentationStyle = .fullScreen
//                    self.present(dashboard, animated: true, completion: {
//                        self.navigationController?.popToRootViewController(animated: false)
//                    })
//                }
            }
        }
    }
    
    func showPoolSettings(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: "PoolViewSettingsControllerID") as! PoolViewController
        viewController.isInitialPoolSetup = true
//        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
        //        let sb = UIStoryboard(name: "PoolSettings", bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewController") as! PoolSettingsStartViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
    }

}
