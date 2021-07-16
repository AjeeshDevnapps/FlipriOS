//
//  DashboardViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/03/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import BAFluidView
import Alamofire
import Device
import CoreMotion
import SideMenu
import SafariServices
import AdSupport
import AppTrackingTransparency
import MSCircularSlider
import JGProgressHUD

let FliprLocationDidChange = Notification.Name("FliprLocationDidChange")
let FliprDataPosted = Notification.Name("FliprDataDidPosted")

class DashboardViewController: UIViewController {
    @IBOutlet weak var topButton: UIButton!

    var motionManager = CMMotionManager()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundOverlayImageView: UIImageView!
    @IBOutlet weak var backgroundOverlayHubImageView: UIImageView!

    
    @IBOutlet weak var alert0Button: AlertButton!
    @IBOutlet weak var alert1Button: AlertButton!
    @IBOutlet weak var alert2Button: AlertButton!
    @IBOutlet weak var alert3Button: AlertButton!
    @IBOutlet weak var alert4Button: AlertButton!
    
    @IBOutlet weak var subscriptionView: UIView!
    
    
    
    @IBOutlet weak var notificationDisabledButton: UIButton!
    @IBOutlet weak var waterTmpChangeButton: UIButton!
    @IBOutlet weak var phChangeButton: UIButton!
    @IBOutlet weak var redoxChangeButton: UIButton!
    @IBOutlet weak var quickActionButtonContainer: UIView!

    
    
    
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var alertCheckView: UIView!
    @IBOutlet weak var currentlyWeatherIcon: UILabel!
    @IBOutlet weak var weatherChevronImageView: UIImageView!
    @IBOutlet weak var startWeatherIcon: UILabel!
    @IBOutlet weak var comingWeatherIcon: UILabel!
    @IBOutlet weak var airTemperatureLabel: UILabel!
    @IBOutlet weak var airLabel: UILabel!
    @IBOutlet weak var airTendendcyImageView: UIImageView!
    @IBOutlet weak var waterTemperatureLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var waterTendencyImageView: UIImageView!
    
    @IBOutlet weak var airTemperatureLabelHubTab: UILabel!
    @IBOutlet weak var airLabelHubTab: UILabel!
    @IBOutlet weak var airTendendcyImageViewHubTab: UIImageView!

    @IBOutlet weak var currentlyWeatherIconHubTab: UILabel!
    @IBOutlet weak var weatherChevronImageViewHubTab: UIImageView!
    @IBOutlet weak var startWeatherIconHubTab: UILabel!
    @IBOutlet weak var comingWeatherIconHubTab: UILabel!

    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var uvView: UIView!
    @IBOutlet weak var uvLabelHubTab: UILabel!
    @IBOutlet weak var uvViewHubTab: UIView!
    
    @IBOutlet weak var pHView: UIView!
    @IBOutlet weak var pHLabel: UILabel!
    @IBOutlet weak var pHSateView: UIView!
    @IBOutlet weak var pHStateLabel: UILabel!
    @IBOutlet weak var pHStatusImageView: UIImageView!

    @IBOutlet weak var orpView: UIView!
    @IBOutlet weak var orpLabel: UILabel!
    @IBOutlet weak var orpIndicatorImageView: UIImageView!
    @IBOutlet weak var orpStateView: UIView!
    @IBOutlet weak var orpStateLabel: UILabel!
    
    @IBOutlet weak var bleStatusView: UIView!
    @IBOutlet weak var bleStatusLabel: UILabel!
    @IBOutlet weak var bleStatusImageView: UIImageView!

    var pHValueCircle = CAShapeLayer()
    
    @IBOutlet weak var lastMeasureDateLabel: UILabel!
    
    @IBOutlet weak var temperaturesTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var phViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var orpViewRightConstraint: NSLayoutConstraint!
    
    var alert:Alert?
    
    @IBOutlet weak var alertCheckLabel: UILabel!
    @IBOutlet weak var subscriptionLabel: UILabel!
    
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var gradiantView: UIView!

    @IBOutlet weak var circularSlider: MSCircularSlider!
    @IBOutlet weak var addNewProgramView: UIView!
    @IBOutlet weak var addNewProgramLabel: UILabel!
    @IBOutlet weak var programListView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollViewContainerView: UIView!
    @IBOutlet weak var addNewProgramViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addNewProgramViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var programListViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pumbStatusView: UIView!
    @IBOutlet weak var bulbStatusView: UIView!

    
    @IBOutlet weak var fliprTabView: UIView!
    @IBOutlet weak var hubTabView: UIView!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var quicActionButton: UIButton!
    @IBOutlet weak var pumbActionButton: UIButton!
    @IBOutlet weak var bulbActionButton: UIButton!
    @IBOutlet weak var addFirstFliprView: UIView!
    @IBOutlet weak var signalStrengthLabel: UILabel!
    @IBOutlet weak var signalStrengthImageView: UIImageView!
    @IBOutlet weak var fliprTabScrollView: UIScrollView!
    
    //Tabs
    @IBOutlet weak var flipTabButton: UIButton!
    @IBOutlet weak var hubTabButton: UIButton!


    //Hub Tab
    @IBOutlet weak var hubTabScrollView: UIScrollView!
    @IBOutlet weak var hubScrollViewContainerView: UIView!
    @IBOutlet weak var hubDeviceTableView: UITableView!
    @IBOutlet weak var hubDeviceTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hubTabWaveTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addEquipmentView: UIView!
    @IBOutlet weak var addFliprHubTabView: UIView!
    @IBOutlet weak var hubWaveContainerView: UIView!

    var hubTabWaveTopConstraintPreValue = 0

    var isShowingAddFirstProgramView = false
    var isShowingHubView = false

    let maskView = UIImageView()
    
    var bleMeasureHasBeenSent = false
    
    var hub:HUB?
    var hubPumb:HUB?
    var hubBulb:HUB?

    var hubs:[HUB] = []
    var fluidViewTopEdge:BAFluidView!
    var fluidView:BAFluidView!
    
    var hubTabFluidViewTopEdge:BAFluidView!
    var hubTabfluidView:BAFluidView!
    
    var isHubTabSelected = false


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        if -300 > -400{
//            print("true")
//        }else{
//            print("false")
//        }
//        let tmp = storyboard?.instantiateViewController(withIdentifier: "UISideMenuNavigationControllerID") as? SideMenuNavigationController
//        tmp?.view.addShadow(offset: CGSize.init(width: 10, height: 10), color: UIColor.black, radius: 100.0, opacity:1.0)
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "UISideMenuNavigationControllerID") as? SideMenuNavigationController
        
        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        
        if SideMenuManager.default.leftMenuNavigationController == nil {
            print("FUCK")
        }
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
//        self.view.clipsToBounds = true
//        self.quickActionButtonContainer.cornerRadius =  self.quickActionButtonContainer.frame.size.height / 2
//        quickActionButtonContainer.layer.cornerRadius = self.quickActionButtonContainer.frame.size.height / 2
//        quickActionButtonContainer.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.init(hexString: "#213A4E"), radius:         self.quickActionButtonContainer.frame.size.height / 2, opacity: 0.3)
        self.intialTabSetup()
        self.handleHubViews()
        self.setupDashboardUI()
        if Locale.current.languageCode != "fr" {
            let attributedTitle = NSAttributedString(string: "Alert in progress: act now!".localized, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]))
            alertButton.setAttributedTitle(attributedTitle, for: .normal)
        }
       // topButton.layer.borderColor = UIColor.init(hexString: "111729").cgColor
       // topButton.layer.borderWidth = 2.0
       // topButton.roundCorner(corner: topButton.frame.size.height / 2 )
        uvView.roundCorner(corner: 6)
        uvViewHubTab.roundCorner(corner: 6)

