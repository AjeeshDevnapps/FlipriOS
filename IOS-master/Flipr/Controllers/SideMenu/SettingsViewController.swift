//
//  SettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 17/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))
        self.settingTable.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 160
        }
        else if indexPath.row == 3 {
            return 64
        }
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"AccountCell",
                                                     for: indexPath)
            return cell
        }
        
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier:"PoolCell",
                                                     for: indexPath)
            return cell
        }
        
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceCell",
                                                     for: indexPath)
            return cell
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier:"NotificationCell",
                                                     for: indexPath) as! NotificationSwitchTableViewCell
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"LogOutCell",
                                                     for: indexPath)
            return cell
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController{
                self.navigationController?.pushViewController(accountVC)
            }
        }
        
        else if indexPath.row == 1{
            
        }
        
        else if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Devices", bundle: nil)
//            let deviceVC = storyboard.instantiateViewController(withIdentifier: "DeviceViewController") as! DeviceViewController
            let deviceVC = storyboard.instantiateViewController(withIdentifier: "DevicesViewController") as! DevicesViewController
            self.navigationController?.pushViewController(deviceVC)

        }
        
        else if indexPath.row == 4 {
            let alertController = UIAlertController(title: "LOGOUT_TITLE".localized, message: "Are you sure you want to log out?".localized, preferredStyle: UIAlertController.Style.actionSheet)
            
            let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
            
            let okAction = UIAlertAction(title: "Log out".localized, style: UIAlertAction.Style.destructive)
            {
                (result : UIAlertAction) -> Void in
                print("You pressed OK")
                
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: K.Notifications.UserDidLogout, object: nil)
                })
                
                User.logout()
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        Alamofire.request(Router.updateUserNotifications(activate: sender.isOn)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                UserDefaults.standard.set(sender.isOn, forKey: notificationOnOffValuesKey)
                NotificationCenter.default.post(name: K.Notifications.NotificationSetttingsChanged, object: nil)
                print("update notification with success: \(value)")
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
                
            case .failure(let error):
                
                print("update notification error: \(error)")
                
                if let serverError = User.serverError(response: response) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = serverError.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                }
            }
            
        })
        
    }
    
}
