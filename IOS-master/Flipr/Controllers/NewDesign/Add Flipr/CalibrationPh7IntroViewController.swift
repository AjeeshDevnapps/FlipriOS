//
//  CalibrationPh7IntroViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import AVKit

class CalibrationPh7IntroViewController: BaseViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var subTitleContainerView: UIView!

    @IBOutlet weak var contentLine1Lbl: UILabel!
    @IBOutlet weak var contentLine2Lbl: UILabel!
    @IBOutlet weak var contentLine3Lbl: UILabel!
    @IBOutlet weak var contentLine4Lbl: UILabel!
    var isAddingNewDevice = false

    
    var recalibration = false
    @IBOutlet weak var titlLbl: UILabel!
    var isPresentedFlow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.roundCorner(corner: 12)
        submitButton.setTitle("Initialiser".localized, for: .normal)
        subTitleContainerView.roundCorner(corner: 12)
        subTitleContainerView.layer.borderWidth = 2.0
        subTitleContainerView.layer.borderColor = UIColor.init(hexString: "3D8FAE").cgColor
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "F2F9FE")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        var titleString  = "Calibration".localized
        titleString.append(" Ph7")
        titlLbl.text  = titleString
        subTitleLbl.text = "La partie basse contient du liquide. Gardez Flipr à la verticale lors du dévissage.".localized
        
        contentLine1Lbl.text  = "Dévissez la partie basse du Flipr. La partie basse se compose soit du capuchon de Flipr (cache plein), soit d’un cache ajouré. Si vous dévissez le capuchon, du liquide se trouve dedans : vous pouvez le jeter.".localized
        contentLine2Lbl.text  = "Munissez-vous du capuchon. Versez le contenu du flacon bleu dans le capuchon.".localized
        contentLine3Lbl.text  = "Vissez le capuchon sur l’appareil.".localized
        contentLine4Lbl.text  = "Cliquez sur le bouton \"Initialiser\".".localized

//        self.navigationController?.navigationBar.tintColor = UIColor.blueColor()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Ph7CalibrationViewController") as! Ph7CalibrationViewController
        vc.recalibration = self.recalibration
        vc.dismissEnabled = self.isPresentedFlow
        if isAddingNewDevice{
            vc.isAddingNewDevice =  self.isAddingNewDevice
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func backButtonTapped() {
        if self.isPresentedFlow{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
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

}
