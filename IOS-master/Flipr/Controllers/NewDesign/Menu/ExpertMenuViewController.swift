//
//  ExpertMenuViewController.swif
//  Flipr
//
//  Created by Ajeesh on 06/09/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class ExpertMenuViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var menuViewHeight: NSLayoutConstraint!

    var haveFirmwereUpgrade = true
    var haveSubscription = false
    @IBOutlet weak var menuView: UIView!

    var cellTitleList = ["Activer la connexion à distance","Déclencher une mesure","Nouveau calibrage","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]
    var imageNames = ["noSubscription","Déclencher une mesure","Nouveau calibrage","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]

//    var cellTitleList = ["Activer la connexion à distance","Mode Expert","Trigger a measurement","Nouveau calibrage","Nouveau test bandelette","Vidange de la piscine","Diagnostic","Flipr Firmware Update"]
//    var imageNames = ["noSubscription","expertMenu1","expertMenu2","expertMenu3","expertMenu4","expertMenu5","diagnostic","upgradebtn"]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable.tableFooterView = UIView()
        haveFirmwereUpgrade = AppSharedData.sharedInstance.haveNewFirmwereUpdate
        menuView.layer.cornerRadius = 14
        menuView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.manageMenuList()
        NotificationCenter.default.addObserver(forName: K.Notifications.showFirmwereUpgradeScreen, object: nil, queue: nil) { (notification) in
            self.showFirmwereUdpateScreen()
        }
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprCalibrationCompleted, object: nil, queue: nil) { (notification) in
            self.dismiss(animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: K.Notifications.DismissMenuView, object: nil)

            }
        }
