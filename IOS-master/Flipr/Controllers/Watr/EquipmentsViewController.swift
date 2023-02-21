//
//  EquipmentsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 21/02/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class EquipmentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var equipmentList: [Equipments]?
    let hud = JGProgressHUD(style:.dark)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Equipements".localized
        callPlacesApi()
        // Do any additional setup after loading the view.
    }
    

    func callPlacesApi(){
        hud?.show(in: self.view)
        User.currentUser?.getEquipments(completion: { (equipmentsResult,error) in
            if (error != nil) {
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud?.textLabel.text = error?.localizedDescription
                self.hud?.dismiss(afterDelay: 0)
            } else {
                if equipmentsResult != nil{
                    self.equipmentList = equipmentsResult!
                    self.hud?.dismiss(afterDelay: 0)
                    self.tableView.reloadData()
                }
            }
        })
    }


}


extension EquipmentsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equipmentList?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: EqipmentsTableViewCell!
        if let info =  self.equipmentList?[indexPath.row]{
            if info.moduleType  == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "EqipmentsTableViewCellFlipr", for: indexPath) as? EqipmentsTableViewCell
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "EqipmentsTableViewCellHub", for: indexPath) as? EqipmentsTableViewCell
            }
            cell.deviceInfo = info
            cell.delegate = self
            cell.nameLbl.text = info.serial ?? ""
        }
        return cell
    }
    
    
}


extension EquipmentsViewController: EqipmentsTableViewCellDelegate{
   
    func didSelectSettingsButton(deviceInfo:Equipments?){
        self.showDeviceDetailsView(deviceInfo: deviceInfo)
    }
    
    func showDeviceDetailsView(deviceInfo:Equipments?){
        if let info =  deviceInfo{
            if info.moduleType  == 1{
            
                let vc = UIStoryboard(name:"WatrFlipr", bundle: nil).instantiateViewController(withIdentifier: "WatrFliprSettingsViewController") as! WatrFliprSettingsViewController
                let placesModules = PlaceModule(dictionary: ["serial":  info.serial])
//                vc.placeDetails = self.placeDetails
                vc.placesModules = placesModules
                let nav = UINavigationController.init(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)

            }else{
                let sb = UIStoryboard.init(name: "WatrFlipr", bundle: nil)
                if let viewController = sb.instantiateViewController(withIdentifier: "WatrHubSettingsViewController") as? WatrHubSettingsViewController {
                    let hub = HUB(serial: info.serial)
                    viewController.hub = hub
                    let nav = UINavigationController.init(rootViewController: viewController)
                    self.present(nav, animated: true) {
                    }
                }
            }
        }
    }
    

}


