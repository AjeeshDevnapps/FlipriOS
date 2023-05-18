//
//  GatewaySuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh on 14/04/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class GatewaySuccessViewController: BaseViewController {
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        self.hidCustombackbutton = true
        super.viewDidLoad()
        submitBtn.setTitle("Ok".localized, for: .normal)
        self.titleLabel.text = "Si la lumière passe au vert, vous êtes connecté!".localized
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        GatewayManager.shared.cancelGatewayConnection { error in

        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func okButtonClicked(_ sender: UIButton) {
        
        if AppSharedData.sharedInstance.isFlipr3{
            AppSharedData.sharedInstance.isFlipr3 = false
            showDashboard()
        }else{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)

        }

    }
    

    func showDashboard(){
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
    
}
