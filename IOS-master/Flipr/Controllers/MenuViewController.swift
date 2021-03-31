//
//  MenuViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 25/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import SideMenu
import SafariServices
import JGProgressHUD

class MenuViewController: UITableViewController {

    @IBOutlet weak var fliprNameLabel: UILabel!
    @IBOutlet weak var batteryLevelLabel: UILabel!
    @IBOutlet weak var batteryImageView: UIImageView!
    @IBOutlet weak var addFliprStartButton: UIButton!
    
    @IBOutlet weak var pooLogLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var subscriptionImageView2: UIImageView!
    @IBOutlet weak var actionsLabel: UILabel!
    @IBOutlet weak var myPoolLabel: UILabel!
    @IBOutlet weak var myEquipmentsLabel: UILabel!
    @IBOutlet weak var myStockLabel: UILabel!
    @IBOutlet weak var tipsAndAdviceLabel: UILabel!
    @IBOutlet weak var supportAndFAQLabel: UILabel!
    @IBOutlet weak var reviewFormLabel: UILabel!
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    @IBOutlet weak var photoHeaderImageView: UIImageView!

    
    var expandMoreCells = false
    let hud = JGProgressHUD(style:.dark)

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if Module.currentModule == nil {
            addFliprStartButton.isHidden = false
            batteryLevelLabel.isHidden = true
            batteryImageView.isHidden = true
        } else {
//            addFliprStartButton.isHidden = true
            batteryLevelLabel.isHidden = false
            batteryImageView.isHidden = false
        }
        Pool.currentPool?.getShopUrl()
        
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: SideMenuManager.default.menuWidth, height: 20))
        statusBarView.backgroundColor = K.Color.DarkBlue
        self.navigationController?.view.addSubview(statusBarView)
        
        let footerView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 80, width: SideMenuManager.default.menuWidth, height: 80))
        footerView.backgroundColor = K.Color.DarkBlue
        self.navigationController?.view.addSubview(footerView)
        
        
        let footerLogoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SideMenuManager.default.menuWidth, height: 50))
        footerLogoImageView.contentMode = .scaleAspectFit
        footerLogoImageView.image = UIImage(named:"logoMenu")
        if let module = Module.currentModule {
            if module.isForSpa {
                myPoolLabel.text = "Spa".localized
                footerLogoImageView.image = UIImage(named:"logoMenu_spa")
            }
        }
        footerView.addSubview(footerLogoImageView)
        
        let footerVersionLabel = UILabel(frame: CGRect(x: 0, y: 50, width: SideMenuManager.default.menuWidth, height: 30))
        footerVersionLabel.text = "Version".localized + " \(Bundle.main.releaseVersionNumber ?? "")(\(Bundle.main.buildVersionNumber ?? ""))"
        footerVersionLabel.font = UIFont.systemFont(ofSize: 13)
        footerVersionLabel.textAlignment = .center
        footerVersionLabel.textColor = .lightText
        footerView.addSubview(footerVersionLabel)
        
        tableView.contentInset =  UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        
        pooLogLabel.text = "Service book".localized
        moreLabel.text = "More".localized
        historyLabel.text = "History".localized
        actionsLabel.text = "Actions".localized
        myPoolLabel.text = "My pool".localized
        if let module = Module.currentModule {
            if module.isForSpa {
                myPoolLabel.text = "My spa".localized
                photoHeaderImageView.image = UIImage(named:"photo_SPA")
            }
            if module.isSubscriptionValid {
                subscriptionImageView.isHidden = true
                subscriptionImageView2.isHidden = true
            } else {
                subscriptionImageView.isHidden = true
                subscriptionImageView2.isHidden = false
            }
        }
        myEquipmentsLabel.text = "My equipments".localized
        myStockLabel.text = "My stock".localized
        tipsAndAdviceLabel.text = "Tips and advice".localized
        supportAndFAQLabel.text = "Support and FAQ".localized
        reviewFormLabel.text = "Share your opinion!".localized
        termsAndPrivacyLabel.text = "Terms and privacy".localized
        logoutLabel.text = "Log out".localized
        
//        if let name = Module.currentModule?.nickName {
//            self.batteryLevelLabel.isHidden = false
//            batteryLevelLabel.text = name
//        }
        
