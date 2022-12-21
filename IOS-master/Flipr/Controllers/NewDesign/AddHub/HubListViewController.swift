//
//  HubListViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 01/06/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth
import JGProgressHUD


class HubListViewController: UIViewController {
    
    @IBOutlet weak var hubListTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var equipmentCode : String = ""
    var serialKey:String = ""
    let hud = JGProgressHUD(style:.dark)

    var hubs:[String:CBPeripheral] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        hubListTableView.tableFooterView = UIView()
        self.titleLbl.text = "Choisissez le Flipr Start à associer".localized
        // Do any additional setup after loading the view.
    }
}



extension HubListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hubs.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceInfoTableViewCell",
                                                     for: indexPath) as! DeviceInfoTableViewCell
         let key = "\(Array(hubs)[indexPath.row].key)"
        cell.keyIdLabel.text = key
        let device = (Array(hubs)[indexPath.row].value)
        let deviceName = device.name ?? ""
        cell.modelLabel.text = deviceName.replacingOccurrences(of: key, with: "")
        cell.shadowView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = "\(Array(hubs)[indexPath.row].key)"
        self.serialKey =  key
        self.activateHub(serialKey: key)

        
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
//            let key = "\(Array(hubs)[indexPath.row].key)"
//            vc.serialKey = key
//            vc.isHub = true
//            vc.equipmentCode = self.equipmentCode
//            self.navigationController?.pushViewController(vc)
//        }
    }
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
        
    }
    
    
    func showNextScreen(){
        
    }
    
    
    func activateHub(serialKey:String){
        hud?.show(in: self.view)
        let equipmentCode = "\(AppSharedData.sharedInstance.selectedEquipmentCode)"
        HUB.activate(serial:serialKey, activationKey: "123456", equipmentCode: equipmentCode, completion: { (error) in
            self.hud?.dismiss(afterDelay: 0)
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)

            } else {
                self.showSuccess(title: nil, message: nil)
                
                let sb = UIStoryboard(name: "HUBDevicePairing", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "WifiListViewController") as! WifiListViewController
                vc.serial = self.serialKey
                self.navigationController?.pushViewController(vc)
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
//                    viewController.serial = self.serialKey
//                    self.navigationController?.pushViewController(viewController, animated: true)
//                }
            }
            
//            UIView.animate(withDuration: 0.25, animations: {
//                self.view.layoutIfNeeded()
//            })
            
        })

    }
}
