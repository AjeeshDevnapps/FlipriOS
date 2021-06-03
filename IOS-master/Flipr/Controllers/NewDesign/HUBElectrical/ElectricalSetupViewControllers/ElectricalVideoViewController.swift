//
//  ElectricalVideoViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 09/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class ElectricalVideoViewController: BaseViewController {
    
    var step = 0
    var equipmentCode = ""
    var inf90 = false
    var simultaneous = false
    var cable4 = false
    
    var showHelperLabel = false
    
    var guideName = "GUIDE_1"
    
    @IBOutlet weak var alertConfirmButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var centerVideoView: UIView!
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var alertTopConstraint: NSLayoutConstraint!
    var needsAlert = false
    @IBOutlet weak var helperLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoImgView: UIImageView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var confirmationTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        titleLabel.text = "Step 1".localized()
        alertView.layer.cornerRadius = 12
        alertTitleLabel.text = "Plutôt deux fois qu'une ! Nous préférons confirmer que vous avez bien coupé le courant avant de passer à l'étape suivante.".localized
        confirmationTitle.text = "Confirmation".localized
        alertConfirmButton.setTitle("J'ai bien coupé le courant".localized, for: .normal)
        nextButton.setTitle("Next".localized(), for: .normal)
        setupText()
        
        helperLabel.text = "Current <90V".localized()
        helperLabel.isHidden = !showHelperLabel
        nextButton.layer.cornerRadius = 12
        alertConfirmButton.layer.cornerRadius = 12
        let image = UIImage(named: "arrow_back-1")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.setImage(image, for: .highlighted)
        
        if !needsAlert {
            infoView.removeFromSuperview()
            view.setNeedsLayout()
        } else {
            infoView.layer.cornerRadius = 12
            infoView.layer.borderWidth = 2
            infoView.layer.borderColor = #colorLiteral(red: 0.239353925, green: 0.5618935227, blue: 0.6831510663, alpha: 1)
            
            let img = UIImage(named: "7B")?.withRenderingMode(.alwaysTemplate)
            infoImgView.image = img
            infoImgView.tintColor = #colorLiteral(red: 0.239353925, green: 0.5618935227, blue: 0.6831510663, alpha: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if step < 5 {
            gradientImageView.isHidden = false
            titleLabel.textColor = .white
            subtitleLabel.textColor = .white
            backButton.tintColor = .white
            VideoBackground.shared.videoGravity = .resizeAspectFill
            var urlString = "https://videoapp.goflipr.com/couper_electricite.mp4"
            var darkness = 0.33
            if step == 2 {
                titleLabel.textColor = .black
                subtitleLabel.textColor = #colorLiteral(red: 0.2901960784, green: 0.3333333333, blue: 0.4039215686, alpha: 1)
                backButton.tintColor = .black
                darkness = 0
                urlString = "https://videoapp.goflipr.com/emplacement.mp4"
            }
            if step == 3 {
                urlString = "https://videoapp.goflipr.com/couper_cable.mp4"
                titleLabel.text = "Step 3".localized()
            }
            if step == 4 {
                urlString = "https://videoapp.goflipr.com/denuder.mp4"
                titleLabel.text = "Step 4".localized()

            }
            if let url = URL(string: urlString) {
                try? VideoBackground.shared.play(view: view, url: url, darkness: CGFloat(darkness), isMuted: true, willLoopVideo: true, setAudioSessionAmbient: false, preventsDisplaySleepDuringVideoPlayback: true)
            }
            
        } else {
            backButton.tintColor = .black
            gradientImageView.isHidden = true
            subtitleLabel.textColor = #colorLiteral(red: 0.2901960784, green: 0.3333333333, blue: 0.4039215686, alpha: 1)
            VideoBackground.shared.videoGravity = .resizeAspect
             try? VideoBackground.shared.play(view: centerVideoView, videoName: guideName, videoType: "mp4", isMuted: true, darkness: 0.0, willLoopVideo: true, setAudioSessionAmbient: false)
        }
        
    }
        
    func setupText() {
        titleLabel.text = "Instructions"
        if step == 1 {
            titleLabel.text = "Step 1".localized()
            subtitleLabel.text = "Make sure the power to the selected equipment is turned off.".localized()
        }
        if step == 2 {
            titleLabel.text = "Step 2".localized()
            subtitleLabel.text = "Locate the power supply to your equipment and follow it to the cabinet.".localized()
        }
        if step == 3 {
            titleLabel.text = "Step 3".localized()
            subtitleLabel.text = "Cut and strip the cable. Leave about 1cm of copper and 4cm of sheath.".localized()
        }
        if step == 4 {
            titleLabel.text = "Step 4".localized()
            subtitleLabel.text = "Locate the different colors.".localized()
        }
        if step == 5 {
            titleLabel.text = "Step 5".localized()
            nextButton.setTitle("C’est fait !".localized, for: .normal)
            if cable4 {
                subtitleLabel.text = "Connect the cables in the order shown, remember to connect the neutral (BLUE)".localized()
            } else {
                subtitleLabel.text = "Connect the cables in the order shown".localized()
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func goToPrevious(_ sender: UIButton) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if step == 1 {
            self.confirmationAlert(show: true)
        }
        if step == 2 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
                vc.equipmentCode = equipmentCode
                vc.inf90 = inf90
                vc.simultaneous = simultaneous
                vc.step = 3
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if step == 3 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
                vc.equipmentCode = equipmentCode
                vc.inf90 = inf90
                vc.simultaneous = simultaneous
                vc.step = 4
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if step == 4 {
            //Afficher le choix des cables // passer le equipement code
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalCableSelectionViewController") as? ElectricalCableSelectionViewController {
                vc.equipmentCode = equipmentCode
                vc.inf90 = inf90
                vc.simultaneous = simultaneous
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if step == 5 {
//            let alert = UIAlertController(title: "Ready?".localized(), message:"Remember to restore the power before moving on!".localized(), preferredStyle:.alert)
//            alert.addAction(UIAlertAction(title: "It's done!".localized(), style: .default, handler: { (action) in
//                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBScanTableViewControllerID") as? HUBScanTableViewController {
//                    vc.equipmentCode = self.equipmentCode
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetupFifthStepViewController") as! SetupFifthStepViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func closeAlert(_ sender: UIButton) {
        self.confirmationAlert(show: false)
    }
    
    @IBAction func onAlertConfirmation(_ sender: UIButton) {
        if step == 1 {
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
//                vc.equipmentCode = self.equipmentCode
//                vc.inf90 = self.inf90
//                vc.simultaneous = self.simultaneous
//                vc.step = 2
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetupFifthStepViewController") as?  SetupFifthStepViewController {
                vc.equipmentCode = self.equipmentCode
                vc.inf90 = self.inf90
                vc.simultaneous = self.simultaneous
                vc.step = 2
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func confirmationAlert(show: Bool) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.30) {
            self.alertTopConstraint.constant = show ? -(self.alertView.height) : 100
            self.view.layoutIfNeeded()
        }
    }
}