//        if let moduleType = Module.currentModule?.moduleType {
//            if moduleType == 1{
//                fliprNameLabel.text = "Flipr"
//            }else{
//                fliprNameLabel.text = "Hub"
//            }
//        }
     /*
        if let level = UserDefaults.standard.object(forKey: "BatteryLevel") as? String, Module.currentModule != nil {
            self.batteryLevelLabel.text = level + "%"
            self.batteryLevelLabel.isHidden = false
        } else {
            self.batteryLevelLabel.isHidden = true
        }
        */
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprBatteryDidRead, object: nil, queue: nil) { (notification) in
            if let level = UserDefaults.standard.object(forKey: "BatteryLevel") as? String, Module.currentModule != nil {
//                self.batteryLevelLabel.text = level + "%"
//                self.batteryLevelLabel.isHidden = false
            } else {
//                self.batteryLevelLabel.isHidden = true
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if AppSharedData.sharedInstance.isNeedtoCallModulesApiForSideMenu{
            self.getDeviceDetails()
        }else{
            self.fliprNameLabel.text = AppSharedData.sharedInstance.serialKey
            self.batteryLevelLabel.text = AppSharedData.sharedInstance.deviceName
        }
    }
    
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDeviceDetails(){
        hud?.show(in: self.navigationController!.view)
        User.currentUser?.getModuleList(completion: { (devices,error) in
//                self.devicesDetails = devices
//            self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
//            self.hud?.textLabel.text = error?.localizedDescription
            self.hud?.dismiss()
            if let deviceInfo = devices?.first{
                AppSharedData.sharedInstance.isNeedtoCallModulesApiForSideMenu = false
                if let name = deviceInfo["Serial"] as? String  {
                    self.fliprNameLabel.text = name
                    AppSharedData.sharedInstance.serialKey = self.fliprNameLabel.text ?? ""
                }
                if let moduleType = deviceInfo["ModuleType_Id"] as? Int  {
                    if moduleType == 1{
                        self.batteryLevelLabel.text = "Flipr"
                        if let info = deviceInfo["CommercialType"] as? [String: AnyObject] {
                            if let type = info["Value"] as? String  {
                                self.batteryLevelLabel.text?.append(" ")
                                if type == "Pro" {
                                    self.batteryLevelLabel.text = "Start MAX"
                                }else{
                                    self.batteryLevelLabel.text?.append(type)
                                }
                            }
                        }
                        AppSharedData.sharedInstance.deviceName = self.batteryLevelLabel.text ?? ""
                    }else{
                        self.batteryLevelLabel.text = "Flipr"
                        AppSharedData.sharedInstance.deviceName = "Flipr"
                    }
                }
            }
           
        })
        
    }
    
    @IBAction func addFliprStartButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationViewControllerID") as? ActivationViewController {
            vc.fromMenu = true
            let navC = UINavigationController(rootViewController: vc)
            navC.setNavigationBarHidden(true, animated: false)
            navC.modalPresentationStyle = .fullScreen
            //navC.modalTransitionStyle = .flipHorizontal
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let bgColorView = UIView()
//        bgColorView.backgroundColor = K.Color.LightBlue
        bgColorView.backgroundColor = .white
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if Module.currentModule == nil {
            if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 {
                return 0
            }
        }
        
        if indexPath.row > 8 && !expandMoreCells && indexPath.row < 14 {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            /*
            if let module = Module.currentModule {
                if !module.isSubscriptionValid {
                    if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    return
                }
            }*/
            if let vc = UIStoryboard(name: "PoolLog", bundle: nil).instantiateInitialViewController() {
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
        
        else  if indexPath.row == 3 {
            let eqpsVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsAndEquipmentsViewController") as! ProductsAndEquipmentsViewController
            let navigationController = UINavigationController.init(rootViewController: eqpsVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        else if indexPath.row == 5 {
            let navigationController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigation") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        else if indexPath.row == 6 {
            let navigationController = UIStoryboard(name:"SideMenuViews", bundle: nil).instantiateViewController(withIdentifier: "HelpNavigation") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        
        
//
        
        if indexPath.row == 4 {
            if let pool = Pool.currentPool {
                if let url = URL(string: pool.shopUrl) {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                    self.present(vc, animated: true)
                }
            } else if let url = URL(string: "SHOP_URL".localized.remotable) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                self.present(vc, animated: true)
            }
        }
        
        if indexPath.row == 8 {
            expandMoreCells = !expandMoreCells
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            if expandMoreCells {
                UIView.animate(withDuration: 0.25, animations: {
                    
                }) { (success) in
                    self.tableView.scrollToRow(at: IndexPath(row: 11, section: 0), at: .top, animated: true)
                }
            }
            
        }
        
       
        
        if indexPath.row == 9 {
            if let url = URL(string: "BLOG_URL".localized.remotable) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                self.present(vc, animated: true)
            }
        }
        
        if indexPath.row == 10 {
            if let url = URL(string: "HELP_DESK_URL".localized.remotable) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                self.present(vc, animated: true)
            }
        }
        
        if indexPath.row == 11 {
            if let url = URL(string: "https://flipr.typeform.com/to/xxpSErRw") {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(vc, animated: true)
            }
        }
        
        if indexPath.row == 12 {
            if let url = URL(string: "CGU_URL".localized.remotable) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(vc, animated: true)
            }
        }
        
        if indexPath.row == 13 {
            let alertController = UIAlertController(title: "LOGOUT_TITLE".localized, message: "Are you sure you want to log out?".localized, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
            
            let okAction = UIAlertAction(title: "Log out".localized, style: UIAlertAction.Style.destructive)
            {
                (result : UIAlertAction) -> Void in
                print("You pressed OK")
                
                self.dismiss(animated: true, completion: { 
                    NotificationCenter.default.post(name: K.Notifications.UserDidLogout, object: nil)
                })
                
                User.logout()
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        /*
        if indexPath.row == 6 {
            
            let alertController = UIAlertController(title: "Suppression", message: "Voulez-vous vraiment supprimer ce module Flipr de votre compte ?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction =  UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel)
            
            let okAction = UIAlertAction(title: "Supprimer", style: UIAlertActionStyle.destructive)
            {
                (result : UIAlertAction) -> Void in
                print("You pressed OK")
                
                Module.deleteCurrentModule(completion: { (error) in
                    if error != nil {
                        self.showError(title: "Erreur", message: error?.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
         
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if indexPath.row == 7 {
            let alertController = UIAlertController(title: "Déconnexion", message: "Voulez-vous vraiment vous déconnecter ?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction =  UIAlertAction(title: "Annuler", style: UIAlertActionStyle.cancel)
            
            let okAction = UIAlertAction(title: "Se déconnecter", style: UIAlertActionStyle.destructive)
            {
                (result : UIAlertAction) -> Void in
                print("You pressed OK")
                
                self.dismiss(animated: true, completion: nil)
                
                User.logout()
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
         */
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "predict" {
            if let module = Module.currentModule {
                if !module.isSubscriptionValid {
                    if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    return false
                }
            }
        }
        return true
    }

}
