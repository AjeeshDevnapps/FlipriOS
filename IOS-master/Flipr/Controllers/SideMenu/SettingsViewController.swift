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

enum ThemeSelector {
    case orange
    case blue
    case camera
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var orangeThemeView: UIView!
    @IBOutlet weak var orangeThemeSelectorView: UIView!
    @IBOutlet weak var blueThemeView: UIView!
    @IBOutlet weak var blueThemeSelectorView: UIView!
    @IBOutlet weak var cameraPicThemeView: UIView!
    @IBOutlet weak var cameraPicThemeSelectorView: UIView!
    var currentSelection = ThemeSelector.orange

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))
      //  self.settingTable.tableFooterView = UIView()
        self.settingTable.isScrollEnabled = false
        self.settingTable.showsVerticalScrollIndicator = false
        setupTheme()
        // Do any additional setup after loading the view.
    }
    
    
    func setupTheme(){
        orangeThemeView.fullyRoundCorner()
        orangeThemeSelectorView.fullyRoundCorner()
        blueThemeView.fullyRoundCorner()
        blueThemeSelectorView.fullyRoundCorner()
        cameraPicThemeView.fullyRoundCorner()
        cameraPicThemeSelectorView.fullyRoundCorner()
        var isOrangeTheme = true
        if let currentThemColour = UserDefaults.standard.object(forKey: "CurrentTheme") as? String{
            if currentThemColour == "blue"{
                isOrangeTheme = false
            }else{
                isOrangeTheme = true
            }
        }
        if isOrangeTheme{
            currentSelection = .orange
            orangeThemeSelectorView.backgroundColor = .black
            orangeThemeView.layer.borderColor = UIColor.init(hexString: "4A5567").cgColor
            orangeThemeView.layer.borderWidth = 2
            
            blueThemeSelectorView.backgroundColor = .clear
            blueThemeView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
            blueThemeView.layer.borderWidth = 1
            
            UserDefaults.standard.set("orange", forKey: "CurrentTheme")
            
        }else{
            currentSelection = .blue
            blueThemeSelectorView.backgroundColor = .black
            blueThemeView.layer.borderColor = UIColor.init(hexString: "4A5567").cgColor
            blueThemeView.layer.borderWidth = 2
            
            orangeThemeSelectorView.backgroundColor = .clear
            orangeThemeView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
            orangeThemeView.layer.borderWidth = 1
            
            UserDefaults.standard.set("blue", forKey: "CurrentTheme")
        }
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
   
    
    func selectOrangeTheme(){
        currentSelection = .orange
        orangeThemeSelectorView.backgroundColor = .black
        orangeThemeView.layer.borderColor = UIColor.init(hexString: "4A5567").cgColor
        orangeThemeView.layer.borderWidth = 2
        UserDefaults.standard.set("orange", forKey: "CurrentTheme")
        NotificationCenter.default.post(name: K.Notifications.WavethemeSettingsChanged, object: nil)

    }
    
    func deSelectOrangeTheme(){
        orangeThemeSelectorView.backgroundColor = .clear
        orangeThemeView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
        orangeThemeView.layer.borderWidth = 1
    }
    
    func selectBlueTheme(){
        currentSelection = .blue
        blueThemeSelectorView.backgroundColor = .black
        blueThemeView.layer.borderColor = UIColor.init(hexString: "4A5567").cgColor
        blueThemeView.layer.borderWidth = 2
        
        UserDefaults.standard.set("blue", forKey: "CurrentTheme")
        NotificationCenter.default.post(name: K.Notifications.WavethemeSettingsChanged, object: nil)

    }
    
    func deSelectBlueTheme(){
        blueThemeSelectorView.backgroundColor = .clear
        blueThemeView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
        blueThemeView.layer.borderWidth = 1
    }
    
    func selectCameraTheme(){
        currentSelection = .camera
        cameraPicThemeSelectorView.backgroundColor = .black
        cameraPicThemeView.layer.borderColor = UIColor.init(hexString: "4A5567").cgColor
        cameraPicThemeView.layer.borderWidth = 2
    }
    
    func deSelectCameraTheme(){
        cameraPicThemeSelectorView.backgroundColor = .clear
        cameraPicThemeView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
        cameraPicThemeView.layer.borderWidth = 1
    }
    
    
    @IBAction func orangeThemeButtonTapped(){
        selectOrangeTheme()
        deSelectBlueTheme()
//        deSelectCameraTheme()
    }
    
    @IBAction func blueThemeButtonTapped(){
        selectBlueTheme()
//        deSelectCameraTheme()
        deSelectOrangeTheme()
    }
    
    @IBAction func cameraThemeButtonTapped(){
        selectCameraTheme()
        deSelectOrangeTheme()
        deSelectBlueTheme()
    }
    
    
    @IBAction func accountButtonTapped(){
        if let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController{
            self.navigationController?.pushViewController(accountVC)
        }
    }
    
    @IBAction func poolButtonTapped(){
        let manSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = manSb.instantiateViewController(withIdentifier: "PoolViewControllerID") as? UINavigationController{
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func devicesButtonTapped(){
        let storyboard = UIStoryboard(name: "Devices", bundle: nil)
        let deviceVC = storyboard.instantiateViewController(withIdentifier: "DevicesViewController") as! DevicesViewController
        self.navigationController?.pushViewController(deviceVC)
    }
    
    @IBAction func logoutButtonTapped(){
    
        let alertController = UIAlertController(title: "LOGOUT_TITLE".localized, message: "Are you sure you want to log out?".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        let okAction = UIAlertAction(title: "Log out".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            User.logout()
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: K.Notifications.UserDidLogout, object: nil)
            })
            
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500

//        if indexPath.row == 4 {
//            return 160
//        }
//        else if indexPath.row == 3 {
//            return 64
//        }
//        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

//        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SettingsTableViewCell",
                                                     for: indexPath)  as! SettingsTableViewCell
            return cell
//        }
        
//        else if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier:"PoolCell",
//                                                     for: indexPath)  as! SettingsTableViewCell
//            return cell
//        }
//
//        else if indexPath.row == 2{
//            let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceCell",
//                                                     for: indexPath)
//            return cell
//        }
//        else if indexPath.row == 3{
//            let cell = tableView.dequeueReusableCell(withIdentifier:"NotificationCell",
//                                                     for: indexPath) as! NotificationSwitchTableViewCell
//            return cell
//        }
//
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier:"LogOutCell",
//                                                     for: indexPath)
//            return cell
//        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /*
        if indexPath.row == 0 {
            if let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController{
                self.navigationController?.pushViewController(accountVC)
            }
        }
        
        else if indexPath.row == 1{
            
        }
        
        else if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Devices", bundle: nil)
            let deviceVC = storyboard.instantiateViewController(withIdentifier: "DevicesViewController") as! DevicesViewController
            self.navigationController?.pushViewController(deviceVC)

        }
        
        else if indexPath.row == 4 {
          
        }
        
        */
    }
    
    func callReactivateAlertApi(alertStatus:Bool){
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        
        if let serialNo = Module.currentModule?.serial {
            Alamofire.request(Router.reactivateAlert(serial: serialNo, status: alertStatus)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
//                    UserDefaults.standard.set(false, forKey: notificationOnOffValuesKey)
                    UserDefaults.standard.set(alertStatus, forKey: notificationOnOffValuesKey)
                    NotificationCenter.default.post(name: K.Notifications.NotificationSetttingsChanged, object: nil)
                    print("update notification with success: \(value)")
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)

                case .failure(let error):
                    
                    print("Reactivated Notification did fail with error: \(error)")
//                    print("update notification error: \(error)")
                    
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
        }else{
            print("No serial number")
        }
       
    }

    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
        self.callReactivateAlertApi(alertStatus: sender.isOn)
        /*
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        
        
        Alamofire.request(Router.updateUserNotifications(activate: sender.isOn)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                UserDefaults.standard.set(!sender.isOn, forKey: notificationOnOffValuesKey)
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
        
        */
        
    }
    
}
