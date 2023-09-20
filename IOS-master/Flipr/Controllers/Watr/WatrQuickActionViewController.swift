//
//  WatrQuickActionViewController.swift
//  Flipr
//
//  Created by Ajeesh on 09/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import SafariServices

class WatrQuickActionViewController: UIViewController {
    
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    
    @IBOutlet weak var subScriptiontitleLbl: UILabel!
    @IBOutlet weak var subScriptionView: UIView!
    @IBOutlet weak var subScriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tapView: UIView!

    var isShowSubscription = false
    var haveFlipr = false
    var haveHub = false
    
    let hud = JGProgressHUD(style:.dark)
    
    var cellTitleList = [String]()
    var imageNames = [String]()
    
    var isPlaceOwner = false
    var haveSubscription = false
    var placeDetails:PlaceDropdown!
    var placesModules:PlaceModule!
    var isV3 = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "Quick Actions".localized
        
        if let identifier = Module.currentModule?.serial {
            var infoStr = AppSharedData.sharedInstance.userInfoTitle
            infoStr.append(" | FID: ")
            infoStr.append("\(identifier)")
            self.subTitleLbl.text = infoStr
        }
        
        //        self.menuView.roundCorners([.topLeft, .topRight], radius: 14.0)
        menuView.layer.cornerRadius = 14
        menuView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        settingTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)
        //        settingTable.tableFooterView = UIView()
        //        settingTable.tableFooterView = UIView(frame: CGRect(x: 0, y: -1, width: settingTable.frame.size.width, height: 1))
        //        getDeviceDetails()
        self.arrangeMenu()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    func showGatewayListing(){
        if let vc = UIStoryboard(name: "Gateway", bundle: nil).instantiateViewController(withIdentifier: "GateWayListingViewController") as? GateWayListingViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeButtonAction(){
        self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func subscriptionButtonAction(){
        if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func arrangeMenu(){
        createMenuOrder()
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }, completion: nil)
    }
    
    
    func createMenuOrder(){
        if self.placeDetails.permissionLevel == "Admin"{
            isPlaceOwner = true
        }else{
            isPlaceOwner = false
        }
        
        if let module = Module.currentModule {
            if let identifier = Module.currentModule?.serial {
                
                //                    self.titleLbl.text = identifier
                if identifier.isValidString{
                    self.haveFlipr = true
                    if identifier.hasPrefix("F"){
                        isV3 = true
                    }else{
                        isV3 = false
                    }
                    
                }
            }
            
            if module.isSubscriptionValid {
                haveSubscription = true
            }else{
                if let identifier = Module.currentModule?.serial {
                    if identifier.hasPrefix("F"){
                        haveSubscription = true
                    }else{
//                        haveSubscription = false
                    }
                }
            }
        }
        
   
//        haveFlipr = false
        if haveFlipr{
            //            haveSubscription = true
            if isPlaceOwner {
                if isV3{
                    self.cellTitleList = ["Entrée manuelle".localized,  "Flipr AI".localized,
                                          "Vue Expert".localized]
                    self.imageNames = ["Entrée manuelle (DipR)","AI", "Vue Expert"]
                    self.menuViewHeight.constant = 340
                }
                else{
                    if haveSubscription{
                        self.cellTitleList = ["Entrée manuelle".localized,"Flipr AI".localized,"Vue Expert".localized]
                        self.imageNames = ["Entrée manuelle (DipR)","AI","Vue Expert"]
                        self.menuViewHeight.constant = 340
                    }else{
                        self.cellTitleList = ["Activer la connexion à distance".localized,
                                              "Flipr AI".localized,"Vue Expert".localized]
                        self.imageNames = ["noSubscription","AI","Vue Expert"]
                        self.menuViewHeight.constant = 360
                    }
                }
            }else{
                self.cellTitleList = ["Buy Flipr AnalysR".localized,"Flipr AI".localized,"Vue Expert".localized]
                self.imageNames = ["buy","AI","Vue Expert"]
                self.menuViewHeight.constant = 270
            }
            
        }
        else{
            self.cellTitleList = [ "Buy Flipr AnalysR".localized,"Flipr AI".localized]
            self.imageNames = ["buy","AI"]
            self.menuViewHeight.constant = 264
        }
        self.settingTable.reloadData()
    }
    
}


