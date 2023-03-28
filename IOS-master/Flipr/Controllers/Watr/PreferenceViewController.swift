//
//  PreferenceViewController.swift
//  Flipr
//
//  Created by Ajeesh on 14/01/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var unitTitleLbl: UILabel!
    @IBOutlet weak var themeTitleLbl: UILabel!


    @IBOutlet weak var themBlueLbl: UILabel!
    @IBOutlet weak var themRoseLbl: UILabel!
    @IBOutlet weak var themBlueTick: UIImageView!
    @IBOutlet weak var themRoseTick: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var container1: UIView!
    
    
    @IBOutlet weak var metricLbl: UILabel!
    @IBOutlet weak var imperialLbl: UILabel!
    @IBOutlet weak var metricTick: UIImageView!
    @IBOutlet weak var imperialTick: UIImageView!
    @IBOutlet weak var container2: UIView!

    var isLoginFlow = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Preferences".localized
        themBlueLbl.text = "Blue".localized
        themRoseLbl.text = "Rose".localized

        nextButton.isHidden = !isLoginFlow
        if isLoginFlow{
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        container1.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container2.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)

        manageUnit()
        managetheme()
        // Do any additional setup after loading the view.
    }
    
    func manageUnit(){
        var isDegree =  true
        if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
            if currentUnit == 2{
                isDegree = false
            }else{
                isDegree = true
            }
        }else{
            UserDefaults.standard.set(1, forKey: "CurrentUnit")
//            NotificationCenter.default.post(name: K.Notifications.MeasureUnitSettingsChanged, object: nil)
        }
        if isDegree{
            imperialTick.isHidden = true
            metricTick.isHidden = false

        }else{
            metricTick.isHidden = true
            imperialTick.isHidden = false
        }
    }
    
    
    func managetheme(){
        var isBlueTheme = true
        if let currentThemColour = UserDefaults.standard.object(forKey: "CurrentTheme") as? String{
            if currentThemColour == "blue"{
                isBlueTheme = true
            }else{
                isBlueTheme = false
            }
        }else{
            UserDefaults.standard.set("blue", forKey: "CurrentTheme")
            NotificationCenter.default.post(name: K.Notifications.WavethemeSettingsChanged, object: nil)
        }
        if isBlueTheme{
            themBlueTick.isHidden = false
            themRoseTick.isHidden = true
        }else{
            themRoseTick.isHidden = false
            themBlueTick.isHidden = true
        }
    }
    
    
    
    @IBAction func matricButtonTapped(){
        UserDefaults.standard.set(1, forKey: "CurrentUnit")
        NotificationCenter.default.post(name: K.Notifications.MeasureUnitSettingsChanged, object: nil)
        manageUnit()

    }

    @IBAction func galButtonTapped(){
        UserDefaults.standard.set(2, forKey: "CurrentUnit")
        NotificationCenter.default.post(name: K.Notifications.MeasureUnitSettingsChanged, object: nil)
        manageUnit()
    }
    
    @IBAction func blueThemeButtonTapped(){
        UserDefaults.standard.set("blue", forKey: "CurrentTheme")
        NotificationCenter.default.post(name: K.Notifications.WavethemeSettingsChanged, object: nil)
        managetheme()

    }

    @IBAction func roseThemeButtonTapped(){
        UserDefaults.standard.set("orange", forKey: "CurrentTheme")
        NotificationCenter.default.post(name: K.Notifications.WavethemeSettingsChanged, object: nil)
        managetheme()
    }
    
    
    
    @IBAction func nextButtonTapped(){
        if AppSharedData.sharedInstance.haveInvitation{
            self.showPlaceDropdownView()
        }else{
            if AppSharedData.sharedInstance.havePlace{
                self.presentDashboard()
            }else{
                self.addPlaceView()
            }
        }
    }
    
    func addPlaceView(){
        let sb = UIStoryboard(name: "NewLocation", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NewLocationViewControllerID") as? NewLocationViewController {
            self.navigationController?.pushViewController(viewController, completion: nil)
            //            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true)
        }
    }

    
    func showPlaceDropdownView(){
        let sb = UIStoryboard.init(name: "Watr", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "PlaceDropdownViewController") as? PlaceDropdownViewController {
//            viewController.delegate = self
//            viewController.placeTitle = self.selectedPlaceDetailsLbl.text
//            viewController.modalPresentationStyle = .overCurrentContext
//            self.present(viewController, animated: true) {
//            }
            viewController.isInvitationFlow = true
            self.navigationController?.pushViewController(viewController, completion: nil)
        }
    }
    
    
    func presentDashboard() {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let dashboard = mainSB.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: false, completion: {
        })
    
    }
    
}
