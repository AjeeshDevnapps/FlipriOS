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
    
    @IBOutlet weak var airSeparatorView: UIView!

    
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
    @IBOutlet weak var bulbStatuImageView: UIImageView!
    @IBOutlet weak var pumbStatuImageView: UIImageView!
    
    
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
    @IBOutlet weak var hubTabMeasureInfoView: UIView!
    @IBOutlet weak var hubTabAirInfoView: UIView!
    @IBOutlet weak var hubTabAirInfoBoxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var hubTabAirLabel: UILabel!
    @IBOutlet weak var hubTabAirValLabel: UILabel!
    @IBOutlet weak var hubTabPhLabel: UILabel!
    @IBOutlet weak var hubTabPhValLabel: UILabel!
    @IBOutlet weak var hubTabClorineLabel: UILabel!
    @IBOutlet weak var hubTabClorineValLabel: UILabel!
    
    //Alert
    @IBOutlet weak var measureAlertButton: UIButton!
    @IBOutlet weak var measureAlertLbl: UILabel!
    @IBOutlet weak var measureAlertView: UIView!
    @IBOutlet weak var measureAlertTouchAreaButton: UIButton!
    
    
    @IBOutlet weak var connectNewDeviceLbl: UILabel!
    
    @IBOutlet weak var phStatusView: DashScrollViewItem!
    @IBOutlet weak var tempStatusView: DashScrollViewItem!
    @IBOutlet weak var redoxStatusView: DashScrollViewItem!
    
    @IBOutlet weak var tempWindView: UIView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var day1TitleLabel: UILabel!
    @IBOutlet weak var day2TitleLabel: UILabel!
    @IBOutlet weak var day3TitleLabel: UILabel!
    @IBOutlet weak var day4TitleLabel: UILabel!
    
    @IBOutlet weak var day1ValueLabel: UILabel!
    @IBOutlet weak var day2ValueLabel: UILabel!
    @IBOutlet weak var day3ValueLabel: UILabel!
    @IBOutlet weak var day4ValueLabel: UILabel!
    
    
    @IBOutlet weak var day1IconLabel: UILabel!
    @IBOutlet weak var day2IconLabel: UILabel!
    @IBOutlet weak var day3IconLabel: UILabel!
    @IBOutlet weak var day4IconLabel: UILabel!
    
    @IBOutlet weak var probableWeatherIcon: UILabel!
    
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var tempPrecipitationLabel: UILabel!
    
    @IBOutlet weak var next5hourTitleLabel: UILabel!
    @IBOutlet weak var fliprTabTitleLbl: UILabel!
    @IBOutlet weak var hubTabTitleLbl: UILabel!
    @IBOutlet weak var firstHubNameLbl: UILabel!
    @IBOutlet weak var secondHubNameLbl: UILabel!
    
    
    //MUMP
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var settingsButtonContainer: UIView!
    @IBOutlet weak var selectedPlaceDetailsLbl: UILabel!
    @IBOutlet weak var placeDropdownButton: UIButton!
    @IBOutlet weak var placeDropdownArrowImage: UIImageView!
    
    
    
    
    var hubTabWaveTopConstraintPreValue = 0
    
    var isShowingAddFirstProgramView = false
    var isShowingHubView = false
    
    let maskView = UIImageView()
    
    var bleMeasureHasBeenSent = false
    var isShowingActivateAlert = false
    var isPhOutOfRangeAlert = false
    var isRedoxOutOfRangeAlert = false
    var isShowingLoadingForAlertApi = false
    
    
    
    var hub:HUB?
    var hubPumb:HUB?
    var hubBulb:HUB?
    
    var hubs:[HUB] = []
    var fluidViewTopEdge:BAFluidView!
    var fluidView:BAFluidView!
    
    var hubTabFluidViewTopEdge:BAFluidView!
    var hubTabfluidView:BAFluidView!
    
    var isHubTabSelected = false
    var lastMeasureDate: Date?
    
    var isThemeChanged = false
    var waveFrame:CGRect?
    var notificationReportTime:String?
    var notificationReportDate:Date?
    var haveFirmwereUpdate = false
    var firmwereLatestVersion = "0"
    var selectedPlace: PlaceDropdown?
    
    var isPlaceOwner = true
    
    var isDefaultPlaceLoaded = false

    
    var isLoadedDashboard = false

    
    var placeDetails:PlaceDropdown!
    var placesModules:PlaceModule!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        BLEManager.shared.disConnectCurrentDevice()
        self.placeDropdownArrowImage.isHidden = true
        manageFlipTabTitle()
        setUpStatusScroll()
        //        if -300 > -400{
        //            print("true")
        //        }else{
        //            print("false")
        //        }
        //        let tmp = storyboard?.instantiateViewController(withIdentifier: "UISideMenuNavigationControllerID") as? SideMenuNavigationController
        //        tmp?.view.addShadow(offset: CGSize.init(width: 10, height: 10), color: UIColor.black, radius: 100.0, opacity:1.0)
        //        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "UISideMenuNavigationControllerID") as? SideMenuNavigationController
        
        //        var settings = SideMenuSettings()
        //        settings.presentationStyle = .menuSlideIn
        //        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        //
        //        if SideMenuManager.default.leftMenuNavigationController == nil {
        //            print("FUCK")
        //        }
        //        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        //        self.view.clipsToBounds = true
        //        self.quickActionButtonContainer.cornerRadius =  self.quickActionButtonContainer.frame.size.height / 2
        //        quickActionButtonContainer.layer.cornerRadius = self.quickActionButtonContainer.frame.size.height / 2
        //        quickActionButtonContainer.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.init(hexString: "#213A4E"), radius:         self.quickActionButtonContainer.frame.size.height / 2, opacity: 0.3)
        self.fliprTabTitleLbl.text = "Analysis".localized
        self.hubTabTitleLbl.text = "Control".localized
        
        hubDeviceTableView.dragDelegate = self
        hubDeviceTableView.dragInteractionEnabled = true
        self.signalStrengthLabel.text = "Signal moyen".localized
        
        self.signalStrengthLabel.text = "Last measure".localized

        self.next5hourTitleLabel.text = "Probability within 5 hours".localized
        self.signalStrengthImageView.image = UIImage(named: "Signalmiddle")
        self.intialTabSetup()
        hideMeasureAlert()
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
        //        measureAlertView.roundCorner(corner: 12)
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
        phStatusView.roundCorner(corner: 12)
        phStatusView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        
        tempStatusView.roundCorner(corner: 12)
        tempStatusView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        
        redoxStatusView.roundCorner(corner: 12)
        redoxStatusView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        
        tempWindView.roundCorner(corner: 12)
        tempWindView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        
        weatherView.roundCorner(corner: 12)
        weatherView.addShadow(offset: CGSize.init(width: 0, height: 12), color: UIColor.init(red: 0, green: 0.071, blue: 0.278, alpha: 0.17), radius: 32, opacity:1)
        
        // subscriptionButton.roundCorner(corner: 12)
        addFirstFliprView.roundCorner(corner: 12)
        connectNewDeviceLbl.text = "Connect new equipment".localized
        // shareButton.setTitle("share".localized, for: .normal)
        self.measureAlertButton.setTitle("En savoir plus".localized, for: .normal)
        measureAlertButton.underline()
        measureAlertLbl.text = "Mesure ancienne".localized
        
        airLabel.text = "air".localized
        airLabelHubTab.text = "air".localized
        
        hubTabAirLabel.text = "water".localized
        waterLabel.text = "water".localized
        alertCheckLabel.text = "Water correction in progress".localized
        subscriptionLabel.text = "Activate all the features!\n7 days free trial".localized
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerForRemoteNotifications(application:  UIApplication.shared)
        
        setupInitialView()
        NotificationCenter.default.addObserver(forName: K.Notifications.CompletedFirmwereUpgrade, object: nil, queue: nil) { (notification) in
            self.callUpdatedFirmwereApi()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FirmwereUpgradeError, object: nil, queue: nil) { (notification) in
            self.handleUpdatedFirmwereError()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FirmwereUpgradeStarted, object: nil, queue: nil) { (notification) in
            self.callStartFirmwereUpdateApi()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.showLastMeasurementScreen, object: nil, queue: nil) { (notification) in
            self.showLastMeasurement()
        }
        
        callPlacesApi()
        
