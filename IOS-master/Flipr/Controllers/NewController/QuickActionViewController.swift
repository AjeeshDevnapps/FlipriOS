//
//  QuickActionViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import SafariServices

class QuickActionViewController: UIViewController {
    @IBOutlet weak var menuTable: UITableView!

    @IBOutlet weak var triggerContainerView: UIView!
    @IBOutlet weak var expertContainerView: UIView!
    @IBOutlet weak var calibrationContainerView: UIView!
    @IBOutlet weak var drainingContainerView: UIView!
    @IBOutlet weak var newStripContainerView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var measurementLbl: UILabel!
    @IBOutlet weak var expertLbl: UILabel!
    @IBOutlet weak var callibrationLbl: UILabel!
    @IBOutlet weak var drainingLbl: UILabel!
    @IBOutlet weak var stripTestLbl: UILabel!
    @IBOutlet weak var subScriptionView: UIView!
    @IBOutlet  var bottonContainerContraint: NSLayoutConstraint!
    @IBOutlet weak var subScriptionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subScriptiontitleLbl: UILabel!
    @IBOutlet  var tableBottonContainerContraint: NSLayoutConstraint!


    var isShowSubscription = false
    var haveFlipr = false
    var haveHub = false
    var haveFirmwereUpgrade = true
    
    var haveServerChangeOption = false


    let hud = JGProgressHUD(style:.dark)


