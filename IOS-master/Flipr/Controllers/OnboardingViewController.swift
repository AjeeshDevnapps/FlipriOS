//
//  OnboardingViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 06/03/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit
import Alamofire
import SwiftVideoBackground

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var alreadyUserLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    let punchLines = ["Jusqu'à - 70% sur une sélection de locations vacances, campings et week-ends","Chaque semaine, 60 nouvelles destinations négociées par nos spécialistes","Vos vacances & week-ends en famille ne seront plus les mêmes !"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        signupButton.setTitle("Create account".localized, for: .normal)
        alreadyUserLabel.text = "Already a user?".localized
        loginButton.setTitle("Login".localized, for: .normal)
        
        //Flipr-eau2 |
        
        if User.currentUser == nil {
            try? VideoBackground.shared.play(view: view, videoName: "Flipr-eau2", videoType: "mp4", isMuted: true, darkness: 0.0, willLoopVideo: true, setAudioSessionAmbient: false)
        }
        
        if let user = User.currentUser {
            Omnisense.currentUser().registered = true
            Omnisense.saveCurrentUser()
            
            Alamofire.request(Router.updateLanguage).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    print("Update language response: \(value)")
                case .failure(let error):
                    print("Update language error: \(error.localizedDescription)")
                }
            })
            if let module = Module.currentModule {
                if !module.pH7CalibrationDone {
                    presentCalibrationViewController(type:.ph7, animated: false)
                } else if !module.pH4CalibrationDone {
                    presentCalibrationViewController(type:.ph4, animated: false)
                } else {
                    presentDashboard(animated: false)
                }
            } else if user.isActivated == false {
                //presentEmailVerificationController(animated: false)
                //Il doit se reconnecter car on ne sauvegarde pas le password
            } else {
                
                if HUB.currentHUB != nil {
                    presentDashboard(animated: false)
                } else {
                    presentLandingController(animated: false)
                }
            }
        }
        
        loadingView.isHidden = false
        loadingView.alpha = 1
        
        /*
        punchLineLabel.text = items[0]
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            if i >= items.count - 1 {
                i = 0
            } else {
                i = i+1
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.punchLineLabel.alpha = 0
            }, completion: { (success) in
                self.punchLineLabel.text = items[i]
                UIView.animate(withDuration: 0.25, animations: {
                    self.punchLineLabel.alpha = 1
                })
            })
            
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if User.currentUser == nil {
//            try? VideoBackground.shared.play(view: view, videoName: "Flipr-eau2", videoType: "mp4", isMuted: true, darkness: 0.0, willLoopVideo: true, setAudioSessionAmbient: false)
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25, animations: {
            self.loadingView.alpha = 0
        }) { (succes) in
            self.loadingView.isHidden = true
        }
//        if User.currentUser == nil {
            try? VideoBackground.shared.play(view: view, videoName: "Flipr-eau2", videoType: "mp4", isMuted: true, darkness: 0.0, willLoopVideo: true, setAudioSessionAmbient: false)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        VideoBackground.shared.pause()
    }
    

    func presentDashboard(animated:Bool) {
        if let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewControllerID") {
            dashboard.modalTransitionStyle = .flipHorizontal
            dashboard.modalPresentationStyle = .fullScreen
            self.present(dashboard, animated: animated, completion: {
                //self.signInStackView.alpha = 1 TODO mauqer la 1ere vue
            })
            
        }
    }
    
    func presentLandingController(animated:Bool) {
        let hubStoryboard = UIStoryboard(name: "HUB", bundle: nil)
        let viewController = hubStoryboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentActivationController(animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ActivationViewControllerID") {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func presentStripController(animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StripViewControllerID") {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func presentEmailVerificationController(animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationViewControllerID") {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func presentCalibrationViewController(type:CalibrationType, animated:Bool) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
            viewController.calibrationType = type
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    

}
