//
//  GatewaySuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh on 14/04/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD


class GatewaySuccessViewController: BaseViewController {
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var gatewayList:[UserGateway]?
    @IBOutlet weak var gwGifImageView: UIImageView!


    var serial:String?

    override func viewDidLoad() {
        self.hidCustombackbutton = true
        super.viewDidLoad()
        submitBtn.setTitle("Ok".localized, for: .normal)
        self.titleLabel.text = "Si la lumière passe au vert (Vraiment vert!), vous êtes connecté et votre Flipr Connect est prêt à recevoir des mesures Flipr! \n\nUn flash bleu intermittent indique que Flipr AnalysR est à portée.\n\nNe débranchez pas Flipr Connect. Les mesures sont exclusivement récupérées et transmises  par cette passerelle.\n\nSi vous changez de réseau Wifi, veuillez refaire la configuration à partir du menu Paramètres.\n".localized
        
        self.navigationItem.setHidesBackButton(true, animated: true)
//        let jeremyGif = UIImage.gifImageWithName("gwgif")
//        gwGifImageView.image = jeremyGif

        GatewayManager.shared.cancelGatewayConnection { error in

        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func okButtonClicked(_ sender: UIButton) {
        
        if AppSharedData.sharedInstance.isFlipr3{
            AppSharedData.sharedInstance.isFlipr3 = false
            showDashboard()
        }else{
            self.showSettingsView()
//            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)


        }

    }
    
    
    func showSettingsView(){
        getGatewayList()
    }
    
    func getGatewayList() {
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        User.currentUser?.getUserGateways(completion: { gateways, error in
            hud?.dismiss()
            self.gatewayList = gateways
            if self.gatewayList != nil && self.serial != nil{
                var selectedItem:UserGateway?
                for(_,item) in self.gatewayList!.enumerated(){
                    let serialNo = self.serial ?? ""
                    if serialNo == item.serial{
                        selectedItem = item
                    }
                }
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GatewaySettingsViewController") as? GatewaySettingsViewController {
                    vc.info = selectedItem
                    vc.isDirectSettings = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
           
        })
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