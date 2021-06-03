//
//  HubListViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 01/06/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth


class HubListViewController: UIViewController {
    @IBOutlet weak var hubListTableView: UITableView!
    var hubs:[String:CBPeripheral] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
        
    }
    
    
}
