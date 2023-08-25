//
//  ExpertViewViewController.swift
//  Flipr
//
//  Created by Ajish on 12/07/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

enum ExpertViewCellOrder: Int{
    case infoCell
    case calibration
    case stripTest
    case trend
    case threshold
}

class ExpertViewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var cellOrder = [ExpertViewCellOrder]()
    
    var placeId = ""
    var expertViewInfo:ExpertViewData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        self.title = "Vue Expert".localized
//        tableView.contentInset =  UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0)
//        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 54, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callExpertViewApi()
    }
    
    func createOrder(){
        cellOrder.removeAll()
        cellOrder.append(.infoCell)
        cellOrder.append(.calibration)
        cellOrder.append(.stripTest)
        cellOrder.append(.trend)
        cellOrder.append(.threshold)
    }
    
    func callExpertViewApi(){
        
        if let module = Module.currentModule {
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            Alamofire.request(Router.expertView(placeId: self.placeId)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String:Any] {
                        let info:ExpertViewData = ExpertViewData(fromDictionary: JSON)
                        self.expertViewInfo = info
                    }
                    hud?.dismiss(afterDelay: 0)
                    self.createOrder()
                    self.tableView.reloadData()
                case .failure(let error):
                    hud?.dismiss(afterDelay: 0)
                    self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)

                    print("callAddDelayApi did fail with error: \(error)")
                    
                }
            })
        }
    }
    
    @IBAction func newStripTestBtnClicked(){
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "StripViewControllerID") as! StripViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func defaultTresholdBtnClicked(){
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            
            Alamofire.request(Router.resetModuleThresholds(serialId: module.serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("reset with success: \(value)")
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                    
//                    self.highPHTresholdTextField.text = ""
//                    self.lowPHTresholdTextField.text = ""
//                    self.lowDisinfectantTresholdTextField.text = ""
//                    self.lowTemperatureThresholdTextField.text = ""
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
                    self.callExpertViewApi()
                    
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
    
    @IBAction func newCalibrationBtnClicked(){
        showCalibrationView()
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
}


extension ExpertViewViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellOrder.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch (cellOrder[indexPath.row]) {
            case .infoCell:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewInfoTableViewCell",
                                                      for: indexPath) as! ExpertviewInfoTableViewCell
            cell.lastMeasureInfo = self.expertViewInfo?.lastMeasure
            cell.loadData()
            return cell
            
            case .calibration:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewCalibrationInfoTableViewCell",
                                                  for: indexPath) as! ExpertviewCalibrationInfoTableViewCell
            cell.lastCalibrations = self.expertViewInfo?.lastCalibrations
            cell.loadData()
            return cell
            
            case .stripTest:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewStripTestInfoTableViewCell",
                                              for: indexPath) as! ExpertviewStripTestInfoTableViewCell
            
            cell.sliderInfo = self.expertViewInfo?.sliderStrip
            cell.stripValues = self.expertViewInfo?.lastStripValues
            cell.loadData()
            return cell

            case .trend:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewTrendInfoTableViewCell",
                                                  for: indexPath) as! ExpertviewTrendInfoTableViewCell
            cell.lsiInfo = self.expertViewInfo?.sliderStrip
            cell.lsiStateValues = self.expertViewInfo?.lastStripValues
            cell.lsiValues = self.expertViewInfo?.lSI

            cell.loadData()

            return cell
            
            case .threshold:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewthresholdInfoTableViewCell",
                                              for: indexPath) as! ExpertviewthresholdInfoTableViewCell
            cell.thresholdValues = self.expertViewInfo?.thresholds
            cell.loadData()
            return cell
            

        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewInfoTableViewCell",
                                                      for: indexPath) as! ExpertviewInfoTableViewCell
            return cell

        }
        
      
        
    }
    
}


extension ExpertViewViewController {
    
    @IBAction func minPhBtnClicked(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.currentType = .Ph
        vc.titleStr = "pH Thresholds"
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    @IBAction func maxPhBtnClicked(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.currentType = .Ph
        vc.titleStr = "pH Thresholds"
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    @IBAction func tempMinBtnClicked(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.currentType = .Temp
        vc.titleStr = "Temperature Thresholds"
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    @IBAction func tempMaxBtnClicked(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.currentType = .Temp
        vc.titleStr = "Temperature Thresholds"

        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    @IBAction func redoxBtnClicked(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.titleStr = "Redox Mini"
        vc.currentType = .Redox
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
}


extension ExpertViewViewController : ExpertViewPickerViewControllerDelegate {
    
    func didSelectPikcer(type:ExpertViewPickerType, value1:String, value2:String ){
        
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            var parameters: [String : Any]!
            var name = "Conductivity"
            if type == .Ph {
                var min = 0.0
                min = value1.doubleValue
                var max = 0.0
                max = value2.doubleValue

                parameters = [
                    "PhMin": ["IsDefaultValue":false,
                        "Value":min],
                    "PhMax": ["IsDefaultValue":false,
                        "Value":max],
                    ]
                
            } else if  type == .Temp {
                
                var min = 0
                min = Int(value1) ?? 0
                var max = 0
                max = Int(value2) ?? 0

                parameters = [
                    "Temperature": ["IsDefaultValue":false,
                        "Value":min],
                    "TemperatureMax": ["IsDefaultValue":false,
                        "Value":max],
                    ]
            }
            else{
                var redoxVal = 0
                redoxVal = Int(value1) ?? 0

                parameters = [
                    "Redox": ["IsDefaultValue":false,
                        "Value":redoxVal],
                    ]
            }
          
            Alamofire.request(Router.updateModuleThresholdNew(serialId: module.serial, values: parameters)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
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
                    hud?.dismiss(afterDelay: 0)
                    self.callExpertViewApi()
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
