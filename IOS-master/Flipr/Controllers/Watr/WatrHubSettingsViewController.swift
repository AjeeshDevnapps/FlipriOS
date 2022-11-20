//
//  WatrHubSettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 18/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class WatrHubSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var placeDetails:PlaceDropdown!
    var placesModules:PlaceModule!
    var hub: HUB?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ContrôlR"
        tableView.tableFooterView =  UIView()
        // Do any additional setup after loading the view.
    }

}


extension WatrHubSettingsViewController: UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
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
        cell.ownerLbl.text = name
        cell.locationLbl.text = "Sample data"
        cell.serialNoLbl.text = Module.currentModule?.serial
//        cell.typeLbl.text = Module.currentModule?.deviceTypename
        return cell
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
        let sb = UIStoryboard.init(name: "SideMenuViews", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "HubSettingsViewController") as? HubSettingsViewController {
            viewController.hub = hub
            viewController.delegate = self
           // viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true) {
            }
        }
    }
    
    
    func showDelete(){
        let alertController = UIAlertController(title: "Supprimer le ControlR".localized, message: "Ce controlR ne sera plus disponible".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
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
