//
//  GatewaySettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 05/04/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

import JGProgressHUD
import Alamofire

class GatewaySettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
//    @IBOutlet weak var changeWifiBtn: UIButton!
    @IBOutlet weak var chanbgeBtnLabel: UILabel!

    
    var placeDetails:PlaceDropdown!
    var placesModules:PlaceModule!
    var hub: HUB?
    var settings:ControlRSettings?
    var info:UserGateway?
    var isShowingWifiListScreen  = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = info?.serial
        tableView.tableFooterView =  UIView()
        self.tableView.reloadData()
        
        NotificationCenter.default.addObserver(forName: K.Notifications.GatewayDiscovered, object: nil, queue: nil) { (notification) in
            //            self.scanningAlertContainerView.isHidden = true
            //            self.loaderView.hideStateView()
            if let serial = notification.userInfo?["serial"] as? String {
                print("Gateway getting ... \(serial)")
                if self.isShowingWifiListScreen{
                    
                }else{
                    self.isShowingWifiListScreen = true
                    DispatchQueue.main.async {
                        self.reconnectGateway()
                    }
                }
//                if let index = self.gatewayArray.firstIndex(of: serial) {
//                    print(index) // Output: 4
//                }else{
//                    self.gatewayArray.append(serial)
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
                //                self.showFliprList(serialKey: serial)
            }else{
                
            }
        }
        

//        self.getSettings()
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
//        self.showRename()
    }
    
    
    func reconnectGateway(){
        GatewayManager.shared.stopScanForGateway()
        let serialNo = self.info?.serial ?? ""
        GatewayManager.shared.connect(serial: serialNo) { error in
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            }
            else {
                print("Added selected Gateway")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GatewaywifiViewController") as? GatewaywifiViewController {
                    vc.serial = serialNo
//                    vc.isChangePassword = true 
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

}


extension GatewaySettingsViewController: UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GatewaySettingsTableViewCell", for: indexPath) as! GatewaySettingsTableViewCell
        if let version = self.info?.moduleType {
            cell.nameLbl.text = "\(version)"
        }
        if let serial = self.info?.serial {
//            cell.ownerLbl.text = serial
        }
//        cell.locationLbl.text = settings?.placeName
//        cell.serialNoLbl.text = settings?.serial

//        let mode = settings?.mode ?? ""
//        cell.modeLbl.text = mode.capitalized
//        let state = settings?.state ?? 0
//        cell.statusLbl.text = state == 0  ? "Active".localized : "Inactive".localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 2{
//            self.showRename()
//        }
    }
}


extension GatewaySettingsViewController{
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.showDelete()
    }
    
 
    
    @IBAction func updateButtonClicked(_ sender: UIButton) {
//        self.showSettings()
        let serial = self.info?.serial ?? ""
        GatewayManager.shared.scanForGateways(serials: [serial], completion: { (gatewayinfo) in
            
        })
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
//        let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
//        if let viewController = sb.instantiateViewController(withIdentifier: "HubRenameViewController") as? HubRenameViewController {
//            viewController.hub = hub
//            viewController.completion(block: { (inputValue) in
//                if inputValue != nil{
//                    self.settings?.moduleName =  inputValue
//                    self.tableView.reloadData()
//                }
//                })
//            self.present(viewController, animated: true, completion: nil)
//        }
    }
    
    
    func showDelete(){
        let alertController = UIAlertController(title: "".localized, message: "Supprimer la passerelle".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Confirmer".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            self.deleteGateway()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteGateway(){
        
        Alamofire.request(Router.deleteModule(moduleId: self.info?.serial ?? "")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(_):
//                    self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                break
            case .failure(let error):
//                NotificationCenter.default.post(name: K.Notifications.FliprDeviceDeleted, object: nil)
                print("get shares Error \(error)")
//                self.dismiss(animated: true, completion: nil)

            }
        })
    }
}