//        refresh()
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            self.notificationDisabledButton.isHidden = true
            self.waterTmpChangeButton.isHidden = true
            self.phChangeButton.isHidden = true
            self.redoxChangeButton.isHidden = true
            //            self.settingsButton.isHidden = true
            self.bleMeasureHasBeenSent = false
            self.refresh()
            self.perform(#selector(self.callGetStatusApis), with: nil, afterDelay: 3)
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.showFirmwereUpgradeScreen, object: nil, queue: nil) { (notification) in
            self.showFirmwereUdpateScreen()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.WavethemeSettingsChanged, object: nil, queue: nil) { (notification) in
            self.isThemeChanged = true
            self.waveThemathanged()
        }
        
        
        
        
        NotificationCenter.default.addObserver(forName: FliprLocationDidChange, object: nil, queue: nil) { (notification) in
            self.view.hideStateView()
            self.refresh()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.ServerChanged, object: nil, queue: nil) { (notification) in
            self.refresh()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.MeasureUnitSettingsChanged, object: nil, queue: nil) { (notification) in
            self.refresh()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDidLastMeasurement, object: nil, queue: nil) { (notification) in
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
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprMeasures409Error, object: nil, queue: nil) { (notification) in
            self.perform(#selector(self.show409Error), with: nil, afterDelay: 0)
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.UserDidLogout, object: nil, queue: nil) { (notification) in
            User.logout()
            self.showLoginScreen()
            AppSharedData.sharedInstance.logout = true
            self.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.SessionExpired, object: nil, queue: nil) { (notification) in
            AppSharedData.sharedInstance.logout = true
            self.dismiss(animated: true, completion: nil)
            //            self.showLoginScreen()
            User.logout()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.AlertDidClose, object: nil, queue: nil) { (notification) in
            self.updateFliprData()
            //            self.updateAlerts()
        }
        
        
        NotificationCenter.default.addObserver(forName: K.Notifications.NotificationSetttingsChanged, object: nil, queue: nil) { (notification) in
            self.manageNotificationDisabledButtton()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil, queue: nil) { (notification) in
            self.managePhValueChangeButtton()
            
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDeviceDeleted, object: nil, queue: nil) { (notification) in
            Module.currentModule?.serial = ""
            self.hideFliprData()
            self.hideWeatherForecast()
            self.settingsButtonContainer.isHidden = true
            self.userHasNoFlipr()
            if self.isPlaceOwner{
                self.addFirstFliprView.isHidden = false
            }
//            self.hideUserHasNoFlipr()
            self.showHubTabInfoView(hide: true)
            self.refresh()
            self.showPlaceSelectionView()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.HubDeviceDeleted, object: nil, queue: nil) { (notification) in
            self.loadHUBs()
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
        
        NotificationCenter.default.addObserver(forName: K.Notifications.UpdateHubViews, object: nil, queue: nil) { (notification) in
            self.loadHUBs()
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
        self.view.bringSubviewToFront(addEquipmentView)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isLoadedDashboard = true
        self.loadHUBs()
        AppReview.shared.requestReviewIfNeeded()
        self.view.bringSubviewToFront(quicActionButton)
    }
    
    func setUpStatusScroll() {
        scrollView.delegate = self
        phStatusView.statusType = .pH
        tempStatusView.statusType = .temperature
        redoxStatusView.statusType = .redox
    }
    
    func reloadWeatherStatus() {
        phStatusView.collectionView.reloadData()
        tempStatusView.collectionView.reloadData()
        redoxStatusView.collectionView.reloadData()
    }
    
    func showUserPreferedHistory(){
        if let index = UserDefaults.standard.object(forKey: "HistoryScrollIndex") as? Int{
            let point = CGPoint(x:  Int(scrollView.frame.size.width) * index, y: 0)
            scrollView.setContentOffset(point, animated: false)
        }
    }
    
    @objc func show409Error(){
        /*
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
        hud?.textLabel.text = "There is no change in measurement"
        hud?.dismiss(afterDelay: 5)
         */
    }
    
    func intialTabSetup(){
        self.scrollView.isHidden = true
        
        self.fliprTabScrollView.isHidden = false
        self.hubTabScrollView.isHidden = true
        self.flipTabButton.isUserInteractionEnabled = false
        self.hubTabButton.isUserInteractionEnabled = true
        
    }
    
    func showLastMeasurement(){
        let tmpSb = UIStoryboard.init(name: "Firmware", bundle: nil)
        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "LastMeasurementNavigation") as? UINavigationController {
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
            
        }
    }
    
    
    func handlTabSelcection(){
        self.fliprTabScrollView.isHidden = isHubTabSelected
        self.hubTabScrollView.isHidden = !isHubTabSelected
        self.flipTabButton.isUserInteractionEnabled = isHubTabSelected
        self.hubTabButton.isUserInteractionEnabled = !isHubTabSelected
    }
    
    
    @IBAction func menuButtonTab(){
        
        if isDefaultPlaceLoaded{
        //if  ((self.placesModules != nil) && (self.placeDetails != nil)){
            let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
            if let viewController = sb.instantiateViewController(withIdentifier: "FliprHubMenuViewController") as? FliprHubMenuViewController {
                viewController.placesModules = self.placesModules
                viewController.placeDetails = self.placeDetails
                // viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: true) {
                }
            }
    
        }
       // }
        
    }
    
    @IBAction func measureAlertButtonTab(){
        if isShowingActivateAlert{
            self.callReactivateAlertApi(alertStatus: true)
        }else{
            let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
            if let viewController = sb.instantiateViewController(withIdentifier: "MeasureAlertViewController") as? MeasureAlertViewController {
                self.present(viewController, animated: true)
            }
        }
        
    }
    
    
    
    @IBAction func tappedFliprTab(){
        self.fliprTabView.backgroundColor = UIColor(hexString: "111729")
        self.hubTabView.backgroundColor = UIColor(hexString: "97A3B6")
        
        isHubTabSelected = !isHubTabSelected
        handlTabSelcection()
        //        if self.hubs.count > 0{
        //            if let firstHubKey  = self.hubs[0].serial as? String{
        //                UserDefaults.standard.set(firstHubKey, forKey: "FirstHubSerialKey")
        //            }
        //        }
        //        if self.hubs.count > 1{
        //            if let secondHubKey  = self.hubs[1].serial as? String{
        //                UserDefaults.standard.set(secondHubKey, forKey: "SecondHubSerialKey")
        //            }
        //        }
        handleHubViews()
    }
    
    @IBAction func tappedHubTab(){
        
        hubTabAirInfoBoxWidthConstraint.constant = (self.view.frame.width - 32) / 3
        //        hubTabAirInfoBoxWidthConstraint.constant = 10
        
        hubTabAirInfoView.setNeedsUpdateConstraints()
        self.view.setNeedsUpdateConstraints()
        hubTabAirInfoView.layoutIfNeeded()
        view.layoutIfNeeded()
        
        self.fliprTabView.backgroundColor = UIColor(hexString: "97A3B6")
        self.hubTabView.backgroundColor = UIColor(hexString: "111729")
        isHubTabSelected = !isHubTabSelected
        handlTabSelcection()
    }
    
    func showHubTabInfoView(hide:Bool){
        self.hubTabMeasureInfoView.isHidden = hide
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
        if isPlaceOwner{
            self.addFirstFliprView.isHidden = false
        }
        
        self.phStatusView.valueStrings.removeAll()
        self.phStatusView.dates.removeAll()
        self.redoxStatusView.valueStrings.removeAll()
        self.redoxStatusView.dates.removeAll()
        self.tempStatusView.valueStrings.removeAll()
        self.tempStatusView.dates.removeAll()
        self.reloadWeatherStatus()

        
        self.phStatusView.isHidden = true
        self.tempStatusView.isHidden = true
        self.redoxStatusView.isHidden = true
        self.tempWindView.isHidden = true
        self.weatherView.isHidden = true
        
        self.airLabel.isHidden = true
        self.airTendendcyImageView.isHidden = true
        self.uvView.isHidden = true
        
        
        self.airLabelHubTab.isHidden = true
        self.airTendendcyImageViewHubTab.isHidden = true
        self.uvViewHubTab.isHidden = true
        
        self.airSeparatorView.isHidden = true

    }
    
    func hideUserHasNoFlipr(){
        if isPlaceOwner{
            self.waveView.isHidden = false
            self.settingsButtonContainer.isHidden = false
            self.addFirstFliprView.isHidden = true
        }else{
            userHasNoFlipr()
        }
    }
    
    @IBAction func addFirstFliprButtonClicked(){
        addFlipr()
    }
    
    func addFlipr(){
        AppSharedData.sharedInstance.addedPlaceId = self.placeDetails.placeId ?? 0
        let fliprStoryboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddFliprViewController") as! AddFliprViewController
        viewController.fromMenu = true
        viewController.isPresent = true
        let nav = UINavigationController.init(rootViewController: viewController)
        self.present(nav, animated: true)
    }
    
    func addHubEquipments(){
        if !isPlaceOwner {return }
        AppSharedData.sharedInstance.addedPlaceId = self.placeDetails.placeId ?? 0
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
                hud?.dismiss(afterDelay: 3)
            }
            /*
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             self.loadHUBs()
             }
             */
            
            self.refreshHUBdisplay()
            self.view.hideStateView()
        })
        
    }
    //
    //    HUB.currentHUB = hub
    //    HUB.saveCurrentHUBLocally()
    //    self.refreshHUBdisplay()
    
    /*
    
    func manageFirstHubStatusIcon(hub:HUB){
        let hubState = hub.equipementState
        if hub.behavior == "auto" {
            let imageName = hubState ? "smartContrlOn" : "smartContrlActivated"
            bulbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "planning" {
            let imageName = hubState ? "pumbPgmOn" : "pumbPgmInactive"
            bulbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "manual" {
            let imageName = hubState ? "ON" : "OFF-pause"
            bulbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else{
            
        }
    }
    
    
    func manageSecondHubStatusIcon(hub:HUB){
        let hubState = hub.equipementState
        if hub.behavior == "auto" {
            let imageName = hubState ? "smartContrlOn" : "smartContrlActivated"
            pumbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "planning" {
            let imageName = hubState ? "pumbPgmOn" : "pumbPgmInactive"
            pumbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "manual" {
            let imageName = hubState ? "ON" : "OFF-pause"
            pumbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else{
            
        }
    }
    
    */
    
    @IBAction func pumbSwitchActionFliptrTab(sender:UIButton){
        if !isPlaceOwner {return}
        HUB.currentHUB =  self.hubPumb
        HUB.saveCurrentHUBLocally()
        if sender.tag == 1{
            if self.hubPumb?.behavior == "manual" {
                pumbActionButton.setImage(UIImage(named: "OFF-pause"), for: .normal)
                self.pumbOffOn(isOn: false)
            }else{
                self.hubButtonAction(self)
            }
        }
        else if sender.tag == 0{
            if self.hubPumb?.behavior == "manual" {
                pumbActionButton.setImage(UIImage(named: "ON"), for: .normal)
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
        if !isPlaceOwner {return}
        HUB.currentHUB =  self.hubBulb
        HUB.saveCurrentHUBLocally()
        if sender.tag == 1{
            if self.hubBulb?.behavior == "manual" {
                bulbActionButton.setImage(UIImage(named: "OFF-pause"), for: .normal)
                self.pumbOffOn(isOn: false)
            }else{
                self.hubButtonAction(self)
            }
        }
        else if sender.tag == 0{
            if self.hubBulb?.behavior == "manual" {
                bulbActionButton.setImage(UIImage(named: "ON"), for: .normal)
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
    
    
    func handleSmartControll(hub:HUB){
        HUB.currentHUB =  hub
        HUB.saveCurrentHUBLocally()
        
        //        self.automView.showEmptyStateViewLoading(title: nil, message: nil)
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        if hub.behavior == "auto" {
            if !hub.equipementState {
                HUB.currentHUB?.updateBehavior(value: "auto", completion: { (message, error) in
                    if error != nil {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = error?.localizedDescription
                        hud?.dismiss(afterDelay: 0)
                    } else {
                        HUB.currentHUB?.behavior = "auto"
                        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud?.dismiss(afterDelay: 3)
                    }
                    self.loadHUBs()
                })
            } else {
                /*
                 HUB.currentHUB?.updateBehavior(value: "manual", completion: { (message, error) in
                 if error != nil {
                 //                    self.showError(title: "Error", message: error?.localizedDescription)
                 hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                 hud?.textLabel.text = error?.localizedDescription
                 hud?.dismiss(afterDelay: 3)
                 
                 } else {
                 HUB.currentHUB?.behavior = "auto"
                 hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                 hud?.dismiss(afterDelay: 3)
                 }
                 self.loadHUBs()
                 })
                 
                 */
            }
        }else{
            HUB.currentHUB?.updateBehavior(value: "auto", completion: { (message, error) in
                if error != nil {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 0)
                    
                } else {
                    HUB.currentHUB?.behavior = "auto"
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 3)
                }
                self.loadHUBs()
            })
        }
        
    }
    
    
    func keepUserOrderHubViews(){
        self.handleHubViews()
    }
    
    
    func manageFirstHubStatusIcon(hub:HUB){
        let hubState = hub.equipementState
        if hub.behavior == "auto" {
            let imageName = hubState ? "smartContrlOn" : "smartContrlActivated"
            bulbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "planning" {
            let imageName = hubState ? "pumbPgmOn" : "pumbPgmInactive"
            bulbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "manual" {
            let imageName = hubState ? "ON" : "OFF-pause"
            bulbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else{
            
        }
    }
    
    
    func manageSecondHubStatusIcon(hub:HUB){
        let hubState = hub.equipementState
        if hub.behavior == "auto" {
            let imageName = hubState ? "smartContrlOn" : "smartContrlActivated"
            pumbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "planning" {
            let imageName = hubState ? "pumbPgmOn" : "pumbPgmInactive"
            pumbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else if hub.behavior == "manual" {
            let imageName = hubState ? "ON" : "OFF-pause"
            pumbActionButton.setImage(UIImage(named: imageName), for: .normal)
        }
        else{
            
        }
    }
    
    
    func clearHubsInFliprTab(){
        self.hubBulb = nil
        self.hubPumb =  nil
        bulbActionButton.setImage(UIImage(named: "add"), for: .normal)
        bulbActionButton.isUserInteractionEnabled = true
        self.bulbStatuImageView.image =  UIImage(named: "lightDisabled")
        pumbActionButton.setImage(UIImage(named: "add"), for: .normal)
        self.pumbStatuImageView.image =  UIImage(named: "pumbdisabled")
        pumbActionButton.isUserInteractionEnabled = true
        firstHubNameLbl.text = ""
        secondHubNameLbl.text = ""

    }
    
    
    // hub state handling
    
    func handleHubViews(){
                
        if self.hubs.count < 1{
            self.updateHubWaveForNoHubs()
            return
        }
        var firstHubKey = ""
        var secondHubKey = ""
        var isNotSavedHubPosition = false
        if let firstHub = UserDefaults.standard.object(forKey: "FirstHubSerialKey") as? String{
            firstHubKey = firstHub
            isNotSavedHubPosition = true
        }
        
        if let secondHub = UserDefaults.standard.object(forKey: "SecondHubSerialKey") as? String{
            secondHubKey = secondHub
        }
        self.hubBulb = nil
        self.hubPumb = nil
        if isNotSavedHubPosition{
            for hubObj in self.hubs{
                
                if hubObj.serial == firstHubKey{
                    self.hubPumb = hubObj
                }
                else if hubObj.serial == secondHubKey{
                    self.hubBulb = hubObj
                }
                
                /*
                 if hubObj.serial == firstHubKey{
                 self.hubBulb = hubObj
                 }
                 else if hubObj.serial == secondHubKey{
                 self.hubPumb = hubObj
                 }
                 */
                
            }
            
        }else{
            self.hubBulb = nil
            self.hubPumb = nil
            if self.hubs.count > 0 {
                for (ordeVal,hubObj) in self.hubs.enumerated(){
                    if ordeVal == 0{
                        self.hubPumb = hubObj
                    }
                    else if ordeVal == 1{
                        self.hubBulb = hubObj
                    }else{
                        
                    }
                    /*
                     if hubObj.equipementCode == 84{
                     self.hubBulb = hubObj
                     }
                     else if hubObj.equipementCode == 86{
                     self.hubPumb = hubObj
                     }
                     else{
                     self.hubBulb = hubObj
                     }
                     */
                }
            }
            
        }
        
        
        if let hubObj = self.hubBulb{
            if hubObj.equipementState {
                bulbActionButton.setImage(UIImage(named: "ON"), for: .normal)
                bulbActionButton.tag = 1
                //                bulbStatuImageView.image =  UIImage(named: "lightOn")
                if hubObj.equipementCode == 84{
                    self.bulbStatuImageView.image =  UIImage(named: "lightOn")
                }
                else if hubObj.equipementCode == 86{
                    self.bulbStatuImageView.image =  UIImage(named: "pumbactive")
                }
                else{
                    self.bulbStatuImageView.image =  UIImage(named: "heatpump")
                }
                bulbActionButton.isUserInteractionEnabled = true
                if hubObj.behavior == "manual" {
                    bulbActionButton.setImage(UIImage(named: "ON"), for: .normal)
                }
                else if hubObj.behavior == "planning" {
                    bulbActionButton.setImage(UIImage(named: "pumbPgmOn"), for: .normal)
                }
                else if hubObj.behavior == "auto" {
                    bulbActionButton.isUserInteractionEnabled = false
                    bulbActionButton.setImage(UIImage(named: "pumbOn"), for: .normal)
                }else{
                    
                }
            }else{
                //                bulbStatuImageView.image =  UIImage(named: "lightDisabled")
                bulbActionButton.setImage(UIImage(named: "OFF"), for: .normal)
                if hubObj.equipementCode == 84{
                    self.bulbStatuImageView.image =  UIImage(named: "lightDisabled")
                }
                else if hubObj.equipementCode == 86{
                    self.bulbStatuImageView.image =  UIImage(named: "pumbactive")
                }
                else{
                    self.bulbStatuImageView.image =  UIImage(named: "heatpump")
                }
                bulbActionButton.isUserInteractionEnabled = true
                bulbActionButton.tag = 0
                if hubObj.behavior == "manual" {
                    bulbActionButton.setImage(UIImage(named: "OFF"), for: .normal)
                }
                else if hubObj.behavior == "planning" {
                    bulbActionButton.setImage(UIImage(named: "pumbPrgmOff"), for: .normal)
                }
                else if hubObj.behavior == "auto" {
                    bulbActionButton.isUserInteractionEnabled = false
                    bulbActionButton.setImage(UIImage(named: "pumbOff"), for: .normal)
                }else{
                    
                }
            }
            self.manageFirstHubStatusIcon(hub: hubObj)
        }
        else{
            secondHubNameLbl.text = ""
            bulbActionButton.setImage(UIImage(named: "add"), for: .normal)
            self.bulbStatuImageView.image =  UIImage(named: "pumbdisabled")
            bulbActionButton.isUserInteractionEnabled = true
        }
        
        if let hubObj = self.hubPumb{
            if hubObj.equipementState {
                pumbActionButton.setImage(UIImage(named: "pumbOn"), for: .normal)
                pumbStatuImageView.image = UIImage(named: "pumbactive")
                if hubObj.equipementCode == 84{
                    self.pumbStatuImageView.image =  UIImage(named: "lightOn")
                }
                else if hubObj.equipementCode == 86{
                    self.pumbStatuImageView.image =  UIImage(named: "pumbactive")
                }
                else{
                    self.pumbStatuImageView.image =  UIImage(named: "heatpump")
                }
                pumbActionButton.isUserInteractionEnabled = true
                pumbActionButton.tag = 1
                if hubObj.behavior == "manual" {
                    pumbActionButton.setImage(UIImage(named: "ON"), for: .normal)
                }
                else if hubObj.behavior == "planning" {
                    pumbActionButton.setImage(UIImage(named: "pumbPgmOn"), for: .normal)
                }
                else if hubObj.behavior == "auto" {
                    pumbActionButton.isUserInteractionEnabled = false
                    pumbActionButton.setImage(UIImage(named: "pumbOn"), for: .normal)
                }else{
                    
                }
            }else{
                //  pumbStatuImageView.image = UIImage(named: "pumbdisabled")
                if hubObj.equipementCode == 84{
                    self.pumbStatuImageView.image =  UIImage(named: "lightDisabled")
                }
                else if hubObj.equipementCode == 86{
                    self.pumbStatuImageView.image =  UIImage(named: "pumbactive")
                }
                else{
                    self.pumbStatuImageView.image =  UIImage(named: "heatpump")
                }
                pumbActionButton.setImage(UIImage(named: "pumbOff"), for: .normal)
                pumbActionButton.tag = 0
                pumbActionButton.isUserInteractionEnabled = true
                if hubObj.behavior == "manual" {
                    pumbActionButton.setImage(UIImage(named: "OFF"), for: .normal)
                }
                else if hubObj.behavior == "planning" {
                    pumbActionButton.setImage(UIImage(named: "pumbPrgmOff"), for: .normal)
                }
                else if hubObj.behavior == "auto" {
                    pumbActionButton.isUserInteractionEnabled = false
                    pumbActionButton.setImage(UIImage(named: "pumbOff"), for: .normal)
                }else{
                    
                }
            }
            
            self.manageSecondHubStatusIcon(hub: hubObj)
            
            firstHubNameLbl.text = self.hubPumb?.equipementName.capitalized
            secondHubNameLbl.text = self.hubBulb?.equipementName.capitalized
            
            
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
        //        getNotificationStatus()
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
        manageAllThreshhhold()
        /*
         let value = UserDefaults.standard.bool(forKey: userDefaultThresholdValuesKey)
         //        self.redoxChangeButton.isHidden = value
         
         UIView.transition(with:  self.redoxChangeButton, duration: 0.4,
         options: .transitionCrossDissolve,
         animations: {
         self.redoxChangeButton.isHidden = value
         })
         */
        
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
        manageAllThreshhhold()
        /*
         let phMinValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMinValuesKey)
         let phMaxValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMaxValuesKey)
         
         let waterMinValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMinValuesKey)
         let waterMaxValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMaxValuesKey)
         let redoxValue = UserDefaults.standard.bool(forKey: userDefaultThresholdValuesKey)
         
         
         if phMinValue && phMaxValue && waterMinValue && waterMaxValue && redoxValue{
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
    
    
    func manageAllThreshhhold(){
        let phMinValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMinValuesKey)
        let phMaxValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMaxValuesKey)
        
        let waterMinValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMinValuesKey)
        let waterMaxValue = UserDefaults.standard.bool(forKey: userDefaultTemperatureMaxValuesKey)
        let redoxValue = UserDefaults.standard.bool(forKey: userDefaultThresholdValuesKey)
        
        if !isPlaceOwner{
            return
        }
        
        if phMinValue && phMaxValue && waterMinValue && waterMaxValue && redoxValue{
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
        if value {
            UIView.transition(with:  self.notificationDisabledButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.notificationDisabledButton.isHidden = value
            })
        }else{
            if self.notificationReportDate != nil{
                if self.notificationReportDate!.timeIntervalSinceNow < 0 {
                    if self.isPlaceOwner {
                        self.notificationDisabledButton.isHidden = false
                    }
                    if let module = Module.currentModule {
                        if module.isSubscriptionValid {
                            // nothing to do
                        }else{
                            self.showSubscriptionButton()
                        }
                    }else{
                        self.showSubscriptionButton()
                    }
                    //                    UserDefaults.standard.set(false, forKey: notificationOnOffValuesKey)
                }else{
                    self.notificationDisabledButton.isHidden = true
                    self.showActivateMeasureAlert()
                }
            }
        }
        
        
        //        self.notificationDisabledButton.isHidden = value
    }
    
    func waveThemathanged(){
        fluidView.removeFromSuperview()
        fluidView = nil
        fluidViewTopEdge.removeFromSuperview()
        fluidViewTopEdge = nil
        
        hubTabfluidView.removeFromSuperview()
        hubTabfluidView = nil
        hubTabFluidViewTopEdge.removeFromSuperview()
        hubTabFluidViewTopEdge = nil
        
        setupInitialView()
//        self.refresh()

    }
    
    func setupInitialView() {
        var isOrangeTheme = true
        if let currentThemColour = UserDefaults.standard.object(forKey: "CurrentTheme") as? String{
            if currentThemColour == "blue"{
                isOrangeTheme = false
            }else{
                isOrangeTheme = true
            }
        }
        var fluidColor =  UIColor.init(hexString: "fcad71")
        if !isOrangeTheme {
            backgroundOverlayImageView.image = UIImage(named: "blue gradient")
            backgroundOverlayHubImageView.image = UIImage(named: "blue gradient")
            //            fluidColor =  UIColor.init(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)
            fluidColor =  UIColor.init(hexString: "2cd3c1")
        }else{
            fluidColor =  UIColor.init(hexString: "fcad71")
            backgroundOverlayImageView.image = UIImage(named: "gradient")
            backgroundOverlayHubImageView.image = UIImage(named: "gradient")
        }
        
        //  var fluidColor =  UIColor.init(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)
        //        let fluidColor =  UIColor.init(hexString: "fcad71")
        
        if let module = Module.currentModule {
            self.settingsButtonContainer.isHidden = false
//            self.hideUserHasNoFlipr()
            if module.isForSpa {
                //backgroundImageView.image = UIImage(named:"Dashboard_BG_SPA")
                //backgroundOverlayImageView.image = UIImage(named:"Degrade_dashboard_SPA")
                //fluidColor =  UIColor.init(colorLiteralRed: 64/255.0, green: 125/255.0, blue: 136/255.0, alpha: 1)
            }
        }else{
            self.hideUserHasNoFlipr()
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
            if orpViewRightConstraint != nil{
                orpViewRightConstraint.constant = 8
                phViewLeftConstraint.constant = 0
            }
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
        if  modelName.rawValue == "iPhone 12 Pro" || modelName.rawValue == "iPhone 11 Pro" || modelName.rawValue == "iPhone 13 Pro"{
            startElevation = 0.96
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
        
        
        var frame = self.waveView.frame
        
        if waveFrame == nil{
            frame = self.waveView.frame
            waveFrame = self.waveView.frame
        }else{
            frame = waveFrame!
        }
        
        fluidView = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral:  startElevation))
        fluidView.strokeColor = .clear
        if !isOrangeTheme {
            //            fluidView.fillColor = UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
            fluidView.fillColor = UIColor.init(hexString: "6e75c5")
        }else{
            fluidView.fillColor = UIColor.init(hexString: "CD69C0")
        }
        // UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
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
        let hubTabStartElevation = 0.85
        
        let hubWaveframe = self.hubWaveContainerView.frame
        hubTabfluidView = BAFluidView.init(frame: hubWaveframe, startElevation: NSNumber(floatLiteral:  hubTabStartElevation))
        hubTabfluidView.strokeColor = .clear
        if !isOrangeTheme {
            hubTabfluidView.fillColor = UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
            
        }else{
            hubTabfluidView.fillColor = UIColor.init(hexString: "CD69C0")
        }
        
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
                //                self!.hubTabFluidViewTopEdge.transform = CGAffineTransform(rotationAngle: 0)
                //                self!.hubTabfluidView.transform = CGAffineTransform(rotationAngle: 0)
            } else {
                let rotation = atan2(data.gravity.x,data.gravity.y) - .pi
                self!.fluidViewTopEdge.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                self!.fluidView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                //                self!.hubTabFluidViewTopEdge.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                //                self!.hubTabfluidView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                
            }
            
        }
        self.view.bringSubviewToFront(quicActionButton)
        showUserPreferedHistory()
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
        if Module.currentModule == nil && HUB.currentHUB != nil {
            self.updateHUBData()
        }else{
            if let serialNo =  Module.currentModule?.serial as? String{
                if serialNo == ""{
                    self.updateHUBData()
                }
            }
        }
        self.updateFliprData()
        
        
    }
     
     
    
    /*
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
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Passive Wintering".localized, message: "You have placed your pool in passive wintering : Flipr does not display datas. To view the datas, please change the status of your pool and follow the advices of impoundment".localized, bottomAlignment:0)
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
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: "Still a little patience, you can leave the application and come back in a few minutes...".localized, bottomAlignment: 0)
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
                self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Configuration du HUB en cours !".localized, message: message, buttonTitle: buttonTitle,bottomAlignment:0, buttonAction: {
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
                self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: message, buttonTitle: buttonTitle, bottomAlignment:0,buttonAction: {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PoolViewControllerID") {
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    }
                })
            }
            
        }
        
    }
    */
    
    
    @objc func hideFirstReadingMsg(){
        self.view.showEmptyStateViewLoading(title: nil, message: nil)
    }
    
    func startReading(){
        
        self.perform(#selector(self.updateFliprData), with: nil, afterDelay: 5)
        self.perform(#selector(self.hideFirstReadingMsg), with: nil, afterDelay: 5)

        
     /*
        BLEManager.shared.calibrationType = .simpleMeasure
        BLEManager.shared.calibrationMeasures = true
        BLEManager.shared.isHandling409 = true

        BLEManager.shared.startMeasure { (error) in
             
            BLEManager.shared.doAcq = false
            
            if error != nil {
              
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                
              
            } else {
//                self.readingSuccess()
//                self.showError(title: "Success", message: "Value read")
                
//                UIApplication.shared.isIdleTimerDisabled = true
                
//                //timer 2 min et à la fin lire la measure.
//                UserDefaults.standard.set(Date()?.addingTimeInterval(self.measuresInterval), forKey: self.calibrationType.rawValue + "CalibrationEndingDate")
//
//                let theme = EmptyStateViewTheme.shared
//                theme.activityIndicatorType = .ballGridPulse
//
//                if self.calibrationType == .simpleMeasure {
//                    self.view.showEmptyStateViewLoading(title: "New measurement".localized.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
//                } else {
//                    self.view.showEmptyStateViewLoading(title: "CALIBRATION ".localized + self.calibrationType.rawValue.uppercased(), message: "Measurement in progress...\n\nThis operation may take a few minutes, do not quit the app, keep the iPhone active and close to the Flipr.".localized, theme: theme)
//                }
//
//
//                self.progressView.isHidden = false
//                self.progressView.setProgress(0, animated: false)
//
//                self.measuresTimer = Timer.scheduledTimer(timeInterval: 0.05,
//                                                          target: self,
//                                                          selector: #selector(self.updateTime),
//                                                          userInfo: nil,
//                                                          repeats: true)
            }
            
        }

        
*/

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
    
    
    func manageFlipTabTitle(){
        /*
         var fliprTabName = "Flipr Start"
         if let module = Module.currentModule {
         if let nameStr = module.deviceTypename{
         fliprTabName = nameStr
         }else{
         if let fliprName = UserDefaults.standard.object(forKey: "FliprName") as? String{
         fliprTabName = fliprName
         }
         }
         }else{
         if let fliprName = UserDefaults.standard.object(forKey: "FliprName") as? String{
         fliprTabName = fliprName
         }
         }
         */
        //        self.fliprTabTitleLbl.text = "Analysis".localized
        
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
                            
                            self.airTemperatureLabel.text = String(format: "%.0f", temperature) + "°C"
                            self.airTemperatureLabelHubTab.text = String(format: "%.0f", temperature) + "°C"
                            
                            if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                                if currentUnit == 2{
                                    let funit = (temperature * 9/5) + 32
                                    self.airTemperatureLabel.text = String(format: "%.0f", funit) + "°F"
                                    self.airTemperatureLabelHubTab.text = String(format: "%.0f", funit) + "°F"
                                }else{
                                }
                            }
                            
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
    
    func showSubscriptionButton(){
        if !isPlaceOwner{
            hideAlertArea()
            return
        }
        self.measureAlertView.isHidden = true
        self.measureAlertTouchAreaButton.isHidden = true
        self.subscriptionButton.tag = 3
        self.subscriptionButton.isUserInteractionEnabled = true
        self.subscriptionButton.isHidden = false
        self.subscriptionButton.backgroundColor  = UIColor.init(hexString: "111729")
        self.subscriptionButton.setTitleColor(.white, for: .normal)
        self.subscriptionButton.setTitle("Activer la connexion à distance".localized, for: .normal)
        self.subscriptionButton.setImage(UIImage(named: "subscriptionIcon"), for: .normal)
    }
    
    func showAlertButton(){
        if !isPlaceOwner{
            hideAlertArea()
            return
        }
        self.measureAlertView.isHidden = true
        self.measureAlertTouchAreaButton.isHidden = true
        self.subscriptionButton.tag = 2
        self.subscriptionButton.isUserInteractionEnabled = true
        self.subscriptionButton.isHidden = false
        self.subscriptionButton.backgroundColor  = UIColor.init(hexString: "FF8F50")
        self.subscriptionButton.setTitleColor(.white, for: .normal)
        self.subscriptionButton.setTitle("Alerte en cours : suivez nos conseils".localized, for: .normal)
        self.subscriptionButton.setImage(UIImage(named: "alertProcessing"), for: .normal)
    }
    
    func showGreenAlertButton(){
        if !isPlaceOwner{
            hideAlertArea()
            return
        }
        self.measureAlertView.isHidden = true
        self.measureAlertTouchAreaButton.isHidden = true
        self.subscriptionButton.tag = 4
        self.subscriptionButton.isUserInteractionEnabled = true
        self.subscriptionButton.isHidden = false
        self.subscriptionButton.backgroundColor  = UIColor.init(hexString: "00CFCF")
        self.subscriptionButton.setTitleColor(.white, for: .normal)
        self.subscriptionButton.setTitle("Correction de l'eau en cours".localized, for: .normal)
        self.subscriptionButton.setImage(UIImage(named: "thumbs-up"), for: .normal)
    }
    
    func showGoodMeasureButton(){
        if !isPlaceOwner{
            hideAlertArea()
            return
        }
        self.measureAlertView.isHidden = true
        self.measureAlertTouchAreaButton.isHidden = true
        self.subscriptionButton.tag = 1
        self.subscriptionButton.isUserInteractionEnabled = false
        self.subscriptionButton.isHidden = false
        self.subscriptionButton.backgroundColor  = .white
        self.subscriptionButton.setTitleColor(UIColor.init(hexString: "111729"), for: .normal)
        self.subscriptionButton.setTitle("Tout est parfait, bravo !".localized, for: .normal)
        self.subscriptionButton.setImage(UIImage(named: "heartBlack"), for: .normal)
    }
    
    
    func showVigilanceButton(){
        if !isPlaceOwner{
            hideAlertArea()
            return
        }
        self.measureAlertView.isHidden = true
        self.measureAlertTouchAreaButton.isHidden = true
        self.subscriptionButton.tag = 5
        self.subscriptionButton.isUserInteractionEnabled = true
        self.subscriptionButton.isHidden = false
        self.subscriptionButton.backgroundColor  = UIColor(hexString: "FFD166")
        self.subscriptionButton.setTitleColor(UIColor.init(hexString: "111729"), for: .normal)
        self.subscriptionButton.setTitle("Vigilance en cours".localized, for: .normal)
        self.subscriptionButton.setImage(UIImage(named: "eye"), for: .normal)
    }
    
    
    func hideAlertArea(){
        self.subscriptionButton.isHidden = true
        self.measureAlertView.isHidden = true
    }
    
    func manageGestView(){
        redoxChangeButton.isHidden = true
        waterTmpChangeButton.isHidden = true
        phChangeButton.isHidden = true
    }
    
    func hideWeatherForecast() {
        airTemperatureLabel.text = "  "
        airTemperatureLabelHubTab.text = "  "
        self.hubTabAirValLabel.text = "  "
        
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
        
        self.measureAlertView.isHidden = true
        self.measureAlertTouchAreaButton.isHidden = true
        self.subscriptionButton.isUserInteractionEnabled = true
        self.subscriptionButton.isHidden = true

        
        if self.lastMeasureDate == nil{
            return
        }
        else{
            if self.lastMeasureDate!.timeIntervalSinceNow > -86400 {
                
                //                let phMinValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMinValuesKey)
                //                let phMaxValue = UserDefaults.standard.bool(forKey: userDefaultPhvalueMaxValuesKey)
                //                let redoxMinValue = UserDefaults.standard.bool(forKey: userDefaultThresholdValuesKey)
                
                if isRedoxOutOfRangeAlert ||  isPhOutOfRangeAlert{
                    let value = UserDefaults.standard.bool(forKey: notificationOnOffValuesKey)
                    if value{
                        self.getAlertFromServer()
                        //                        self.showActivateMeasureAlert()
                    }else{
                        if self.notificationReportDate != nil{
                            if self.notificationReportDate!.timeIntervalSinceNow < 0 {
                                if let module = Module.currentModule {
                                    if module.isSubscriptionValid {
                                        // nothing to do
                                    }else{
                                        self.showSubscriptionButton()
                                    }
                                }else{
                                    self.showSubscriptionButton()
                                }
                            }else{
                                self.showActivateMeasureAlert()
                            }
                        }else{
                            self.showActivateMeasureAlert()
                        }
                    }
                    
                }else{
                    if let module = Module.currentModule {
                        if module.isSubscriptionValid {
                            self.showGoodMeasureButton()
                        }else{
                            self.showSubscriptionButton()
                        }
                    }else{
                        self.showSubscriptionButton()
                    }
                }
            }else{
                self.showMeasureAlert()
            }
        }
    }
    
    
    func callReactivateAlertApi(alertStatus:Bool){
        
        if let serialNo = Module.currentModule?.serial {
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            Alamofire.request(Router.reactivateAlert(serial: serialNo, status: alertStatus)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    UserDefaults.standard.set(alertStatus, forKey: notificationOnOffValuesKey)
                    self.manageNotificationDisabledButtton()
                    hud?.dismiss(afterDelay: 3)
                    self.isShowingLoadingForAlertApi = true
                    self.getAlertFromServer()
                case .failure(let error):
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                    print("Reactivated Notification did fail with error: \(error)")
                    
                }
                
            })
        }else{
            print("No serial number")
        }
    }
    
    func showMeasureAlert(){
        self.measureAlertButton.setTitle("En savoir plus".localized, for: .normal)
        self.measureAlertButton.titleLabel?.text = "En savoir plus".localized
        measureAlertButton.underline()
        measureAlertLbl.text = "Mesure ancienne".localized
        self.subscriptionButton.isHidden = true
        self.measureAlertView.isHidden = false
        self.measureAlertTouchAreaButton.isHidden = false
        self.isShowingActivateAlert = false
    }
    
    func showActivateMeasureAlert(){
        self.measureAlertButton.setTitle("Annuler".localized, for: .normal)
        self.measureAlertButton.setTitle(" ".localized, for: .normal)
        self.measureAlertButton.titleLabel?.text = "Annuler".localized
        measureAlertButton.underline()
        //        self.measureAlertButton.setTitle("Test dsad", for: .normal)
        
        measureAlertLbl.text = "vous avez reporte vos alerts".localized
        self.subscriptionButton.isHidden = true
        self.measureAlertView.isHidden = false
        self.measureAlertTouchAreaButton.isHidden = false
        self.isShowingActivateAlert = true
    }
    
    
    func hideMeasureAlert(){
        self.measureAlertView.isHidden = true
        self.measureAlertTouchAreaButton.isHidden = true
        
    }
    
    
    
    func getProrityAlert(){
        self.alertButton.isHidden = true
        self.alertCheckView.isHidden = true
        
        self.alert0Button.isHidden = true
        self.alert1Button.isHidden = true
        self.alert2Button.isHidden = true
        self.alert3Button.isHidden = true
        self.alert4Button.isHidden = true
        DispatchQueue.global().async {
            self.callAlertAPi()
        }
    }
    
    
    func callAlertAPi(){
        self.alert = nil
        //        self.alertButton.isHidden = true
        //        self.alertCheckView.isHidden = true
        //
        //        self.alert0Button.isHidden = true
        //        self.alert1Button.isHidden = true
        //        self.alert2Button.isHidden = true
        //        self.alert3Button.isHidden = true
        //        self.alert4Button.isHidden = true
        
        //        let hud = JGProgressHUD(style:.dark)
        //        hud?.show(in: self.view)
        Module.currentModule?.getAlertsForPlace(completion: { (alert, priorityAlerts, error) in
            //            hud?.dismiss(afterDelay: 0)
            
            DispatchQueue.main.async {
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
            }
            
            
            
        })
    }
    
    func getAlertFromServer(){
        self.getMainAlertsFromServer()
    }
    
    func  getMainAlertsFromServer(){
        
        
        self.alert = nil
        self.alertButton.isHidden = true
        self.alertCheckView.isHidden = true
        
        self.alert0Button.isHidden = true
        self.alert1Button.isHidden = true
        self.alert2Button.isHidden = true
        self.alert3Button.isHidden = true
        self.alert4Button.isHidden = true
        
        if subscriptionButton.tag == 2 {
            self.hideBottomAlertButton()
        }
        /*
         if let module = Module.currentModule {
         if !module.isSubscriptionValid {
         // self.handleSubscriptionButton()
         return
         }else{
         //                self.subscriptionButton.isHidden = true
         }
         }
         */
        
        //  let hud = JGProgressHUD(style:.dark)
        if self.isShowingLoadingForAlertApi{
            // hud?.show(in: self.view)
        }
        DispatchQueue.global().async {
            
            Module.currentModule?.getCurrentAlertsMump(completion: { (alert, priorityAlerts, error) in
                
                DispatchQueue.main.async {
                    
                    
                    if self.isShowingLoadingForAlertApi{
                        self.isShowingLoadingForAlertApi = false
                        //  hud?.dismiss(afterDelay: 0)
                    }
                    var noMainAlert = true
                    if alert != nil {
                        noMainAlert = false
                        self.alert = alert
                        if self.alert?.status == 0 {
                            self.alertButton.isHidden = false
                            self.showAlertButton()
                            self.alertCheckView.isHidden = true
                        } else {
                            self.alertButton.isHidden = true
                            self.showGreenAlertButton()
                            //                    self.alertCheckView.isHidden = false
                        }
                        //                if let module = Module.currentModule {
                        //                    if module.isSubscriptionValid {
                        //                        self.showAlertButton()
                        //                    }else{
                        //                        if self.lastMeasureDate != nil{
                        //                            if self.lastMeasureDate!.timeIntervalSinceNow > -21600 {
                        //                                self.showAlertButton()
                        //                            }
                        //                        }
                        //                    }
                        //                }FF
                    }
                    
                    else {
                        noMainAlert = true
                        self.alert = nil
                        self.alertButton.isHidden = true
                        self.alertCheckView.isHidden = true
                        //                if let module = Module.currentModule {
                        //                    if module.isSubscriptionValid {
                        //                        self.showGoodMeasureButton()
                        //                    }else{
                        //                    }
                        //                }
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
                    
                    if noMainAlert && i == 0 {
                        if let module = Module.currentModule {
                            if module.isSubscriptionValid {
                                self.showVigilanceButton()
                            }else{
                                self.showSubscriptionButton()
                            }
                        }else{
                            self.showSubscriptionButton()
                        }
                    }
                    else{
                        /*
                         if let module = Module.currentModule {
                         if module.isSubscriptionValid {
                         self.showAlertButton()
                         }else{
                         if self.lastMeasureDate != nil{
                         if self.lastMeasureDate!.timeIntervalSinceNow > -21600 {
                         self.showAlertButton()
                         }
                         }
                         }
                         }
                         */
                    }
                }
            })
        }
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
                    
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Refresh error".localized, message: error.localizedDescription, buttonTitle: "Retry".localized,bottomAlignment:0, buttonAction: {
                        self.view.hideStateView()
                        self.updateFliprData()
                    })
                    
                } else if let JSON = response.result.value as? [String:Any] {
                    
                    print("HUB JSON resume: \(JSON)")
                    self.scrollView.isHidden = false
                    self.phStatusView.isHidden = false
                    self.tempStatusView.isHidden = false
                    self.redoxStatusView.isHidden = false
                    self.tempWindView.isHidden = false
                    self.weatherView.isHidden = false
                    
                    self.airLabel.isHidden = false
                    self.airTendendcyImageView.isHidden = false
                    self.uvView.isHidden = false
                    
                    
                    self.airLabelHubTab.isHidden = false
                    self.airTendendcyImageViewHubTab.isHidden = false
                    self.uvViewHubTab.isHidden = false
                    self.airSeparatorView.isHidden = false

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
                            
                            self.airTemperatureLabel.text = String(format: "%.0f", temperature) + "°C"
                            self.airTemperatureLabelHubTab.text = String(format: "%.0f", temperature) + "°C"
                            
                            if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                                if currentUnit == 2{
                                    let funit = (temperature * 9/5) + 32
                                    self.airTemperatureLabel.text = String(format: "%.0f", funit) + "°F"
                                    self.airTemperatureLabelHubTab.text = String(format: "%.0f", funit) + "°F"
                                }else{
                                }
                            }
                            
                            
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
                            self.uvLabel.layer.borderWidth = 0
                            //                            self.uvLabel.layer.cornerRadius = (self.uvLabel.frame.size.height / 2)
                            self.uvLabelHubTab.text = index
                            self.uvLabelHubTab.layer.borderWidth = 0
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
                    
                    if let lastWeekWeather = JSON["WeatherLastWeek"] as? [String: Any] {
                        if let individualData = lastWeekWeather["ListWeatherOneDayUnit"] as? [[String: Any]] {
                            do {
                                let data = try JSONSerialization.data(withJSONObject: individualData, options: .prettyPrinted)
                                let decoder = JSONDecoder()
                                let decodedValues = try decoder.decode([WeatherForDay].self, from: data)
                                let phValues = decodedValues.map { $0.moyPH }
                                let rxValues = decodedValues.map { $0.moyRX }
                                let highestTemp = decodedValues.map { $0.waterTemp }
                                let dates = decodedValues.map { $0.date }
                                self.phStatusView.valueStrings = phValues
                                self.phStatusView.dates = dates
                                self.redoxStatusView.valueStrings = rxValues
                                self.redoxStatusView.dates = dates
                                self.tempStatusView.valueStrings = highestTemp
                                self.tempStatusView.dates = dates
                                self.reloadWeatherStatus()
                                
                                /*
                                 let lastFourDaysData = Array(decodedValues.suffix(4))
                                 if lastFourDaysData.count == 4 {
                                 self.day1IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[0].weatherIcon ?? "")
                                 self.day1TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[0].date)
                                 self.day1ValueLabel.text = (lastFourDaysData[0].minTemp?.fixedFraction(digits: 0).toString ?? "") + " - " + (lastFourDaysData[0].maxTemp?.fixedFraction(digits: 0).toString ?? "") + "°"
                                 
                                 self.day2IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[1].weatherIcon ?? "")
                                 self.day2TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[1].date)
                                 self.day2ValueLabel.text = (lastFourDaysData[1].minTemp?.fixedFraction(digits: 0).toString ?? "") +  " - " + (lastFourDaysData[1].maxTemp?.fixedFraction(digits: 0).toString ?? "")  + "°"
                                 
                                 self.day3IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[2].weatherIcon ?? "")
                                 self.day3TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[2].date)
                                 self.day3ValueLabel.text = (lastFourDaysData[2].minTemp?.fixedFraction(digits: 0).toString ?? "") + " - " + (lastFourDaysData[2].maxTemp?.fixedFraction(digits: 0).toString ?? "") + "°"
                                 
                                 self.day4IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[3].weatherIcon ?? "")
                                 self.day4TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[3].date)
                                 self.day4ValueLabel.text = (lastFourDaysData[3].minTemp?.fixedFraction(digits: 0).toString ?? "") + " - " + (lastFourDaysData[3].maxTemp?.fixedFraction(digits: 0).toString ?? "") + "°"
                                 
                                 }
                                 */
                                
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                    if let nextFiveHoursData = JSON["WeatherNext5Hours"] as? [[String:Any]] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: nextFiveHoursData, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let decodedValues = try decoder.decode([WeatherForHour].self, from: data)
                            let weatherForFifthHour = decodedValues.last
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            if let givenDate = formatter.date(from: weatherForFifthHour?.hourTemperature ?? "") {
                                formatter.dateFormat = "dd/MM"
                            }
                            //                            self.probableWeatherIcon.text = self.climaconsCharWithIcon(icon: weatherForFifthHour?.weatherIcon ?? "")
                            //                            self.tempPrecipitationLabel.text =  "\(weatherForFifthHour?.precipitationProbability ?? 0 )" + "%"
                            if let precipitation = weatherForFifthHour?.precipitationProbability{
                                let val = precipitation * 100
                                self.tempPrecipitationLabel.text = (val.fixedFraction(digits: 0).toString) + "%"
                            }
                            self.windSpeedLabel.text = (weatherForFifthHour?.windSpeed?.fixedFraction(digits: 1).toString ?? "") + "km/h"
                            
                        } catch let error {
                            
                        }
                    }
                    
                    if let nextDaysWeather = JSON["WeatherNext3Days"] as? [[String: Any]] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: nextDaysWeather, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let decodedValues = try decoder.decode([NextDaysWeatherData].self, from: data)
                            self.day1IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[0].weatherIcon ?? "")
                            self.day1TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[0].tempMaxTime ?? "")
                            self.day1ValueLabel.text = (decodedValues[0].tempMin?.fixedFraction(digits: 0).toString ?? "") + " | " + (decodedValues[0].tempMax?.fixedFraction(digits: 0).toString ?? "") + "°"
                            
                            self.day2IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[1].weatherIcon ?? "")
                            self.day2TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[1].tempMaxTime ?? "")
                            self.day2ValueLabel.text = (decodedValues[1].tempMin?.fixedFraction(digits: 0).toString ?? "") +  " | " + (decodedValues[1].tempMax?.fixedFraction(digits: 0).toString ?? "")  + "°"
                            
                            self.day3IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[2].weatherIcon ?? "")
                            self.day3TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[2].tempMaxTime ?? "")
                            self.day3ValueLabel.text = (decodedValues[2].tempMin?.fixedFraction(digits: 0).toString ?? "") + " | " + (decodedValues[2].tempMax?.fixedFraction(digits: 0).toString ?? "") + "°"
                            
                            self.day4IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[3].weatherIcon ?? "")
                            self.day4TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[3].tempMaxTime ?? "")
                            self.day4ValueLabel.text = (decodedValues[3].tempMin?.fixedFraction(digits: 0).toString ?? "") + " | " + (decodedValues[3].tempMax?.fixedFraction(digits: 0).toString ?? "") + "°"
                        } catch let error {
                            
                        }
                    }
                    
                }
            })
            
        } else {
            print("The Flipr HUB identifier does not exist :/")
        }
    }
    
    
    func dayOfTheWeek(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEE"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    @objc func updateFliprData() {
        
        hideFliprData()
        
        if let identifier = Module.currentModule?.serial, identifier.isValidString {
            
            Alamofire.request(Router.readModuleResume(serialId: identifier)).responseJSON(completionHandler: { (response) in
                
                if response.response?.statusCode == 401 {
                    NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                }
                
                if let error = response.result.error {
                    //                    self.showHubTabInfoView(hide: true)
                    print("Update Flipr data did fail with error: \(error)")
                    
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "Refresh error".localized, message: error.localizedDescription, buttonTitle: "Retry".localized,bottomAlignment:0, buttonAction: {
                        self.view.hideStateView()
                        self.updateFliprData()
                    })
                    
                }
                else if let JSON = response.result.value as? [String:Any]
                {
                    self.settingsButtonContainer.isHidden = false
                    self.waterLabel.isHidden = false
                    self.waterTendencyImageView.isHidden = false

                    self.scrollView.isHidden = false
                    self.waveView.isHidden = false
                    self.addFirstFliprView.isHidden = true
                    self.phStatusView.isHidden = false
                    self.tempStatusView.isHidden = false
                    self.redoxStatusView.isHidden = false
                    self.tempWindView.isHidden = false
                    self.weatherView.isHidden = false
                    
                    self.airLabel.isHidden = false
                    self.airTendendcyImageView.isHidden = false
                    self.uvView.isHidden = false
                    
                    
                    self.airLabelHubTab.isHidden = false
                    self.airTendendcyImageViewHubTab.isHidden = false
                    self.uvViewHubTab.isHidden = false
                    self.airSeparatorView.isHidden = false

                    self.showHubTabInfoView(hide: false)
                    print("JSON: Flipr Data \(JSON)")
                    
                    if let fliprData = JSON["fliprSection"] as? [String:Any] {
                        
                        if let needCalib = fliprData["NeedCalib"] as? Bool {
                            if needCalib{
                                self.showCalibrationAlert()
                            }
                            
                        }
                        
                        
                        if let deviceName = fliprData["CommercialType"] as? String {
                            if deviceName == "Flipr Analyzer"
                            {
                                Module.currentModule?.deviceTypename = deviceName
                                UserDefaults.standard.set(deviceName, forKey: "FliprName")
                            }else{
                                Module.currentModule?.deviceTypename = "Flipr Start"
                                UserDefaults.standard.set(deviceName, forKey: "Flipr Start")
                            }
                            self.manageFlipTabTitle()
                        }
                        var firmwereCurrentVersion = "0"
                        var isNeedtoShowUpgrade = 0
                        
                        if let upgradeStatus = fliprData["EnableFliprFirmwareUpgrade"] as? Int {
                            isNeedtoShowUpgrade = upgradeStatus
//                            AppSharedData.sharedInstance.haveNewFirmwereUpdate = FALSE
                        }else{
                            
                        }
                        if let latestVersion = fliprData["FleetCurrentSoftwareVersion"] as? String {
                            self.firmwereLatestVersion = latestVersion
                        }
                        if let currentVersion = fliprData["ModuleSoftwareVersion"] as? String {
                            firmwereCurrentVersion = currentVersion
                        }
                        
                        if isNeedtoShowUpgrade == 0{
                            
                        }else{
                            if self.firmwereLatestVersion == firmwereCurrentVersion{
                                self.haveFirmwereUpdate = false
                                AppSharedData.sharedInstance.haveNewFirmwereUpdate = false
                                //                                self.haveFirmwereUpdate = true
                                //                                AppSharedData.sharedInstance.haveNewFirmwereUpdate = true
                                //                                self.showFirmwereUpdatePrompt()
                            }else{
                                self.haveFirmwereUpdate = true
                                AppSharedData.sharedInstance.haveNewFirmwereUpdate = true
                                self.showFirmwereUpdatePrompt()
                            }
                        }
                        
                    }
                    
                    if let msg = JSON["Message"] as? String {
                        if msg == "you don't have the privileges to perform this action"{
                            self.userHasNoFlipr()
                            self.showHubTabInfoView(hide: true)
                            return
                        }
                    }
                    
                    if let notificationData = JSON["userSection"] as? [String:Any] {
                        if let time = notificationData["NotificationReportDate"] as? String{
                            self.notificationReportTime = time
                            if let lastDate = time.fliprDate {
                                self.notificationReportDate = lastDate
                            }
                            
                        }
                        if let notificationStatus = notificationData["NotificationStatut"] as? Int{
                            UserDefaults.standard.set(notificationStatus == 1 ? true : false, forKey: notificationOnOffValuesKey)
                        }
                        
                    }
                    
                    if let nextFiveHoursData = JSON["WeatherNext5Hours"] as? [[String:Any]] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: nextFiveHoursData, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let decodedValues = try decoder.decode([WeatherForHour].self, from: data)
                            let weatherForFifthHour = decodedValues.last
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            if let givenDate = formatter.date(from: weatherForFifthHour?.hourTemperature ?? "") {
                                formatter.dateFormat = "dd/MM"
                            }
                            //                            self.probableWeatherIcon.text = self.climaconsCharWithIcon(icon: weatherForFifthHour?.weatherIcon ?? "")
                            //                            self.tempPrecipitationLabel.text =  "\(weatherForFifthHour?.precipitationProbability ?? 0 )" + "%"
                            if let precipitation = weatherForFifthHour?.precipitationProbability{
                                let val = precipitation * 100
                                self.tempPrecipitationLabel.text = (val.fixedFraction(digits: 0).toString) + "%"
                            }
                            self.windSpeedLabel.text = (weatherForFifthHour?.windSpeed?.fixedFraction(digits: 1).toString ?? "") + "km/h"
                        } catch let error {
                            
                        }
                    }
                    
                    if let nextDaysWeather = JSON["WeatherNext3Days"] as? [[String: Any]] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: nextDaysWeather, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let decodedValues = try decoder.decode([NextDaysWeatherData].self, from: data)
                            self.day1IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[0].weatherIcon ?? "")
                            self.day1TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[0].tempMaxTime ?? "")
                            self.day1ValueLabel.text = (decodedValues[0].tempMin?.fixedFraction(digits: 0).toString ?? "") + " | " + (decodedValues[0].tempMax?.fixedFraction(digits: 0).toString ?? "") + "°"
                            
                            self.day2IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[1].weatherIcon ?? "")
                            self.day2TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[1].tempMaxTime ?? "")
                            self.day2ValueLabel.text = (decodedValues[1].tempMin?.fixedFraction(digits: 0).toString ?? "") +  " | " + (decodedValues[1].tempMax?.fixedFraction(digits: 0).toString ?? "")  + "°"
                            
                            self.day3IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[2].weatherIcon ?? "")
                            self.day3TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[2].tempMaxTime ?? "")
                            self.day3ValueLabel.text = (decodedValues[2].tempMin?.fixedFraction(digits: 0).toString ?? "") + " | " + (decodedValues[2].tempMax?.fixedFraction(digits: 0).toString ?? "") + "°"
                            
                            self.day4IconLabel.text = self.climaconsCharWithIcon(icon: decodedValues[3].weatherIcon ?? "")
                            self.day4TitleLabel.text = self.dayOfTheWeek(dateString: decodedValues[3].tempMaxTime ?? "")
                            self.day4ValueLabel.text = (decodedValues[3].tempMin?.fixedFraction(digits: 0).toString ?? "") + " | " + (decodedValues[3].tempMax?.fixedFraction(digits: 0).toString ?? "") + "°"
                        } catch let error {
                            
                        }
                    }
                    
                    if let lastWeekWeather = JSON["WeatherLastWeek"] as? [String: Any] {
                        if let individualData = lastWeekWeather["ListWeatherOneDayUnit"] as? [[String: Any]] {
                            do {
                                let data = try JSONSerialization.data(withJSONObject: individualData, options: .prettyPrinted)
                                let decoder = JSONDecoder()
                                let decodedValues = try decoder.decode([WeatherForDay].self, from: data)
                                let phValues = decodedValues.map { $0.moyPH }
                                let rxValues = decodedValues.map { $0.moyRX }
                                let highestTemp = decodedValues.map { $0.waterTemp }
                                let dates = decodedValues.map { $0.date }
                                self.phStatusView.valueStrings = phValues
                                self.phStatusView.dates = dates
                                self.redoxStatusView.valueStrings = rxValues
                                self.redoxStatusView.dates = dates
                                self.tempStatusView.valueStrings = highestTemp
                                self.tempStatusView.dates = dates
                                self.reloadWeatherStatus()
                                
                                /*
                                 let lastFourDaysData = Array(decodedValues.suffix(4))
                                 if lastFourDaysData.count == 4 {
                                 self.day1IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[0].weatherIcon ?? "")
                                 self.day1TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[0].date)
                                 self.day1ValueLabel.text = (lastFourDaysData[0].minTemp?.fixedFraction(digits: 0).toString ?? "") + " - " + (lastFourDaysData[0].maxTemp?.fixedFraction(digits: 0).toString ?? "") + "°"
                                 
                                 self.day2IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[1].weatherIcon ?? "")
                                 self.day2TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[1].date)
                                 self.day2ValueLabel.text = (lastFourDaysData[1].minTemp?.fixedFraction(digits: 0).toString ?? "") +  " - " + (lastFourDaysData[1].maxTemp?.fixedFraction(digits: 0).toString ?? "")  + "°"
                                 
                                 self.day3IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[2].weatherIcon ?? "")
                                 self.day3TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[2].date)
                                 self.day3ValueLabel.text = (lastFourDaysData[2].minTemp?.fixedFraction(digits: 0).toString ?? "") + " - " + (lastFourDaysData[2].maxTemp?.fixedFraction(digits: 0).toString ?? "") + "°"
                                 
                                 self.day4IconLabel.text = self.climaconsCharWithIcon(icon: lastFourDaysData[3].weatherIcon ?? "")
                                 self.day4TitleLabel.text = dayOfTheWeek(dateString: lastFourDaysData[3].date)
                                 self.day4ValueLabel.text = (lastFourDaysData[3].minTemp?.fixedFraction(digits: 0).toString ?? "") + " - " + (lastFourDaysData[3].maxTemp?.fixedFraction(digits: 0).toString ?? "") + "°"
                                 
                                 }
                                 */
                                
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }
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
                            
                            self.airTemperatureLabel.text = String(format: "%.0f", temperature) + "°C"
                            self.airTemperatureLabelHubTab.text = String(format: "%.0f", temperature) + "°C"
                            Module.currentModule?.airTemperature = String(format: "%.2f", temperature) + "°C"
                            
                            if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                                if currentUnit == 2{
                                    let funit = (temperature * 9/5) + 32
                                    self.airTemperatureLabel.text = String(format: "%.0f", funit) + "°F"
                                    self.airTemperatureLabelHubTab.text = String(format: "%.0f", funit) + "°F"
                                    Module.currentModule?.airTemperature = String(format: "%.2f", temperature) + "°F"
                                }else{
                                }
                            }
                            
                            
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
                            self.uvLabel.layer.borderWidth = 0
                            self.uvLabel.layer.cornerRadius = (self.uvLabel.frame.size.height / 2)
                            self.uvLabelHubTab.text = index
                            self.uvLabelHubTab.layer.borderWidth = 0
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
                        
                        print("JSON Current: \(current)")
                        if let sourceId = current["ModeId"] as? Int {
                            self.handleSettingsButton(mode: sourceId)
                        }
                        
                        self.view.hideStateView()
                        
                        if let dateString = current["DateTime"] as? String {
                            self.signalStrengthLabel.textColor =  .black

                            if let lastDate = dateString.fliprDate {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "EEE dd/MM HH:mm"
                                self.lastMeasureDateLabel.text = "\(dateFormatter.string(from: lastDate))"
                                self.lastMeasureDateLabel.isHidden = false
                                self.lastMeasureDate = lastDate
                                Module.currentModule?.rawlastMeasure = dateFormatter.string(from: lastDate)
                                print("lastDate interval since now:\(lastDate.timeIntervalSinceNow)")
                                //
                                /*
                                 
                                 
                                 if let dateString = current["DateTime"] as? String {
                                 if let lastDate = dateString.fliprDate {
                                 let dateFormatter = DateFormatter()
                                 dateFormatter.dateFormat = "EEE HH:mm"
                                 self.lastMeasureDateLabel.text = "Last measure".localized +  " : \(dateFormatter.string(from: lastDate))"
                                 self.lastMeasureDateLabel.isHidden = false
                                 
                                 Module.currentModule?.rawlastMeasure = dateFormatter.string(from: lastDate)
                                 
                                 print("lastDate interval since now:\(lastDate.timeIntervalSinceNow)")
                                 if lastDate.timeIntervalSinceNow < -4500 {
                                 self.readBLEMeasure(completion: { (error) in
                                 if error != nil {
                                 self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
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
                                 self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                                 self.bleStatusView.isHidden = true
                                 } else {
                                 self.bleMeasureHasBeenSent = true
                                 }
                                 })
                                 }
                                 
                                 
                                 */
                                
                                //        if -300 > -400{
                                //            print("true")
                                //        }else{
                                //            print("false")
                                //        }
                                // Greater than 75 minute ex: -4600
                                
                                
                                
                                if lastDate.timeIntervalSinceNow < -4500 {
                                    if self.isPlaceOwner{
                                        if identifier.hasPrefix("F"){
                                            
                                        }else{
                                            self.readBLEMeasure(completion: { (error) in
                                                if error != nil {
                                                    if error?.localizedDescription == "Diff Device"{
                                                        debugPrint("Diff Device error")
                                                    }else{
                                                        //                                                    self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)

    //                                                    self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                                                        self.bleStatusView.isHidden = true
                                                    }
                                                    
                                                } else {
                                                    self.bleMeasureHasBeenSent = true
                                                }
                                            })
                                        }
                                    }
                                }
                                
                                // less than 75 / < 75 ex: -4400
                                else if lastDate.timeIntervalSinceNow  > -18000 {
                                    //                                    self.signalStrengthLabel.text = "Signal excellent".localized
                                    self.signalStrengthLabel.text = "Dernière mesure".localized
                                    
                                    
                                    self.signalStrengthImageView.image = UIImage(named: "Signalhigh")
                                    //                                    self.readBLEMeasure(completion: { (error) in
                                    //                                        if error != nil {
                                    //                                            self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                                    //                                            self.bleStatusView.isHidden = true
                                    //                                        } else {
                                    //                                            self.bleMeasureHasBeenSent = true
                                    //                                        }
                                    //                                    })
                                    
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
                                // less than 75 / < 75 ex: -85000
                                
                                else if lastDate.timeIntervalSinceNow > -54000 {
                                    //                                    self.signalStrengthLabel.text = "Signal moyen".localized
                                    self.signalStrengthLabel.text = "Dernière mesure".localized
                                    self.signalStrengthImageView.image = UIImage(named: "Signalmiddle")
                                    
                                }
                                else if  lastDate.timeIntervalSinceNow > -259200 {
                                    //                                    self.signalStrengthLabel.text = "Signal faible".localized
                                    self.signalStrengthLabel.text = "Mesure ancienne".localized
                                    self.signalStrengthImageView.image = UIImage(named: "Signallow")
                                    
                                }else{
                                    
                                    //                                    self.signalStrengthLabel.text = "Signal inexistant".localized
                                    self.signalStrengthLabel.text = "Mesure obsolète".localized
                                    self.signalStrengthLabel.textColor =  .red
                                    self.signalStrengthImageView.image = UIImage(named: "SignalNo")
                                }
                                
                                self.signalStrengthLabel.text = "Last measure".localized
                                
                            }
                        }
                        else {
                            self.signalStrengthLabel.textColor = .red
                            self.signalStrengthLabel.text = "Signal inexistant".localized
                            self.signalStrengthLabel.text = "Last measure".localized
                            self.signalStrengthImageView.image = UIImage(named: "SignalNo")
                            /*
                            if self.isPlaceOwner{
                                self.readBLEMeasure(completion: { (error) in
                                    if error != nil {
                                        self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                                        self.bleStatusView.isHidden = true
                                    } else {
                                        self.bleMeasureHasBeenSent = true
                                    }
                                })
                            }
                            */
                        }
                        
                        
                        if let tendency = current["Tendancy"] as? Double {
                            if tendency >= 1 {
                                self.waterTendencyImageView.image = UIImage(named: "watertmpUp")
                                self.waterTendencyImageView.isHidden = false
                            } else if  tendency <= -1 {
                                self.waterTendencyImageView.image = UIImage(named: "watertmpDown")
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
                            
                            self.waterTemperatureLabel.text = String(format: "%.0f", temp) + "°C"
                            self.hubTabAirValLabel.text = String(format: "%.0f", temp) + "°C"
                            Module.currentModule?.rawWaterTemperature = String(format: "%.2f", temp) + "°C"
                            if temp > 0 && temp < 41{
                                
                            }else{
                                self.waterTemperatureLabel.text = "NA"
                                self.hubTabAirValLabel.text = "NA"
                            }
                            if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                                if currentUnit == 2{
                                    let funit = (temp * 9/5) + 32
                                    if funit > 0 && funit < 41{
                                        self.waterTemperatureLabel.text = String(format: "%.0f", funit) + "°F"
                                        self.hubTabAirValLabel.text = String(format: "%.0f", funit) + "°F"
                                        Module.currentModule?.rawWaterTemperature = String(format: "%.2f", temp) + "°F"
                                    }else{
                                        self.waterTemperatureLabel.text = "NA"
                                        self.hubTabAirValLabel.text = "NA"
                                    }
                                }else{
                                }
                            }
                            
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
                                self.hubTabPhValLabel.text = String(format: "%.1f", value)
                                
                                if value < 0 {
                                    self.pHLabel.text = "0"
                                    self.hubTabPhValLabel.text = "0"
                                }
                                
                                if (value > 3.9 && value < 10.1){
                                    
                                }else{
                                    self.pHLabel.text = "NA"
                                    self.hubTabPhValLabel.text = "NA"
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
                                        self.isPhOutOfRangeAlert = true
                                        self.pHSateView.backgroundColor = K.Color.white
                                        self.pHStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                        self.pHStateLabel.textColor = .black
                                        
                                    } else if sector == "MediumHigh" || sector == "MediumLow" {
                                        self.isPhOutOfRangeAlert = false
                                        self.pHSateView.backgroundColor = K.Color.clear
                                        self.pHStateLabel.textColor = .white
                                        self.pHStatusImageView.image = UIImage(named:"thumbs-up")
                                        
                                    } else if sector == "Medium" {
                                        self.isPhOutOfRangeAlert = false
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
                        // Chlorine
                        
                        if let orp = current["Desinfectant"] as? [String:Any] {
                            
                            if let label = orp["Label"] as? String, let deviation = orp["Deviation"] as? Double {
                                self.orpLabel.text = label
                                self.hubTabClorineLabel.text = label
                                
                                if let message = orp["Message"] as? String {
                                    self.orpStateLabel.text = message
                                    self.hubTabClorineValLabel.text = message
                                    self.orpStateView.isHidden = false
                                } else {
                                    self.orpStateLabel.text = ""
                                    self.hubTabClorineValLabel.text = ""
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
                                        self.isRedoxOutOfRangeAlert = true
                                        self.orpStateView.backgroundColor = K.Color.white
                                        self.bleStatusImageView.image = #imageLiteral(resourceName: "Material Icon Font")
                                        self.orpStateLabel.textColor = .black
                                    } else if sector == "MediumHigh" || sector == "MediumLow" {
                                        self.isRedoxOutOfRangeAlert = false
                                        
                                        self.orpStateView.backgroundColor = K.Color.clear
                                        self.orpStateLabel.textColor    = .white
                                        self.bleStatusImageView.image = UIImage(named:"thumbs-up")
                                        
                                        
                                    } else if sector == "Medium" {
                                        self.isRedoxOutOfRangeAlert = false
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
                                if isValid{
                                    //self.subscriptionButton.isHidden = true
                                }else{
                                    // self.handleSubscriptionButton()
                                }
//                                Module.currentModule?.isSubscriptionValid = isValid
//                                Module.saveCurrentModuleLocally()
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
                                    self.signalStrengthImageView.isHidden = false
                                   // self.signalStrengthImageView.image = UIImage(named: "Bluetooth icon")
                                    self.signalStrengthLabel.isHidden = false
//                                    self.showSubscriptionButton()
                                } else {
                                    self.signalStrengthLabel.isHidden = false
                                    self.signalStrengthImageView.isHidden = false
                                    //                                    self.subscriptionView.alpha = 0
                                    //                                    self.subscriptionButton.isHidden = true
                                }
                                
                                var cType = 0
                                if let fliprData = JSON["fliprSection"] as? [String:Any] {
                                    if let deviceName = fliprData["CommercialType_Id"] as? Int {
                                        cType = deviceName
                                    }
                                }
                                
                                if cType == 1 && module.isSubscriptionValid == false {
                                    if self.isPlaceOwner{
                                        if identifier.hasPrefix("F"){
                                            Module.currentModule?.isSubscriptionValid = true
                                            Module.saveCurrentModuleLocally()
                                            self.subscriptionButton.isHidden = true
                                        }else{
                                            self.showSubscriptionButton()
                                        }
                                    }else{
                                        Module.currentModule?.isSubscriptionValid = true
                                        Module.saveCurrentModuleLocally()
                                        self.subscriptionButton.isHidden = true
                                    }
                                }else{
                                    Module.currentModule?.isSubscriptionValid = true
                                    Module.saveCurrentModuleLocally()
                                    self.subscriptionButton.isHidden = true
                                }
                            }
                        }, completion: { (success) in
                            
                        })
                        
                        if let sourceId = current["SourceId"] as? Int {
                            self.handleConnectionStatus(mode: sourceId)
                        }
                        
                        let value = UserDefaults.standard.bool(forKey: notificationOnOffValuesKey)
                        if value{
                            if self.isPlaceOwner{
                                self.updateAlerts()
                                self.getProrityAlert()
                            }
                        }else{
                            if self.isPlaceOwner{
                                self.manageNotificationDisabledButtton()
                            }
                        }
                    }
                  
                    
                    else {
                        
                        if self.isLoadedDashboard{
                            self.showSuccess(title: "", message: "first analysis is in progress!")
//                            print("response.result.value: \(response.result.value)")
//                            self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: "Waiting for the first measure...".localized, bottomAlignment: 0)
//                            self.startReading()
                        }
                        
                        /*
                        self.readBLEMeasure(completion: { (error) in
                            if error != nil {
                                self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                                self.bleStatusView.isHidden = true
                            } else {
                                self.bleMeasureHasBeenSent = true
                            }
                        })
                        
                        */
                        
                    }
                    
                    if self.isPlaceOwner{
                        self.settingsButton.isHidden = false
                    }else{
                        self.settingsButton.isHidden = true
                    }
                    
                } else {
                    /*
                    print("response.result.value: \(response.result.value)")
                    self.view.showEmptyStateView(image: nil, title: "\n\n\n\n\n\n" + "The first analysis is in progress!".localized, message: "Waiting for the first measure...".localized, bottomAlignment: 0)
                    */
                    /*
                    self.readBLEMeasure(completion: { (error) in
                        if error != nil {
                            self.showError(title: "Bluetooth connection error".localized, message: error?.localizedDescription)
                            self.bleStatusView.isHidden = true
                        } else {
                            self.bleMeasureHasBeenSent = true
                        }
                    })
                    */
                }
            })
         
            
        } else {
            print("The Flipr module identifier does not exist :/")
            self.settingsButtonContainer.isHidden = true
            self.waterLabel.isHidden = true
            self.waterTendencyImageView.isHidden = true

        }
    }
    
    
    
    func hideFliprData() {
        waterTemperatureLabel.text = "  "
        self.hubTabAirValLabel.text = "  "
        pHValueCircle.removeFromSuperlayer()
        pHView.alpha = 0
        orpView.alpha = 0
        self.subscriptionView.alpha = 0
        self.hideBottomAlertButton()
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
    
    func hideBottomAlertButton(){
        self.subscriptionButton.isHidden = true
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
                        viewController.placeId = self.placeDetails.placeId ?? 0
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
        else if let alert = alert {
            if let navController = self.storyboard?.instantiateViewController(withIdentifier: "AlertNavigationControllerID") as? UINavigationController {
                if let viewController = navController.viewControllers[0] as? AlertTableViewController {
                    viewController.alert = alert
                    viewController.placeId = self.placeDetails.placeId ?? 0
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
        let tmpSb = UIStoryboard.init(name: "ExpertView", bundle: nil)
        if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertViewViewController") as? ExpertViewViewController {
            viewController.placeId = placeDetails.placeId?.string ?? ""
            let nav = UINavigationController.init(rootViewController: viewController)
            self.present(nav, animated: true)
        }
       /*
        let tmpSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
            if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
                navigationController.modalPresentationStyle = .fullScreen
                viewController.isDirectPresenting = true
                navigationController.setViewControllers([viewController], animated: false)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
        
        */
        //        let sb = UIStoryboard.init(name: "Notifications", bundle: nil)
        //        if let viewController = sb.instantiateViewController(withIdentifier: "NotificationsAlertViewController") as? NotificationsAlertViewController {
        //            viewController.alertType = .Threshold
        //            viewController.delegate = self
        //            viewController.modalPresentationStyle = .overCurrentContext
        //            self.present(viewController, animated: true, completion: nil)
        //        }
    }
    
    
    
    @IBAction func subscriptionButtonAction(_ sender: UIButton) {
        let tag =  sender.tag
        if tag == 1{
            
        }
        else if tag == 2{
            if let alert = alert {
                if let navController = self.storyboard?.instantiateViewController(withIdentifier: "AlertNavigationControllerID") as? UINavigationController {
                    if let viewController = navController.viewControllers[0] as? AlertTableViewController {
                        viewController.alert = alert
                        viewController.placeId = self.placeDetails.placeId ?? 0
                        navController.modalPresentationStyle = .fullScreen
                        self.present(navController, animated: true, completion: nil)
                    }
                }
                
            }
        }
        else if tag == 3{
            
            if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        else if tag == 5{
            self.showVigilanceView()
        }
        else{
            
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
        /*
         let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
         if let viewController = sb.instantiateViewController(withIdentifier: "QuickActionViewController") as? QuickActionViewController {
         viewController.modalPresentationStyle = .overCurrentContext
         self.present(viewController, animated: true) {
         viewController.showBackgroundView()
         }
         }
         */
        if  ((self.placesModules != nil) && (self.placeDetails != nil)){
            
            let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
            if let viewController = sb.instantiateViewController(withIdentifier: "WatrQuickActionViewController") as? WatrQuickActionViewController {
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.placesModules = self.placesModules
                viewController.placeDetails = self.placeDetails
                self.present(viewController, animated: true) {
                    viewController.showBackgroundView()
                }
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
            if let hub = HUB.currentHUB{
                if hub.behavior == "auto"{
                    self.handleSmartControll(hub: hub)
                }else{
                    self.getSelectedHubDetails(selectedHub:  hub)
                }
            }
            
            //            let storyboard = UIStoryboard(name: "HUB", bundle: nil)
            //            let viewController = storyboard.instantiateViewController(withIdentifier: "HUBNavigationControllerID")
            //            viewController.modalPresentationStyle = .fullScreen
            //            self.present(viewController, animated: true, completion: nil)
            
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
//            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNavigation") as! UINavigationController
//            navigationController.modalPresentationStyle = .fullScreen
//            self.present(navigationController, animated: true, completion: nil)
            let vc = UIStoryboard(name:"WatrFlipr", bundle: nil).instantiateViewController(withIdentifier: "WatrFliprSettingsViewController") as! WatrFliprSettingsViewController
            vc.placeDetails = self.placeDetails
            vc.placesModules = self.placesModules
            let nav = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
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
        
        if let phMax = JSON["PhMax"] as? [String:Any?] {
            if let isDefaultValue = phMax["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultPhvalueMaxValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                    
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultPhvalueMaxValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                }
            }
        }
        
        if let phMax = JSON["PhMin"] as? [String:Any?] {
            if let isDefaultValue = phMax["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultPhvalueMinValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                    
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultPhvalueMinValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                }
            }
        }
        
        if let redox = JSON["Redox"] as? [String:Any?] {
            if let isDefaultValue = redox["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultThresholdValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationThresholdDefalutValueChangedChanged, object: nil)
                } else {
                    
                    UserDefaults.standard.set(true, forKey: userDefaultThresholdValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationThresholdDefalutValueChangedChanged, object: nil)
                }
            }
        }
        
        if let temp = JSON["Temperature"] as? [String:Any?] {
            
            if let isDefaultValue = temp["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultTemperatureMinValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultTemperatureMinValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                }
            }
            
        }
        
        if let temp = JSON["TemperatureMax"] as? [String:Any?] {
            
            if let isDefaultValue = temp["IsDefaultValue"] as? Bool {
                if !isDefaultValue {
                    UserDefaults.standard.set(false, forKey: userDefaultTemperatureMaxValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                } else {
                    UserDefaults.standard.set(true, forKey: userDefaultTemperatureMaxValuesKey)
                    //                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                }
            }
            
        }
        
        self.manageAllThreshhhold()
        
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
        if  Pool.currentPool ==  nil{
            updateHubWaveForNoHubs()
            self.hubs.removeAll()
            self.hubDeviceTableView.reloadData()
            self.keepUserOrderHubViews()
            return
        }
        Pool.currentPool?.getHUBS(completion: { (hubs, error) in
            //            self.view.hideStateView()
            if error != nil {
                self.hubs.removeAll()
                self.hubDeviceTableView.reloadData()
                self.keepUserOrderHubViews()
                self.updateHubWaveForNoHubs()

//                self.showError(title: "Error".localized, message: error!.localizedDescription)
            } else if hubs != nil {
                self.hubs.removeAll()
                if hubs!.count > 0 {
                    
                    
                    var secondHubKey = ""
                    var firstHubKey = ""
                    var isNotSavedHubPosition = false
                    if let firstHub = UserDefaults.standard.object(forKey: "FirstHubSerialKey") as? String{
                        firstHubKey = firstHub
                        isNotSavedHubPosition = true
                    }
                    
                    if let secondHub = UserDefaults.standard.object(forKey: "SecondHubSerialKey") as? String{
                        secondHubKey = secondHub
                    }
                    if isNotSavedHubPosition{
                        var tmpHubs:[HUB] = [HUB]()
                        var firstHub : HUB?
                        var secondHub : HUB?
                        
                        for hubObj in hubs!{
                            
                            if hubObj.serial == firstHubKey{
                                firstHub = hubObj
                            }
                            else if hubObj.serial == secondHubKey{
                                secondHub = hubObj
                            }
                            
                        }
                        if let first = firstHub{
                            tmpHubs.append(first)
                        }
                        if let second = secondHub{
                            tmpHubs.append(second)
                        }
                        for hubObj in hubs!{
                            if hubObj.serial != firstHubKey && hubObj.serial != secondHubKey{
                                tmpHubs.append(hubObj)
                            }
                        }
                        self.hubs = tmpHubs
                    }else{
                        self.hubs = hubs!
                    }
                    if let currentHub = HUB.currentHUB {
                        var noCurrentHub = true
                        for hub in hubs! {
                            if currentHub.serial == hub.serial {
                                noCurrentHub = false
                                self.hub = hub
                                HUB.currentHUB = hub
                                HUB.saveCurrentHUBLocally()
                                self.refreshHUBdisplay()
                                break
                            }
                        }
                        if noCurrentHub{
                            self.hub = self.hubs.first
                            HUB.currentHUB = self.hubs.first
                            HUB.saveCurrentHUBLocally()
                            self.refreshHUBdisplay()
                        }
                    } else {
                        self.hub = self.hubs.first
                        HUB.currentHUB = self.hubs.first
                        HUB.saveCurrentHUBLocally()
                        self.refreshHUBdisplay()
                    }
                }
                else {
                    self.hubs.removeAll()
                    self.hubDeviceTableView.reloadData()
                    self.keepUserOrderHubViews()
                    //                   self.showError(title: "Error".localized, message: "No hubs :/")
                }
            } else {
                self.hubs.removeAll()
                self.hubDeviceTableView.reloadData()
                self.keepUserOrderHubViews()
                //                self.showError(title: "Error".localized, message: "No hubs :/")
            }
        })
    }
    
    func refreshHUBdisplay() {
        
        showUserPreferedHistory()
        self.hubDeviceTableView.reloadData()
        self.hubDeviceTableViewHeightConstraint.constant = CGFloat(127 * self.hubs.count)
        
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
        self.keepUserOrderHubViews()
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
    
    @IBAction func showVigilanceButtonTapped(){
        self.showVigilanceView()
    }
    
    func showVigilanceView(){
        let fliprStoryboard = UIStoryboard(name: "SideMenuViews", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "VigilanceViewController") as! VigilanceViewController
        self.present(viewController, animated: true)
    }
    
    @IBAction func addHubDeviceButtonTapped(){
        self.addHubEquipments()
    }
    
    @IBAction func addFliprButtonTapped(){
        self.addFlipr()
    }
    
    func updateHubWaveForNoHubs(){
        clearHubsInFliprTab()
        if hubScrollViewContainerView.height < self.hubTabScrollView.height{
            let diff = self.hubTabScrollView.height - hubScrollViewContainerView.height
            self.hubTabWaveTopConstraint.constant =  self.hubTabWaveTopConstraint.constant + diff
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                let hubWaveframe = self.hubWaveContainerView.frame
                self.hubTabfluidView.frame = hubWaveframe
                self.hubTabFluidViewTopEdge.frame = hubWaveframe
            })
        }
    }
}

extension DashboardViewController: UITableViewDelegate,UITableViewDataSource, UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = self.hubs[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = self.hubs.remove(at: sourceIndexPath.row)
        self.hubs.insert(mover, at: destinationIndexPath.row)
        if self.hubs.count > 0{
            if let firstHubKey  = self.hubs[0].serial as? String{
                UserDefaults.standard.set(firstHubKey, forKey: "FirstHubSerialKey")
            }
        }
        if self.hubs.count > 1{
            if let secondHubKey  = self.hubs[1].serial as? String{
                UserDefaults.standard.set(secondHubKey, forKey: "SecondHubSerialKey")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession){
        if self.hubs.count > 0{
            if let firstHubKey  = self.hubs[0].serial as? String{
                UserDefaults.standard.set(firstHubKey, forKey: "FirstHubSerialKey")
            }
        }
        if self.hubs.count > 1{
            if let secondHubKey  = self.hubs[1].serial as? String{
                UserDefaults.standard.set(secondHubKey, forKey: "SecondHubSerialKey")
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hubs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"HubDeviceTableViewCell",
                                                 for: indexPath) as! HubDeviceTableViewCell
        if indexPath.row >  self.hubs.count{
            return cell
        }
        cell.isOwner = self.isPlaceOwner
        cell.delegate = self
        let hub = self.hubs[indexPath.row]
        cell.hub = hub
        if hub.equipementCode == 84{
            cell.iconImageView.image = #imageLiteral(resourceName: "lightEnabled")
        }
        else if hub.equipementCode == 86{
            cell.iconImageView.image = #imageLiteral(resourceName: "pumbactive")
        }
        else{
            cell.iconImageView.image = UIImage(named: "heatpump")
        }
        //        cell.modeNameLbl.text = hub.behavior.capitalizingFirstLetter()
        cell.deviceNameLbl.text = hub.equipementName.capitalizingFirstLetter()
        cell.settingsBtn.isHidden = !self.isPlaceOwner
        cell.manageIcons()
        //        cell.filtrationTimeLbl.isHidden = false
        //        cell.filtrationTimeLbl.text =  "asdsads asd"
        
        return cell
    }
    
}


extension DashboardViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexOfPage :Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        UserDefaults.standard.set(indexOfPage, forKey: "HistoryScrollIndex")
        self.stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(_scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }
    
    func stoppedScrolling() {
        
        
    }
}

extension DashboardViewController: HubDeviceDelegate{
    
    func didSelectSmartControllButton(hub: HUB) {
        self.handleSmartControll(hub: hub)
    }
    
    
    func didSelectSettingsButton(hub:HUB){
        let sb = UIStoryboard.init(name: "WatrFlipr", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "WatrHubSettingsViewController") as? WatrHubSettingsViewController {
            viewController.hub = hub
            //            viewController.delegate = self
            // viewController.modalPresentationStyle = .overCurrentContext
            let nav = UINavigationController.init(rootViewController: viewController)
            self.present(nav, animated: true) {
            }
        }
        
        // self.hubButtonAction(self)
    }
    
    
    func didSelectPowerButton(hub:HUB){
        HUB.currentHUB =  hub
        HUB.saveCurrentHUBLocally()
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        var state = true
        if hub.behavior == "manual" {
            state = !hub.equipementState
        }
        HUB.currentHUB?.updateState(value: state, completion: { (error) in
            if error != nil {
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 0)
            } else {
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 3)
            }
            //            self.refreshHUBdisplay()
            self.view.hideStateView()
            self.loadHUBs()
            
            
            /*
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             self.loadHUBs()
             }
             */
        })
    }
    
    //    func didSelectPlanningButton(hub:HUB){
    //        self.getSelectedHubDetails(selectedHub: hub)
    //
    //    }
    
    func didSelectProgramButton(hub:HUB){
        self.getSelectedHubDetails(selectedHub: hub)
    }
    
    
    func didSelectProgramEditButton(hub:HUB){
        self.getSelectedHubDetails(selectedHub: hub)
    }
    //    HUBProgramViewControllerID
    func getSelectedHubDetails(selectedHub:HUB) {
        HUB.currentHUB = selectedHub
        HUB.saveCurrentHUBLocally()
        HUB.currentHUB?.getPlannings(completion: { (error) in
            if error != nil {
                let sb = UIStoryboard.init(name: "HUB", bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                    vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                if HUB.currentHUB!.plannings.count == 0 {
                    let sb = UIStoryboard.init(name: "HUB", bundle: nil)
                    if let vc = sb.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                } else {
                    let sb = UIStoryboard.init(name: "HUB", bundle: nil)
                    if let viewController = sb.instantiateViewController(withIdentifier: "HubProgramViewController") as? HubProgramViewController {
                        viewController.hub = selectedHub
                        viewController.modalPresentationStyle = .overCurrentContext
                        self.present(viewController, animated: true) {
                            viewController.showBackgroundView()
                        }
                    }
                }
                
            }
        })
    }
    
    func showProgramListVC(){
        if let count = HUB.currentHUB?.plannings.count{
            if count == 0{
                let sb = UIStoryboard.init(name: "HUB", bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                    vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                let sb = UIStoryboard.init(name: "HUB", bundle: nil)
                if let viewController = sb.instantiateViewController(withIdentifier: "HubProgramViewController") as? HubProgramViewController {
                    viewController.hub = hub
                    viewController.modalPresentationStyle = .overCurrentContext
                    self.present(viewController, animated: true) {
                        viewController.showBackgroundView()
                    }
                }
            }
            
        } else {
            let sb = UIStoryboard.init(name: "HUB", bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}


extension DashboardViewController: HubSettingViewDelegate{
    
    func didSelectRenameButton(hub:HUB){
        let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "HubRenameViewController") as? HubRenameViewController {
            viewController.hub = hub
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    func didSelectWifiButton(hub:HUB){
        let sb = UIStoryboard(name: "HUB", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
            viewController.serial = hub.serial
            viewController.fromSetting = false
            let nav = UINavigationController.init(rootViewController: viewController)
            self.present(nav, animated: true, completion: nil)
            //            self.navigationController?.pushViewController(viewController, animated: true)
            //            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    
    func didSelectRemoveButton(hub:HUB){
        let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "HubRemoveViewController") as? HubRemoveViewController {
            viewController.hub = hub
            self.present(viewController, animated: true, completion: nil)
        }
        
    }
    
    func showFirmwereUdpateScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    func showFirmwereUpdatePrompt(){
        let value = UserDefaults.standard.bool(forKey: disAllowFirmwereUpdatePromptKey)
        if value{
            
        }else{
            AppSharedData.sharedInstance.isShowingFirmwereUpdateScreen = true
            let viewController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwereUpdateAlertViewController") as! FirmwereUpdateAlertViewController
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true) {
                viewController.showBackgroundView()
            }
        }
    }
    
    func callUpdatedFirmwereApi(){
        if let serialNo = Module.currentModule?.serial {
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            Alamofire.request(Router.updatedFirmwere(serial: serialNo, version: self.firmwereLatestVersion)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    hud?.dismiss(afterDelay: 0)
                case .failure(let error):
                    hud?.dismiss(afterDelay: 0)
                    print("Reactivated Notification did fail with error: \(error)")
                    
                }
            })
        }else{
            print("No serial number")
        }
    }
    
    
    func callStartFirmwereUpdateApi(){
        if let serialNo = Module.currentModule?.serial {
            //            let hud = JGProgressHUD(style:.dark)
            //            hud?.show(in: self.view)
            Alamofire.request(Router.startedUpdatedFirmwere(serial: serialNo)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    print("Started firmware upgrade api")
                    //                    hud?.dismiss(afterDelay: 0)
                case .failure(let error):
                    //                    hud?.dismiss(afterDelay: 0)
                    print("Started firmware upgrade  did fail with error: \(error)")
                    
                }
            })
        }else{
            print("No serial number")
        }
    }
    
    
    func handleUpdatedFirmwereError(){
        self.showFirmwereUdpateScreen()
    }
    
    
    //MUMP
    
    @IBAction func settingsButtonClicked(){
       

        if self.placesModules != nil && self.placeDetails != nil{
            let vc = UIStoryboard(name:"WatrFlipr", bundle: nil).instantiateViewController(withIdentifier: "WatrFliprSettingsViewController") as! WatrFliprSettingsViewController
            vc.placeDetails = self.placeDetails
            vc.placesModules = self.placesModules
            let nav = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
      
        
        /*
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        FliprActivateManager.shared.scanForFlipr(serial: Module.currentModule?.serial ?? "") { error in
            FliprActivateManager.shared.removeConnection()
            hud?.dismiss(afterDelay: 0)
            if error != nil{
                print("Activation failed")

//                self.showError(title: error.domain ?? "Flipr" , message: error.localizedDescription ?? "Error")
            }else{
                print("Activation success")
            }
        }
        */
       
    }
    
    @IBAction func placeDropDownButtonClicked(){
        self.showPlaceSelectionView()
    }
    
    func showPlaceSelectionView(){
        let sb = UIStoryboard.init(name: "Watr", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "PlaceDropdownViewController") as? PlaceDropdownViewController {
            viewController.delegate = self
            viewController.placeTitle = self.selectedPlaceDetailsLbl.text
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true) {
            }
        }
    }
    
}

extension DashboardViewController{
    func callPlacesApi(){
        isDefaultPlaceLoaded = false
        var places = [PlaceDropdown]()
        
        //        hud?.show(in: self.view)
        User.currentUser?.getPlaces(completion: { (placesResult,error) in
            if (error != nil) {
                self.isDefaultPlaceLoaded = true

                //                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                //                self.hud?.textLabel.text = error?.localizedDescription
                //                self.hud?.dismiss(afterDelay: 0)
            } else {
                if placesResult != nil{
                    places = placesResult!
                    if places.count > 0{
                        var haveSavedPlace = false
                        for (pos,place) in places.enumerated() {
                            let tmpPlace:Int = place.placeId ?? 0
                            if Module.currentModule?.placeId == tmpPlace {
                                self.selectedPlace = places[pos]
                                self.placeDetails =  self.selectedPlace
                                self.showPlaceInfo()
                                haveSavedPlace = true
                                break
                            }
                        }
                        if haveSavedPlace == false{
                            self.selectedPlace = places[0]
                            self.placeDetails =  self.selectedPlace
                            self.showPlaceInfo()
                        }
                        Pool.currentPool?.id = self.placeDetails.placeId
                    }
                    //                    self.hud?.dismiss(afterDelay: 0)
                    //                    self.placesTableView.reloadData()
                }
            }
//            self.refresh()
            
        })
        
    }
    
    func showPlaceInfo(){
        
        if let level = self.selectedPlace?.permissionLevel{
            if level == "Admin"{
                isPlaceOwner = true
            }else{
                isPlaceOwner = false
            }
        }else{
            isPlaceOwner = false
        }
//        var placeDetails =  (self.selectedPlace?.name ?? "")

        var placeDetails =  (self.selectedPlace?.privateName ?? "")
//        if self.selectedPlace?.privateName != nil{
//            placeDetails.append(self.selectedPlace?.privateName ?? "")
//        }else{
//            placeDetails.append(self.selectedPlace?.placeOwnerFirstName ?? "")
//            placeDetails.append(" ")
//            placeDetails.append(self.selectedPlace?.placeOwnerLastName ?? "")
//        }
        if isPlaceOwner {
            
            
        }else{
            placeDetails.append(" - ")
            placeDetails.append(self.selectedPlace?.placeOwnerFirstName ?? "")
            placeDetails.append(" ")
            placeDetails.append(self.selectedPlace?.placeOwnerLastName ?? "")
        }

//        placeDetails.append(self.selectedPlace?.name ?? "")

        placeDetails.append(" - ")
        placeDetails.append(self.selectedPlace?.placeCity ?? "")
        self.selectedPlaceDetailsLbl.text = placeDetails
        self.placeDropdownArrowImage.isHidden = false
        
        if let placeId = self.selectedPlace?.placeId{
            Module.currentModule?.placeId = placeId
            Module.saveCurrentModuleLocally() 
            let placeIdStr = "\(placeId)"
            getPlaceModules(placeId: placeIdStr)
        }
      
        AppSharedData.sharedInstance.isOwner = isPlaceOwner
        self.shareButton.isHidden = !isPlaceOwner
        self.settingsButton.isHidden = !isPlaceOwner
        self.waterTmpChangeButton.isHidden = !isPlaceOwner;
//        self.notificationDisabledButton.isHidden = !isPlaceOwner;
        self.phChangeButton.isHidden = !isPlaceOwner;
        self.redoxChangeButton.isHidden = !isPlaceOwner;
        self.manageGestView()
        self.createUserInfoString()
    }
    
    func getPlaceModules(placeId:String){
        //        hud?.show(in: self.view)
        User.currentUser?.getPlaceModules(placeId: placeId, completion: { (placesModuleResult,error) in
            self.isDefaultPlaceLoaded = true
            if (error != nil) {
                //                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                //                self.hud?.textLabel.text = error?.localizedDescription
                //                self.hud?.dismiss(afterDelay: 3)
            } else {
                if placesModuleResult != nil{
                    var pModules = placesModuleResult!
                    
                    var isFliprModule = false
                    var fliprModule:PlaceModule?
                    
                    if pModules.count > 0{
                        for module in pModules {
                            if module.isFlipr{
                                isFliprModule = true
                                fliprModule = module
                                self.placesModules = module
                                break
                            }
                        }
                        
                        if isFliprModule{
                            //            Module.currentModule = module
                            if Module.currentModule == nil{
                                Module.currentModule = Module.init(serial: fliprModule?.serial ?? "")
                            }
                            Module.currentModule?.serial = fliprModule?.serial ?? ""
                            Module.currentModule?.activationKey = fliprModule?.activationKey ?? ""
                            Module.saveCurrentModuleLocally()
                        }
                        else{
                            Module.currentModule?.serial = ""
                            Module.currentModule?.activationKey = ""
                            Module.saveCurrentModuleLocally()
                        }
                        self.refresh()
                    }else{
                    }
                }
            }
            
        })
    }
    
    
    
    
}

extension DashboardViewController:PlaceDropdownDelegate{
    
    
    func createUserInfoString(){
//        self.placeDetails
        
        var info:String = "UID: "
        if let userIDStr = self.placeDetails.placeOwner{
            info.append("\(userIDStr)")
        }

//        if isPlaceOwner{
//            if let userIDStr = self.placeDetails.placeOwner{
//                info.append("\(userIDStr)")
//            }
//        }else{
//            if let guestIDStr = self.placeDetails.guestId{
//                info.append("\(guestIDStr)")
//            }
//        }
        
        if let placeIDStr = self.placeDetails.placeId{
            info.append(" | PID: ")
            info.append("\(placeIDStr)")
        }
        
       
        AppSharedData.sharedInstance.userInfoTitle = info
        
    }
    
    
    func didSelectPlaceModules(placeModules: [PlaceModule], placeDetails: PlaceDropdown) {
        
        if placeDetails.permissionLevel == "Admin"{
            isPlaceOwner = true
            self.addEquipmentView.isHidden = false
        }else{
            isPlaceOwner = false
            self.addEquipmentView.isHidden = true
        }
        self.placeDetails = placeDetails
        self.selectedPlace = placeDetails
        self.showPlaceInfo()
        var isFliprModule = false
        var fliprModule:PlaceModule?
        for module in placeModules {
            if module.isFlipr{
                isFliprModule = true
                fliprModule = module
                self.placesModules = module
                break
            }
        }
        
        if isFliprModule{
            //            Module.currentModule = fliprModule
            //            let placeIsStr:String = "\(fliprModule?.placeid ?? 0)"
            //            Module.currentModule?.serial = placeIsStr
            if Module.currentModule == nil{
                Module.currentModule = Module.init(serial: fliprModule?.serial ?? "")
            }
            Module.currentModule?.serial = fliprModule?.serial ?? ""
            Module.currentModule?.placeId = placeDetails.placeId
            Module.currentModule?.activationKey = fliprModule?.activationKey ?? ""
            Module.saveCurrentModuleLocally()
            Pool.currentPool?.id = placeDetails.placeId
            Pool.saveCurrentPoolLocally()
            refreshDashboardForSelectedPlace()
            BLEManager.shared.disConnectCurrentDevice()
        }else{
            userHasNoFlipr()
            Module.currentModule?.serial = ""
            Module.currentModule?.placeId = placeDetails.placeId
            self.notificationDisabledButton.isHidden = true
            self.waterTmpChangeButton.isHidden = true
            self.phChangeButton.isHidden = true
            self.redoxChangeButton.isHidden = true
            Pool.currentPool?.id = placeDetails.placeId
            Pool.saveCurrentPoolLocally()
            loadHUBs()
        }
        createUserInfoString()
    }
    
    func updatePool(){
        User.currentUser?.getPool(completion: { (error) in
            if error != nil {
                print("Pool issue")
                Pool.currentPool = nil
                Pool.currentPool = nil
                HUB.currentHUB = nil
                self.showNoDevicePool()
                self.refreshDashboardForSelectedPlace()
            } else {
                self.refreshDashboardForSelectedPlace()
            }
        })
    }
    
    
    
    func showNoDevicePool(){
        clearHubsInFliprTab()
    }
    
    func refreshDashboardForSelectedPlace(){
        self.notificationDisabledButton.isHidden = true
        self.waterTmpChangeButton.isHidden = true
        self.phChangeButton.isHidden = true
        self.redoxChangeButton.isHidden = true
        //            self.settingsButton.isHidden = true
        self.bleMeasureHasBeenSent = false
        self.refresh()
        self.perform(#selector(self.callGetStatusApis), with: nil, afterDelay: 0)
    }
    
    
    
    
    
}


extension DashboardViewController{
    
    func handleSettingsButton(mode:Int){
        var imageName  = ""
        switch (mode){
            case 0: imageName = "SleepMode"
            case 1: imageName = "NormalMode"
            case 2: imageName = "ecoMode"
            case 3: imageName = "OtherMode"

        default: break
        }
        
        self.settingsButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    
    func handleConnectionStatus(mode:Int){
        var imageName  = ""
        switch (mode){
            case 0: imageName = "sifoxConnection"
            case 1: imageName = "bleConnection"
            case 2: imageName = "wifiConnection"
            case 3: imageName = "gateWayConnection"
            case 10: imageName = "MannualConnection"

        default: break
        }
        self.signalStrengthImageView.isHidden = false
        self.signalStrengthImageView.image = UIImage(named: imageName)
    }
    
    
    func showCalibrationAlert(){
        let alertController = UIAlertController(title: nil, message: "Calibration Alert".localized, preferredStyle: UIAlertController.Style.alert)
        
        
        let okAction = UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            
            self.callAddDelayApi()
           
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func callAddDelayApi(){
        if let module = Module.currentModule {
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            Alamofire.request(Router.addDelay(serial: module.serial ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    hud?.dismiss(afterDelay: 0)
                case .failure(let error):
                    hud?.dismiss(afterDelay: 0)
                    print("callAddDelayApi did fail with error: \(error)")
                    
                }
            })
        }
    }
   
}
