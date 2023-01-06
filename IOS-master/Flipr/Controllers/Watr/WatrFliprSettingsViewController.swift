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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AnalysR".localized
        tableView.tableFooterView =  UIView()
        self.getSettings()
        // Do any additional setup after loading the view.
    }
    
    func getSettings(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        Alamofire.request(Router.analysrSettings(serial: self.placesModules.serial ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let responseData):
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

}


extension WatrFliprSettingsViewController: UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
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
        
        cell.lastMesureLbl.text = settings?.lastMeasureDateTime
        let batteryInfo = settings?.percentageBattery ?? 0
        cell.batteryInfoLbl.text = "\(Int(batteryInfo)) %"
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
        return cell
    }
}


extension WatrFliprSettingsViewController{
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.showDelete()
    }
    
    @IBAction func updateButtonClicked(_ sender: UIButton) {
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
        
    }
}
