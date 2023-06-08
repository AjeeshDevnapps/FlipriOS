//
//  FliprModeChangeViewController.swift
//  Flipr
//
//  Created by Ajeesh on 19/05/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class FliprModeChangeViewController: UIViewController {

    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var radioBtnTitle1: UILabel!
    @IBOutlet weak var radioBtnTitle2: UILabel!
    @IBOutlet weak var radioBtnTitle3: UILabel!
    @IBOutlet weak var radioBtnTitle4: UILabel!
    @IBOutlet weak var radioBtn1: UIButton!
    @IBOutlet weak var radioBtn2: UIButton!
    @IBOutlet weak var radioBtn3: UIButton!
    @IBOutlet weak var radioBtn4: UIButton!
    
    @IBOutlet weak var radioBtnImg1: UIImageView!
    @IBOutlet weak var radioBtnImg2: UIImageView!
    @IBOutlet weak var radioBtnImg3: UIImageView!
    @IBOutlet weak var radioBtnImg4: UIImageView!

    @IBOutlet weak var containerView: UIView!

    var modeVal = "01"
    let hud = JGProgressHUD(style:.dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mode".localized
        self.infoLbl.text = "Le changement de mode ne peut se faire qu’à proximité immédiate du Flipr. \n\nLes modes “Eco et Sleep” préserveront significativement la batterie pendant les périodes d’hivernage.\n\nL’utilisation du mode “Boost” entraine pourra annuler la garantie  de la batterie. Celle-ci se déchargera très rapidement.\n".localized
        radioBtnTitle1.text = "Normal (20 Measurements / Day)".localized
        radioBtnTitle2.text = "Eco  (2 Measurements / Day)".localized
        radioBtnTitle3.text = "Sleep (No measurement)".localized
        radioBtnTitle4.text = "Boost (700 measurements / Day)".localized

        NotificationCenter.default.addObserver(forName: K.Notifications.FliprModeValue, object: nil, queue: nil) { (notification) in
            //            self.scanningAlertContainerView.isHidden = true
            //            self.loaderView.hideStateView()
            if let mode = notification.userInfo?["Mode"] as? String {
                FliprModeManager.shared.removeConnection()
                self.hud?.dismiss()
                self.modeVal = mode
                self.selectModeImage(mode: self.modeVal)
            }else{
                
            }
        }
        self.selectModeImage(mode: modeVal)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func radioBtn1Action(_ sender: UIButton) {
        self.changeMode(mode: 1)
        self.selectModeImage(mode: modeVal)
    }
    
    @IBAction func radioBtn2Action(_ sender: UIButton) {
        self.changeMode(mode: 2)
        self.selectModeImage(mode: modeVal)

    }
    
    @IBAction func radioBtn3Action(_ sender: UIButton) {
        self.changeMode(mode: 0)
        self.selectModeImage(mode: modeVal)
        
    }
    
    @IBAction func radioBtn4Action(_ sender: UIButton) {
        self.changeMode(mode: 3)
        self.selectModeImage(mode: modeVal)
    }
    
    
    func selectModeImage(mode:String){
        radioBtnImg1.image = UIImage(named: "UnSelectRadioBtn")
        radioBtnImg2.image = UIImage(named: "UnSelectRadioBtn")
        radioBtnImg3.image = UIImage(named: "UnSelectRadioBtn")
        radioBtnImg4.image = UIImage(named: "UnSelectRadioBtn")
        if mode == "00"{
            radioBtnImg3.image = UIImage(named: "SelectedRadioBtn")
        }
        else if mode == "01"{
            radioBtnImg1.image = UIImage(named: "SelectedRadioBtn")
        }
        else if mode == "02"{
            radioBtnImg2.image = UIImage(named: "SelectedRadioBtn")

        }
        else if mode == "03"{
            radioBtnImg4.image = UIImage(named: "SelectedRadioBtn")

        }else{}
    }

    
    func changeMode(mode:UInt8){
        hud?.show(in: self.view)
        FliprModeManager.shared.isWriteMode = true
        FliprModeManager.shared.writingValue = mode
        FliprModeManager.shared.connect( completion: { (error) in
            if error == nil{
                FliprModeManager.shared.readModeValue()
            }
//            if error == nil{
//                FliprModeManager.shared.setMode(mode: mode, completion: { error in
//                    
//                })
//            }
        })
    }
}
