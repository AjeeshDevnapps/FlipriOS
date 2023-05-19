//
//  CalibrationChlorineIntroViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import AVKit

class CalibrationChlorineIntroViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

    @IBOutlet weak var titlLbl: UILabel!
    
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var subTitleContainerView: UIView!

    @IBOutlet weak var contentLine1Lbl: UILabel!
    @IBOutlet weak var contentLine2Lbl: UILabel!
    @IBOutlet weak var contentLine3Lbl: UILabel!
    @IBOutlet weak var contentLine4Lbl: UILabel!

    var recalibration = false
    var isAddingNewDevice = false

    override func viewDidLoad() {
        super.viewDidLoad()
        var titleString  = "Calibration".localized
        titleString.append(" Ph4")
        titlLbl.text  = titleString
        submitButton.roundCorner(corner: 12)
        subTitleLbl.text = "La partie basse contient du liquide. Gardez Flipr à la verticale lors du dévissage.".localized
        
        contentLine1Lbl.text  = "Dévissez la partie basse du Flipr.Versez le liquide précédemment utilisé dans un récipient.".localized
        contentLine2Lbl.text  = "Versez le contenu du flacon rouge dans le capuchon.".localized
        contentLine3Lbl.text  = "Vissez le capuchon sur l’appareil.".localized
        contentLine4Lbl.text  = "Cliquez sur le bouton \"Initialiser\".".localized
        
        if isAddingNewDevice{
            if AppSharedData.sharedInstance.deviceSerialNo.hasPrefix("F"){
                self.skipButton.isHidden = false
            }else{
                self.skipButton.isHidden = true
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChlorineCalibrationViewController") as! ChlorineCalibrationViewController
        vc.recalibration = self.recalibration
        if isAddingNewDevice{
            vc.isAddingNewDevice =  self.isAddingNewDevice
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func playVideoButtonAction(_ sender: Any) {
        if let videoURL = URL(string: "http://videoapp.goflipr.com/democalib.mp4".localized.remotable("CALIBRATION_VIDEO_URL")) {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.navigationController?.present(playerViewController, animated: true, completion: nil)
            playerViewController.player!.play()
        }
        
    }

    @IBAction func skipButton(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Gateway", bundle: nil).instantiateViewController(withIdentifier: "GateWayListingViewController") as? GateWayListingViewController{
            vc.isSkipping = true
            self.navigationController?.pushViewController(vc)
        }
    }
    

}
