//
//  WatrSettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 04/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

class WatrSettingsViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fliprDetailsLbl: UILabel!
    @IBOutlet weak var themTitleLbl: UILabel!
    @IBOutlet weak var themLbl: UILabel!
    @IBOutlet weak var NotificationLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var themBkImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!


    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
//    @IBOutlet weak var container3: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings".localized
        setupView()
        self.nameLbl.text  = (User.currentUser?.firstName ?? "") +  " " +   (User.currentUser?.lastName ?? "")
        self.nameLbl.text = self.nameLbl.text?.capitalized
        self.fliprDetailsLbl.text  = (Module.currentModule?.serial ?? "") //+  "," +   (User.currentUser?.lastName ?? "")
        
        container1.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container2.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        saveButton.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)


        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setupUnitView()
    }
    
    func setupView(){
        if let currentThemColour = UserDefaults.standard.object(forKey: "CurrentTheme") as? String{
            if currentThemColour == "blue"{
                themLbl.text = "Blue"
                themBkImage.image = UIImage(named: "blurTheme")
            }else{
                themLbl.text = "Rose"
                themBkImage.image = UIImage(named: "RoseThemeBk")
            }
        }else{
            UserDefaults.standard.set("orange", forKey: "CurrentTheme")
            themLbl.text = "Rose"
            themBkImage.image = UIImage(named: "RoseThemeBk")
        }
    }
    
    
    func setupUnitView(){
        if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
            if currentUnit == 2{
                unitLbl.text = "Impérial : Feets,  °F"
            }else{
                unitLbl.text = "Métrique (m, m°C)"
            }
        }
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
    
    
    @IBAction func themeButtonTapped(){
        if let themeVC = self.storyboard?.instantiateViewController(withIdentifier: "WatrThemeViewController") as? WatrThemeViewController{
            self.navigationController?.pushViewController(themeVC)
        }
    }

    
    @IBAction func unitButtonTapped(){
        if let themeVC = self.storyboard?.instantiateViewController(withIdentifier: "UnitViewController") as? UnitViewController{
            self.navigationController?.pushViewController(themeVC)
        }
    }
    
    
    @IBAction func accountButtonTapped(){
        if let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController{
            self.navigationController?.pushViewController(accountVC)
        }
    }
    
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
        self.callReactivateAlertApi(alertStatus: sender.isOn)
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

}