extension WatrQuickActionViewController: UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = cellTitleList[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = cellTitleList.remove(at: sourceIndexPath.row)
        cellTitleList.insert(mover, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellTitleList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier:"MenuTableViewCell",
                                                  for: indexPath) as! MenuTableViewCell
        
        cell.menuTitleLbl.text = cellTitleList[indexPath.row]
        cell.menuIcon.image =  UIImage(named: imageNames[indexPath.row])
        if cellTitleList.count  == (indexPath.row + 1){
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width);
        }else{
            
        }
        
        
        if haveFlipr{
            
            if isPlaceOwner {
                if isV3{
                    if indexPath.row == 0{
                        cell.disableView.isHidden = false
                        cell.comingSoonLbl.isHidden = false
                    }
                    else if indexPath.row == 1{
                        cell.disableView.isHidden = false
                        cell.comingSoonLbl.isHidden = false
                    }
                    else{
                        cell.disableView.isHidden = true
                        cell.comingSoonLbl.isHidden = true
                    }
                }
                else{
                    if haveSubscription{
                        if indexPath.row == 0 || indexPath.row == 1{
                            cell.disableView.isHidden = false
                            cell.comingSoonLbl.isHidden = false
                        }else{
                            cell.disableView.isHidden = true
                            cell.comingSoonLbl.isHidden = true
                        }
                    }else{
                        if indexPath.row == 1{
                            cell.disableView.isHidden = false
                            cell.comingSoonLbl.isHidden = false
                        }else{
                            cell.disableView.isHidden = true
                            cell.comingSoonLbl.isHidden = true
                        }
                    }
                }
            }else{
                
                if indexPath.row == 1{
                    cell.disableView.isHidden = false
                    cell.comingSoonLbl.isHidden = false
                }else{
                    cell.disableView.isHidden = true
                    cell.comingSoonLbl.isHidden = true
                }
                
            }
            
        }
        else{
            if indexPath.row == 1{
                cell.disableView.isHidden = false
                cell.comingSoonLbl.isHidden = false
            }else{
                cell.disableView.isHidden = true
                cell.comingSoonLbl.isHidden = true
            }
            
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        handlePlaceNavigation(indexPath: indexPath)
    }
    
    
    func handlePlaceNavigation(indexPath: IndexPath){
        
        
        if haveFlipr{
            if isPlaceOwner {
                if isV3{
                    if indexPath.row == 0{
                        
                    }
                    
//                    if indexPath.row == 1{
//                        showLastMeasurement()
//                    }
                    
                    else if indexPath.row == 1{
                        self.showAIView()
                    }
                    
                    else if indexPath.row == 2{
                        self.showExpertView()
                    }
                    
                }
                else{
                    if haveSubscription{
                        if indexPath.row == 0{
                            
                        }
//                        else if indexPath.row == 1{
//                            showLastMeasurement()
//                        }
                        else if indexPath.row == 1{
                            showAIView()
                        }
                        else if indexPath.row == 2{
                            showExpertView()
                        }
                        
                        else{
                            
                        }
                    }else{
                        
                        
                        if indexPath.row == 0{
                            self.showSubscriptionView()
                        }
//                        else if indexPath.row == 1{
//                            showLastMeasurement()
//
//                        }
                        else if indexPath.row == 1{
                            showAIView()
                        }
                        else if indexPath.row == 2{
                            showExpertView()
                        }
                        else if indexPath.row == 3{
//                            showExpertView()
                        }
                        
                        else{
                            
                        }
                    }
                }
            }else{
                if indexPath.row == 0{
                    self.showBuyProducts()
                }
                else if indexPath.row == 1{
                    self.showAIView()
                }
                else if indexPath.row == 2{
                    showExpertView()
                }
            }
            
        }
        else{
            if indexPath.row == 0{
                self.showBuyProducts()
            }
            else if indexPath.row == 1{
                self.showAIView()
            }
            else{
                
            }
            
        }
        /*
         
         if haveFlipr{
         if isPlaceOwner && (haveSubscription == false){
         self.handlePlaceOwnerWithOutSubscriptionNavigation(indexPath: indexPath)
         }
         else{
         if isPlaceOwner{
         self.handlePlaceOwnerWithSubscriptionNavigation(indexPath: indexPath)
         }else{
         self.handleGuestNavigation(indexPath: indexPath)
         }
         }
         }else{
         self.handleNoFliprNavigation(indexPath: indexPath)
         }
         
         */
        
    }
    
    
    func handleNoFliprNavigation(indexPath: IndexPath){
        
        if indexPath.row == 0{
            self.showBuyProducts()
        }
        else if indexPath.row == 1{
            showSettings()
        }
        
        else {
        }
    }
    
    
    func handleGuestNavigation(indexPath: IndexPath){
        if indexPath.row == 0{
            
        }
        else if indexPath.row == 1{
            showLastMeasurement()
        }
        else if indexPath.row == 2{
            showExpertView()
        }
        else if indexPath.row == 3{
            showSettings()
        }
        else{
            
        }
    }
    
    
    
    func handlePlaceOwnerWithSubscriptionNavigation(indexPath: IndexPath){
        
        //        if indexPath.row == 0{
        //            self.showBuyProducts()
        //        }
        //        else
        if indexPath.row == 0{
            
        }
        else if indexPath.row == 1{
            showLastMeasurement()
        }
        else if indexPath.row == 2{
            showExpertView()
        }
        else if indexPath.row == 3{
            showSettings()
        }
        else{
            
        }
        
    }
    
    
    func handlePlaceOwnerWithOutSubscriptionNavigation(indexPath: IndexPath){
        
        if isV3{
            if indexPath.row == 0{
                
            }
            else if indexPath.row == 1{
                showExpertView()
            }
            else if indexPath.row == 2{
                showSettings()
            }
            else{
                
            }
        }else{
            if indexPath.row == 0{
                self.showSubscriptionView()
            }
            else if indexPath.row == 1{
                //                showServiceBook()
            }
            else if indexPath.row == 2{
                showLastMeasurement()
            }
            else if indexPath.row == 3{
                showExpertView()
            }
            else if indexPath.row == 4{
                showSettings()
            }
            else{
                
            }
        }
        
    }
    
    
    func showAIView(){
        if let vc = UIStoryboard(name: "FliprAI", bundle: nil).instantiateViewController(withIdentifier: "FliprAIViewController") as? FliprAIViewController {
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func showBuyProducts(){
        if let url = URL(string: "https://goflipr.com/produit/flipr-analysr-3/") {
            UIApplication.shared.open(url)
        }
    }
    
    func showSubscriptionView(){
        if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
            //            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showLastMeasurement(){
        let tmpSb = UIStoryboard.init(name: "Firmware", bundle: nil)
        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "LastMeasurementNavigation") as? UINavigationController {
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func showServiceBook(){
        if let vc = UIStoryboard(name: "PoolLog", bundle: nil).instantiateInitialViewController() {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func showPoolHouse(){
        let manSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = manSb.instantiateViewController(withIdentifier: "PoolViewControllerID") as? UINavigationController{
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func showExpertView(){
        showNewExpertView()
        return
        //            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpertMenuViewController") as? ExpertMenuViewController {
        //               // viewController.modalPresentationStyle = .overCurrentContext
        //                self.present(viewController, animated: true)
        //            }
        
        let tmpSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
            if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
                navigationController.modalPresentationStyle = .fullScreen
                viewController.isDirectPresenting = true
                navigationController.setViewControllers([viewController], animated: false)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func showNewExpertView(){
        let tmpSb = UIStoryboard.init(name: "ExpertView", bundle: nil)
        if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertViewViewController") as? ExpertViewViewController {
            viewController.placeId = placeDetails.placeId?.string ?? ""
            let nav = UINavigationController.init(rootViewController: viewController)
            self.present(nav, animated: true)
        }
    }
    
    func showAde(){
        let navigationController = UIStoryboard(name:"SideMenuViews", bundle: nil).instantiateViewController(withIdentifier: "HelpNavigation") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func showSettings(){
        let navigationController = UIStoryboard(name:"Settings", bundle: nil).instantiateViewController(withIdentifier: "WatrSettingsNavigation") as! UINavigationController
        //        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func showLogout(){
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
    
    func handleNavigation(indexPath: IndexPath){
        if self.haveFlipr && self.haveHub{
            self.handleHubnFliprNavigation(indexPath: indexPath)
        }else{
            if self.haveFlipr{
                self.handleHubnFliprNavigation(indexPath: indexPath)
            }else{
                self.handleHubOnlyNavigation(indexPath: indexPath)
            }
        }
    }
    
    func handleHubnFliprNavigation(indexPath: IndexPath){
        
        if indexPath.row == 0{
            if let vc = UIStoryboard(name: "PoolLog", bundle: nil).instantiateInitialViewController() {
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 1{
            if let navC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilprPredictNav") as? UINavigationController {
                navC.modalPresentationStyle = .fullScreen
                present(navC, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 2{
            
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpertMenuViewController") as? ExpertMenuViewController {
                // viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: true)
            }
        }
        else  if indexPath.row == 3 {
            let eqpsVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsAndEquipmentsViewController") as! ProductsAndEquipmentsViewController
            let navigationController = UINavigationController.init(rootViewController: eqpsVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        else if indexPath.row == 4 {
            if let url = URL(string: "https://goflipr.com/le-shop/#traitement-piscine") {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                self.present(vc, animated: true)
            }
        }
        
        else if indexPath.row == 5 {
            if let url = URL(string: "https://goflipr.com/blog-flipr/") {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                self.present(vc, animated: true)
            }
        }
        
        else if indexPath.row == 6 {
            let navigationController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigation") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        else if indexPath.row == 7 {
            
            let navigationController = UIStoryboard(name:"SideMenuViews", bundle: nil).instantiateViewController(withIdentifier: "HelpNavigation") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        else if indexPath.row == 8 {
            
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
        
        
    }
    
    
    func handleHubOnlyNavigation(indexPath: IndexPath){
        
        if indexPath.row == 0{
            
            if let vc = UIStoryboard(name: "PoolLog", bundle: nil).instantiateInitialViewController() {
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
        else  if indexPath.row == 1 {
            let eqpsVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsAndEquipmentsViewController") as! ProductsAndEquipmentsViewController
            let navigationController = UINavigationController.init(rootViewController: eqpsVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            if let url = URL(string: "https://goflipr.com/le-shop/#traitement-piscine") {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                self.present(vc, animated: true)
            }
        }
        
        else if indexPath.row == 3 {
            if let url = URL(string: "https://goflipr.com/blog-flipr/") {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                self.present(vc, animated: true)
            }
        }
        
        else if indexPath.row == 4 {
            let navigationController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigation") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        else if indexPath.row == 5 {
            
            let navigationController = UIStoryboard(name:"SideMenuViews", bundle: nil).instantiateViewController(withIdentifier: "HelpNavigation") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        else if indexPath.row == 6 {
            
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
        
        
    }
    
    
}