//        addNewProgramLabel.roundCorner(corner: 4.0)
        uvView.layer.borderColor = UIColor.init(hexString: "111729").cgColor
        uvView.layer.borderWidth = 1.0
        uvViewHubTab.layer.borderColor = UIColor.init(hexString: "111729").cgColor
        uvViewHubTab.layer.borderWidth = 1.0
        pumbStatusView.roundCorner(corner: 12)
        addEquipmentView.roundCorner(corner: 12)
        pumbStatusView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        bulbStatusView.roundCorner(corner: 12)
        bulbStatusView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        
        subscriptionButton.roundCorner(corner: 12)
        addFirstFliprView.roundCorner(corner: 12)

       // shareButton.setTitle("share".localized, for: .normal)
        airLabel.text = "air".localized
        airLabelHubTab.text = "air".localized

        waterLabel.text = "water".localized
        alertCheckLabel.text = "Water correction in progress".localized
        subscriptionLabel.text = "Activate all the features!\n7 days free trial".localized
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerForRemoteNotifications(application:  UIApplication.shared)
        
        setupInitialView()
        
        refresh()
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            self.notificationDisabledButton.isHidden = true
            self.waterTmpChangeButton.isHidden = true
            self.phChangeButton.isHidden = true
            self.redoxChangeButton.isHidden = true
            self.bleMeasureHasBeenSent = false
            self.refresh()
            self.perform(#selector(self.callGetStatusApis), with: nil, afterDelay: 3)
        }
        
        NotificationCenter.default.addObserver(forName: FliprLocationDidChange, object: nil, queue: nil) { (notification) in
            self.view.hideStateView()
            self.refresh()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDiscovered, object: nil, queue: nil) { (notification) in
            self.bleStatusLabel.text = "flipr detected, connection in progress...".localized
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDidRead, object: nil, queue: nil) { (notification) in
            self.bleStatusLabel.text = "Sending data...".localized
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprMeasuresPosted, object: nil, queue: nil) { (notification) in
            self.bleStatusView.isHidden = true
            self.updateFliprData()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.UserDidLogout, object: nil, queue: nil) { (notification) in
            self.showLoginScreen()

            //            self.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.SessionExpired, object: nil, queue: nil) { (notification) in
//            self.dismiss(animated: true, completion: nil)
            self.showLoginScreen()
            User.logout()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.AlertDidClose, object: nil, queue: nil) { (notification) in
            self.updateAlerts()
        }
        
        
        NotificationCenter.default.addObserver(forName: K.Notifications.NotificationSetttingsChanged, object: nil, queue: nil) { (notification) in
            self.manageNotificationDisabledButtton()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil, queue: nil) { (notification) in
            self.managePhValueChangeButtton()
            
        }
        
        
        NotificationCenter.default.addObserver(forName: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil, queue: nil) { (notification) in
            self.manageTemperatureValueChangeButtton()
            
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.NotificationThresholdDefalutValueChangedChanged, object: nil, queue: nil) { (notification) in
            self.manageRedoxValueChangeButtton()
        }
      
        NotificationCenter.default.addObserver(forName: K.Notifications.PoolSettingsUpdated, object: nil, queue: nil) { (notification) in
            self.callGetStatusApis()
        }
        
        self.perform(#selector(self.callGetStatusApis), with: nil, afterDelay: 3)
        
        NotificationCenter.default.addObserver(forName: K.Notifications.BackFromWintering, object: nil, queue: nil) { (notification) in
            
            let alertController = UIAlertController(title: "Calibrating".localized, message: "Your Flipr has remained in wintering for some time, we advise you to carry out a calibrating.".localized, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction =  UIAlertAction(title: "Later".localized, style: UIAlertAction.Style.cancel) {(result : UIAlertAction) -> Void in
            }
            
            let okAction = UIAlertAction(title: "Calibrating now".localized, style: UIAlertAction.Style.default) {(result : UIAlertAction) -> Void in
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                    viewController.calibrationType = .ph7
                    viewController.dismissEnabled = true
                    let navigationController = LightNavigationViewController.init(rootViewController: viewController)
                    navigationController.setNavigationBarHidden(true, animated: false)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: {
                        
                    })
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        self.appTrackingRequestPermission()
        self.view.bringSubviewToFront(quicActionButton)

      
        /*
         readBLEMeasure(completion: { (error) in
         if error != nil {
         self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
         self.bleStatusView.isHidden = true
         }
         })
         */
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadHUBs()
        AppReview.shared.requestReviewIfNeeded()
        self.view.bringSubviewToFront(quicActionButton)

    }
    
    func intialTabSetup(){
        self.fliprTabScrollView.isHidden = false
        self.hubTabScrollView.isHidden = true
        self.flipTabButton.isUserInteractionEnabled = false
        self.hubTabButton.isUserInteractionEnabled = true
    }
    
    func handlTabSelcection(){
        self.fliprTabScrollView.isHidden = isHubTabSelected
        self.hubTabScrollView.isHidden = !isHubTabSelected
        self.flipTabButton.isUserInteractionEnabled = isHubTabSelected
        self.hubTabButton.isUserInteractionEnabled = !isHubTabSelected
    }
    
    @IBAction func tappedFliprTab(){
        self.fliprTabView.backgroundColor = UIColor(hexString: "111729")
        self.hubTabView.backgroundColor = UIColor(hexString: "97A3B6")

        isHubTabSelected = !isHubTabSelected
        handlTabSelcection()
    }
    
    @IBAction func tappedHubTab(){
        self.fliprTabView.backgroundColor = UIColor(hexString: "97A3B6")
        self.hubTabView.backgroundColor = UIColor(hexString: "111729")
        isHubTabSelected = !isHubTabSelected
        handlTabSelcection()
    }
    
    func setupDashboardUI(){
        fliprTabView.clipsToBounds = true
        fliprTabView.layer.cornerRadius = 12
        if #available(iOS 11.0, *) {
            fliprTabView.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        hubTabView.layer.cornerRadius = 12
        if #available(iOS 11.0, *) {
            hubTabView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func userHasNoFlipr(){
        self.waveView.isHidden = true
        self.addFirstFliprView.isHidden = false
    }
    
    func hideUserHasNoFlipr(){
        self.waveView.isHidden = false
        self.addFirstFliprView.isHidden = true
    }
    
    @IBAction func addFirstFliprButtonClicked(){
        let fliprStoryboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddFliprViewController")
        let nav = UINavigationController.init(rootViewController: viewController)
        self.present(nav, animated: true)
    }
    
    func addHubEquipments(){
    
        let fliprStoryboard = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "ElectricalSetupViewController") as! ElectricalSetupViewController
        viewController.isPresentView = true
        let navigationVC = UINavigationController.init(rootViewController: viewController)
        self.present(navigationVC, animated: true)
    }
    
    /*
    func refreshHUBdisplay() {
     
        if let hub = hub {
            hubButton.setTitle(hub.equipementName, for: .normal)
            if hub.equipementState {
                stateLabel.text = "Working".localized()
                stateImageView.image = UIImage(named: "play_circle")
                manualSwitch.isOn = hub.equipementState
            } else {
                stateLabel.text = "Stopped".localized()
                stateImageView.image = UIImage(named: "stop_circle")
                manualSwitch.isOn = hub.equipementState
            }
            if hub.behavior == "manual" {
                modeValueLabel.text = "Manual".localized()
                automSwitch.isOn = false
                manualButtonAction(self)
            } else if hub.behavior == "planning" {
                modeValueLabel.text = "Program".localized()
                automSwitch.isOn = false
                progButtonAction(self)
            } else if hub.behavior == "auto" {
                modeValueLabel.text = "Smart Control"
                automSwitch.isOn = true
                automButtonAction(self)
                hub.getAutomMessage { (message) in
                    if message != nil {
                        self.autoMessageLabel.text = message
                        self.autoMessageLabel.isHidden = false
                    }
                }
            } else {
                modeValueLabel.text = "Unkown mode"
                automSwitch.isOn = false
                manualButtonAction(self)
            }
        }
       
    }
     */
    
    func pumbOffOn(isOn:Bool){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        
        HUB.currentHUB?.updateState(value: isOn, completion: { (error) in
            if error != nil {
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 3)
            } else {
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
            }
            self.refreshHUBdisplay()
            self.view.hideStateView()
        })
        
    }
    
    
    
    @IBAction func pumbSwitchActionFliptrTab(sender:UIButton){
        if sender.tag == 1{
            if self.hubPumb?.behavior == "manual" {
                self.pumbOffOn(isOn: false)
            }else{
                self.hubButtonAction(self)
            }
        }
        else if sender.tag == 0{
            if self.hubPumb?.behavior == "manual" {
                self.pumbOffOn(isOn: true)
            }else{
                self.hubButtonAction(self)
            }
        }
        else{
//            self.hubButtonAction(self)
            showHubSettingView()
        }
    }
    
    
    @IBAction func bulbSwitchActionFliptrTab(sender:UIButton){
        if sender.tag == 1{
            if self.hubBulb?.behavior == "manual" {
                self.pumbOffOn(isOn: false)
            }else{
                self.hubButtonAction(self)
            }
        }
        if sender.tag == 0{
            if self.hubBulb?.behavior == "manual" {
                self.pumbOffOn(isOn: true)
            }else{
                self.hubButtonAction(self)
            }
        }
        else{
            showHubSettingView()
        }
    }
    
    func showHubSettingView(){
        addHubEquipments()
    }
    
    func handleHubViews(){
        
        for hubObj in self.hubs{
            if hubObj.equipementCode == 84{
                self.hubBulb = hubObj
            }
            else if hubObj.equipementCode == 86{
                self.hubPumb = hubObj
            }
        }
        
        if let hubObj = self.hubBulb{
            if hubObj.equipementState {
                bulbActionButton.setImage(UIImage(named: "ON"), for: .normal)
                bulbActionButton.tag = 1
            }else{
                bulbActionButton.setImage(UIImage(named: "OFF"), for: .normal)
                bulbActionButton.tag = 0
            }
        }
        
        if let hubObj = self.hubPumb{
            if hubObj.equipementState {
                pumbActionButton.setImage(UIImage(named: "pumbOn"), for: .normal)
                pumbActionButton.tag = 1
                if hubObj.behavior == "manual" {
                    pumbActionButton.setImage(UIImage(named: "ON"), for: .normal)
                }
                else if hubObj.behavior == "planning" {
                    pumbActionButton.setImage(UIImage(named: "pumbPgmOn"), for: .normal)
                }
                else if hubObj.behavior == "auto" {
                    pumbActionButton.setImage(UIImage(named: "pumbOn"), for: .normal)
                }else{
                    
                }
            }else{
                pumbActionButton.setImage(UIImage(named: "pumbOff"), for: .normal)
                pumbActionButton.tag = 0
                if hubObj.behavior == "manual" {
                    pumbActionButton.setImage(UIImage(named: "OFF"), for: .normal)
                }
                else if hubObj.behavior == "planning" {
                    pumbActionButton.setImage(UIImage(named: "pumbPrgmOff"), for: .normal)
                }
                else if hubObj.behavior == "auto" {
                    pumbActionButton.setImage(UIImage(named: "pumbOff"), for: .normal)
                }else{
                    
                }
            }
        }
        /*
        for hubObj in self.hubs{
            if hubObj.equipementCode == 84{
                self.hubBulb = hubObj
            }
            else if hubObj.equipementCode == 86{
                self.hubPumb = hubObj
            }
            else{
                
            }
            if hubObj.equipementState {
                if hubObj.equipementCode == 84{
                    bulbActionButton.setImage(UIImage(named: "ON"), for: .normal)
                    bulbActionButton.tag = 1
                }
                else if hubObj.equipementCode == 86{
                    pumbActionButton.setImage(UIImage(named: "pumbOn"), for: .normal)
                    pumbActionButton.tag = 1
                    if hubObj.behavior == "manual" {
                        pumbActionButton.setImage(UIImage(named: "ON"), for: .normal)
                    }
                    else if hubObj.behavior == "planning" {
                        pumbActionButton.setImage(UIImage(named: "pumbPgmOn"), for: .normal)
                    }
                    else if hubObj.behavior == "auto" {
                        pumbActionButton.setImage(UIImage(named: "pumbOn"), for: .normal)
                    }else{
                        
                    }
                }
            } else {
                if hubObj.equipementCode == 84{
                    bulbActionButton.setImage(UIImage(named: "OFF"), for: .normal)
                    bulbActionButton.tag = 0
                }
                else if hubObj.equipementCode == 86{
                    pumbActionButton.setImage(UIImage(named: "pumbOff"), for: .normal)
                    pumbActionButton.tag = 0
                    if hubObj.behavior == "manual" {
                        pumbActionButton.setImage(UIImage(named: "OFF"), for: .normal)
                    }
                    else if hubObj.behavior == "planning" {
                        pumbActionButton.setImage(UIImage(named: "pumbPrgmOff"), for: .normal)
                    }
                    else if hubObj.behavior == "auto" {
                        pumbActionButton.setImage(UIImage(named: "pumbOff"), for: .normal)
                    }else{
                        
                    }
                  
                }
            }
        }
        
        */
        
        return
        
        if self.hub != nil {
            if HUB.currentHUB!.plannings.count == 0 {
                self.addNewProgramView.isHidden = false
                self.isShowingAddFirstProgramView = true
                self.addNewProgramViewHeightConstraint.constant = 68
                self.addNewProgramViewBottomConstraint.constant = 0
            }
            else{
                self.addNewProgramView.isHidden = false
                self.addNewProgramViewHeightConstraint.constant = 0
            }
            self.addNewProgramViewBottomConstraint.constant = 12
            
            self.isShowingHubView = true
            self.programListView.isHidden = false
            self.programListViewHeightConstraint.constant = 128
//            self.updateWaterAnimation()
        }else{
            self.addNewProgramViewHeightConstraint.constant = 0
            self.addNewProgramViewBottomConstraint.constant = 0
            self.programListViewHeightConstraint.constant = 0
            self.addNewProgramView.isHidden = true
            self.programListView.isHidden = true
            self.isShowingAddFirstProgramView = false
            self.isShowingHubView = false
        }
    }
    
   /*
    func updateWaterFlowAnimation(){
        var startElevation =  0.71
        if self.isShowingAddFirstProgramView && self.isShowingHubView {
            startElevation = 0.51
        }else{
            if self.isShowingAddFirstProgramView {
                startElevation =  0.65
            }
            if self.isShowingHubView {
                startElevation =  0.58
            }
        }
//        fluidViewTopEdge
        fluidViewTopEdge.fill(to: NSNumber(floatLiteral: startElevation))
        fluidView.fill(to: NSNumber(floatLiteral: startElevation))
    }
    */
    
    func appTrackingRequestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func showLoginScreen(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let loginSb = UIStoryboard(name: "LoginSignup", bundle: nil)
        let loginNav = loginSb.instantiateViewController(withIdentifier: "LoginNavigation")
        appDelegate.window?.rootViewController = loginNav
    }
    
    @objc func callGetStatusApis(){
        self.loadHUBs()
        getThresholdValues()
        getNotificationStatus()
    }
    
    func getThresholdValues(){
        if let module = Module.currentModule {
            Alamofire.request(Router.readModuleThresholds(serialId: module.serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                
                case .success(let value):
                    
                    print("get thresholds response.result.value: \(value)")
                    
                    if let JSON = value as? [String:Any] {
                        self.checkDefaultValueChanged(JSON:JSON)
                        
                    }
                    
                case .failure(let error):
                    print("get thresholds did fail with error: \(error)")
                }
            })
        }
    }
    
    func getNotificationStatus(){
        Alamofire.request(Router.readUserNotifications).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            
            case .success(let value):
                
                print("get notifications response.result.value: \(value)")
                
                if let JSON = value as? [String:Any] {
                    
                    if let value = JSON["Value"] as? Bool {
                        UserDefaults.standard.set(value, forKey: notificationOnOffValuesKey)
                        NotificationCenter.default.post(name: K.Notifications.NotificationSetttingsChanged, object: nil)
                    }
                    
                } else {
                    self.showError(title: "Error".localized, message: "Data format returned by the server is not supported.".localized)
                }
                
            case .failure(let error):
                
                print("get notifications did fail with error: \(error)")
                
            }
        })
    }
    
    func manageRedoxValueChangeButtton(){
        let value = UserDefaults.standard.bool(forKey: userDefaultThresholdValuesKey)
        //        self.redoxChangeButton.isHidden = value
        
        UIView.transition(with:  self.redoxChangeButton, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.redoxChangeButton.isHidden = value
                          })
        
    }
    
    func manageTemperatureValueChangeButtton(){
        manageThresholdButton()
        /*
        let minValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMinValuesKey)
        let maxValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMaxValuesKey)
        if minValue && maxValue{
            //            self.waterTmpChangeButton.isHidden = true
            UIView.transition(with:  self.waterTmpChangeButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.waterTmpChangeButton.isHidden = true
                              })
        }else{
            UIView.transition(with:  self.waterTmpChangeButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.waterTmpChangeButton.isHidden = false
                              })
        }
        */
    }
    
    func managePhValueChangeButtton(){
        manageThresholdButton()
        /*
        let minValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMinValuesKey)
        let maxValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMaxValuesKey)
        if minValue && maxValue{
            UIView.transition(with:  self.phChangeButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.phChangeButton.isHidden = true
                              })
        }else{
            UIView.transition(with:  self.phChangeButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.waterTmpChangeButton.isHidden = false
                              })
        }
        */
    }
    
    func manageThresholdButton(){
        let phMinValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMinValuesKey)
        let phMaxValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMaxValuesKey)
        
        let waterMinValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMinValuesKey)
        let waterMaxValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMaxValuesKey)
        if phMinValue && phMaxValue && waterMinValue && waterMaxValue{
            UIView.transition(with:  self.waterTmpChangeButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.waterTmpChangeButton.isHidden = true
                              })
        }else{
            UIView.transition(with:  self.waterTmpChangeButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.waterTmpChangeButton.isHidden = false
                              })
        }


    }
    
    func manageNotificationDisabledButtton(){
        let value = UserDefaults.standard.bool(forKey: notificationOnOffValuesKey)
        //        self.notificationDisabledButton.isHidden = value
        UIView.transition(with:  self.notificationDisabledButton, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.notificationDisabledButton.isHidden = !value
                          })
    }
    
    func setupInitialView() {
      //  var fluidColor =  UIColor.init(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)
        let fluidColor =  UIColor.init(hexString: "fcad71")
        
        if let module = Module.currentModule {
            self.hideUserHasNoFlipr()
            if module.isForSpa {
                //backgroundImageView.image = UIImage(named:"Dashboard_BG_SPA")
                //backgroundOverlayImageView.image = UIImage(named:"Degrade_dashboard_SPA")
                //fluidColor =  UIColor.init(colorLiteralRed: 64/255.0, green: 125/255.0, blue: 136/255.0, alpha: 1)
            }
        }else{
            self.userHasNoFlipr()
        }
        
        alertButton.isHidden = true
        alertCheckView.isHidden = true
        lastMeasureDateLabel.isHidden = true
        bleStatusView.isHidden = true
        
        alert0Button.isHidden = true
        alert1Button.isHidden = true
        alert2Button.isHidden = true
        alert3Button.isHidden = true
        alert4Button.isHidden = true
        
        pHSateView.layer.cornerRadius = pHSateView.bounds.height/2
        orpStateView.layer.cornerRadius = orpStateView.bounds.height/2
        pHSateView.layer.borderWidth = 2
        pHSateView.layer.borderColor = UIColor.white.cgColor
        orpStateView.layer.borderWidth = 2
        orpStateView.layer.borderColor = UIColor.white.cgColor

        
        if Device.size() == Size.screen3_5Inch || Device.size() == Size.screen4Inch {
            orpViewRightConstraint.constant = 8
            phViewLeftConstraint.constant = 0
        }
        
        /*
         // iPhone 6,7
         var startElevation = 0.67
         temperaturesTopConstraint.constant = self.view.frame.size.height * (1 - startElevation)
         
         //iPhone 4 + iPad
         if Device.size() == Size.screen3_5Inch {
         startElevation = 0.67
         temperaturesTopConstraint.constant = 0
         //airTemperatureLabel.font = UIFont(name: "Lato-Light", size: 50)
         //waterTemperatureLabel.font = UIFont(name: "Lato-Light", size: 50)
         orpViewRightConstraint.constant = 8
         phViewLeftConstraint.constant = 0
         }
         
         //iPhone 5
         if Device.size() == Size.screen4Inch {
         startElevation = 0.68
         temperaturesTopConstraint.constant = 20
         //airTemperatureLabel.font = UIFont(name: "Lato-Light", size: 55)
         //waterTemperatureLabel.font = UIFont(name: "Lato-Light", size: 55)
         orpViewRightConstraint.constant = 12
         phViewLeftConstraint.constant = 4
         }
         
         //iPhone 6,7 +  ou X
         if Device.size() > Size.screen4_7Inch {
         startElevation = 0.65
         if #available(iOS 11.0, tvOS 11.0, *) {
         print("Top noch: \(UIApplication.shared.delegate?.window??.safeAreaInsets.top)")
         if (UIApplication.shared.delegate?.window??.safeAreaInsets.top)! > CGFloat(20) { // hasTopNotch
         temperaturesTopConstraint.constant = self.view.frame.height - (self.view.frame.height * CGFloat(startElevation)) - 160
         } else {
         temperaturesTopConstraint.constant = self.view.frame.height - (self.view.frame.height * CGFloat(startElevation)) - 140
         }
         } else {
         temperaturesTopConstraint.constant = self.view.frame.height - (self.view.frame.height * CGFloat(startElevation)) - 140
         }
         }
         */
        
        
        
//        var startElevation =  0.71
//        if self.isShowingAddFirstProgramView && self.isShowingHubView {
//            startElevation = 0.51
//        }else{
//            if self.isShowingAddFirstProgramView {
//                startElevation =  0.65
//            }
//            if self.isShowingHubView {
//                startElevation =  0.58
//            }
//        }
        
        
        var startElevation = 0.85
        
        let modelName = UIDevice().type
        if  modelName.rawValue == "iPhone 12 Pro"{
            startElevation = 0.91
        }
        else if modelName.rawValue == "iPhone 12 Pro Max"{
            startElevation = 0.75
        }

        else if modelName.rawValue == "iPhone 8 Plus" || modelName.rawValue == "iPhone 7 Plus" {
            startElevation = 0.95
        }
//        temperaturesTopConstraint.constant = self.view.frame.height * (1 - CGFloat(startElevation)) + 20
        if #available(iOS 11.0, tvOS 11.0, *) {
            if (UIApplication.shared.delegate?.window??.safeAreaInsets.top)! > CGFloat(20) { // hasTopNotch
//                temperaturesTopConstraint.constant = self.view.frame.height * (1 - CGFloat(startElevation))
            }
        }
        
