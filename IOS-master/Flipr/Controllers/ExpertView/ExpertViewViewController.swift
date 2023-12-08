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
    case stripTestOneYear
    case trend
    case rawData
    case threshold
    case taylor
    
}

class ExpertViewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var cellOrder = [ExpertViewCellOrder]()
    
    var placeId = ""
    var expertViewInfo:ExpertViewData?
    var defaulthreshold:DefaultThreshold?
    
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
//        getDefaultThreshold()
    }
    
    func createOrder(){
        cellOrder.removeAll()
        cellOrder.append(.infoCell)
        cellOrder.append(.calibration)
        if let dateString = self.expertViewInfo?.lastMeasure.dateTime{
            if let lastDate = dateString.fliprDate {
                if lastDate.timeIntervalSinceNow < -31536000 {
                    cellOrder.append(.stripTestOneYear)
                }else{
                    cellOrder.append(.stripTest)
                }
            }else{
                cellOrder.append(.stripTest)
            }
        }else{
            cellOrder.append(.stripTest)
        }
        cellOrder.append(.taylor)
        cellOrder.append(.trend)
        if let list = self.expertViewInfo?.rawList{
            if list.count > 0 {
                cellOrder.append(.rawData)
            }
        }
        
       
        
    
        cellOrder.append(.threshold)
    }
    
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
       return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
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
    
    
    @IBAction func oneYearStripTestBtnClicked(){
        showStripTest()
    }
    
    @IBAction func newStripTestBtnClicked(){
        showStripTest()
    }
    
    
    func showStripTest(){
        let sb:UIStoryboard = UIStoryboard.init(name: "Calibration", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "StripTestIntroViewController") as? StripTestIntroViewController {
            viewController.recalibration = false
            viewController.isPresentView = true
            viewController.isFromExpertView = true
            self.navigationController?.pushViewController(viewController)
        }
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
//        let sb = UIStoryboard(name: "Calibration", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "CalibrationPh7IntroViewController") as! CalibrationPh7IntroViewController
//        vc.isPresentedFlow = true
//        vc.recalibration = true
//        vc.noStripTest = true
//        let navigationController = UINavigationController.init(rootViewController: vc)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
        
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationIntroViewController") as! CalibrationIntroViewController
        vc.isPresentingView = true
        vc.noStripTest = true
        vc.recalibration = true

        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)

    }
}


