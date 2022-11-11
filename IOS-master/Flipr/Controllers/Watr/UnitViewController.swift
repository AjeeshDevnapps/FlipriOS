//
//  UnitViewController.swift
//  Flipr
//
//  Created by Ajeesh on 27/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class UnitViewController: UIViewController {

    @IBOutlet weak var themBlueLbl: UILabel!
    @IBOutlet weak var themRoseLbl: UILabel!
    @IBOutlet weak var themBlueTick: UIImageView!
    @IBOutlet weak var themRoseTick: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Système"
        manageUnit()
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
            NotificationCenter.default.post(name: K.Notifications.MeasureUnitSettingsChanged, object: nil)
        }
        if !isDegree{
            themBlueTick.isHidden = true
            themRoseTick.isHidden = false

        }else{
            themRoseTick.isHidden = true
            themBlueTick.isHidden = false
        }
    }
    
    
    @IBAction func blueThemeButtonTapped(){
        UserDefaults.standard.set(1, forKey: "CurrentUnit")
        NotificationCenter.default.post(name: K.Notifications.MeasureUnitSettingsChanged, object: nil)
        manageUnit()

    }

    @IBAction func roseThemeButtonTapped(){
        UserDefaults.standard.set(2, forKey: "CurrentUnit")
        NotificationCenter.default.post(name: K.Notifications.MeasureUnitSettingsChanged, object: nil)
        manageUnit()
    }
    

}