//        if sNo.hasPrefix("F"){

        if let identifier = Module.currentModule?.serial {
            var infoStr = AppSharedData.sharedInstance.userInfoTitle
            infoStr.append(" | FID: ")
            infoStr.append("\(identifier)")
            self.titleLbl.text = infoStr
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CalibrationManager.shared.removeConnection()
    }
    

    @IBAction func closeButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func manageMenuList(){
        
        if let module = Module.currentModule {
            if let identifier = Module.currentModule?.serial {
//                self.titleLbl.text = identifier
//                self.haveFlipr = true
            }

            if module.isSubscriptionValid {
                haveSubscription = true
            }else{
//                haveSubscription = false
                if let identifier = Module.currentModule?.serial {
                    if identifier.hasPrefix("F"){
                        haveSubscription = true
                    }else{
                        haveSubscription = false
                    }
                }
            }
        }
        
        if haveSubscription{
             let identifier = Module.currentModule?.serial ?? ""
                if identifier.hasPrefix("F"){
                    cellTitleList = ["Nouveau calibrage","Déclencher une mesure","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]
                     imageNames = ["Nouveau calibrage","Déclencher une mesure","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]
                    self.menuViewHeight.constant = 610
                }else{
                    cellTitleList = ["Déclencher une mesure","Nouveau calibrage","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]
                     imageNames = ["Déclencher une mesure","Nouveau calibrage","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]
                    self.menuViewHeight.constant = 600

                }
        }else{
            cellTitleList = ["Activer la connexion à distance","Déclencher une mesure","Nouveau calibrage","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]
             imageNames = ["noSubscription","Déclencher une mesure","Nouveau calibrage","Nouveau test bandelette","Vue Expert","Flipr Predict","Vidange de la piscine"]
            self.menuViewHeight.constant = 670

        }

        
        /*
        if haveFirmwereUpgrade{
            cellTitleList = ["Mode Expert","Trigger a measurement","Nouveau calibrage","Nouveau test bandelette","Vidange de la piscine","Diagnostic","Flipr Firmware Update"]
            imageNames = ["expertMenu1","expertMenu2","expertMenu3","expertMenu4","expertMenu5","diagnostic","upgradebtn"]

        }else{
            cellTitleList = ["Mode Expert","Trigger a measurement","Nouveau calibrage","Nouveau test bandelette","Vidange de la piscine","Diagnostic",]
            imageNames = ["expertMenu1","expertMenu2","expertMenu3","expertMenu4","expertMenu5","diagnostic"]
        }
        */

    }
   

}

extension ExpertMenuViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cellTitleList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell =  tableView.dequeueReusableCell(withIdentifier:"MenuTableViewCell",
                                             for: indexPath) as! MenuTableViewCell
        
        cell.menuTitleLbl.text = cellTitleList[indexPath.row].localized
        cell.menuIcon.image =  UIImage(named: imageNames[indexPath.row])
        if cellTitleList.count  == (indexPath.row + 1){
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width);
        }else{
            
        }
        if indexPath.row == 0{
//            if let identifier = Module.currentModule?.serial {
//                if identifier.hasPrefix("F"){
//                    cell.contentView.alpha = 0.5
//                }else{
//                    cell.contentView.alpha = 1.0
//                }
//            }
        }
        else{
            cell.contentView.alpha = 1.0
        }
        return cell
    }
    
    func handlePlaceOwnerWithSubscriptionV3Navigation(indexPath: IndexPath){
        if indexPath.row == 0{
            showCalibrationView()
        }
        
        else if indexPath.row == 1{
            triggerMesurement()
        }
        
        else if indexPath.row == 2{
            stripTest()
        }
        else if indexPath.row == 3{
            expertView()
        }
        else if indexPath.row == 4{
            history()
        }
        else if indexPath.row == 5{
            drainingWater()
        }
        else if indexPath.row == 6{
            showFirmwereDiagnosticScreen()
        }
        else if indexPath.row == 7{
//            showFirmwereDiagnosticScreen()
        }
        else{
            
        }
        
    }
    
        
    func handlePlaceOwnerWithSubscriptionNavigation(indexPath: IndexPath){
        if indexPath.row == 0{
            triggerMesurement()
        }
        else if indexPath.row == 1{
            showCalibrationView()
        }
        else if indexPath.row == 2{
            stripTest()
        }
        else if indexPath.row == 3{
            expertView()
        }
        else if indexPath.row == 4{
            history()
        }
        else if indexPath.row == 5{
            drainingWater()
        }
        else if indexPath.row == 6{
            showFirmwereDiagnosticScreen()
        }
        else if indexPath.row == 7{
//            showFirmwereDiagnosticScreen()
        }
        else{
            
        }
        
    }
    
    func handlePlaceOwnerWithOutSubscriptionNavigation(indexPath: IndexPath){
        if indexPath.row == 0{
            showSubscriptionView()
        }
        else if indexPath.row == 1{
            triggerMesurement()
        }
        else if indexPath.row == 2{
            showCalibrationView()
        }
        else if indexPath.row == 3{
            stripTest()
        }
        else if indexPath.row == 4{
            expertView()
        }
        else if indexPath.row == 5{
            history()
        }
        else if indexPath.row == 6{
            drainingWater()
        }
        else if indexPath.row == 7{
            showFirmwereDiagnosticScreen()
        }
        else{
            
        }
    }
    
    
    func drainingWater(){
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = mainSb.instantiateViewController(withIdentifier: "WaterLevelTableViewController") as? WaterLevelTableViewController {
//            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true, completion: nil)
//
            let navigationController = LightNavigationViewController.init(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion:nil)

        }
    }
    
    func history(){
        
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = mainSb.instantiateViewController(withIdentifier: "HistoricViewController") as? HistoricViewController {
//            viewController.calibrationType = .simpleMeasure
//            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func showSubscriptionView(){
        if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func triggerMesurement(){
        
        let mainSb = UIStoryboard.init(name: "Firmware", bundle: nil)
        if let viewController = mainSb.instantiateViewController(withIdentifier: "NewMeasurementViewController") as? NewMeasurementViewController {
//            viewController.calibrationType = .simpleMeasure
            let nav = UINavigationController.init(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen

            self.present(nav, animated: true, completion: nil)
        }
        
        
/*
        
        if let identifier = Module.currentModule?.serial {
            if identifier.hasPrefix("F") || identifier.hasPrefix("f"){
                return
            }
        }
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
            viewController.calibrationType = .simpleMeasure
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        */
        
    }
    
    
    func stripTest(){
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        let alert = UIAlertController(title: "Strip test".localized, message:"Are you sure you want to do a new strip test?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            let sb:UIStoryboard = UIStoryboard.init(name: "Calibration", bundle: nil)
            if let viewController = sb.instantiateViewController(withIdentifier: "StripViewControllerID") as? StripViewController {
                viewController.recalibration = true
                viewController.isPresentView = true
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)

            }
        }))
        alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
            if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func expertView(){
//        let tmpSb = UIStoryboard.init(name: "Main", bundle: nil)
//        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
//            if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
//                navigationController.modalPresentationStyle = .fullScreen
//                viewController.isDirectPresenting = true
//                navigationController.setViewControllers([viewController], animated: false)
//                self.present(navigationController, animated: true, completion: nil)
//            }
//        }
        
        
        let tmpSb = UIStoryboard.init(name: "ExpertView", bundle: nil)
        if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertViewViewController") as? ExpertViewViewController {
            if let placeId =  Module.currentModule?.placeId?.string {
                viewController.placeId = placeId
            }
            self.present(viewController, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handlePlaceNavigation(indexPath: indexPath)
    }
    
    func handlePlaceNavigation(indexPath: IndexPath){
        if haveSubscription{
            let identifier = Module.currentModule?.serial ?? ""
            if identifier.hasPrefix("F"){
                self.handlePlaceOwnerWithSubscriptionV3Navigation(indexPath: indexPath)
            }else{
                self.handlePlaceOwnerWithSubscriptionNavigation(indexPath: indexPath)
            }

        }else{
            self.handlePlaceOwnerWithOutSubscriptionNavigation(indexPath: indexPath)
        }

    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
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
        else if indexPath.row == 1{
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                viewController.calibrationType = .simpleMeasure
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 2{
            
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            let alert = UIAlertController(title: "Calibration".localized, message:"Are you sure you want to calibrate the probes again?".localized, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
                self.showCalibrationView()
    //            if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
    //                viewController.recalibration = true
    //                viewController.calibrationType = .ph7
    //                viewController.modalPresentationStyle = .fullScreen
    //                let nav = UINavigationController.init(rootViewController: viewController)
    //                nav.modalPresentationStyle = .fullScreen
    //                self.present(nav, animated: true, completion: nil)
    //            }
            }))
            alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
                if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                    UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        else if indexPath.row == 3{
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            let alert = UIAlertController(title: "Strip test".localized, message:"Are you sure you want to do a new strip test?".localized, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
                let sb:UIStoryboard = UIStoryboard.init(name: "Calibration", bundle: nil)
                if let viewController = sb.instantiateViewController(withIdentifier: "StripViewControllerID") as? StripViewController {
                    viewController.recalibration = true
                    viewController.isPresentView = true
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)

                }
            }))
            alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
                if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                    UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        else if indexPath.row == 4{
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            if let viewController = mainSb.instantiateViewController(withIdentifier: "WaterLevelTableViewController") as? WaterLevelTableViewController {
    //            viewController.modalPresentationStyle = .fullScreen
    //            self.present(viewController, animated: true, completion: nil)
    //
                let navigationController = LightNavigationViewController.init(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion:nil)

            }
        }
        else if indexPath.row == 5{
            self.showFirmwereDiagnosticScreen()
        }
        else if indexPath.row == 6{
            self.showFirmwereUdpateScreen()
        }
        else{
        }
        
    }
    
    */
    
    func showFirmwereUdpateScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    func showFirmwereDiagnosticScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "DiganosticNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
  
    func showCalibrationView(){
        
        
        
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationPh7IntroViewController") as! CalibrationPh7IntroViewController
        vc.isPresentedFlow = true
        vc.recalibration = true
        vc.noStripTest = true
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
       return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
   }

}
