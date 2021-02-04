//
//  CablesSelectionViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 16/07/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit
import SafariServices

class CablesSelectionViewController: UIViewController {
    
    
    @IBOutlet weak var cables2Button: UIButton!
    @IBOutlet weak var cables3Button: UIButton!
    @IBOutlet weak var cables4Button: UIButton!
    @IBOutlet weak var cables5Button: UIButton!
    @IBOutlet weak var webviewButton: UIButton!
    
    
    var equipmentCode = ""
    var inf90 = false
    var simultaneous = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webviewButton.setTitle("I have a doubt".localized(), for: .normal)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func webviewButtonAction(_ sender: Any) {
        if let url = URL(string: "https://videoapp.goflipr.com/MANUEL_HUB_zoom_cablages.pdf".localized) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(vc, animated: true)
        }
    }
    

    @IBAction func cables2ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            if inf90 {
                vc.guideName = "GUIDE_5"
                vc.showHelperLabel = true
            } else {
                vc.guideName = "GUIDE_2"
            }
            vc.step = 5
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cables3ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            if inf90 {
                vc.guideName = "GUIDE_5"
                vc.showHelperLabel = true
            } else {
                if simultaneous {
                    vc.guideName = "GUIDE_6"
                } else {
                    vc.guideName = "GUIDE_3"
                }
            }
            vc.step = 5
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func cables4ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            vc.guideName = "GUIDE_4"
            vc.cable4 = true
            vc.step = 5
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func cables5ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            vc.step = 5
            vc.guideName = "GUIDE_1"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