//        let frame = CGRect(x: -(self.view.frame.height - self.view.frame.width)/2 - 50, y: 0, width: sqrt(self.view.frame.height * self.view.frame.height + self.view.frame.width * self.view.frame.width) + 100, height: self.view.frame.height + 100)

        let frame = self.waveView.frame
        fluidView = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral:  startElevation))
        fluidView.strokeColor = .clear
        fluidView.fillColor = UIColor.init(hexString: "CD69C0") // UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
        fluidView.fill(to: NSNumber(floatLiteral: startElevation))
        fluidView.startAnimation()
        fluidView.clipsToBounds = false
        
        self.scrollViewContainerView.insertSubview(fluidView, belowSubview: backgroundOverlayImageView)
        
        fluidViewTopEdge = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral: startElevation))
        fluidViewTopEdge.strokeColor = .clear
        fluidViewTopEdge.fillColor = fluidColor
        fluidViewTopEdge.fill(to: NSNumber(floatLiteral: startElevation))
        fluidViewTopEdge.startAnimation()
        fluidViewTopEdge.clipsToBounds = false

       
     //   fluidView.clipsToBounds = true
        self.scrollViewContainerView.insertSubview(fluidViewTopEdge, aboveSubview: fluidView)
        
        
        //Hun wave setup
        var hubTabStartElevation = 0.85

        let hubWaveframe = self.hubWaveContainerView.frame
        hubTabfluidView = BAFluidView.init(frame: hubWaveframe, startElevation: NSNumber(floatLiteral:  hubTabStartElevation))
        hubTabfluidView.strokeColor = .clear
        hubTabfluidView.fillColor = UIColor.init(hexString: "CD69C0") // UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
        hubTabfluidView.fill(to: NSNumber(floatLiteral: hubTabStartElevation))
        hubTabfluidView.startAnimation()
        hubTabfluidView.clipsToBounds = true
        
        self.hubScrollViewContainerView.insertSubview(hubTabfluidView, belowSubview: backgroundOverlayHubImageView)
        
        hubTabFluidViewTopEdge = BAFluidView.init(frame: hubWaveframe, startElevation: NSNumber(floatLiteral: hubTabStartElevation))
        hubTabFluidViewTopEdge.strokeColor = .clear
        hubTabFluidViewTopEdge.fillColor = fluidColor
        hubTabFluidViewTopEdge.fill(to: NSNumber(floatLiteral: hubTabStartElevation))
        hubTabFluidViewTopEdge.startAnimation()
        hubTabFluidViewTopEdge.clipsToBounds = true
       
        self.hubScrollViewContainerView.insertSubview(hubTabFluidViewTopEdge, aboveSubview: hubTabfluidView)

       // setGradientBackground()
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main) {
            [weak self] (data, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            //
            
            //if data.gravity.x > -0.025 && data.gravity.x < 0.025 || data.gravity.y > -0.05 { //&& data.gravity.y < 0.05 {
            if data.gravity.y > -0.05 {
                self!.fluidViewTopEdge.transform = CGAffineTransform(rotationAngle: 0)
                self!.fluidView.transform = CGAffineTransform(rotationAngle: 0)
                self!.hubTabFluidViewTopEdge.transform = CGAffineTransform(rotationAngle: 0)
                self!.hubTabfluidView.transform = CGAffineTransform(rotationAngle: 0)
            } else {
                let rotation = atan2(data.gravity.x,data.gravity.y) - .pi
                self!.fluidViewTopEdge.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                self!.fluidView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                self!.hubTabFluidViewTopEdge.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                self!.hubTabfluidView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))

            }
            
        }
        self.view.bringSubviewToFront(quicActionButton)
       /*
        let pHCircle = CAShapeLayer()
        
        let startAngle = CGFloat(150 * Double.pi / 180)
        let endAngle = CGFloat(30 * Double.pi / 180)
        
        pHCircle.path = UIBezierPath(arcCenter: CGPoint(x: pHView.bounds.width/2, y: 84), radius: 66, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        pHCircle.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        pHCircle.strokeColor = K.Color.DarkBlue.cgColor
        pHCircle.lineWidth = 8
        pHCircle.lineCap = CAShapeLayerLineCap.round
        pHView.layer.addSublayer(pHCircle)
        */
    }
    
    /*
    func updateWaterAnimation(){
        fluidView.removeFromSuperview()
        fluidView = nil
        fluidViewTopEdge.removeFromSuperview()
        fluidViewTopEdge = nil
        let fluidColor =  UIColor.init(hexString: "fcad71")
        var startElevation =  0.71
        if self.isShowingAddFirstProgramView && self.isShowingHubView {
            startElevation = 0.37
        }else{
            if self.isShowingAddFirstProgramView {
                startElevation =  0.65
            }
            if self.isShowingHubView {
                startElevation =  0.58
            }
        }
        
        let frame = self.waveView.frame
        fluidView = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral:  startElevation))
        fluidView.strokeColor = .clear
        fluidView.fillColor = UIColor.init(hexString: "CD69C0") // UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
        fluidView.fill(to: NSNumber(floatLiteral: startElevation))
        fluidView.startAnimation()
        fluidView.clipsToBounds = false

        self.scrollViewContainerView.insertSubview(fluidView, belowSubview: backgroundOverlayImageView)
        
        fluidViewTopEdge = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral: startElevation))
        fluidViewTopEdge.strokeColor = .clear
        fluidViewTopEdge.fillColor = fluidColor
        fluidViewTopEdge.fill(to: NSNumber(floatLiteral: startElevation))
        fluidViewTopEdge.startAnimation()
        fluidViewTopEdge.clipsToBounds = false

        //   fluidView.clipsToBounds = true
        self.scrollViewContainerView.insertSubview(fluidViewTopEdge, aboveSubview: fluidView)
        
        
        // setGradientBackground()
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main) {
            [weak self] (data, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            //
            
            //if data.gravity.x > -0.025 && data.gravity.x < 0.025 || data.gravity.y > -0.05 { //&& data.gravity.y < 0.05 {
            if data.gravity.y > -0.05 {
                self!.fluidViewTopEdge.transform = CGAffineTransform(rotationAngle: 0)
                self!.fluidView.transform = CGAffineTransform(rotationAngle: 0)
            } else {
                let rotation = atan2(data.gravity.x,data.gravity.y) - .pi
                self!.fluidViewTopEdge.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                self!.fluidView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            }
        }
    
    }
    
    */
    
    
    func setGradientBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "FFB779").cgColor,UIColor(hexString:"FF62B9").cgColor,UIColor(hexString: "2481D7").cgColor,UIColor(hexString: "1DDCC5").cgColor]
        gradientLayer.locations = [0,-10.67,1.4,0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.gradiantView.bounds
        self.gradiantView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func refresh() {
        
        self.hideFliprData()
        self.hideWeatherForecast()
        
        if Pool.currentPool?.city != nil {
            
            if Module.currentModule == nil && HUB.currentHUB != nil {
                self.updateHUBData()
                return
            }
            
            if let mode = Pool.currentPool?.mode {
                if mode.id == 2 {
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Passive Wintering".localized, message: "You have placed your pool in passive wintering : Flipr does not display datas. To view the datas, please change the status of your pool and follow the advices of impoundment".localized)
                    return
                } else {
                    self.view.hideStateView()
                }
            }
            
            self.perform(#selector(self.showStockPopUpIfNeeded), with: nil, afterDelay: 2)
            
            if let date =  UserDefaults.standard.value(forKey:"FirstMeasureStartDate") as? Date {
                print("FirstMeasureStartDate interval: \(date.timeIntervalSinceNow)")
                if date.timeIntervalSinceNow < -150 {
                    
                    self.view.hideStateView()
                    
                    //self.updateWeatherForecast()
                    
                    self.updateFliprData()
                    
                    /*
                     if let sentDate =  UserDefaults.standard.value(forKey:"LastMeasureSentDate") as? Date {
                     print("sentDate interval since now:\(sentDate.timeIntervalSinceNow)")
                     if sentDate.timeIntervalSinceNow < -600 {
                     readBLEMeasure(completion: { (error) in
                     if error != nil {
                     self.showError(title: "Erreur de connexion Bluetooth", message: error?.localizedDescription)
                     self.bleStatusView.isHidden = true
                     }
                     })
                     }
                     } else {
                     print("Read BLE measure without LastMeasureSentDate")
                     readBLEMeasure(completion: { (error) in
                     if error != nil {
                     self.showError(title: "Erreur de connexion Bluetooth", message: error?.localizedDescription)
                     self.bleStatusView.isHidden = true
                     }
                     })
                     }*/
                    
                    
                } else {
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: "Still a little patience, you can leave the application and come back in a few minutes...".localized)
                    self.perform(#selector(self.refresh), with: nil, afterDelay: 160)
                }
            }
            
            
        } else {
            
            if HUB.currentHUB != nil {
                var message = "Meanwhile, let's get to know your pool...".localized
                var buttonTitle = "My pool!".localized
                if let module = Module.currentModule {
                    if module.isForSpa {
                        buttonTitle = "My spa!".localized
                        message = "Meanwhile, let's get to know your spa...".localized
                    }
                }
                self.perform(#selector(self.refresh), with: nil, afterDelay: 160)
                self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Configuration du HUB en cours !".localized, message: message, buttonTitle: buttonTitle, buttonAction: {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PoolViewControllerID") {
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    }
                })
            } else {
                var message = "Meanwhile, let's get to know your pool...".localized
                var buttonTitle = "My pool!".localized
                if let module = Module.currentModule {
                    if module.isForSpa {
                        buttonTitle = "My spa!".localized
                        message = "Meanwhile, let's get to know your spa...".localized
                    }
                }
                self.perform(#selector(self.refresh), with: nil, afterDelay: 160)
                self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: message, buttonTitle: buttonTitle, buttonAction: {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PoolViewControllerID") {
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    }
                })
            }
            
        }
        
    }
    
    func readBLEMeasure(completion: ((_ error: Error?) -> Void)?) {
        
        if !self.bleMeasureHasBeenSent {
            
            print("readBLEMeasure")
            
            self.bleStatusLabel.text = "Searching for flipr...".localized
            self.bleStatusView.isHidden = false
            
            self.perform(#selector(self.checkForDeviceSearchingTimeOut), with: nil, afterDelay: 5)
            
            BLEManager.shared.sendMeasuresCompletionBlock = completion
            
            if BLEManager.shared.measuresCharacteristic != nil {
                BLEManager.shared.sendMeasureAfterConnection = true
                if BLEManager.shared.flipr?.state == .connected {
                    self.bleStatusView.isHidden = false
                    self.bleStatusLabel.text = "Retrieving the measure...".localized
                    BLEManager.shared.flipr?.readValue(for: BLEManager.shared.measuresCharacteristic!)
                } else {
                    self.bleStatusView.isHidden = false
                    self.bleStatusLabel.text = "Connecting to flipr...".localized
                    BLEManager.shared.isConnecting = true
                    BLEManager.shared.centralManager.connect(BLEManager.shared.flipr!, options: nil)
                }
            } else if BLEManager.shared.flipr != nil {
                BLEManager.shared.sendMeasureAfterConnection = true
                if BLEManager.shared.flipr?.state == .connected {
                    self.bleStatusView.isHidden = false
                    self.bleStatusLabel.text = "Connecting to flipr...".localized
                    BLEManager.shared.flipr?.discoverServices([FliprBLEParameters.measuresServiceUUID,FliprBLEParameters.deviceServiceUUID])
                } else {
                    self.bleStatusView.isHidden = false
                    self.bleStatusLabel.text = "Connecting to flipr...".localized
                    BLEManager.shared.isConnecting = true
                    BLEManager.shared.centralManager.connect(BLEManager.shared.flipr!, options: nil)
                }
            } else {
                BLEManager.shared.startUpCentralManager(connectAutomatically: true, sendMeasure: true)
                //self.updateFliprData()
            }
        }
        
    }
    
    @objc func checkForDeviceSearchingTimeOut() {
        if BLEManager.shared.centralManager.isScanning {
            //V.2.?? On laisse le scan en BG cf. Ticket https://taiga.isee-u.fr/project/julien-flipr/issue/328
            //BLEManager.shared.centralManager.stopScan()
            self.bleStatusLabel.text = "No flipr nearby.".localized
            self.perform(#selector(self.hideSatusLabel), with: nil, afterDelay: 1)
        }
    }
    
    @objc func hideSatusLabel() {
        self.bleStatusView.isHidden = true
    }
    
    func updateWeatherForecast() {
        
        hideWeatherForecast()
        
        print("Update Weather forecast for city: \(Pool.currentPool?.city)")
        
        if let city = Pool.currentPool?.city  {
            
            let apiKey = "b4bac883d4b707db90ff523d0a4afe98"
            
            Alamofire.request("https://api.forecast.io/forecast/\(apiKey)/\(city.latitude),\(city.longitude)?lang=fr&units=si").responseJSON { response in
                if let JSON = response.result.value as? [String:Any] {
                    print("Forecast JSON: \(JSON)")
                    if let currently = JSON["currently"] as? [String:Any] {
                        var currentTemperature = 0.0
                        if let temperature = currently["temperature"] as? Double {
                            print("Air T°: \(temperature)")
                            
                            currentTemperature = temperature
                            
                            let textAnimation = CATransition()
                            textAnimation.type = CATransitionType.push
                            textAnimation.subtype = CATransitionSubtype.fromBottom
                            textAnimation.duration = 0.5
                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            self.airTemperatureLabel.layer.add(textAnimation, forKey: "changeAirTempratureTransition")
                            
                            self.airTemperatureLabel.text = String(format: "%.0f", temperature) + "°"
                            self.airTemperatureLabelHubTab.text = String(format: "%.0f", temperature) + "°"

                        }
                        if let icon = currently["icon"] as? String {
                            print("Icon: \(icon)")
                            
                            let textAnimation = CATransition()
                            textAnimation.type = CATransitionType.push
                            textAnimation.subtype = CATransitionSubtype.fromLeft
                            textAnimation.duration = 0.5
                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            self.currentlyWeatherIcon.layer.add(textAnimation, forKey: "changeCurrentlyWeatherIconTransition")
                            
                            self.currentlyWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                            self.currentlyWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: icon)

                        }
                        if let hourly = JSON["hourly"] as? [String:Any] {
                            if let data = hourly["data"] as? [[String:Any]] {
                                var i = 0
                                for item in data {
                                    if i == 4 {
                                        if let icon = item["icon"] as? String {
                                            print("Icon: \(icon)")
                                            
                                            let textAnimation = CATransition()
                                            textAnimation.type = CATransitionType.push
                                            textAnimation.subtype = CATransitionSubtype.fromRight
                                            textAnimation.duration = 0.5
                                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                            self.comingWeatherIcon.layer.add(textAnimation, forKey: "changeComingWeatherIconTransition")
                                            self.comingWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                                            self.comingWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: icon)

                                        }
                                        if let forecastTemperature = item["temperature"] as? Double {
                                            print("Forecast Air T°: \(forecastTemperature)")
                                            if forecastTemperature > currentTemperature {
                                                self.airTendendcyImageView.image = UIImage(named: "arrow_air_up")
                                                self.airTendendcyImageView.isHidden = false
                                                
                                                self.airTendendcyImageViewHubTab.image = UIImage(named: "arrow_air_up")
                                                self.airTendendcyImageViewHubTab.isHidden = false
                                            } else {
                                                self.airTendendcyImageView.image = UIImage(named: "arrow_air_down")
                                                self.airTendendcyImageView.isHidden = false
                                                self.airTendendcyImageViewHubTab.image = UIImage(named: "arrow_air_down")
                                                self.airTendendcyImageViewHubTab.isHidden = false
                                                
                                                
                                            }
                                        } else {
                                            self.airTendendcyImageView.isHidden = true
                                            self.airTendendcyImageViewHubTab.isHidden = true

                                        }
                                    }
                                    i = i + 1
                                }
                            }
                        }
                        UIView.animate(withDuration: 0.5, animations: {
                            for view in self.view.subviews {
                                if view.tag == 1 {
                                    view.alpha = 1
                                }
                                for subview in view.subviews {
                                    if subview.tag == 1 {
                                        subview.alpha = 1
                                    }
                                }
                            }
                        }, completion: { (success) in
                        })
                    }
                }
            }
        } else {
            hideWeatherForecast()
        }
        
    }
    
    func handleSubscriptionButton(){
        self.subscriptionButton.backgroundColor  = UIColor.init(hexString: "FF8F50")
        self.subscriptionButton.setTitleColor(.white, for: .normal)
        self.subscriptionButton.setTitle("Alerte en cours : suivez nos conseils".localized, for: .normal)
        self.subscriptionButton.setImage(UIImage(named: "alertSubscription"), for: .normal)
    }
    
    func hideWeatherForecast() {
        airTemperatureLabel.text = "  "
        airTemperatureLabelHubTab.text = "  "
        currentlyWeatherIcon.text = "  "
        currentlyWeatherIconHubTab.text = "  "

        startWeatherIcon.text = "   "
        startWeatherIcon.isHidden = true
        startWeatherIconHubTab.text = "   "
        startWeatherIconHubTab.isHidden = true
        weatherChevronImageView.isHidden = true
        weatherChevronImageViewHubTab.isHidden = true

        comingWeatherIcon.text = "  "
        comingWeatherIconHubTab.text = "  "
        for view in self.view.subviews {
            if view.tag == 1 {
                view.alpha = 0
            }
            for subview in view.subviews {
                if subview.tag == 1 {
                    subview.alpha = 0
                }
            }
        }
    }
    
    func climaconsCharWithIcon(icon: String) -> String {
        
        switch icon {
        case "clear-day":
            return "I"
        case "clear-night":
            return "N"
        case "rain":
            return "$"
        case "snow":
            return "6"
        case "sleet":
            return ""
        case "wind":
            return "B"
        case "fog":
            return "?"
        case "cloudy":
            return "!"
        case "partly-cloudy-day":
            return "\""
        case "partly-cloudy-night":
            return "#"
        case "hail":
            return "3"
        case "thunderstorm":
            return "F"
        case "tornado":
            return "F"
        default:
            return ""
        }
        
    }
    
    func updateAlerts() {
        
        self.alert = nil
        self.alertButton.isHidden = true
        self.alertCheckView.isHidden = true
        
        self.alert0Button.isHidden = true
        self.alert1Button.isHidden = true
        self.alert2Button.isHidden = true
        self.alert3Button.isHidden = true
        self.alert4Button.isHidden = true
        
        if let module = Module.currentModule {
            if !module.isSubscriptionValid {
                return
            }
        }
        
        Module.currentModule?.getAlerts(completion: { (alert, priorityAlerts, error) in
            if alert != nil {
                self.alert = alert
                if self.alert?.status == 0 {
                    self.alertButton.isHidden = false
                    self.alertCheckView.isHidden = true
                } else {
                    self.alertButton.isHidden = true
//                    self.alertCheckView.isHidden = false
                }
                
            } else {
                self.alert = nil
                self.alertButton.isHidden = true
                self.alertCheckView.isHidden = true
            }
            
            var i = 0
            
            for alert in priorityAlerts {
                if i == 0 {
                    self.alert0Button.alert = alert
                    self.alert0Button.isHidden = false
                }
                if i == 1 {
                    self.alert1Button.alert = alert
                    self.alert1Button.isHidden = false
                }
                if i == 2 {
                    self.alert2Button.alert = alert
                    self.alert2Button.isHidden = false
                }
                if i == 3 {
                    self.alert3Button.alert = alert
                    self.alert3Button.isHidden = false
                }
                if i == 4 {
                    self.alert4Button.alert = alert
                    self.alert4Button.isHidden = false
                }
                i = i + 1
            }
            
        })
        
    }
    
    func updateHUBData() {
        hideFliprData()
        
        if let identifier = HUB.currentHUB?.serial {
            
            Alamofire.request(Router.readModuleResume(serialId: identifier)).responseJSON(completionHandler: { (response) in
                
                if response.response?.statusCode == 401 {
                    NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                }
                
                if let error = response.result.error {
                    print("Update Flipr data did fail with error: \(error)")
                    
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Refresh error".localized, message: error.localizedDescription, buttonTitle: "Retry".localized, buttonAction: {
                        self.view.hideStateView()
                        self.updateFliprData()
                    })
                    
                } else if let JSON = response.result.value as? [String:Any] {
                    
                    print("HUB JSON resume: \(JSON)")
                    
                    if let weather = JSON["Weather"] as? [String:Any] {
                        if let temperature = weather["CurrentTemperature"] as? Double {
                            print("Air T°: \(temperature)")
                            
                            //currentTemperature = temperature
                            
                            let textAnimation = CATransition()
                            textAnimation.type = CATransitionType.push
                            textAnimation.subtype = CATransitionSubtype.fromBottom
                            textAnimation.duration = 0.5
                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            self.airTemperatureLabel.layer.add(textAnimation, forKey: "changeAirTempratureTransition")
                            
                            self.airTemperatureLabel.text = String(format: "%.0f", temperature) + "°"
                            self.airTemperatureLabelHubTab.text = String(format: "%.0f", temperature) + "°"

                            
                            if let forecastTemperature = weather["NextHourTemperature"] as? Double {
                                if forecastTemperature > temperature {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_up")
                                    self.airTendendcyImageView.isHidden = false
                                    self.airTendendcyImageViewHubTab.image = UIImage(named: "arrow_air_up")
                                    self.airTendendcyImageViewHubTab.isHidden = false
                                } else {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_down")
                                    self.airTendendcyImageView.isHidden = false
                                    self.airTendendcyImageViewHubTab.image = UIImage(named: "arrow_air_down")
                                    self.airTendendcyImageViewHubTab.isHidden = false
                                }
                            } else {
                                self.airTendendcyImageView.isHidden = true
                                self.airTendendcyImageViewHubTab.isHidden = true

                            }
                            
                        }
                        if let icon = weather["CurrentWeatherIcon"] as? String {
                            print("Icon: \(icon)")
                            
                            let textAnimation = CATransition()
                            textAnimation.type = CATransitionType.push
                            textAnimation.subtype = CATransitionSubtype.fromLeft
                            textAnimation.duration = 0.5
                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            
                            
                            if let nextIcon = weather["NextHourWeatherIcon"] as? String {
                                self.currentlyWeatherIcon.layer.add(textAnimation, forKey: "changeCurrentlyWeatherIconTransition")
                                self.currentlyWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                                self.currentlyWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: icon)

                                let textAnimation = CATransition()
                                textAnimation.type = CATransitionType.push
                                textAnimation.subtype = CATransitionSubtype.fromRight
                                textAnimation.duration = 0.5
                                textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                self.comingWeatherIcon.layer.add(textAnimation, forKey: "changeComingWeatherIconTransition")
                                self.comingWeatherIcon.text = self.climaconsCharWithIcon(icon: nextIcon)
                                self.comingWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: nextIcon)

                                self.weatherChevronImageView.isHidden = false
                                self.weatherChevronImageViewHubTab.isHidden = false

                            } else {
                                self.startWeatherIcon.isHidden = false
                                self.startWeatherIconHubTab.isHidden = false
                                self.weatherChevronImageView.isHidden = true
                                self.weatherChevronImageViewHubTab.isHidden = true
                                self.startWeatherIcon.layer.add(textAnimation, forKey: "changeCurrentlyWeatherIconTransition")
                                self.startWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                                self.startWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: icon)

                            }
                            
                        }
                        
                        
                        if let uvIndex = weather["UvIndex"] as? Double {
                            self.uvLabel.isHidden = false
                            self.uvLabelHubTab.isHidden = false

                            self.uvView.isHidden = false
                            self.uvViewHubTab.isHidden = false
                            let index = String(format: "%.0f", uvIndex)
                            self.uvLabel.text = index
                            self.uvLabel.layer.borderWidth = 1
                            self.uvLabel.layer.cornerRadius = (self.uvLabel.frame.size.height / 2)
                            self.uvLabelHubTab.text = index
                            self.uvLabelHubTab.layer.borderWidth = 1
                            self.uvLabelHubTab.layer.cornerRadius = (self.uvLabelHubTab.frame.size.height / 2)
                            if uvIndex <= 2 {
                                self.uvLabel.layer.borderColor = UIColor(red: 41/255.0, green: 255/255.0, blue: 3/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 41/255.0, green: 255/255.0, blue: 3/255.0, alpha: 1).cgColor

                            } else if  uvIndex <= 5 {
                                self.uvLabel.layer.borderColor = UIColor(red: 235/255.0, green: 212/255.0, blue: 15/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 235/255.0, green: 212/255.0, blue: 15/255.0, alpha: 1).cgColor

                            } else if  uvIndex <= 7 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 145/255.0, blue: 33/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 255/255.0, green: 145/255.0, blue: 33/255.0, alpha: 1).cgColor

                            } else if  uvIndex <= 10 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 91/255.0, blue: 95/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 255/255.0, green: 91/255.0, blue: 95/255.0, alpha: 1).cgColor

                            } else {
                                self.uvLabel.layer.borderColor = UIColor(red: 240/255.0, green: 3/255.0, blue: 0/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 240/255.0, green: 3/255.0, blue: 0/255.0, alpha: 1).cgColor

                            }
                        } else {
                            self.uvLabel.text = "NA"
                            self.uvLabel.isHidden = true
                            self.uvLabelHubTab.text = "NA"
                            self.uvLabelHubTab.isHidden = true
                            self.uvView.isHidden = true
                            self.uvViewHubTab.isHidden = true

                        }
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            for view in self.view.subviews {
                                if view.tag == 1 {
                                    view.alpha = 1
                                }
                                for subview in view.subviews {
                                    if subview.tag == 1 {
                                        subview.alpha = 1
                                    }
                                }
                            }
                        }, completion: { (success) in
                            
                        })
                    }
                    
                }
            })
            
        } else {
            print("The Flipr HUB identifier does not exist :/")
        }
    }
    
    func updateFliprData() {
        
        hideFliprData()
        
        if let identifier = Module.currentModule?.serial {
            
            Alamofire.request(Router.readModuleResume(serialId: identifier)).responseJSON(completionHandler: { (response) in
                
                if response.response?.statusCode == 401 {
                    NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                }
                
                if let error = response.result.error {
                    print("Update Flipr data did fail with error: \(error)")
                    
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Refresh error".localized, message: error.localizedDescription, buttonTitle: "Retry".localized, buttonAction: {
                        self.view.hideStateView()
                        self.updateFliprData()
                    })
                    
                } else if let JSON = response.result.value as? [String:Any] {
                    
                    print("JSON: \(JSON)")
                    
                    if let forecast = JSON["HourlyForecast"] as? [[String:Any]] {
                        Pool.currentPool?.hourlyForecast = forecast.reversed()
                    }
                    
                    if let forecast = JSON["DailyForecast"] as? [[String:Any]] {
                        Pool.currentPool?.dailyForecast = forecast
                        if let first = Pool.currentPool?.dailyForecast?.first {
                            if let time = first["DateTime"] as? String {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                //dateFormatter.timeZone = TimeZone.current   
                                if let date = formatter.date(from: time) {
                                    formatter.dateFormat = "MM-dd"
                                    if formatter.string(from: date) == formatter.string(from: Date()) {
                                        Pool.currentPool?.dailyForecast?.removeFirst()
                                    }
                                }
                            }
                        }
                    }
                    
                    if let weather = JSON["Weather"] as? [String:Any] {
                        if let temperature = weather["CurrentTemperature"] as? Double {
                            print("Air T°: \(temperature)")
                            
                            //currentTemperature = temperature
                            
                            let textAnimation = CATransition()
                            textAnimation.type = CATransitionType.push
                            textAnimation.subtype = CATransitionSubtype.fromBottom
                            textAnimation.duration = 0.5
                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            self.airTemperatureLabel.layer.add(textAnimation, forKey: "changeAirTempratureTransition")
                            
                            self.airTemperatureLabel.text = String(format: "%.0f", temperature) + "°"
                            self.airTemperatureLabelHubTab.text = String(format: "%.0f", temperature) + "°"

                            
                            if let forecastTemperature = weather["NextHourTemperature"] as? Double {
                                if forecastTemperature > temperature {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_up")
                                    self.airTendendcyImageView.isHidden = false
                                    self.airTendendcyImageViewHubTab.image = UIImage(named: "arrow_air_up")
                                    self.airTendendcyImageViewHubTab.isHidden = false
                                } else {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_down")
                                    self.airTendendcyImageView.isHidden = false
                                    self.airTendendcyImageViewHubTab.image = UIImage(named: "arrow_air_down")
                                    self.airTendendcyImageViewHubTab.isHidden = false
                                }
                            } else {
                                self.airTendendcyImageView.isHidden = true
                                self.airTendendcyImageViewHubTab.isHidden = true

                            }
                            
                        }
                        if let icon = weather["CurrentWeatherIcon"] as? String {
                            print("Icon: \(icon)")
                            
                            let textAnimation = CATransition()
                            textAnimation.type = CATransitionType.push
                            textAnimation.subtype = CATransitionSubtype.fromLeft
                            textAnimation.duration = 0.5
                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            
                            
                            if let nextIcon = weather["NextHourWeatherIcon"] as? String {
                                self.currentlyWeatherIcon.layer.add(textAnimation, forKey: "changeCurrentlyWeatherIconTransition")
                                self.currentlyWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                                self.currentlyWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: icon)

                                let textAnimation = CATransition()
                                textAnimation.type = CATransitionType.push
                                textAnimation.subtype = CATransitionSubtype.fromRight
                                textAnimation.duration = 0.5
                                textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                self.comingWeatherIcon.layer.add(textAnimation, forKey: "changeComingWeatherIconTransition")
                                self.comingWeatherIcon.text = self.climaconsCharWithIcon(icon: nextIcon)
                                self.comingWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: nextIcon)
                                self.weatherChevronImageView.isHidden = false
                                self.weatherChevronImageViewHubTab.isHidden = false

                            } else {
                                self.startWeatherIcon.isHidden = false
                                self.startWeatherIconHubTab.isHidden = false
                                self.weatherChevronImageView.isHidden = true
                                self.weatherChevronImageViewHubTab.isHidden = true
                                self.startWeatherIcon.layer.add(textAnimation, forKey: "changeCurrentlyWeatherIconTransition")
                                self.startWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                                self.startWeatherIconHubTab.text = self.climaconsCharWithIcon(icon: icon)
                            }
                            
                        }
                        
                        
                        if let uvIndex = weather["UvIndex"] as? Double {
                            self.uvLabel.isHidden = false
                            self.uvLabelHubTab.isHidden = false

                            self.uvView.isHidden = false
                            self.uvViewHubTab.isHidden = false

                            let index = String(format: "%.0f", uvIndex)
                            self.uvLabel.text = index
                            self.uvLabel.layer.borderWidth = 1
                            self.uvLabel.layer.cornerRadius = (self.uvLabel.frame.size.height / 2)
                            self.uvLabelHubTab.text = index
                            self.uvLabelHubTab.layer.borderWidth = 1
                            self.uvLabelHubTab.layer.cornerRadius = (self.uvLabelHubTab.frame.size.height / 2)
                            if uvIndex <= 2 {
                                self.uvLabel.layer.borderColor = UIColor(red: 41/255.0, green: 255/255.0, blue: 3/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 41/255.0, green: 255/255.0, blue: 3/255.0, alpha: 1).cgColor
                            } else if  uvIndex <= 5 {
                                self.uvLabel.layer.borderColor = UIColor(red: 235/255.0, green: 212/255.0, blue: 15/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 235/255.0, green: 212/255.0, blue: 15/255.0, alpha: 1).cgColor

                            } else if  uvIndex <= 7 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 145/255.0, blue: 33/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 255/255.0, green: 145/255.0, blue: 33/255.0, alpha: 1).cgColor

                            } else if  uvIndex <= 10 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 91/255.0, blue: 95/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 255/255.0, green: 91/255.0, blue: 95/255.0, alpha: 1).cgColor

                            } else {
                                self.uvLabel.layer.borderColor = UIColor(red: 240/255.0, green: 3/255.0, blue: 0/255.0, alpha: 1).cgColor
                                self.uvLabelHubTab.layer.borderColor = UIColor(red: 240/255.0, green: 3/255.0, blue: 0/255.0, alpha: 1).cgColor
                            }
                        } else {
                            self.uvLabel.text = "NA"
                            self.uvLabel.isHidden = true
                            self.uvLabelHubTab.text = "NA"
                            self.uvLabelHubTab.isHidden = true
                            self.uvView.isHidden = true
                            self.uvViewHubTab.isHidden = true

                        }
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            for view in self.view.subviews {
                                if view.tag == 1 {
                                    view.alpha = 1
                                }
                                for subview in view.subviews {
                                    if subview.tag == 1 {
                                        subview.alpha = 1
                                    }
                                }
                            }
                        }, completion: { (success) in
                            
                        })
                    }
                    
                    
                    if let current = JSON["Current"] as? [String:Any] {
                        self.updateAlerts()
                        
                        print("JSON Current: \(current)")
                        
                        self.view.hideStateView()
                        
                        if let dateString = current["DateTime"] as? String {
                            if let lastDate = dateString.fliprDate {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "EEE HH:mm"
                                self.lastMeasureDateLabel.text = "Last measure".localized +  " : \(dateFormatter.string(from: lastDate))"
                                self.lastMeasureDateLabel.isHidden = false
                                
                                Module.currentModule?.rawlastMeasure = dateFormatter.string(from: lastDate)
                                
                                print("lastDate interval since now:\(lastDate.timeIntervalSinceNow)")
//
                                //        if -300 > -400{
                                //            print("true")
                                //        }else{
                                //            print("false")
                                //        }
                                if lastDate.timeIntervalSinceNow  > -4500 {
                                    self.signalStrengthLabel.text = "Signal excellent".localized
                                    self.signalStrengthImageView.image = UIImage(named: "Signalhigh")
                                }
                                
//                                else if lastDate.timeIntervalSinceNow < -4500 {
//                                    self.readBLEMeasure(completion: { (error) in
//                                        if error != nil {
//                                            self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
//                                            self.bleStatusView.isHidden = true
//                                        } else {
//                                            self.bleMeasureHasBeenSent = true
//                                        }
//                                    })
//                                }
                                else if lastDate.timeIntervalSinceNow > -86400 {
                                    self.signalStrengthLabel.text = "Signal moyen".localized
                                    self.signalStrengthImageView.image = UIImage(named: "Signalmiddle")

                                }
                                else if  lastDate.timeIntervalSinceNow > -172800 {
                                    self.signalStrengthLabel.text = "Signal faible".localized
                                    self.signalStrengthImageView.image = UIImage(named: "Signallow")

                                }else{
                                    self.signalStrengthLabel.text = "Signal inexistant".localized
                                    self.signalStrengthImageView.image = UIImage(named: "SignalNo")
                                }
                                
                            }
                        } else {
                            self.signalStrengthLabel.text = "Signal inexistant".localized
                            self.signalStrengthImageView.image = UIImage(named: "SignalNo")
                            self.readBLEMeasure(completion: { (error) in
                                if error != nil {
                                    self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                                    self.bleStatusView.isHidden = true
                                } else {
                                    self.bleMeasureHasBeenSent = true
                                }
                            })
                        }
                        
                        if let tendency = current["Tendancy"] as? Double {
                            if tendency >= 1 {
                                self.waterTendencyImageView.image = UIImage(named: "arrow-up-right")
                                self.waterTendencyImageView.isHidden = false
                            } else if  tendency <= -1 {
                                self.waterTendencyImageView.image = UIImage(named: "arrow_eau_down")
                                self.waterTendencyImageView.isHidden = false
                            } else {
                                self.waterTendencyImageView.isHidden = true
                            }
                        } else {
                            self.waterTendencyImageView.isHidden = true
                        }
                        
                        
                        if let temp = current["Temperature"] as? Double {
                            let textAnimation = CATransition()
                            textAnimation.type = CATransitionType.push
                            textAnimation.subtype = CATransitionSubtype.fromTop
                            textAnimation.duration = 0.5
                            textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            self.waterTemperatureLabel.layer.add(textAnimation, forKey: "changeWaterTempratureTransition")
                            
                            self.waterTemperatureLabel.text = String(format: "%.0f", temp) + "°"
                            
                            Module.currentModule?.rawWaterTemperature = String(format: "%.2f", temp) + "°"
                            
                        }
                        
                        if let battery = current["Battery"] as? [String:Any] {
                            if let deviation = battery["Deviation"] as? Double {
                                UserDefaults.standard.set(String(format: "%.0f", deviation * 100), forKey: "BatteryLevel")
                            }
                        }
                        
                        if let pH = current["PH"] as? [String:Any] {
                            
                            
                            if let value = pH["Value"] as? Double, let label = pH["Label"] as? String, let deviation = pH["Deviation"] as? Double {
                                
                                Module.currentModule?.rawPH = String(format: "%.2f", value)
                                
                                self.pHLabel.text = String(format: "%.1f", value)
                                if value < 0 {
                                    self.pHLabel.text = "0"
                                }
                                if let message = pH["Message"] as? String {
                                    self.pHStateLabel.text = message
                                    self.pHSateView.isHidden = false
                                } else {
                                    self.pHStateLabel.text = ""
                                    self.pHSateView.isHidden = true
                                }
                                
                                
                                if deviation >= 1 {
                                    self.pHSateView.backgroundColor = K.Color.white
                                    self.pHStateLabel.textColor = .black
                                    self.pHStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                } else if deviation <= -1 {
                                    self.pHSateView.backgroundColor = K.Color.white
                                    self.pHStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                    self.pHStateLabel.textColor = .black
                                } else {
                                    self.pHSateView.backgroundColor = K.Color.clear
                                    self.pHStateLabel.textColor = .white
                                    self.pHStatusImageView.image = UIImage(named:"thumbs-up")

                                }
                                
                                if let sector = pH["DeviationSector"] as? String {
                                    if sector == "TooHigh" || sector == "TooLow" {
                                        self.pHSateView.backgroundColor = K.Color.white
                                        self.pHStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                        self.pHStateLabel.textColor = .black

                                    } else if sector == "MediumHigh" || sector == "MediumLow" {
                                        self.pHSateView.backgroundColor = K.Color.clear
                                        self.pHStateLabel.textColor = .white
                                        self.pHStatusImageView.image = UIImage(named:"thumbs-up")

                                    } else if sector == "Medium" {
                                        self.pHSateView.backgroundColor = K.Color.clear
                                        self.pHStateLabel.textColor = .white
                                        self.pHStatusImageView.image = UIImage(named:"thumbs-up")
                                    }
                                }
                                self.circularSlider.currentValue = (78/14)*value
                             /*
                                let startAngle = CGFloat(150 * Double.pi / 180)
                                let endAngle = CGFloat(30 * Double.pi / 180)
                                
                                self.pHValueCircle = CAShapeLayer()
                                
                                self.pHValueCircle.path = UIBezierPath(arcCenter: CGPoint(x: self.pHView.bounds.width/2, y: 84), radius: 66, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
                                self.pHValueCircle.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                                self.pHValueCircle.strokeColor = UIColor.init(hexString: "111729").cgColor //UIColor(red: 39/255, green: 226/255, blue: 253/255, alpha: 1).cgColor
                                self.pHValueCircle.lineWidth = 8
                                self.pHValueCircle.lineCap = CAShapeLayerLineCap.round
                                self.pHValueCircle.strokeEnd = 0.0
                                self.pHView.layer.addSublayer(self.pHValueCircle)
                                
                                let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
                                drawAnimation.duration = 1
                                drawAnimation.repeatCount = 0.0
                                drawAnimation.isRemovedOnCompletion = false
                                drawAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                
                                drawAnimation.fromValue = 0
                                drawAnimation.toValue = value / 14
                                
                                self.pHValueCircle.strokeEnd = CGFloat(value) / 14
                                self.pHValueCircle.add(drawAnimation, forKey: "drawPHValueCircleAnimation")
                                
//                               let track = UIBezierPath(arcCenter: CGPoint(x: self.pHView.bounds.width/2, y: 84), radius: 66, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//                                let bkColr = UIColor.white.withAlphaComponent(0.2)
//                                bkColr.setStroke()
//                                track.lineWidth = 8
//
//                                track.stroke()
                         */
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.pHView.alpha = 1
                                }, completion: { (success) in
                                    
                                })
                                
                               
                                
                            }
                            
                        }
                        
                        if let orp = current["OxydoReductionPotentiel"] as? [String:Any] {
                            if let value = orp["Value"] as? Double {
                                Module.currentModule?.rawRedox = String(format: "%.0f", value) + " mV"
                            }
                        }
                        
                        if let conductivity = current["Conductivity"] as? [String:Any] {
                            if let value = conductivity["Value"] as? Double {
                                Module.currentModule?.rawConductivity = String(format: "%.0f", value)
                            } else if let level = conductivity["Level"] as? String {
                                Module.currentModule?.rawConductivity = level
                            }
                        }
                        
                        
                        /*
                         var orpField = "Chlorine"
                         if let treatment = Pool.currentPool?.treatment {
                         if treatment.id == 3 {
                         orpField = "Bromine"
                         }
                         }
                         */
                        
                        if let orp = current["Desinfectant"] as? [String:Any] {
                            
                            if let label = orp["Label"] as? String, let deviation = orp["Deviation"] as? Double {
                                self.orpLabel.text = label
                                
                                if let message = orp["Message"] as? String {
                                    self.orpStateLabel.text = message
                                    self.orpStateView.isHidden = false
                                } else {
                                    self.orpStateLabel.text = ""
                                    self.orpStateView.isHidden = true
                                }
                                
                                
                                let maxAngle = Double.pi/5.7
                                var gaugeAngle:CGFloat = 0
                                   
                                if deviation >= 1 {
                                    self.orpStateView.backgroundColor = K.Color.white
                                    self.orpStateLabel.textColor = .black
                                    self.bleStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                    gaugeAngle = -CGFloat(maxAngle)
                                } else if deviation <= -1 {
                                    self.orpStateView.backgroundColor = K.Color.white
                                    self.bleStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                    self.orpStateLabel.textColor = .black
                                    
                                    gaugeAngle = CGFloat(maxAngle)
                                } else {
                                    gaugeAngle = -CGFloat(deviation*maxAngle)
                                    self.orpStateView.backgroundColor = K.Color.clear
                                    self.orpStateLabel.textColor = .white
                                    self.bleStatusImageView.image = UIImage(named:"thumbs-up")
                                }
                                
                                if let sector = orp["DeviationSector"] as? String {
                                    if sector == "TooHigh" || sector == "TooLow" {
                                        self.orpStateView.backgroundColor = K.Color.white
                                        self.bleStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                        self.orpStateLabel.textColor = .black
                                    } else if sector == "MediumHigh" || sector == "MediumLow" {
                                        self.orpStateView.backgroundColor = K.Color.clear
                                        self.orpStateLabel.textColor = .white
                                        self.bleStatusImageView.image = UIImage(named:"thumbs-up")


                                    } else if sector == "Medium" {
                                        self.orpStateView.backgroundColor = K.Color.clear
                                        self.orpStateLabel.textColor = .white
                                        self.bleStatusImageView.image = UIImage(named:"thumbs-up")
                                    }
                                }
                                
                                self.orpIndicatorImageView.transform = .identity
                                
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.orpView.alpha = 1
                                    self.orpIndicatorImageView.transform = self.orpIndicatorImageView.transform.rotated(by: gaugeAngle)
                                }, completion: { (success) in
                                    
                                })
                                
                            }
                            
                        }
                        
                        if let subscription = JSON["Subscription"] as? [String:Any] {
                            if let isValid = subscription["IsValid"] as? Bool {
                                Module.currentModule?.isSubscriptionValid = isValid
                                Module.saveCurrentModuleLocally()
                            }
                        }
                        
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            for view in self.view.subviews {
                                if view.tag == 2 {
                                    view.alpha = 1
                                }
                            }
                            if let module = Module.currentModule {
                                if module.isSubscriptionValid == false {
//                                    self.subscriptionView.alpha = 1
//                                    self.subscriptionButton.isHidden = false
                                    self.handleSubscriptionButton()
                                } else {
//                                    self.subscriptionView.alpha = 0
//                                    self.subscriptionButton.isHidden = true
                                }
                            }
                        }, completion: { (success) in
                            
                        })
                    } else {
                        
                        print("response.result.value: \(response.result.value)")
                        self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: "Waiting for the first measure...".localized)
                        
                        self.readBLEMeasure(completion: { (error) in
                            if error != nil {
                                self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                                self.bleStatusView.isHidden = true
                            } else {
                                self.bleMeasureHasBeenSent = true
                            }
                        })
                    }
                    
                    
                    
                } else {
                    print("response.result.value: \(response.result.value)")
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: "Waiting for the first measure...".localized)
                    
                    self.readBLEMeasure(completion: { (error) in
                        if error != nil {
                            self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                            self.bleStatusView.isHidden = true
                        } else {
                            self.bleMeasureHasBeenSent = true
                        }
                    })
                }
            })
            /*
             Alamofire.request(Router.readModuleLastMetrics(serialId: identifier)).responseJSON(completionHandler: { (response) in
             if let error = response.result.error {
             print("Update Flipr data did fail with error: \(error)")
             
             self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\nErreur de rafraichissement", message: error.localizedDescription, buttonTitle: "Réessayer", buttonAction: {
             self.view.hideStateView()
             self.updateFliprData()
             })
             
             } else if let JSON = response.result.value as? [String:Any] {
             
             self.updateAlerts()
             
             
             print("JSON: \(JSON)")
             
             self.view.hideStateView()
             
             if let dateString = JSON["DateTime"] as? String {
             if let lastDate = dateString.date(withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'")?.addingTimeInterval(7200) {
             //let style = DateFo
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "EEE HH:mm"
             self.lastMeasureDateLabel.text = "Dernière mesure : \(dateFormatter.string(from: lastDate))"
             self.lastMeasureDateLabel.isHidden = false
             
             print("lastDate interval since now:\(lastDate.timeIntervalSinceNow)")
             if lastDate.timeIntervalSinceNow < -3600 {
             self.readBLEMeasure(completion: { (error) in
             if error != nil {
             self.showError(title: "Erreur de connexion Bluetooth", message: error?.localizedDescription)
             self.bleStatusView.isHidden = true
             } else {
             self.bleMeasureHasBeenSent = true
             }
             })
             }
             }
             } else {
             self.readBLEMeasure(completion: { (error) in
             if error != nil {
             self.showError(title: "Erreur de connexion Bluetooth", message: error?.localizedDescription)
             self.bleStatusView.isHidden = true
             } else {
             self.bleMeasureHasBeenSent = true
             }
             })
             }
             
             
             if let temp = JSON["Temperature"] as? Double {
             let textAnimation = CATransition()
             textAnimation.type = kCATransitionPush
             textAnimation.subtype = kCATransitionFromTop
             textAnimation.duration = 0.5
             textAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
             self.waterTemperatureLabel.layer.add(textAnimation, forKey: "changeWaterTempratureTransition")
             
             self.waterTemperatureLabel.text = String(format: "%.0f", temp) + "°"
             }
             if let pH = JSON["PH"] as? Double {
             
             self.pHLabel.text = String(format: "%.1f", pH)
             
             if pH > 7.5 {
             self.pHSateView.backgroundColor = UIColor(colorLiteralRed: 229/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
             self.pHStateLabel.text = "Trop élevé"
             self.pHStateIcon.image = UIImage(named:"warning_result_picto")
             } else if pH < 6.9 {
             self.pHSateView.backgroundColor = UIColor(colorLiteralRed: 229/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
             self.pHStateLabel.text = "Trop faible"
             self.pHStateIcon.image = UIImage(named:"warning_result_picto")
             } else {
             self.pHSateView.backgroundColor = UIColor(colorLiteralRed: 48/255.0, green: 225/255.0, blue: 175/255.0, alpha: 1)
             self.pHStateLabel.text = "Parfait"
             self.pHStateIcon.image = UIImage(named:"check_result_picto")
             }
             
             let startAngle = CGFloat(150 * Double.pi / 180)
             let endAngle = CGFloat(30 * Double.pi / 180)
             
             self.pHValueCircle = CAShapeLayer()
             
             self.pHValueCircle.path = UIBezierPath(arcCenter: CGPoint(x: self.pHView.bounds.width/2, y: 84), radius: 66, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
             self.pHValueCircle.fillColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0).cgColor
             self.pHValueCircle.strokeColor = UIColor(colorLiteralRed: 139/255.0, green: 205/255.0, blue: 217/255.0, alpha: 1).cgColor
             self.pHValueCircle.lineWidth = 8
             self.pHValueCircle.lineCap = kCALineCapRound
             self.pHValueCircle.strokeEnd = 0.0
             self.pHView.layer.addSublayer(self.pHValueCircle)
             
             let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
             drawAnimation.duration = 1
             drawAnimation.repeatCount = 0.0
             drawAnimation.isRemovedOnCompletion = false
             drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
             
             drawAnimation.fromValue = 0
             drawAnimation.toValue = pH / 14
             
             self.pHValueCircle.strokeEnd = CGFloat(pH) / 14
             self.pHValueCircle.add(drawAnimation, forKey: "drawPHValueCircleAnimation")
             
             UIView.animate(withDuration: 0.5, animations: {
             self.pHView.alpha = 1
             }, completion: { (success) in
             
             })
             }
             
             var orpField = "FreeChlore"
             self.orpLabel.text = "Chlore"
             var orpMax:Double = 2 //avt 1.5
             var orpMin:Double = 0.4 //avt 1
             if let treatment = Pool.currentPool?.treatment {
             if treatment.id == 3 {
             orpField = "Brome"
             orpMax = 3
             orpMin = 0.4
             self.orpLabel.text = treatment.label.capitalized
             } // else if treatment.id == 4 {
             //  orpField = "Salinity"
             //  orpMax = 8
             //  orpMin = 3 // et 0.4 chlore pour dire "Trop Failble" (avt ct 0.7)
             //  self.orpLabel.text = "Chlore" //treatment.label.capitalized
             // }
             }
             
             if let orp = JSON[orpField] as? Double {
             
             if orp > orpMax {
             self.orpStateView.backgroundColor = UIColor(colorLiteralRed: 229/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
             self.orpStateLabel.text = "Trop élevé"
             self.orpImageView.image = UIImage(named:"chlore_graph_up")
             self.orpStateIcon.image = UIImage(named:"warning_result_picto")
             } else if orp < orpMin {
             if orpField == "Salinity" {
             if let orpChlore = JSON["FreeChlore"] as? Double {
             if orpChlore < 0.4 {
             self.orpStateView.backgroundColor = UIColor(colorLiteralRed: 229/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
             self.orpStateLabel.text = "Trop faible"
             self.orpImageView.image = UIImage(named:"chlore_graph_down")
             self.orpStateIcon.image = UIImage(named:"warning_result_picto")
             } else {
             self.orpStateView.backgroundColor = UIColor(colorLiteralRed: 48/255.0, green: 225/255.0, blue: 175/255.0, alpha: 1)
             self.orpStateLabel.text = "Parfait"
             self.orpImageView.image = UIImage(named:"chlore_graph_ok")
             self.orpStateIcon.image = UIImage(named:"check_result_picto")
             }
             }
             }else {
             self.orpStateView.backgroundColor = UIColor(colorLiteralRed: 229/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
             self.orpStateLabel.text = "Trop faible"
             self.orpImageView.image = UIImage(named:"chlore_graph_down")
             self.orpStateIcon.image = UIImage(named:"warning_result_picto")
             }
             
             } else {
             self.orpStateView.backgroundColor = UIColor(colorLiteralRed: 48/255.0, green: 225/255.0, blue: 175/255.0, alpha: 1)
             self.orpStateLabel.text = "Parfait"
             self.orpImageView.image = UIImage(named:"chlore_graph_ok")
             self.orpStateIcon.image = UIImage(named:"check_result_picto")
             }
             
             
             UIView.animate(withDuration: 0.5, animations: {
             self.orpView.alpha = 1
             }, completion: { (success) in
             
             })
             }
             
             UIView.animate(withDuration: 0.5, animations: {
             for view in self.view.subviews {
             if view.tag == 2 {
             view.alpha = 1
             }
             }
             }, completion: { (success) in
             
             })
             } else {
             print("response.result.value: \(response.result.value)")
             self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\nLa première analyse est en cours !", message: "En attente de la première mesure...")
             
             self.readBLEMeasure(completion: { (error) in
             if error != nil {
             self.showError(title: "Erreur de connexion Bluetooth", message: error?.localizedDescription)
             self.bleStatusView.isHidden = true
             } else {
             self.bleMeasureHasBeenSent = true
             }
             })
             }
             })*/
            
        } else {
            print("The Flipr module identifier does not exist :/")
        }
        
        
    }
    
    func hideFliprData() {
        waterTemperatureLabel.text = "  "
        pHValueCircle.removeFromSuperlayer()
        pHView.alpha = 0
        orpView.alpha = 0
        self.subscriptionView.alpha = 0
        self.subscriptionButton.isHidden = true
        for view in self.view.subviews {
            if view.tag == 2 {
                view.alpha = 0
            }
        }
        
        alertButton.isHidden = true
        alertCheckView.isHidden = true
        lastMeasureDateLabel.isHidden = true
        
        alert0Button.isHidden = true
        alert1Button.isHidden = true
        alert2Button.isHidden = true
        alert3Button.isHidden = true
        alert4Button.isHidden = true
        
        
            
    }
    
    @IBAction func fliprStoreButtonAction(_ sender: Any) {
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
    
    @IBAction func alertButtonAction(_ sender: Any) {
        if sender is AlertButton {
            if let alert = (sender as! AlertButton).alert {
                if let navController = self.storyboard?.instantiateViewController(withIdentifier: "AlertNavigationControllerID") as? UINavigationController {
                    if let viewController = navController.viewControllers[0] as? AlertTableViewController {
                        viewController.alert = alert
                        navController.modalPresentationStyle = .fullScreen
                        self.present(navController, animated: true, completion: nil)
                    }
                }
                /*
                 if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewControllerID") as? AlertViewController {
                 viewController.alert = alert
                 self.present(viewController, animated: true, completion: nil)
                 }*/
            }
        } else if let alert = alert {
            if let navController = self.storyboard?.instantiateViewController(withIdentifier: "AlertNavigationControllerID") as? UINavigationController {
                if let viewController = navController.viewControllers[0] as? AlertTableViewController {
                    viewController.alert = alert
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true, completion: nil)
                }
            }
            /*
             if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewControllerID") as? AlertViewController {
             viewController.alert = alert
             self.present(viewController, animated: true, completion: nil)
             }*/
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func showStockPopUpIfNeeded() {
        
        if Pool.currentPool?.city != nil {
            
            if UserDefaults.standard.object(forKey:"StockProductCount") == nil {
                if let date =  UserDefaults.standard.value(forKey:"StockPopUpDisplayDate") as? Date {
                    if date.timeIntervalSinceNow < -3600 * 48 {
                        //showStockPopUp()
                    } else {
                        showEquipmentPopUpIfNeeded()
                    }
                } else {
                    showStockPopUp()
                }
            } else {
                showEquipmentPopUpIfNeeded()
            }
            
        }
        
        
    }
    
    func showStockPopUp() {
        
        UserDefaults.standard.set(Date(), forKey: "StockPopUpDisplayDate")
        
        let alertController = UIAlertController(title: "Fill in your inventory Products!".localized, message: "Flipr needs to know your maintenance products to let you know the right dosages to insert in your pool. Fill in your inventory now: it's quick and easy!".localized, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Later".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Fill in".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            
            if let viewConntroller = self.storyboard?.instantiateViewController(withIdentifier: "StockNavigationControllerID") {
                viewConntroller.modalPresentationStyle = .fullScreen
                self.present(viewConntroller, animated: true, completion: nil)
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showEquipmentPopUpIfNeeded() {
        
        if Pool.currentPool?.city != nil {
            
            if UserDefaults.standard.object(forKey:"EquipementCount") == nil {
                if let date =  UserDefaults.standard.value(forKey:"EquipmentPopUpDisplayDate") as? Date {
                    if date.timeIntervalSinceNow < -3600 * 48 {
                        //showEquipmentPopUp()
                    }
                } else {
                    showEquipmentPopUp()
                }
            }
            
        }
        
        
    }
    
    func showEquipmentPopUp() {
        
        UserDefaults.standard.set(Date(), forKey: "EquipmentPopUpDisplayDate")
        
        let alertController = UIAlertController(title: "Fill in your equipment!".localized, message: "Flipr needs to know your equipment to better advise you in the management of your pond. Fill in your equipment now: it's quick and easy!".localized, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Later".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Fill in".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            
            if let viewConntroller = self.storyboard?.instantiateViewController(withIdentifier: "EquipmentNavigationControllerID") {
                self.present(viewConntroller, animated: true, completion: nil)
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        //cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        
        cell.contents = UIImage(named: "test_piece")?.cgImage
        return cell
    }
    
    
    @IBAction func notificationButtonAction(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Notifications", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NotificationsAlertViewController") as? NotificationsAlertViewController {
            viewController.alertType = .Notification
            viewController.delegate = self
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func thresholdSettingsButtonAction(_ sender: Any) {
        let tmpSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
            if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
                navigationController.modalPresentationStyle = .fullScreen
                viewController.isDirectPresenting = true
                navigationController.setViewControllers([viewController], animated: false)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
//        let sb = UIStoryboard.init(name: "Notifications", bundle: nil)
//        if let viewController = sb.instantiateViewController(withIdentifier: "NotificationsAlertViewController") as? NotificationsAlertViewController {
//            viewController.alertType = .Threshold
//            viewController.delegate = self
//            viewController.modalPresentationStyle = .overCurrentContext
//            self.present(viewController, animated: true, completion: nil)
//        }
    }
    
    
    
    @IBAction func subscriptionButtonAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func funcamButtonaction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FunCamViewControllerID") as? FunCamViewController {
            vc.temperature = self.waterTemperatureLabel.text ?? ""
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func quickActionButtonAction(_ sender: Any) {
    
        let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "QuickActionViewController") as? QuickActionViewController {
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true) {
                viewController.showBackgroundView()
            }
        }
    }
    
    @IBAction func hubButtonAction(_ sender: Any) {
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
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

extension DashboardViewController: AlertPresentViewDelegate{
    func settingsButtonClicked(type:AlertType){
        if type == .Notification{
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNavigation") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }else{
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
                    navigationController.modalPresentationStyle = .fullScreen
                    viewController.isDirectPresenting = true
                    navigationController.setViewControllers([viewController], animated: false)
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
       
    }
    
    
    func checkDefaultValueChanged(JSON: [String:Any]){
        
        if let phMax = JSON["PhMax"] as? [String:Any] {
            if let _ = phMax["Value"] as? Double, let isDefaultValue = phMax["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultPhvalueMaxValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                    
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultPhvalueMaxValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                }
            }
        }
        
        if let phMax = JSON["PhMin"] as? [String:Any] {
            if let _ = phMax["Value"] as? Double, let isDefaultValue = phMax["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultPhvalueMinValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                    
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultPhvalueMinValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                }
            }
        }
        
        if let redox = JSON["Redox"] as? [String:Any] {
            if let _ = redox["Value"] as? Double, let isDefaultValue = redox["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultThresholdValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationThresholdDefalutValueChangedChanged, object: nil)
                } else {
                    
                    UserDefaults.standard.set(true, forKey: userDefaultThresholdValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationThresholdDefalutValueChangedChanged, object: nil)
                }
            }
        }
        
        if let temp = JSON["Temperature"] as? [String:Any] {
            
            if let _ = temp["Value"] as? Double, let isDefaultValue = temp["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultTemperatureMinValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultTemperatureMinValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                }
            }
            
        }
        
        if let temp = JSON["TemperatureMax"] as? [String:Any] {
            
            if let _ = temp["Value"] as? Double, let isDefaultValue = temp["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultTemperatureMaxValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultTemperatureMaxValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                }
            }
            
        }
        
        
    }
}

extension DashboardViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 128)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgramCollectionViewCell", for: indexPath) as! ProgramCollectionViewCell
        cell.addShadow()
        cell.titleLbl.text =  self.hub?.equipementName
        cell.shadowView.roundCorner(corner: 12)
        cell.contentView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        if let hub = hub {
            if hub.equipementState {
                cell.subTitleLbl.text = "Working".localized()
                cell.buttonShadowView.backgroundColor = UIColor(hexString: "00DA4F")
                cell.iconImageView.image = UIImage(named: "powerWhite")
//                    stateImageView.image = UIImage(named: "play_circle")
//                    manualSwitch.isOn = hub.equipementState
            } else {
                cell.subTitleLbl.text = "Stopped".localized()
                cell.buttonShadowView.backgroundColor = .white
                cell.iconImageView.image = UIImage(named: "powerGray")

//                    stateImageView.image = UIImage(named: "stop_circle")
//                    manualSwitch.isOn = hub.equipementState
            }
            if hub.behavior == "manual" {
                cell.subTitleLbl.text = "Manual".localized()
                cell.buttonShadowView.backgroundColor = UIColor(hexString: "00DA4F")
                cell.iconImageView.image = UIImage(named: "powerWhite")

//                automSwitch.isOn = false
//                manualButtonAction(self)
            } else if hub.behavior == "planning" {
                cell.subTitleLbl.text  = "Program".localized()
                cell.buttonShadowView.backgroundColor = UIColor(hexString: "00DA4F")
                cell.iconImageView.image = UIImage(named: "timerWhite")

//                automSwitch.isOn = false
//                progButtonAction(self)
            } else if hub.behavior == "auto" {
                cell.subTitleLbl.text = "Smart Control"
                cell.iconImageView.image = #imageLiteral(resourceName: "Flash_select")
                cell.buttonShadowView.backgroundColor = UIColor(hexString: "00DA4F")
//                automSwitch.isOn = true
//                automButtonAction(self)
                hub.getAutomMessage { (message) in
                    if message != nil {
//                        self.autoMessageLabel.text = message
//                        self.autoMessageLabel.isHidden = false
                    }
                }
            }
            
            if indexPath.row == 1{
                if hub.equipementState {
                    cell.subTitleLbl.text = "Working".localized()
                    cell.buttonShadowView.backgroundColor = UIColor(hexString: "00DA4F")
                    cell.iconImageView.image = UIImage(named: "powerWhite")
    //                    stateImageView.image = UIImage(named: "play_circle")
    //                    manualSwitch.isOn = hub.equipementState
                } else {
                    cell.subTitleLbl.text = "Stopped".localized()
                    cell.buttonShadowView.backgroundColor = .white
                    cell.iconImageView.image = UIImage(named: "powerGray")

    //                    stateImageView.image = UIImage(named: "stop_circle")
    //                    manualSwitch.isOn = hub.equipementState
                }
            }
            
         
        }
        
        

        return cell
    }
}


extension DashboardViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}

extension DashboardViewController{
    
    func loadHUBs() {
//        let theme = EmptyStateViewTheme.shared
//        theme.activityIndicatorType = .ballPulse
//        self.view.showEmptyStateViewLoading(title: nil, message: nil, theme: theme)
        Pool.currentPool?.getHUBS(completion: { (hubs, error) in
//            self.view.hideStateView()
            if error != nil {
                self.showError(title: "Error".localized, message: error!.localizedDescription)
            } else if hubs != nil {
                if hubs!.count > 0 {
                    self.hubs = hubs!
                    if let currentHub = HUB.currentHUB {
                        for hub in hubs! {
                            if currentHub.serial == hub.serial {
                                self.hub = hub
                                HUB.currentHUB = hub
                                HUB.saveCurrentHUBLocally()
                                self.refreshHUBdisplay()
                                break
                            }
                        }
                    } else {
                        self.hub = hubs!.first
                        HUB.currentHUB = hubs!.first
                        HUB.saveCurrentHUBLocally()
                        self.refreshHUBdisplay()
                    }
                } else {
                    self.handleHubViews()
//                   self.showError(title: "Error".localized, message: "No hubs :/")
                }
            } else {
                self.handleHubViews()
//                self.showError(title: "Error".localized, message: "No hubs :/")
            }
        })
    }
    
    func refreshHUBdisplay() {
        self.hubDeviceTableView.reloadData()
        self.hubDeviceTableViewHeightConstraint.constant = CGFloat(145 * self.hubs.count)
        
        if hubScrollViewContainerView.height < self.hubTabScrollView.height{
            let diff = self.hubTabScrollView.height - hubScrollViewContainerView.height
            self.hubTabWaveTopConstraint.constant =  self.hubTabWaveTopConstraint.constant + diff
        }else{
            let diff = hubScrollViewContainerView.height - self.hubTabScrollView.height
            if diff < self.hubTabWaveTopConstraint.constant{
                self.hubTabWaveTopConstraint.constant = self.hubTabWaveTopConstraint.constant - diff
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    let hubWaveframe = self.hubWaveContainerView.frame
                    self.hubTabfluidView.frame = hubWaveframe
                    self.hubTabFluidViewTopEdge.frame = hubWaveframe
                })
//                self.hubScrollViewContainerView.updateConstraints()
            }
        }

        let hubWaveframe = self.hubWaveContainerView.frame
        self.hubTabfluidView.frame = hubWaveframe
        self.hubTabFluidViewTopEdge.frame = hubWaveframe
        self.handleHubViews()
        /*
        if let hub = hub {
            hubButton.setTitle(hub.equipementName, for: .normal)
            if hub.equipementState {
                stateLabel.text = "Working".localized()
                stateImageView.image = UIImage(named: "play_circle")
                manualSwitch.isOn = hub.equipementState
            } else {
                stateLabel.text = "Stopped".localized()
                stateImageView.image = UIImage(named: "stop_circle")
                manualSwitch.isOn = hub.equipementState
            }
            if hub.behavior == "manual" {
                modeValueLabel.text = "Manual".localized()
                automSwitch.isOn = false
                manualButtonAction(self)
            } else if hub.behavior == "planning" {
                modeValueLabel.text = "Program".localized()
                automSwitch.isOn = false
                progButtonAction(self)
            } else if hub.behavior == "auto" {
                modeValueLabel.text = "Smart Control"
                automSwitch.isOn = true
                automButtonAction(self)
                hub.getAutomMessage { (message) in
                    if message != nil {
                        self.autoMessageLabel.text = message
                        self.autoMessageLabel.isHidden = false
                    }
                }
            } else {
                modeValueLabel.text = "Unkown mode"
                automSwitch.isOn = false
                manualButtonAction(self)
            }
        }
        
        */
    }
    
    
    func refreshPlannings() {
//        self.programView.showEmptyStateViewLoading(title: nil, message: nil)
        HUB.currentHUB?.getPlannings(completion: { (error) in
            if error != nil {
                if HUB.currentHUB!.plannings.count > 0 {
//                    self.programView.showEmptyStateViewLoading(title: "Error".localized, message: error?.localizedDescription)
                } else {
                    self.showError(title: "Error".localized, message: error?.localizedDescription)
                }
            } else {
                if HUB.currentHUB!.plannings.count == 0 {
                    /*
                    self.programView.showEmptyStateView(image: nil, title: nil, message: "No program".localized(), buttonTitle: "Add a new program".localized()) {
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                    */
                } else {
                    /*
                    self.programView.hideStateView()
                    self.tableView.reloadData()
 */
                }
                
            }
        })
    }


}

extension DashboardViewController{
    
    @IBAction func addHubDeviceButtonTapped(){
        
    }
    
    @IBAction func addFliprButtonTapped(){
        
    }
}

extension DashboardViewController: UITableViewDelegate,UITableViewDataSource,HubDeviceDelegate {
 
    func didSelectSettingsButton(){
        self.hubButtonAction(self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hubs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"HubDeviceTableViewCell",
                                                 for: indexPath) as! HubDeviceTableViewCell
        if indexPath.row >  self.hubs.count{
            return cell
        }
        cell.delegate = self
        let hub = self.hubs[indexPath.row]
        if hub.equipementCode == 84{
            cell.iconImageView.image = #imageLiteral(resourceName: "lightEnabled")
        }
        else if hub.equipementCode == 86{
            cell.iconImageView.image = #imageLiteral(resourceName: "pumbactive")
        }
        cell.modeNameLbl.text = hub.behavior
        cell.deviceNameLbl.text = hub.equipementName
        return cell

    }
    
    

}
