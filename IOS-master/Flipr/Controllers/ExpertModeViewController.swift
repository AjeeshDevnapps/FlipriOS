//
//  ExpertModeViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 06/04/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD
import RangeSeekSlider

let notificationOnOffValuesKey = "notificationOnOff"

let userDefaultPhvalueMinValuesKey = "DefaultPhvalueMinValuesKey"
let userDefaultPhvalueMaxValuesKey = "efaultPhvalueMaxValuesKey"

let userDefaultTemperatureMinValuesKey = "DefaultTemperatureMinValuesKey"
let userDefaultTemperatureMaxValuesKey = "DefaultTemperatureMaxValuesKey"

let userDefaultThresholdValuesKey = "userDefaultThresholdValuesKey"
let disAllowFirmwereUpdateKey = "disAllowFirmwereUpdate"

let disAllowFirmwereUpdatePromptKey = "disAllowFirmwereUpdatePrompt"

//let userDefaultThresholdeMinValuesKey = "DefaultThresholdeMinValuesKey"
//let userDefaultThresholdeMaxValuesKey = "DefaultThresholdeMaxValuesKey"


class ExpertModeViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var rawDataLabel: UILabel!
    @IBOutlet weak var lastMeasurLabel: UILabel!
    
    @IBOutlet weak var pHValueLabel: UILabel!
    @IBOutlet weak var redoxValueLabel: UILabel!
    @IBOutlet weak var conductivityValueLabel: UILabel!
    @IBOutlet weak var waterTemperatureValueLabel: UILabel!
    
    @IBOutlet weak var pHLabel: UILabel!
    @IBOutlet weak var redoxLabel: UILabel!
    @IBOutlet weak var conductivityLabel: UILabel!
    @IBOutlet weak var waterTemperatureLabel: UILabel!
    
    @IBOutlet weak var tresholdLabel: UILabel!
    @IBOutlet weak var tresholdDescriptionLabel: UILabel!
    
    @IBOutlet weak var highPHTresholdTextField: UITextField!
    @IBOutlet weak var lowPHTresholdTextField: UITextField!
    @IBOutlet weak var lowDisinfectantTresholdTextField: UITextField!
    @IBOutlet weak var lowTemperatureThresholdTextField: UITextField!
    @IBOutlet weak var alertActivationSwitch: UISwitch!
    
    @IBOutlet weak var pHTresholdLabel: UILabel!
    @IBOutlet weak var temperatureAlertThersholdLabel: UILabel!

    @IBOutlet weak var highPHTresholdLabel: UILabel!
    @IBOutlet weak var lowPHTresholdLabel: UILabel!
    @IBOutlet weak var lowDisinfectantThreshold: UILabel!
    @IBOutlet weak var lowTemperatureThersholdLabel: UILabel!
    @IBOutlet weak var alertActivationLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var phRangeSlider: RangeSeekSlider!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    
    var isDirectPresenting:Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Vue Expert".localized
        if self.isDirectPresenting{
            self.addCloseButton()
        }
        var bakcgroundFileName = "BG"
        
        if let module = Module.currentModule {
            if module.isForSpa {
                bakcgroundFileName = "BG_spa"
            }
        }
        
        let imvTableBackground = UIImageView.init(image: UIImage(named: bakcgroundFileName))
        imvTableBackground.frame = self.tableView.frame
        self.tableView.backgroundView = imvTableBackground
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        phRangeSlider.numberFormatter = formatter
        
        rawDataLabel.text = "Raw data".localized
        lastMeasurLabel.text = "Last measure".localized +  " : \(Module.currentModule?.rawlastMeasure ?? "NaN")"
        
        pHValueLabel.text = Module.currentModule?.rawPH
        redoxValueLabel.text = Module.currentModule?.rawRedox
        
        
        conductivityValueLabel.text = Module.currentModule?.airTemperature
        waterTemperatureValueLabel.text = Module.currentModule?.rawWaterTemperature
        
        pHTresholdLabel.text = "pH alert threshold".localized
        temperatureAlertThersholdLabel.text = "Temperature alert threshold (C°)".localized
        
        
        pHLabel.text = "pH".localized
        redoxLabel.text = "Redox".localized
        conductivityLabel.text = "Air".localized
        waterTemperatureLabel.text = "Water".localized
        
        tresholdLabel.text = "Custom alert thresholds".localized
        tresholdDescriptionLabel.text = "Here you can change the ways in which Flipr can send you alerts.\nWarning: this operation is reserved for experienced users".localized
            
        highPHTresholdLabel.text = "High pH alert threshold".localized
        lowPHTresholdLabel.text = "Low pH alert threshold".localized
        lowDisinfectantThreshold.text = "Low disinfectant alert threshold".localized
        lowTemperatureThersholdLabel.text  = "Low temperature alert threshold".localized
        
        alertActivationLabel.text = "Disable Flipr alerts and notifications".localized
        alertActivationSwitch.isHidden = true
        
        resetButton.setTitle("Reset thresholds".localized, for: .normal)
        
        highPHTresholdTextField.text = ""
        highPHTresholdTextField.placeholder = "None".localized
        lowPHTresholdTextField.text = ""
        lowPHTresholdTextField.placeholder = "None".localized
        lowDisinfectantTresholdTextField.text = ""
        lowDisinfectantTresholdTextField.placeholder = "None".localized
        lowTemperatureThresholdTextField.text = ""
        lowTemperatureThresholdTextField.placeholder = "None".localized
        refresh()
        
    }
    
    
    
    func addCloseButton(){
        let backBTN = UIBarButtonItem(image: UIImage(named: "close_icon white"),
                                      style: .plain,
                                      target: self,
                                      action:  #selector(self.closeView) )
        navigationItem.leftBarButtonItem = backBTN
    }
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleGuestView(){
        if !AppSharedData.sharedInstance.isOwner{
            self.lowDisinfectantTresholdTextField.isUserInteractionEnabled = false
            self.lowTemperatureThresholdTextField.isUserInteractionEnabled = false
            highPHTresholdTextField.isUserInteractionEnabled = false
            lowPHTresholdTextField.isUserInteractionEnabled = false
            phRangeSlider.isUserInteractionEnabled = false
            rangeSlider.isUserInteractionEnabled = false
            self.resetButton.isUserInteractionEnabled = false
        }
    }
    
    func refresh() {
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            Alamofire.request(Router.readModuleThresholds(serialId: module.serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                hud?.dismiss()
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("get thresholds response.result.value: \(value)")
  
                    if let JSON = value as? [String:Any] {
                        self.checkDefaultValueChanged(JSON:JSON)
                        if let phMax = JSON["PhMax"] as? [String:Any] {
                            if let value = phMax["Value"] as? Double, let isDefaultValue = phMax["IsDefaultValue"] as? Bool {
                                if !isDefaultValue {
                                    self.highPHTresholdTextField.text = String(value)
                                    self.phRangeSlider.selectedMaxValue = CGFloat(value)
                                } else {
                                    self.highPHTresholdTextField.placeholder = String(value)
                                    self.phRangeSlider.selectedMaxValue = CGFloat(value)
                                }
                                self.phRangeSlider.minValue = 0
                            }
                        }
                        
                        if let phMin = JSON["PhMin"] as? [String:Any] {
                            if let value = phMin["Value"] as? Double, let isDefaultValue = phMin["IsDefaultValue"] as? Bool {
                                if !isDefaultValue {
                                    self.lowPHTresholdTextField.text = String(value)
                                    self.phRangeSlider.selectedMinValue = CGFloat(value)
                                } else {
                                    self.lowPHTresholdTextField.placeholder = String(value)
                                    self.phRangeSlider.selectedMinValue = CGFloat(value)
                                }
                                self.phRangeSlider.minValue = 0
                            }
                        }
                        
                        if let redox = JSON["Redox"] as? [String:Any] {
                            if let value = redox["Value"] as? Double, let isDefaultValue = redox["IsDefaultValue"] as? Bool {
                                if !isDefaultValue {
                                    self.lowDisinfectantTresholdTextField.text = String(value)
                                } else {
                                    self.lowDisinfectantTresholdTextField.placeholder = String(format:"%.0f",value)
                                }
                            }
                        }
                        
                        if let temp = JSON["Temperature"] as? [String:Any] {
                            /*
                            if let value = temp["Value"] as? Double, let isDefaultValue = temp["IsDefaultValue"] as? Bool {
                                if !isDefaultValue {
                                    self.lowTemperatureThresholdTextField.text = String(value)
                                } else {
                                    self.lowTemperatureThresholdTextField.placeholder = String(format:"%.0f", value)
                                }
                            }*/
                            if let value = temp["Value"] as? Double {
                                self.rangeSlider.selectedMinValue = max(CGFloat(value), 0)
                            } else {
                                self.rangeSlider.selectedMinValue = 5
                            }
                            self.rangeSlider.minValue = 0
                        }
                        
                        if let temp = JSON["TemperatureMax"] as? [String:Any] {
                            
                            if let value = temp["Value"] as? Double {
                                self.rangeSlider.selectedMaxValue = min(CGFloat(value),50)
                            } else {
                                self.rangeSlider.selectedMaxValue = 39
                            }
                            self.rangeSlider.minValue = 0
                                
                        }
                        
                        self.tableView.reloadData()
                        
                        
                    } else {
                        self.showError(title: "Error".localized, message: "Data format returned by the server is not supported.".localized)
                    }
                    self.handleGuestView()
                    
                case .failure(let error):
                    
                    print("get thresholds did fail with error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        self.showError(title: "Error".localized, message: serverError.localizedDescription)
                    } else {
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                    self.handleGuestView()
                }
                
                })
                
                Alamofire.request(Router.readUserNotifications).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        print("get notifications response.result.value: \(value)")
                        
                        if let JSON = value as? [String:Any] {
                            
                            if let value = JSON["Value"] as? Bool {
                                self.alertActivationSwitch.setOn(!value, animated: false)
                                self.alertActivationSwitch.isHidden = false
                            }
                            
                            self.tableView.reloadData()
                            
                        } else {
                            self.showError(title: "Error".localized, message: "Data format returned by the server is not supported.".localized)
                        }
                        
                    case .failure(let error):
                        
                        print("get notifications did fail with error: \(error)")
                        
                        if let serverError = User.serverError(response: response) {
                            self.showError(title: "Error".localized, message: serverError.localizedDescription)
                        } else {
                            self.showError(title: "Error".localized, message: error.localizedDescription)
                        }
                    }
                    self.handleGuestView()
            })
                
            }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            return 0
        }
        if indexPath.section == 1 && indexPath.row == 2 {
            return 0
        }
        if indexPath.section == 1 && indexPath.row == 4 {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Expert mode".localized, message:"EXPERT_MODE_INFO".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func warningButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Raw data warning".localized, message:"EXPERT_MODE_WARNING".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func callReactivateAlertApi(alertStatus:Bool){
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        
        if let serialNo = Module.currentModule?.serial {
            Alamofire.request(Router.reactivateAlert(serial: serialNo, status: alertStatus)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
//                    UserDefaults.standard.set(false, forKey: notificationOnOffValuesKey)
                    UserDefaults.standard.set(alertStatus, forKey: notificationOnOffValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationSetttingsChanged, object: nil)
                    print("update notification with success: \(value)")
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)

                case .failure(let error):
                    
                    print("Reactivated Notification did fail with error: \(error)")
//                    print("update notification error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = serverError.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    } else {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = error.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    }
                }
                
            })
        }else{
            print("No serial number")
        }
       
    }

    
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: Any) {
        self.callReactivateAlertApi(alertStatus: self.alertActivationSwitch.isOn)
        
        /*
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        Alamofire.request(Router.updateUserNotifications(activate: self.alertActivationSwitch.isOn)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                UserDefaults.standard.set(self.alertActivationSwitch.isOn, forKey: notificationOnOffValuesKey)
                NotificationCenter.default.post(name: K.Notifications.NotificationSetttingsChanged, object: nil)
                print("update notification with success: \(value)")
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
                
            case .failure(let error):
                
                print("update notification error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = serverError.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                }
            }
            
        })
        
        */
        
    }
    
    
    @IBAction func resetThresholdsButtonAction(_ sender: Any) {
        
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            Alamofire.request(Router.resetModuleThresholds(serialId: module.serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("reset with success: \(value)")
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                    
                    self.highPHTresholdTextField.text = ""
                    self.lowPHTresholdTextField.text = ""
                    self.lowDisinfectantTresholdTextField.text = ""
                    self.lowTemperatureThresholdTextField.text = ""
                    UserDefaults.standard.set(true, forKey: userDefaultPhvalueMaxValuesKey)
                    UserDefaults.standard.set(true, forKey: userDefaultPhvalueMaxValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationPhDefalutValueChangedChanged, object: nil)
                    UserDefaults.standard.set(true, forKey: userDefaultTemperatureMinValuesKey)
                    UserDefaults.standard.set(true, forKey: userDefaultTemperatureMaxValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationTmpDefalutValueChangedChanged, object: nil)
                    UserDefaults.standard.set(true, forKey: userDefaultThresholdValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationThresholdDefalutValueChangedChanged, object: nil)

                    //self.rangeSlider.selectedMinValue = 5
                    //self.rangeSlider.selectedMaxValue = 39
                    self.refresh()
                    
                case .failure(let error):
                    
                    print("add product error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = serverError.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    } else {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = error.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    }
                }
                
            })
        }
        
    }
    
    
    // MARK: - TextfieldDelegate  Threshhold
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Yeah!")
        
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            var name = "Conductivity"
            if textField == highPHTresholdTextField {
                name = "PhMax"
            } else if textField == lowPHTresholdTextField {
                name = "PhMin"
            } else if textField == lowDisinfectantTresholdTextField {
                name = "Redox"
            } else if textField == lowTemperatureThresholdTextField {
                name = "Temperature"
            }
            
            if let value = Double(textField.text!.replacingOccurrences(of: ",", with: ".")) {
                print("Yeah!: \(value)")
                
                Alamofire.request(Router.updateModuleThreshold(serialId: module.serial, name:name, value: value)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
//                    if response.response?.statusCode == 401 {
//                        NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
//                    }
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        print("update with success: \(value)")
                        
                        if let JSON = value as? [String:Any] {
                            self.checkDefaultValueChanged(JSON:JSON)
                        }
                        
                        
                        
                        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud?.dismiss(afterDelay: 1)
                        
                    case .failure(let error):
                        
                        print("reset threshold error: \(error)")
                        
                        if let serverError = User.serverError(response: response) {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = serverError.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        } else {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = error.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        }
                    }
                    
                })
                
            } else {
                
                Alamofire.request(Router.resetModuleThreshold(serialId: module.serial, name:name)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
                    if response.response?.statusCode == 401 {
                        NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                    }
                    
                    switch response.result {
                        
                    case .success(let value):
                        
//                        if let JSON = value as? [String:Any] {
//                            self.checkDefaultValueChanged(JSON:JSON)
//                        }
                        
                        print("reset with success: \(value)")
                        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud?.dismiss(afterDelay: 1)
                    
                    case .failure(let error):
                        
                        print("reset threshold error: \(error)")
                        
                        if let serverError = User.serverError(response: response) {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = serverError.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        } else {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = error.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        }
                    }
                    
                })
                
            }
        }
        
    }
    
    //Ph
    
    @IBAction func phRangeSliderTouchUpInside(_ sender: Any) {
        
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            //hud?.show(in: self.navigationController!.view)
            
            Alamofire.request(Router.updateModuleThreshold(serialId: module.serial, name:"PhMin", value: Double(phRangeSlider.selectedMinValue))).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                if response.response?.statusCode == 401 {
                    NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                }
                
                switch response.result {
                    
                case .success(let value):
                    
                    if let JSON = value as? [String:Any] {
                        self.checkDefaultValueChanged(JSON:JSON)
                    }
                    
                    
                    Alamofire.request(Router.updateModuleThreshold(serialId: module.serial, name:"PhMax", value: Double(self.phRangeSlider.selectedMaxValue))).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                        
                        if response.response?.statusCode == 401 {
                            NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                        }
                        
                        switch response.result {
                            
                        case .success(let value):
                            
                            print("update with success: \(value)")
                            
                            if let JSON = value as? [String:Any] {
                                self.checkDefaultValueChanged(JSON:JSON)
                            }
                            
                            
                            //hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            //hud?.dismiss(afterDelay: 1)
                            
                        case .failure(let error):
                            
                            print("reset threshold error: \(error)")
                            
                            if let serverError = User.serverError(response: response) {
                                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                                hud?.textLabel.text = serverError.localizedDescription
                                hud?.dismiss(afterDelay: 3)
                            } else {
                                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                                hud?.textLabel.text = error.localizedDescription
                                hud?.dismiss(afterDelay: 3)
                            }
                        }
                        
                    })
                    
                case .failure(let error):
                    
                    print("reset threshold error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = serverError.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    } else {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = error.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    }
                }
                
            })
                
                
                
        }
    }
    
    // Temp
    
    @IBAction func rangeSliderTouchUpInside(_ sender: Any) {
        
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            //hud?.show(in: self.navigationController!.view)
            
            Alamofire.request(Router.updateModuleThreshold(serialId: module.serial, name:"Temperature", value: Double(rangeSlider.selectedMinValue))).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                if response.response?.statusCode == 401 {
                    NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                }
                
                switch response.result {
                    
                case .success(let value):
                    
                    if let JSON = value as? [String:Any] {
                        self.checkDefaultValueChanged(JSON:JSON)
                    }
                    
                    
                    Alamofire.request(Router.updateModuleThreshold(serialId: module.serial, name:"TemperatureMax", value: Double(self.rangeSlider.selectedMaxValue))).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                        
                        if response.response?.statusCode == 401 {
                            NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                        }
                        
                        switch response.result {
                            
                        case .success(let value):
                            
                            print("update with success: \(value)")
                            
                            if let JSON = value as? [String:Any] {
                                self.checkDefaultValueChanged(JSON:JSON)
                            }
                            
                            
                            //hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            //hud?.dismiss(afterDelay: 1)
                            
                        case .failure(let error):
                            
                            print("reset threshold error: \(error)")
                            
                            if let serverError = User.serverError(response: response) {
                                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                                hud?.textLabel.text = serverError.localizedDescription
                                hud?.dismiss(afterDelay: 3)
                            } else {
                                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                                hud?.textLabel.text = error.localizedDescription
                                hud?.dismiss(afterDelay: 3)
                            }
                        }
                        
                    })
                    
                case .failure(let error):
                    
                    print("reset threshold error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = serverError.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    } else {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = error.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    }
                }
                
            })
                
                
                
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
