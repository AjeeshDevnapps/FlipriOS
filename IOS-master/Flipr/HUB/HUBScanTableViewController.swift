//
//  HUBScanTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth

class HUBScanTableViewController: UITableViewController {
    
    var equipmentCode:String!
    var hubs:[String:CBPeripheral] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Appareils à proximité"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(back))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HUBManager.shared.scanForHubs(serials: nil) { (hubInfo) in
            print("HUB detected: \(hubInfo.keys.first ?? "???")")
            self.hubs = hubInfo
            self.tableView.reloadData()
        }
    }
    
    @objc func back(){
        HUBManager.shared.stopScanForHubs()
        HUBManager.shared.detectedHubs.removeAll()
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return hubs.keys.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FliprHUBScanIndicatorCell", for: indexPath)
            if let indicator = cell.viewWithTag(1) as? UIActivityIndicatorView {
                indicator.startAnimating()
            }
            if let label = cell.viewWithTag(2) as? UILabel {
                label.text = "Recherche en cours..."
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FliprHUBScanCell", for: indexPath)

        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = "S/N : \(Array(hubs)[indexPath.row].key)"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            HUBManager.shared.stopScanForHubs()
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBActivationViewControllerID") as? HUBActivationViewController {
                vc.serial = Array(hubs)[indexPath.row].key
                vc.equipmentCode = equipmentCode
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