extension ExpertViewViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        cellOrder.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellOrder[section] == .rawData{
            let count = self.expertViewInfo?.rawList.count ?? 0
            return (count + 1)
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch (cellOrder[indexPath.section]) {
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
            
            case .stripTestOneYear:
                let cell =  tableView.dequeueReusableCell(withIdentifier:"OneYearExpertviewStripTestInfoTableViewCell",
                                              for: indexPath) as! ExpertviewStripTestInfoTableViewCell
                cell.sliderInfo = self.expertViewInfo?.sliderStrip
                cell.stripValues = self.expertViewInfo?.lastStripValues
                cell.oneYearStripTestLbl.text = "4416:64259".localized
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
//            if self.defaulthreshold != nil{
//                cell.defaultThresholdValues = self.defaulthreshold
//                cell.loadData()
//            }
            cell.loadData()

            return cell
            
        case .rawData:
            if indexPath.row == 0{
                let cell =  tableView.dequeueReusableCell(withIdentifier:"RawDataTitleTableViewCell",
                                                  for: indexPath) as! RawDataTitleTableViewCell
                return cell

            }else{
                let cell =  tableView.dequeueReusableCell(withIdentifier:"RawDataTableViewCell",
                                                  for: indexPath) as! RawDataTableViewCell
                cell.data = self.expertViewInfo?.rawList[indexPath.row - 1]
                cell.loadData()
                return cell

            }
            
        case .taylor:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewTaylorBalanceTableViewCell",
                                              for: indexPath) as! ExpertviewTaylorBalanceTableViewCell
            cell.data = self.expertViewInfo?.taylorBalance
            cell.loadData()
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewInfoTableViewCell",
                                                      for: indexPath) as! ExpertviewInfoTableViewCell
            return cell

        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if cellOrder[indexPath.section] == .rawData{
            if indexPath.row == 0{
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
   
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        if cellOrder[indexPath.section] == .rawData{
            if indexPath.row == 0{
                return nil
            }else{
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                    // delete the item here
                    self.callDeleteAction(indexPath: indexPath)
                    completionHandler(true)
                }
                deleteAction.image = UIImage(named: "cellDelete")
                deleteAction.backgroundColor = .systemRed
                
                let ph4Action = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                    // delete the item here
                    self.callPh4Action(indexPath: indexPath)
                    completionHandler(true)
                }
//                ph4Action.image = UIImage(named: "")
                ph4Action.title = "pH4"
                ph4Action.backgroundColor = UIColor(hexString: "73BED8")
                
                let ph7Action = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                    // delete the item here
                    self.callPh7Action(indexPath: indexPath)
                    completionHandler(true)
                }
//                ph7Action.image = UIImage(named: "")
                ph7Action.title = "pH7"
                ph7Action.backgroundColor = UIColor(hexString: "EC7EE1")
//
                let configuration = UISwipeActionsConfiguration(actions: [ph7Action,ph4Action,deleteAction])
                return configuration
            }
        }else{
            return nil
        }
    }

    
    func callDeleteAction(indexPath: IndexPath){
        
        let alert = UIAlertController(title: "Delete this measurement".localized, message:"Be careful, modifying a measurement leads to significant changes in the behavior of your pool".localized, preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm".localized, style: .destructive, handler: { (action) in
            if let data = self.expertViewInfo?.rawList[indexPath.row - 1]{
                self.callRawModifyApi(serial:data.deviceId ?? "0", measureId: data.mesureId ?? 0, action: 0)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func callPh4Action(indexPath: IndexPath){
        let alert = UIAlertController(title: "Transform as pH4 Calibration".localized, message:"Be careful, modifying a measurement leads to significant changes in the behavior of your pool".localized, preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm".localized, style: .destructive, handler: { (action) in
            if let data = self.expertViewInfo?.rawList[indexPath.row - 1]{
                self.callRawModifyApi(serial:data.deviceId ?? "0", measureId: data.mesureId ?? 0, action: 1)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callPh7Action(indexPath: IndexPath){
        let alert = UIAlertController(title: "Transform as pH7 Calibration".localized, message:"Be careful, modifying a measurement leads to significant changes in the behavior of your pool".localized, preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm".localized, style: .destructive, handler: { (action) in
            if let data = self.expertViewInfo?.rawList[indexPath.row - 1]{
                self.callRawModifyApi(serial:data.deviceId ?? "0", measureId: data.mesureId ?? 0, action: 2)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func callRawModifyApi(serial: String, measureId:Int, action:Int){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        Alamofire.request(Router.updateRawData(serial: serial, measureId: measureId, action: action)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                hud?.dismiss(afterDelay: 0)
                self.callExpertViewApi()
            case .failure(let error):
                hud?.dismiss(afterDelay: 0)
//                self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
            }
        })
    }
//
    
}


extension ExpertViewViewController {
    
    
    @IBAction func setFactoryBtnClicked(){
        let alert = UIAlertController(title: nil, message:"4292:67566".localized, preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm".localized, style: .destructive, handler: { (action) in
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            let serial = self.expertViewInfo?.lastMeasure.deviceId ?? "0"
            Alamofire.request(Router.setDefaultCalibration(serial: serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    hud?.dismiss(afterDelay: 0)
                    self.callExpertViewApi()
                case .failure(let error):
                    hud?.dismiss(afterDelay: 0)
    //                self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func minPhBtnClicked(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.currentType = .Ph
        vc.titleStr = "pH Thresholds"
        vc.delegate = self
        
        vc.defaultValue1 = (self.expertViewInfo?.thresholds?.phMin.value ?? 0).string
        vc.defaultValue2 = (self.expertViewInfo?.thresholds?.phMax.value ?? 0).string

        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    @IBAction func maxPhBtnClicked(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.currentType = .Ph
        vc.defaultValue1 = (self.expertViewInfo?.thresholds?.phMin.value ?? 0).string
        vc.defaultValue2 = (self.expertViewInfo?.thresholds?.phMax.value ?? 0).string

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
        vc.defaultValue1 = (self.expertViewInfo?.thresholds?.temperature.value ?? 0).string
        vc.defaultValue2 = (self.expertViewInfo?.thresholds?.temperatureMax.value ?? 0).string
        if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
            if currentUnit == 2{
                let val = self.expertViewInfo?.thresholds?.temperature.value ?? 0
                let tmp = (val * 9/5) + 32

                let val1 = self.expertViewInfo?.thresholds?.temperatureMax.value ?? 0
                let tmp1 = (val1 * 9/5) + 32

                vc.defaultValue1 = tmp.string
                vc.defaultValue2 = tmp1.string
            }
        }
        
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
        vc.defaultValue1 = (self.expertViewInfo?.thresholds?.temperature.value ?? 0).string
        vc.defaultValue2 = (self.expertViewInfo?.thresholds?.temperatureMax.value ?? 0).string

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
        let tmpVal = (self.expertViewInfo?.thresholds?.redox.value ?? 0).string
        let tripValArray = tmpVal.components(separatedBy: ".")
        let val    = tripValArray[0]

        vc.defaultValue1 = val
        vc.firstItemArray = ["50", "100", "150", "200", "250", "300", "350", "400", "450", "500", "550", "600", "650", "700", "750", "800", "850", "900", "950", "1000", "1050", "1100", "1150", "1200", "1250", "1300", "1350", "1400", "1450", "1500"]
        vc.delegate = self
        vc.isSingleItem = true  
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
                    "Redox": ["IsDefaultValue":self.expertViewInfo?.thresholds.redox.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.redox.value ?? 0.0],
                    "Temperature": ["IsDefaultValue":self.expertViewInfo?.thresholds.temperature.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.temperature.value ?? 0.0],
                    "TemperatureMax": ["IsDefaultValue":self.expertViewInfo?.thresholds.temperatureMax.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.temperatureMax.value ?? 0.0]
                    ]
                
            } else if  type == .Temp {
                
                var min = 0.0
                min = value1.doubleValue
                var max = 0.0
                max = value2.doubleValue
                if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                    if currentUnit == 2{
                        let tmp = (min - 32) * 5 / 9
                        min = tmp
                        
                        let tmp1 = (max - 32) * 5 / 9
                        max = tmp1

                    }else{
                        
                    }
                }
                parameters = [
                    "Temperature": ["IsDefaultValue":false,
                        "Value":min],
                    "TemperatureMax": ["IsDefaultValue":false,
                        "Value":max],
                    "Redox": ["IsDefaultValue":self.expertViewInfo?.thresholds.redox.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.redox.value ?? 0.0],
                    "PhMin": ["IsDefaultValue":self.expertViewInfo?.thresholds.phMin.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.phMin.value ?? 0.0],
                    "PhMax": ["IsDefaultValue":self.expertViewInfo?.thresholds.phMax.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.phMax.value ?? 0.0]

                    ]
            }
            else{
                var redoxVal = 0.0
                redoxVal = value1.doubleValue
                parameters = [
                    "Redox": ["IsDefaultValue":false,
                        "Value":redoxVal],
                    "Temperature": ["IsDefaultValue":self.expertViewInfo?.thresholds.temperature.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.temperature.value ?? 0.0],
                    "TemperatureMax": ["IsDefaultValue":self.expertViewInfo?.thresholds.temperatureMax.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.temperatureMax.value ?? 0.0],
                    
                    "PhMin": ["IsDefaultValue":self.expertViewInfo?.thresholds.phMin.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.phMin.value ?? 0.0],
                    "PhMax": ["IsDefaultValue":self.expertViewInfo?.thresholds.phMax.isDefaultValue ?? false,
                              "Value":self.expertViewInfo?.thresholds.phMax.value ?? 0.0]

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
                    
                    if let data = value as? [String:Any] {
                      let newThresholdObj = Threshold.init(fromDictionary: data)
                        self.expertViewInfo?.thresholds = newThresholdObj
                        self.tableView.reloadData()
                    }
                    
                    
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 0)
//                    self.callExpertViewApi()
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

    
   

    func getDefaultThreshold() {
        
        if let module = Module.currentModule {
            
//            let hud = JGProgressHUD(style:.dark)
//            hud?.show(in: self.navigationController!.view)
//
            Alamofire.request(Router.getDefaultThresholds(serialId: module.serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
//                hud?.dismiss()
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("get default thresholds response.result.value: \(value)")
                    if let data = value as? [String:Any] {
                      let defaultThresholdObj = DefaultThreshold.init(fromDictionary: data)
                        self.defaulthreshold = defaultThresholdObj
                        self.tableView.reloadData()
                    }
                   
                    
                case .failure(let error):
                    
                    print("get default thresholds did fail with error: \(error)")
                    
//                    if let serverError = User.serverError(response: response) {
//                        self.showError(title: "Error".localized, message: serverError.localizedDescription)
//                    } else {
//                        self.showError(title: "Error".localized, message: error.localizedDescription)
//                    }
                }
                
                })
                
                
            }
        
    }

}
