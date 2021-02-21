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

let FliprLocationDidChange = Notification.Name("FliprLocationDidChange")
let FliprDataPosted = Notification.Name("FliprDataDidPosted")

class DashboardViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundOverlayImageView: UIImageView!
    
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
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var uvView: UIView!
    
    @IBOutlet weak var pHView: UIView!
    @IBOutlet weak var pHLabel: UILabel!
    @IBOutlet weak var pHSateView: UIView!
    @IBOutlet weak var pHStateLabel: UILabel!
    
    @IBOutlet weak var orpView: UIView!
    @IBOutlet weak var orpLabel: UILabel!
    @IBOutlet weak var orpIndicatorImageView: UIImageView!
    @IBOutlet weak var orpStateView: UIView!
    @IBOutlet weak var orpStateLabel: UILabel!
    
    @IBOutlet weak var bleStatusView: UIView!
    @IBOutlet weak var bleStatusLabel: UILabel!
    var pHValueCircle = CAShapeLayer()
    
    @IBOutlet weak var lastMeasureDateLabel: UILabel!
    
    @IBOutlet weak var temperaturesTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var phViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var orpViewRightConstraint: NSLayoutConstraint!
    
    var alert:Alert?
    
    @IBOutlet weak var alertCheckLabel: UILabel!
    @IBOutlet weak var subscriptionLabel: UILabel!
    
    
    var bleMeasureHasBeenSent = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "UISideMenuNavigationControllerID") as? SideMenuNavigationController
        
        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        
        if SideMenuManager.default.leftMenuNavigationController == nil {
            print("FUCK")
        }
        
        self.view.clipsToBounds = true
