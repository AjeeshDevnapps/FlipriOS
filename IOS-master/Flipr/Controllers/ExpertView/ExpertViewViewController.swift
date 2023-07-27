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
//        tableView.contentInset =  UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0)
//        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 54, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callExpertViewApi()
        createOrder()
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
                    self.tableView.reloadData()
                case .failure(let error):
                    hud?.dismiss(afterDelay: 0)
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