    var cellTitleList = [String]()
    var imageNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupViews()
        haveFirmwereUpgrade = AppSharedData.sharedInstance.haveNewFirmwereUpdate
//        haveFirmwereUpgrade = true
        titleLbl.text = "Quick Actions".localized
        menuTable.tableFooterView = UIView(frame: CGRect(x: 0, y: -1, width: menuTable.frame.size.width, height: 1))
        containerView.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)
        getDeviceDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(rawValue: 0), animations: {
//            self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        }, completion: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                }, completion: nil)

//        self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    func getDeviceDetails(){
        hud?.show(in: self.view)
        User.currentUser?.getModuleList(completion: { [self] (devices,error) in
            self.hud?.dismiss()
            if let modules = devices as? [[String:Any]] {
                var hubId = ""
                for mod in modules {
                    if let type = mod["ModuleType_Id"] as? Int {
                        if type == 1 {
                            self.haveFlipr = true
                            if let name = mod["Serial"] as? String  {
                                AppSharedData.sharedInstance.serialKey = name
                            }
                        }else{
                            self.haveHub = true
                           
                            if let name = mod["Serial"] as? String  {
                                hubId = name
                                AppSharedData.sharedInstance.serialKey = name
                            }
                        }
                    }
                }
                self.haveServerChangeOption = false
                if self.haveFlipr{
                  
                    if let module = Module.currentModule {
                        if module.isSubscriptionValid {
                            self.subScriptionViewHeight.constant = 0
                            self.subScriptionView.isHidden = true
                        }else{
                            self.subScriptionView.isHidden = false
                            self.subScriptiontitleLbl.text  = "Activer la connexion à distance".localized
                            self.subScriptionViewHeight.constant = 64
                        }
                    }
                    if self.haveHub {
                        self.cellTitleList = ["Retrieve the last measurement".localized,"Expert Mode".localized,"Buy cleaning products".localized,"Settings".localized]
                        self.imageNames = ["icon-mesure","icon-calibration","Group 241","settingsIconQuickAction"]
                        
                      //  let value = UserDefaults.standard.bool(forKey:ScannedPeripheralTableViewCell disAllowFirmwereUpdateKey)
                        if haveFirmwereUpgrade{
                            self.cellTitleList = ["Flipr Firmware Update".localized,"Retrieve the last measurement".localized,"Expert Mode".localized,"Buy cleaning products".localized,"Settings".localized]
                            self.imageNames = ["firmwere","icon-mesure","icon-calibration","Group 241","settingsIconQuickAction"]
                        }
                    }else{
                        
                        self.cellTitleList = ["Retrieve the last measurement".localized,"Expert Mode".localized,"Buy cleaning products".localized,"Add a Flipr Hub".localized]
                        self.imageNames = ["icon-mesure","icon-calibration","Group 241","icon-smart-scan"]
//                        let value = UserDefaults.standard.bool(forKey: disAllowFirmwereUpdateKey)
                        if haveFirmwereUpgrade{
                            self.cellTitleList = ["Flipr Firmware Update".localized,"Retrieve the last measurement".localized,"Expert Mode".localized,"Buy cleaning products".localized,"Add a Flipr Hub".localized]
                            self.imageNames = ["firmwere","icon-mesure","icon-calibration","Group 241","icon-smart-scan"]
                        }
                    }
                    self.addServerChangeOption()
                    
                }else{
                    if self.haveHub {
                        self.cellTitleList = ["Gestion des plannings".localized,"Buy cleaning products".localized,"Add a Flipr Hub".localized]
                        self.imageNames = ["quickMenuTime","Group 241","icon-smart-scan"]
                    }
//                    let value = UserDefaults.standard.bool(forKey: disAllowFirmwereUpdateKey)
                    if haveFirmwereUpgrade{
                        self.cellTitleList = ["Flipr Firmware Update".localized,"Gestion des plannings".localized,"Buy cleaning products".localized,"Add a Flipr Hub".localized]
                        self.imageNames = ["firmwere","quickMenuTime","Group 241","icon-smart-scan"]
                    }
                    self.addServerChangeOption()

                }
                if self.haveHub && self.haveFlipr {
                    if let module = Module.currentModule {
                        if module.isSubscriptionValid {
                            containerViewHeight.constant = 360
                            if haveFirmwereUpgrade{
                                containerViewHeight.constant = 424
                            }
                            subScriptionViewHeight.constant = 0
                        }else{
                            containerViewHeight.constant = 404
                            subScriptionViewHeight.constant = 64
                            if haveFirmwereUpgrade{
                                containerViewHeight.constant = 468
                            }

                        }
                    }else{
                        containerViewHeight.constant = 360
                        if haveFirmwereUpgrade{
                            containerViewHeight.constant = 424
                        }
                    }
                    if self.haveServerChangeOption == true{
                        var tmpVal = containerViewHeight.constant
                        tmpVal = tmpVal + 60
                        containerViewHeight.constant = tmpVal
                    }
                }
                else{
                    if self.haveHub{
                        containerViewHeight.constant = 296
                        if haveFirmwereUpgrade{
                            containerViewHeight.constant = 360
                        }
                        tableBottonContainerContraint.constant = 10
                        containerView.setNeedsDisplay()
                    }else{
                        if let module = Module.currentModule {
                            if module.isSubscriptionValid {
                                containerViewHeight.constant = 360
                                if haveFirmwereUpgrade{
                                    containerViewHeight.constant = 424
                                }
                                subScriptionViewHeight.constant = 0
                            }else{
                                containerViewHeight.constant = 404
                                if haveFirmwereUpgrade{
                                    containerViewHeight.constant = 468
                                }
                                subScriptionViewHeight.constant = 64
                            }
                        }else{
                            containerViewHeight.constant = 360
                        }
                    }
                    if self.haveServerChangeOption == true{
                        var tmpVal = containerViewHeight.constant
                        tmpVal = tmpVal + 60
                        containerViewHeight.constant = tmpVal
                    }
                }
                self.menuTable.reloadData()

            }
           
        })
        
    }

    
    func addServerChangeOption(){
        if User.currentUser?.email != nil{
            if let email = User.currentUser?.email{
                if (email.hasSuffix("@flipr.fr")){
                    self.haveServerChangeOption = true
                    self.cellTitleList.append("Change Server".localized)
                    self.imageNames.append("firmwereBig".localized)
                }
            }
        }
    }
    
    func setupViews(){
//        if UIScreen.main.nativeBounds.height < 1334{
//            bottonContainerContraint.constant = 576 - 70
//        }
        titleLbl.text = "Quick Actions".localized
        measurementLbl.text = "Retrieve the last measurement".localized
        expertLbl.text  = "Expert Mode".localized
        callibrationLbl.text  = "New Calibration".localized
        drainingLbl.text  = "Add a Flipr Hub".localized
        if Module.currentModule == nil{
            triggerContainerView.alpha = 0.3
        }else{
            triggerContainerView.alpha = 1.0
        }
        
        stripTestLbl.text  = "New strip test".localized
//
//        triggerContainerView.layer.cornerRadius = 15.0
//        triggerContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        expertContainerView.layer.cornerRadius = 15.0
//        expertContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        calibrationContainerView.layer.cornerRadius = 15.0
//        calibrationContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        drainingContainerView.layer.cornerRadius = 15.0
//        drainingContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        newStripContainerView.layer.cornerRadius = 15.0
//        newStripContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHubButtonClicked(){
    
        let fliprStoryboard = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "ElectricalSetupViewController") as! ElectricalSetupViewController
        viewController.isPresentView = true
        let navigationVC = UINavigationController.init(rootViewController: viewController)
        self.present(navigationVC, animated: true)
    }
    
    @IBAction func triggerMeasureButtonClicked(){
        if  Module.currentModule == nil{
            return
        }
        
        
        
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
            viewController.calibrationType = .simpleMeasure
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }

    @IBAction func expertModeButtonClicked(){
//        self.newStripTestButtonClicked()
//        return
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
    
    @IBAction func newCalibrationButtonClicked(){
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        let alert = UIAlertController(title: "Calibration".localized, message:"Are you sure you want to calibrate the probes again?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            self.showCalibrationView()
        }))
        alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
            if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func drainingButtonClicked(){
//        WaterLevelTableViewController
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
    
    @IBAction func newStripTestButtonClicked(){
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
        
        
    // Helper function inserted by Swift 4.2 migrator.
     func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }

   
    func showCalibrationView(){
        
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationIntroViewController") as! CalibrationIntroViewController
        vc.isPresentedFlow = true
        vc.recalibration = true
        vc.noStripTest = true
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension QuickActionViewController: UITableViewDelegate,UITableViewDataSource {
    
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
        if haveFirmwereUpgrade{
            if indexPath.row == 0{
                cell.menuTitleLbl.textColor =  .white
                cell.backgroundColor =  UIColor.init(hexString: "#F83A59")
            }
            else{
                cell.backgroundColor = .white
                cell.menuTitleLbl.textColor =   UIColor.init(hexString: "#111729")
            }
        }
        return cell
    }
     
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.haveHub && self.haveFlipr {
            handleFliprNhubMenu(indexPath:indexPath)
        }
        else {
            if self.haveHub{
                handleHubMenu(indexPath:indexPath)
            }else{
                handleFliprMenu(indexPath:indexPath)
            }
        }
    }
    
    
    
    func handleFliprNhubMenu(indexPath: IndexPath){
        if indexPath.row == 0 {
            if haveFirmwereUpgrade{
                showFliprFirmwereUpgradeScreen()
            }else{
                triggerMesurment()
            }
        }
        else if indexPath.row == 1 {
            if haveFirmwereUpgrade{
                triggerMesurment()
            }else{
                expertMode()
            }
        }
        else if indexPath.row == 2 {
            if haveFirmwereUpgrade{
                expertMode()
            }
            else{
                buyProduct()
            }
        }
        else if indexPath.row == 3 {
            if haveFirmwereUpgrade{
                buyProduct()
            }
            else{
                self.settingsScreen()
            }
//            hubButtonAction()
        }
        else if indexPath.row == 4 {
            let title = cellTitleList[indexPath.row]
            if title == "Change Server".localized{
                self.showServerChangeOption()
            }else{
                self.settingsScreen()
            }
        }
        else{
            let title = cellTitleList[indexPath.row]
            if title == "Change Server".localized{
                self.showServerChangeOption()
            }
        }
    }
    
    
    func showServerChangeOption(){

        let alert = UIAlertController(title: "Change Server".localized, message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Live Server".localized, style: .default , handler:{ (UIAlertAction)in
                UserDefaults.standard.set(false, forKey: K.AppConstant.CurrentServerIsDev)
                NotificationCenter.default.post(name: K.Notifications.ServerChanged, object: nil)
           }))
           
        alert.addAction(UIAlertAction(title: "Dev Server".localized, style: .default , handler:{ (UIAlertAction)in
               UserDefaults.standard.set(true, forKey: K.AppConstant.CurrentServerIsDev)
               NotificationCenter.default.post(name: K.Notifications.ServerChanged, object: nil)
           }))

            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel , handler:{ (UIAlertAction)in
               print("User click Delete button")
           }))
           
           self.present(alert, animated: true, completion: {
               print("completion block")
           })
    }
    
    func handleHubMenu(indexPath: IndexPath){
        if indexPath.row == 0 {
            if haveFirmwereUpgrade{
                showFliprFirmwereUpgradeScreen()
            }else{
                hubButtonAction()
            }
        }
        else if indexPath.row == 1 {
            if haveFirmwereUpgrade{
                hubButtonAction()
            }else{
                buyProduct()
            }
        }
        else if indexPath.row == 2 {
            if haveFirmwereUpgrade{
                buyProduct()
            }else{
                addHubEquipments()
            }
        }
        else if indexPath.row == 3 {
            let title = cellTitleList[indexPath.row]
            if title == "Change Server".localized{
                self.showServerChangeOption()
            }else{
                addHubEquipments()
            }
        }
        else{
            let title = cellTitleList[indexPath.row]
            if title == "Change Server".localized{
                self.showServerChangeOption()
            }
        }
    }
    
    func handleFliprMenu(indexPath: IndexPath){
        if indexPath.row == 0 {
            if haveFirmwereUpgrade{
                showFliprFirmwereUpgradeScreen()
            }else{
                triggerMesurment()
            }
        }
        else if indexPath.row == 1 {
            if haveFirmwereUpgrade{
                triggerMesurment()
            }
            else{
                expertMode()
            }
        }
        else if indexPath.row == 2 {
            if haveFirmwereUpgrade{
                expertMode()
            }else{
                buyProduct()
            }
        }
        else if indexPath.row == 3 {
            if haveFirmwereUpgrade{
                buyProduct()
            }else{
                addHubEquipments()
            }
        }
        else if indexPath.row == 4 {
            let title = cellTitleList[indexPath.row]
            if title == "Change Server".localized{
                self.showServerChangeOption()
            }else{
                addHubEquipments()
            }
        }
        else{
            let title = cellTitleList[indexPath.row]
            if title == "Change Server".localized{
                self.showServerChangeOption()
            }
        }
    }
    
    
    func showFliprFirmwereUpgradeScreen(){
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: K.Notifications.showFirmwereUpgradeScreen, object: nil)

