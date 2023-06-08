//
//  WatrFliprSettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 18/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import AVFoundation
import JGProgressHUD
import Alamofire

class WatrFliprSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var placeDetails:PlaceDropdown!
    var placesModules:PlaceModule!
    var settings:AnalysrSettings?
    var isV3flipr = false
    var fliprMode = ""
    var isReadMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AnalysR".localized
        tableView.tableFooterView =  UIView()
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprModeValue, object: nil, queue: nil) { (notification) in
            //            self.scanningAlertContainerView.isHidden = true
            //            self.loaderView.hideStateView()
            FliprModeManager.shared.removeConnection()
            FliprModeManager.shared.centralManager.stopScan()

            if let mode = notification.userInfo?["Mode"] as? String {
                self.fliprMode = mode
                self.tableView.reloadData()
            }else{
                
            }
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprConnecitngForModeValue, object: nil, queue: nil) { (notification) in
            self.fliprMode = "Connecting"
            self.tableView.reloadData()

        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprReadingModeValue, object: nil, queue: nil) { (notification) in
            self.fliprMode = "Reading"
            self.tableView.reloadData()
        }
        
        self.getSettings()
        // Do any additional setup after loading the view.
    }
    
    func getSettings(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        Alamofire.request(Router.analysrSettings(serial: self.placesModules.serial ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let responseData):
                self.readMode()
                if let settingsDic = responseData as? [String:Any] {
                    self.settings = AnalysrSettings.init(fromDictionary: settingsDic)
                }
                self.tableView.reloadData()
                hud?.dismiss(afterDelay: 0)
            case .failure(let error):
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error.localizedDescription
                hud?.dismiss(afterDelay: 3)
            }
        })
    }
    
    
    func readMode(){
        var serial =  Module.currentModule?.serial ?? ""
        FliprModeManager.shared.scanForFlipr(serials: [serial], completion: { (info) in
            
            
        })
        
    }
    
    
    func showModeChangeVC(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FliprModeChangeViewController") as? FliprModeChangeViewController{
            vc.modeVal = self.fliprMode
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    @IBAction func modeChangeAction(_ sender: UIButton) {
        if self.isReadMode{
            showModeChangeVC()
        }
    }
}


extension WatrFliprSettingsViewController: UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings == nil ? 0 : 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FliprSettingsTableViewCell", for: indexPath) as! FliprSettingsTableViewCell
        var name = ""
        if let fname = User.currentUser?.firstName{
            name.append(fname)
        }
        if let lname = User.currentUser?.lastName{
            name.append(" ")
            name.append(lname)
        }
        
        cell.ownerLbl.text = settings?.userName
        cell.locationLbl.text = settings?.placeName
        cell.serialNoLbl.text = settings?.serial
        cell.typeLbl.text = "Flipr"
        let type  = settings?.model ?? ""
        if type == "Pro" {
            cell.typeLbl.text = "Start MAX"
        }else{
            cell.typeLbl.text?.append(type)
        }
        
        let tmpSerial =  settings?.serial ?? ""
        if tmpSerial.hasPrefix("F"){
            isV3flipr =  true
            cell.firmwareUpdateView.alpha = 0.3
        }

        cell.lastMesureLbl.text = settings?.lastMeasureDateTime
        let batteryInfo = String(format: "%.2f", settings?.tensionBattery ?? 0.0)
        cell.batteryInfoLbl.text = "\(batteryInfo) V"
//        settings?.tensionBattery ?? 0
//        cell.batteryInfoLbl.text = "\(Int(batteryInfo)) V"
        let version = settings?.version ?? 0
        cell.firmwareVerLbl.text = "\(version)"
        
        if let dateString = settings?.lastMeasureDateTime as? String {
            if let lastDate = dateString.fliprDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
//                cell.lastMesureLbl.text = "Lun.".localized +  " : \(dateFormatter.string(from: lastDate))"
                cell.lastMesureLbl.text =   "\(dateFormatter.string(from: lastDate))"

            }
        }
        cell.modeIndicator.startAnimating()
        var mode = "Searching Flipr".localized
        isReadMode  = false
        if self.fliprMode == "Connecting"{
            mode = "Connecting".localized
        }
        if self.fliprMode == "Reading"{
            mode = "Reading".localized
        }
        else if self.fliprMode == "00"{
            isReadMode  = true
            cell.modeIndicator.isHidden = true
            cell.modeIndicator.stopAnimating()
            mode = "Sleep"
        }
        else if self.fliprMode == "01"{
            isReadMode  = true
            cell.modeIndicator.isHidden = true
            cell.modeIndicator.stopAnimating()
            mode = "Normal"
        }
        else if self.fliprMode == "02"{
            isReadMode  = true
            cell.modeIndicator.isHidden = true
            cell.modeIndicator.stopAnimating()
            mode = "Eco"
        }
        else if self.fliprMode == "03"{
            isReadMode  = true
            cell.modeIndicator.isHidden = true
            cell.modeIndicator.stopAnimating()
            mode = "Boost"
        }else{
            //mode = fliprMode
        }
//        isReadMode = true
        cell.modeValueLbl.text = mode
        return cell
    }
    
    
}


extension WatrFliprSettingsViewController{
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.showDelete()
    }
    
    @IBAction func updateButtonClicked(_ sender: UIButton) {
        if isV3flipr{return}
        self.showFirmwereUdpateScreen()
    }
    
    @IBAction func diagnosticButtonClicked(_ sender: UIButton) {
        
        showFirmwereDiagnosticScreen()
    }
    
    func showFirmwereDiagnosticScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "DiganosticNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showFirmwereUdpateScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showDelete(){
        let alertController = UIAlertController(title: "Supprimer AnalysR".localized, message: "Ce Flipr AnalysR ne sera plus disponible".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Supprimer".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            self.deleteFlipr()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteFlipr(){
        Alamofire.request(Router.deleteModule(moduleId: self.placesModules.serial ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success(_):
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: K.Notifications.FliprDeviceDeleted, object: nil)
                break
            case .failure(let error):
//                NotificationCenter.default.post(name: K.Notifications.FliprDeviceDeleted, object: nil)
                print("get shares Error \(error)")
                self.dismiss(animated: true, completion: nil)

            }
            Module.currentModule?.serial = ""
            Module.saveCurrentModuleLocally()
            FliprModeManager.shared.stopScanning = true
            FliprModeManager.shared.removeConnection()

        })
    }
    
    
    

}

