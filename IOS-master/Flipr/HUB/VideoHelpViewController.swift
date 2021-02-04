//
//  VideoHelpViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 16/07/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class VideoHelpViewController: UIViewController {
    
    var step = 0
    var equipmentCode = ""
    var inf90 = false
    var simultaneous = false
    var cable4 = false
    
    var showHelperLabel = false
    
    var guideName = "GUIDE_1"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var centerVideoView: UIView!
    @IBOutlet weak var gradientImageView: UIImageView!
    
    @IBOutlet weak var helperLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Instructions".localized()
        prevButton.setTitle("Previous".localized(), for: .normal)
        nextButton.setTitle("Next".localized(), for: .normal)
        setupText()
        
        helperLabel.text = "Current <90V".localized()
        helperLabel.isHidden = !showHelperLabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if step < 5 {
            prevButton.tintColor = .white
            gradientImageView.isHidden = false
            titleLabel.textColor = .white
            subtitleLabel.textColor = .white
            
            var urlString = "https://videoapp.goflipr.com/couper_electricite.mp4"
            var darkness = 0.33
            if step == 2 {
                titleLabel.textColor = .black
                subtitleLabel.textColor = .black
                darkness = 0
                urlString = "https://videoapp.goflipr.com/emplacement.mp4"
            }
            if step == 3 {
                urlString = "https://videoapp.goflipr.com/couper_cable.mp4"
            }
            if step == 4 {
                urlString = "https://videoapp.goflipr.com/denuder.mp4"
            }
            if let url = URL(string: urlString) {
                try? VideoBackground.shared.play(view: view, url: url, darkness: CGFloat(darkness), isMuted: true, willLoopVideo: true, setAudioSessionAmbient: false, preventsDisplaySleepDuringVideoPlayback: true)
            }
            
        } else {
            gradientImageView.isHidden = true
             try? VideoBackground.shared.play(view: centerVideoView, videoName: guideName, videoType: "mp4", isMuted: true, darkness: 0.0, willLoopVideo: true, setAudioSessionAmbient: false)
        }
        
    }
    
    func setupText() {
        titleLabel.text = "Instructions"
        if step == 1 {
            subtitleLabel.text = "Step 1: Make sure the power to the selected equipment is turned off.".localized()
        }
        if step == 2 {
            subtitleLabel.text = "Step 2: Locate the power supply to your equipment and follow it to the cabinet.".localized()
        }
        if step == 3 {
            subtitleLabel.text = "Step 3: Cut and strip the cable. Leave about 1cm of copper and 4cm of sheath.".localized()
        }
        if step == 4 {
            subtitleLabel.text = "Step 4: Locate the different colors.".localized()
        }
        if step == 5 {
            if cable4 {
                subtitleLabel.text = "Step 5: Connect the cables in the order shown, remember to connect the neutral (BLUE)".localized()
            } else {
                subtitleLabel.text = "Step 5: Connect the cables in the order shown".localized()
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
    
    @IBAction func prevButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if step == 1 {
            let alert = UIAlertController(title: "Make sure the electricity is off".localized, message:nil, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "It's done!".localized(), style: .default, handler: { (action) in
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                    vc.equipmentCode = self.equipmentCode
                    vc.inf90 = self.inf90
                    vc.simultaneous = self.simultaneous
                    vc.step = 2
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        if step == 2 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                vc.equipmentCode = equipmentCode
                vc.inf90 = inf90
                vc.simultaneous = simultaneous
                vc.step = 3
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if step == 3 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                vc.equipmentCode = equipmentCode
                vc.inf90 = inf90
                vc.simultaneous = simultaneous
                vc.step = 4
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if step == 4 {
            //Afficher le choix des cables // passer le equipement code
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CablesSelectionViewControllerID") as? CablesSelectionViewController {
                vc.equipmentCode = equipmentCode
                vc.inf90 = inf90
                vc.simultaneous = simultaneous
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if step == 5 {
            let alert = UIAlertController(title: "Ready?".localized(), message:"Remember to restore the power before moving on!".localized(), preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "It's done!".localized(), style: .default, handler: { (action) in
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBScanTableViewControllerID") as? HUBScanTableViewController {
                    vc.equipmentCode = self.equipmentCode
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
