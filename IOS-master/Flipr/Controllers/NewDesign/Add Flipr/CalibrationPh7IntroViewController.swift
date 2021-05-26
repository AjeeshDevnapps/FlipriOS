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
    var recalibration = false

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.roundCorner(corner: 12)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "F2F9FE")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.tintColor = UIColor.blueColor()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Ph7CalibrationViewController") as! Ph7CalibrationViewController
        vc.recalibration = self.recalibration
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

}
