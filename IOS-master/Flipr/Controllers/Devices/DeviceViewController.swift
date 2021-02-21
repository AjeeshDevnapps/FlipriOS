//
//  DeviceViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 19/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

enum DeviceWifiCellType {
    case MeasureInfo
    case StatusInfo
}

class DeviceViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    var devicewifiTypeCell = DeviceWifiCellType.MeasureInfo
    var devicesDetails:  [String:Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension DeviceViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 275
        }
        else if indexPath.row == 1 {
            return 66
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceInfoTableViewCell",
                                                     for: indexPath) as! DeviceInfoTableViewCell
            if let serial = devicesDetails?["Serial"] as? String  {
                cell.serialLabel.text = serial
            }
            if let activationKey = devicesDetails?["ActivationKey"] as? String {
                cell.keyIdLabel.text = activationKey
            }
          
            if let deviceType = devicesDetails?["ModuleType_Id"] as? Int {
                if deviceType == 1 {
                    cell.modelLabel.text = "Flipr"
                }else{
                    cell.modelLabel.text = "Hub"
                }
            }
            return cell
        }
        
        else if indexPath.row == 1{
            if devicewifiTypeCell == DeviceWifiCellType.MeasureInfo{
                let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceWifiInfoTableViewCell",
                                                         for: indexPath) as! DeviceWifiInfoTableViewCell
                
                if let dateString = devicesDetails?["LastMeasureDateTime"] as? String {
                    if let lastDate = dateString.fliprDate {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEE. dd/MM"
                        cell.valueLabel.text = "\(dateFormatter.string(from: lastDate))"
//                        Module.currentModule?.rawlastMeasure = dateFormatter.string(from: lastDate)
                    }
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceWifiStatusTableViewCell",
                                                         for: indexPath) as! DeviceWifiStatusTableViewCell
                if let value = devicesDetails?["StateEquipment"] as? Bool {
                    cell.statusLabel.text = value ? "Connected" : "Not Connected"
                }
                if let value = devicesDetails?["Behavior"] as? String {
                    cell.modeLabel.text = value
                }
                return cell
            }
           
        }
        
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceActionTableViewCell",
                                                     for: indexPath) as! DeviceActionTableViewCell
            return cell
        }
//        else if indexPath.row == 3{
//            let cell = tableView.dequeueReusableCell(withIdentifier:"NotificationCell",
//                                                     for: indexPath) as! NotificationSwitchTableViewCell
//            return cell
//        }
        
       
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"LogOutCell",
                                                     for: indexPath)
            return cell
        }
        
       
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
//
//        let hud = JGProgressHUD(style:.dark)
//        hud?.show(in: self.navigationController!.view)
//
//        Alamofire.request(Router.updateUserNotifications(activate: sender.isOn)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
//
//            switch response.result {
//
//            case .success(let value):
//                UserDefaults.standard.set(sender.isOn, forKey: notificationOnOffValuesKey)
//                NotificationCenter.default.post(name: K.Notifications.NotificationSetttingsChanged, object: nil)
//                print("update notification with success: \(value)")
//                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
//                hud?.dismiss(afterDelay: 1)
//
//            case .failure(let error):
//
//                print("update notification error: \(error)")
//
//                if let serverError = User.serverError(response: response) {
//                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud?.textLabel.text = serverError.localizedDescription
//                    hud?.dismiss(afterDelay: 3)
//                } else {
//                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud?.textLabel.text = error.localizedDescription
//                    hud?.dismiss(afterDelay: 3)
//                }
//            }
//
//        })
//
    }
    
}