//        self.quickActionButtonContainer.cornerRadius =  self.quickActionButtonContainer.frame.size.height / 2
        quickActionButtonContainer.layer.cornerRadius = self.quickActionButtonContainer.frame.size.height / 2
        quickActionButtonContainer.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.init(hexString: "#213A4E"), radius: self.quickActionButtonContainer.frame.size.height / 2, opacity: 0.21)

        if Locale.current.languageCode != "fr" {
            let attributedTitle = NSAttributedString(string: "Alert in progress: act now!".localized, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white]))
            alertButton.setAttributedTitle(attributedTitle, for: .normal)
        }
        
        shareButton.setTitle("share".localized, for: .normal)
        airLabel.text = "air".localized
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
            self.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.SessionExpired, object: nil, queue: nil) { (notification) in
            self.dismiss(animated: true, completion: nil)
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
        
        //        self.getNotificationStatus()
        //        self.getThresholdValues()
        
        
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
        
        AppReview.shared.requestReviewIfNeeded()
    }
    
    @objc func callGetStatusApis(){
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
    }
    
    func managePhValueChangeButtton(){
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
                                self.phChangeButton.isHidden = false
                              })
        }
    }
    
    func manageNotificationDisabledButtton(){
        let value = UserDefaults.standard.bool(forKey: notificationOnOffValuesKey)
        //        self.notificationDisabledButton.isHidden = value
        UIView.transition(with:  self.notificationDisabledButton, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.notificationDisabledButton.isHidden = value
                          })
    }
    
    func setupInitialView() {
        var fluidColor =  UIColor.init(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)
        
        if let module = Module.currentModule {
            if module.isForSpa {
                //backgroundImageView.image = UIImage(named:"Dashboard_BG_SPA")
                //backgroundOverlayImageView.image = UIImage(named:"Degrade_dashboard_SPA")
                //fluidColor =  UIColor.init(colorLiteralRed: 64/255.0, green: 125/255.0, blue: 136/255.0, alpha: 1)
            }
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
        
        
        
        let startElevation = 0.67
        temperaturesTopConstraint.constant = self.view.frame.height * (1 - CGFloat(startElevation)) + 20
        if #available(iOS 11.0, tvOS 11.0, *) {
            if (UIApplication.shared.delegate?.window??.safeAreaInsets.top)! > CGFloat(20) { // hasTopNotch
                temperaturesTopConstraint.constant = self.view.frame.height * (1 - CGFloat(startElevation))
            }
        }
        
        let frame = CGRect(x: -(self.view.frame.height - self.view.frame.width)/2 - 50, y: 0, width: sqrt(self.view.frame.height * self.view.frame.height + self.view.frame.width * self.view.frame.width) + 100, height: self.view.frame.height + 100)
        //        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.height + 100)
        //        let frame = self.view.frame
        var fluidView1 = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral:  startElevation))
        fluidView1.strokeColor = .clear
        fluidView1.fillColor = UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
        fluidView1.fill(to: NSNumber(floatLiteral: startElevation))
        fluidView1.startAnimation()
        //            fluidView1.clipsToBounds = true
        
        self.view.insertSubview(fluidView1, belowSubview: backgroundOverlayImageView)
        
        var fluidView = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral: startElevation))
        fluidView.strokeColor = .clear
        fluidView.fillColor = fluidColor
        fluidView.fill(to: NSNumber(floatLiteral: startElevation))
        fluidView.startAnimation()
        //            fluidView.clipsToBounds = true
        self.view.insertSubview(fluidView, aboveSubview: fluidView1)
        
        /*
         let particleEmitter = CAEmitterLayer()
         
         particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
         particleEmitter.emitterShape = kCAEmitterLayerLine
         particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
         
         let red = makeEmitterCell(color: UIColor.red)
         let green = makeEmitterCell(color: UIColor.green)
         let blue = makeEmitterCell(color: UIColor.blue)
         
         particleEmitter.emitterCells = [red, green, blue]
         
         fluidView.layer.addSublayer(particleEmitter)
         */
        
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main) {
            [weak self] (data, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            //
            
            //if data.gravity.x > -0.025 && data.gravity.x < 0.025 || data.gravity.y > -0.05 { //&& data.gravity.y < 0.05 {
            if data.gravity.y > -0.05 {
                fluidView.transform = CGAffineTransform(rotationAngle: 0)
                fluidView1.transform = CGAffineTransform(rotationAngle: 0)
            } else {
                let rotation = atan2(data.gravity.x,data.gravity.y) - .pi
                fluidView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                fluidView1.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            }
            
        }
        
        let pHCircle = CAShapeLayer()
        
        let startAngle = CGFloat(150 * Double.pi / 180)
        let endAngle = CGFloat(30 * Double.pi / 180)
        
        pHCircle.path = UIBezierPath(arcCenter: CGPoint(x: pHView.bounds.width/2, y: 84), radius: 66, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        pHCircle.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        pHCircle.strokeColor = K.Color.DarkBlue.cgColor
        pHCircle.lineWidth = 8
        pHCircle.lineCap = CAShapeLayerLineCap.round
        pHView.layer.addSublayer(pHCircle)
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
                                        }
                                        if let forecastTemperature = item["temperature"] as? Double {
                                            print("Forecast Air T°: \(forecastTemperature)")
                                            if forecastTemperature > currentTemperature {
                                                self.airTendendcyImageView.image = UIImage(named: "arrow_air_up")
                                                self.airTendendcyImageView.isHidden = false
                                            } else {
                                                self.airTendendcyImageView.image = UIImage(named: "arrow_air_down")
                                                self.airTendendcyImageView.isHidden = false
                                            }
                                        } else {
                                            self.airTendendcyImageView.isHidden = true
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
    
    func hideWeatherForecast() {
        airTemperatureLabel.text = "  "
        currentlyWeatherIcon.text = "  "
        startWeatherIcon.text = "   "
        startWeatherIcon.isHidden = true
        weatherChevronImageView.isHidden = true
        comingWeatherIcon.text = "  "
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
                    self.alertCheckView.isHidden = false
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
                            
                            if let forecastTemperature = weather["NextHourTemperature"] as? Double {
                                if forecastTemperature > temperature {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_up")
                                    self.airTendendcyImageView.isHidden = false
                                } else {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_down")
                                    self.airTendendcyImageView.isHidden = false
                                }
                            } else {
                                self.airTendendcyImageView.isHidden = true
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
                                
                                let textAnimation = CATransition()
                                textAnimation.type = CATransitionType.push
                                textAnimation.subtype = CATransitionSubtype.fromRight
                                textAnimation.duration = 0.5
                                textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                self.comingWeatherIcon.layer.add(textAnimation, forKey: "changeComingWeatherIconTransition")
                                self.comingWeatherIcon.text = self.climaconsCharWithIcon(icon: nextIcon)
                                self.weatherChevronImageView.isHidden = false
                            } else {
                                self.startWeatherIcon.isHidden = false
                                self.weatherChevronImageView.isHidden = true
                                self.startWeatherIcon.layer.add(textAnimation, forKey: "changeCurrentlyWeatherIconTransition")
                                self.startWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                            }
                            
                        }
                        
                        
                        if let uvIndex = weather["UvIndex"] as? Double {
                            self.uvLabel.isHidden = false
                            self.uvView.isHidden = false
                            let index = String(format: "%.0f", uvIndex)
                            self.uvLabel.text = index
                            self.uvLabel.layer.borderWidth = 1
                            self.uvLabel.layer.cornerRadius = 10
                            if uvIndex <= 2 {
                                self.uvLabel.layer.borderColor = UIColor(red: 41/255.0, green: 255/255.0, blue: 3/255.0, alpha: 1).cgColor
                            } else if  uvIndex <= 5 {
                                self.uvLabel.layer.borderColor = UIColor(red: 235/255.0, green: 212/255.0, blue: 15/255.0, alpha: 1).cgColor
                            } else if  uvIndex <= 7 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 145/255.0, blue: 33/255.0, alpha: 1).cgColor
                            } else if  uvIndex <= 10 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 91/255.0, blue: 95/255.0, alpha: 1).cgColor
                            } else {
                                self.uvLabel.layer.borderColor = UIColor(red: 240/255.0, green: 3/255.0, blue: 0/255.0, alpha: 1).cgColor
                            }
                        } else {
                            self.uvLabel.text = "NA"
                            self.uvLabel.isHidden = true
                            self.uvView.isHidden = true
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
                            
                            if let forecastTemperature = weather["NextHourTemperature"] as? Double {
                                if forecastTemperature > temperature {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_up")
                                    self.airTendendcyImageView.isHidden = false
                                } else {
                                    self.airTendendcyImageView.image = UIImage(named: "arrow_air_down")
                                    self.airTendendcyImageView.isHidden = false
                                }
                            } else {
                                self.airTendendcyImageView.isHidden = true
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
                                
                                let textAnimation = CATransition()
                                textAnimation.type = CATransitionType.push
                                textAnimation.subtype = CATransitionSubtype.fromRight
                                textAnimation.duration = 0.5
                                textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                                self.comingWeatherIcon.layer.add(textAnimation, forKey: "changeComingWeatherIconTransition")
                                self.comingWeatherIcon.text = self.climaconsCharWithIcon(icon: nextIcon)
                                self.weatherChevronImageView.isHidden = false
                            } else {
                                self.startWeatherIcon.isHidden = false
                                self.weatherChevronImageView.isHidden = true
                                self.startWeatherIcon.layer.add(textAnimation, forKey: "changeCurrentlyWeatherIconTransition")
                                self.startWeatherIcon.text = self.climaconsCharWithIcon(icon: icon)
                            }
                            
                        }
                        
                        
                        if let uvIndex = weather["UvIndex"] as? Double {
                            self.uvLabel.isHidden = false
                            self.uvView.isHidden = false
                            let index = String(format: "%.0f", uvIndex)
                            self.uvLabel.text = index
                            self.uvLabel.layer.borderWidth = 1
                            self.uvLabel.layer.cornerRadius = 10
                            if uvIndex <= 2 {
                                self.uvLabel.layer.borderColor = UIColor(red: 41/255.0, green: 255/255.0, blue: 3/255.0, alpha: 1).cgColor
                            } else if  uvIndex <= 5 {
                                self.uvLabel.layer.borderColor = UIColor(red: 235/255.0, green: 212/255.0, blue: 15/255.0, alpha: 1).cgColor
                            } else if  uvIndex <= 7 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 145/255.0, blue: 33/255.0, alpha: 1).cgColor
                            } else if  uvIndex <= 10 {
                                self.uvLabel.layer.borderColor = UIColor(red: 255/255.0, green: 91/255.0, blue: 95/255.0, alpha: 1).cgColor
                            } else {
                                self.uvLabel.layer.borderColor = UIColor(red: 240/255.0, green: 3/255.0, blue: 0/255.0, alpha: 1).cgColor
                            }
                        } else {
                            self.uvLabel.text = "NA"
                            self.uvLabel.isHidden = true
                            self.uvView.isHidden = true
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
                        
                        if let tendency = current["Tendancy"] as? Double {
                            if tendency >= 1 {
                                self.waterTendencyImageView.image = UIImage(named: "arrow_eau_up")
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
                                    self.pHSateView.backgroundColor = K.Color.Red
                                } else if deviation <= -1 {
                                    self.pHSateView.backgroundColor = K.Color.Red
                                } else {
                                    self.pHSateView.backgroundColor = K.Color.Green
                                }
                                
                                if let sector = pH["DeviationSector"] as? String {
                                    if sector == "TooHigh" || sector == "TooLow" {
                                        self.pHSateView.backgroundColor = K.Color.Red
                                    } else if sector == "MediumHigh" || sector == "MediumLow" {
                                        self.pHSateView.backgroundColor = K.Color.Green
                                    } else if sector == "Medium" {
                                        self.pHSateView.backgroundColor = K.Color.Green
                                    }
                                }
                                
                                let startAngle = CGFloat(150 * Double.pi / 180)
                                let endAngle = CGFloat(30 * Double.pi / 180)
                                
                                self.pHValueCircle = CAShapeLayer()
                                
                                self.pHValueCircle.path = UIBezierPath(arcCenter: CGPoint(x: self.pHView.bounds.width/2, y: 84), radius: 66, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
                                self.pHValueCircle.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                                self.pHValueCircle.strokeColor = UIColor(red: 39/255, green: 226/255, blue: 253/255, alpha: 1).cgColor
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
                                    self.orpStateView.backgroundColor = K.Color.Red
                                    gaugeAngle = -CGFloat(maxAngle)
                                } else if deviation <= -1 {
                                    self.orpStateView.backgroundColor = K.Color.Red
                                    gaugeAngle = CGFloat(maxAngle)
                                } else {
                                    gaugeAngle = -CGFloat(deviation*maxAngle)
                                    self.orpStateView.backgroundColor = K.Color.Green
                                }
                                
                                if let sector = orp["DeviationSector"] as? String {
                                    if sector == "TooHigh" || sector == "TooLow" {
                                        self.orpStateView.backgroundColor = K.Color.Red
                                    } else if sector == "MediumHigh" || sector == "MediumLow" {
                                        self.orpStateView.backgroundColor = K.Color.Green
                                    } else if sector == "Medium" {
                                        self.orpStateView.backgroundColor = K.Color.Green
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
                                    self.subscriptionView.alpha = 1
                                } else {
                                    self.subscriptionView.alpha = 0
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
        let sb = UIStoryboard.init(name: "Notifications", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NotificationsAlertViewController") as? NotificationsAlertViewController {
            viewController.alertType = .Threshold
            viewController.delegate = self
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        }
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
            self.present(viewController, animated: true, completion: nil)
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
        
        if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
                navigationController.modalPresentationStyle = .fullScreen
                viewController.isDirectPresenting = true
                navigationController.setViewControllers([viewController], animated: false)
                self.present(navigationController, animated: true, completion: nil)
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
