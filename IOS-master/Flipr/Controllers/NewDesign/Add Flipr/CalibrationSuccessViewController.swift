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
    @IBOutlet weak var titlLbl: UILabel!
    
    @IBOutlet weak var contentLine1Lbl: UILabel!
    @IBOutlet weak var contentLine2Lbl: UILabel!
    @IBOutlet weak var contentLine3Lbl: UILabel!
    @IBOutlet weak var contentLine4Lbl: UILabel!
    var recalibration = false

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.roundCorner(corner: 12)
        submitButton.setTitle("Suivant".localized, for: .normal)
        titlLbl.text  = "Étalonnage réussi".localized
        contentLine1Lbl.text  = "Dévissez le capuchon.".localized
        contentLine2Lbl.text  = "Jetez le liquide qui se trouve dedans, ainsi que le liquide précédemment conservé dans un récipient.".localized
        contentLine3Lbl.text  = "Vissez la grille (cache ajouré).".localized
        contentLine4Lbl.text  = "Placez Flipr dans votre bassin, directement dans l'eau.".localized
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
        /*
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: "PoolViewSettingsControllerID") as! PoolViewController
        viewController.isInitialPoolSetup = true
//        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
        */
                let sb = UIStoryboard(name: "PoolSettings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "PoolSettingsStartViewController") as! PoolSettingsStartViewController
                self.navigationController?.pushViewController(vc, animated: true)
    }

}