//        AppSharedData.sharedInstance.isShowingFirmwereUpdateScreen = true
//        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true)
       
    }
    
    func settingsScreen(){
//        let navigationController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigation") as! UINavigationController
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
        
        let navigationController = UIStoryboard(name:"Settings", bundle: nil).instantiateViewController(withIdentifier: "WatrSettingsNavigation") as! UINavigationController
//        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)

    }
    
    func triggerMesurment(){
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: K.Notifications.showLastMeasurementScreen, object: nil)

        
//        showLastMeasurement()
//        if  Module.currentModule == nil{
//            return
//        }
//        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
//        if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
//            viewController.calibrationType = .simpleMeasure
//            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true, completion: nil)
//        }
    }
    
    
    func showLastMeasurement(){
        let tmpSb = UIStoryboard.init(name: "Firmware", bundle: nil)
        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "LastMeasurementNavigation") as? UINavigationController {
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func expertMode(){
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
    
    func newCalibration(){
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        let alert = UIAlertController(title: "Calibration".localized, message:"Are you sure you want to calibrate the probes again?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            self.showCalibrationView()
        }))
        alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
            if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addHubEquipments(){
    
        let fliprStoryboard = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "ElectricalSetupViewController") as! ElectricalSetupViewController
        viewController.isPresentView = true
        let navigationVC = UINavigationController.init(rootViewController: viewController)
        self.present(navigationVC, animated: true)
    }
    
    func hubButtonAction() {
        if HUB.currentHUB == nil {
            
            let alertController = UIAlertController(title: "Flipr HUB", message: "Vous n'avez pas de HUB associé à votre compte.".localized, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
            
            let okAction = UIAlertAction(title: "Découvrir Flipr HUB".localized, style: UIAlertAction.Style.default)
            {
                (result : UIAlertAction) -> Void in
                
                if let url = URL(string: "https://www.goflipr.com/flipr-hub/") {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                    self.present(vc, animated: true)
                }
                
            }
            let addAction = UIAlertAction(title: "Connecter votre Flipr HUB".localized, style: UIAlertAction.Style.default)
            {
                (result : UIAlertAction) -> Void in
                
                
                let storyboard = UIStoryboard(name: "HUB", bundle: nil)
                
                let viewController = storyboard.instantiateViewController(withIdentifier: "HubTypeSelectionViewControllerID") as! HubTypeSelectionViewController
                viewController.dismissOnBack = true
                let navC = UINavigationController(rootViewController: viewController)
                navC.setNavigationBarHidden(true, animated: false)
                navC.modalPresentationStyle = .fullScreen
                self.present(navC, animated: true, completion: nil)
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            if Pool.currentPool?.city != nil {
                alertController.addAction(addAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if Pool.currentPool?.city == nil {
            let alertController = UIAlertController(title: "Flipr HUB".localized, message: "Pour terminer la configuration du HUB, veuillez d'abord configurer votre piscine.".localized, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default)
            {
                (result : UIAlertAction) -> Void in
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PoolViewControllerID") {
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                }
                
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            let storyboard = UIStoryboard(name: "HUB", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "HUBNavigationControllerID")
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func subscriptionButtonAction(){
        if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func buyProduct(){
        if let url = URL(string: "https://goflipr.com/le-shop/#traitement-piscine") {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(vc, animated: true)
        }
    }
}
