//
//  WatrHubSettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 18/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

class WatrHubSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var placeDetails:PlaceDropdown!
    var placesModules:PlaceModule!
    var hub: HUB?
    var settings:ControlRSettings?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ContrôlR"
        tableView.tableFooterView =  UIView()
        self.getSettings()
        // Do any additional setup after loading the view.
    }
    
    func getSettings(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        
        Alamofire.request(Router.hUBSettings(serial: self.hub?.serial ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let responseData):
                if let settingsDic = responseData as? [String:Any] {
                    self.settings = ControlRSettings.init(fromDictionary: settingsDic)
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
    
    @IBAction func renameButtonAction(_ sender: Any) {
        self.showRename()
    }

}


extension WatrHubSettingsViewController: UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FliprSettingsTableViewCell", for: indexPath) as! FliprSettingsTableViewCell
        cell.ownerLbl.text = settings?.userName
        cell.locationLbl.text = settings?.placeName
        cell.typeLbl.text = settings?.moduleName
        cell.serialNoLbl.text = settings?.serial

        let mode = settings?.mode ?? ""
        cell.batteryInfoLbl.text = mode.capitalized
        let state = settings?.state ?? 0
        cell.lastMesureLbl.text = state == 0  ? "Inactif".localized : "Actif".localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            self.showRename()
        }
    }
}


extension WatrHubSettingsViewController{
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.showDelete()
    }
    
 
    
    @IBAction func updateButtonClicked(_ sender: UIButton) {
        self.showSettings()
    }
    
    func showSettings(){
        let sb = UIStoryboard(name: "HUB", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
            viewController.serial = hub?.serial ?? ""
            viewController.fromSetting = false
            let nav = UINavigationController.init(rootViewController: viewController)
            self.present(nav, animated: true, completion: nil)
//            self.navigationController?.pushViewController(viewController, animated: true)
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
//        let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
//        if let viewController = sb.instantiateViewController(withIdentifier: "HubSettingsViewController") as? HubSettingsViewController {
//            viewController.hub = hub
//            viewController.delegate = self
//           // viewController.modalPresentationStyle = .overCurrentContext
//            self.present(viewController, animated: true) {
//            }
//        }
    }
    
    
    func showRename(){
        let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "HubRenameViewController") as? HubRenameViewController {
            viewController.hub = hub
            viewController.completion(block: { (inputValue) in
                if inputValue != nil{
                    self.settings?.moduleName =  inputValue
                    self.tableView.reloadData()
                }
                })
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    func showDelete(){
        let alertController = UIAlertController(title: "Supprimer le ControlR".localized, message: "Ce controlR ne sera plus disponible".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Supprimer".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            self.deleteHub()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteHub(){
        
        func deleteFlipr(){
            Alamofire.request(Router.deleteModule(moduleId: self.hub?.serial ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(_):
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: K.Notifications.HubDeviceDeleted, object: nil)
                    break
                case .failure(let error):
    //                NotificationCenter.default.post(name: K.Notifications.FliprDeviceDeleted, object: nil)
                    print("get shares Error \(error)")
                    self.dismiss(animated: true, completion: nil)

                }
            })
        }
    }
}

extension WatrHubSettingsViewController: HubSettingViewDelegate{

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
}
