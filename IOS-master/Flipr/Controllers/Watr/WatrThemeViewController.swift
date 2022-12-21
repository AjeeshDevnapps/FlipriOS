//
//  WatrThemeViewController.swift
//  Watr
//
//  Created by Ajeesh on 04/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class WatrThemeViewController: UIViewController {
    @IBOutlet weak var themBlueLbl: UILabel!
    @IBOutlet weak var themRoseLbl: UILabel!
    @IBOutlet weak var themBlueTick: UIImageView!
    @IBOutlet weak var themRoseTick: UIImageView!
    @IBOutlet weak var container1: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thème"
        container1.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        managetheme()
        // Do any additional setup after loading the view.
    }
    
    func managetheme(){
        var isOrangeTheme = true
        if let currentThemColour = UserDefaults.standard.object(forKey: "CurrentTheme") as? String{
            if currentThemColour == "blue"{
                isOrangeTheme = false
            }else{
                isOrangeTheme = true
            }
        }
        if isOrangeTheme{
            themBlueTick.isHidden = true
            themRoseTick.isHidden = false

        }else{
            themRoseTick.isHidden = true
            themBlueTick.isHidden = false
        }
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
    

}
