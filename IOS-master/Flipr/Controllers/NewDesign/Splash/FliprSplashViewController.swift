//
//  FliprSplashViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 31/03/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import Alamofire

extension UIView {


    func rotate(degrees: CGFloat) {

        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))

        // If you like to use layer you can uncomment the following line
        //layer.transform = CATransform3DMakeRotation(degreesToRadians(degrees), 0.0, 0.0, 1.0)
    }
}

class FliprSplashViewController: BaseViewController {
    @IBOutlet weak var rightAnimationImageView: UIImageView!
    @IBOutlet weak var leftAnimationImageView: UIImageView!
    @IBOutlet weak var waveAnimationImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var rightAnimationContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    
    @IBOutlet weak var waveAnimationImageViewYpost: NSLayoutConstraint!
    @IBOutlet weak var logoImageViewYpost: NSLayoutConstraint!
    
    var userStatusChecking = false
    var isAnimationCompleted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        userStatusChecking = true
        self.imageView.isHidden = true
        perform(#selector(showWaveAnimation), with: nil, afterDelay: 0.5)
        perform(#selector(showEducationScreen), with: nil, afterDelay: 2.0)
        addRightImage()
        self.titleLabel.text = "Goodbye to troubled waters".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func showEducationScreen(){
        if userStatusChecking == false{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginEducationViewOneController") as! LoginEducationOneViewController
//            self.navigationController?.pushViewController(vc)
        }
    }
    
    
    func addRightImage(){
        self.rightAnimationImageView.transform = CGAffineTransform(translationX: 110.0, y: 0.0)
        self.leftAnimationImageView.transform = CGAffineTransform(translationX: -58.0, y: 0.0)

        UIView.animate(withDuration: 1, animations: {
            let rightRotationMatrix = CGAffineTransform(rotationAngle: -0.01)
            let rightTranslationMatrix = CGAffineTransform(translationX: 0.0, y: 0.0)
            self.rightAnimationImageView.transform = rightRotationMatrix.concatenating(rightTranslationMatrix)
            let leftRotationMatrix = CGAffineTransform(rotationAngle: 0.01)
            let leftTranslationMatrix = CGAffineTransform(translationX: 0.0, y: 0.0)
            self.leftAnimationImageView.transform = leftRotationMatrix.concatenating(leftTranslationMatrix)
        })
        
    }
    
    
    @objc func showWaveAnimation(){
        waveAnimationImageView.isHidden = false
        self.waveAnimationImageViewYpost.constant = 0
        self.logoImageViewYpost.constant =  self.logoImageViewYpost.constant - 100
        UIView.animate(withDuration: 0.5) {
            self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.checkUserStatus()
            }
        }
    }
    
    func checkUserStatus(){
        
        if User.currentUser == nil {
            userStatusChecking = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginEducationViewOneController") as! LoginEducationOneViewController
            self.navigationController?.pushViewController(vc)
        
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
        
    }
    
    
}


extension FliprSplashViewController{
    
    func presentDashboard(animated:Bool) {
//        let mainSB = UIStoryboard.init(name: "Dashboard", bundle: nil)
//        let dashboard = mainSB.instantiateViewController(withIdentifier: "NewDashboardViewController")
//        dashboard.modalTransitionStyle = .flipHorizontal
//        dashboard.modalPresentationStyle = .fullScreen
//        self.present(dashboard, animated: animated, completion: {
//        })
//
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let dashboard = mainSB.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: animated, completion: {
        })
    }
    
    func presentLandingController(animated:Bool) {
        let hubStoryboard = UIStoryboard(name: "HUB", bundle: nil)
        let viewController = hubStoryboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.setViewControllers([vc,viewController], animated: true)
//        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentActivationController(animated:Bool) {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = mainSB.instantiateViewController(withIdentifier: "ActivationViewControllerID")
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentStripController(animated:Bool) {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = mainSB.instantiateViewController(withIdentifier: "StripViewControllerID")
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentEmailVerificationController(animated:Bool) {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
         let viewController = mainSB.instantiateViewController(withIdentifier: "EmailVerificationViewControllerID")
            self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentCalibrationViewController(type:CalibrationType, animated:Bool) {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = mainSB.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController{
            viewController.calibrationType = type
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
}
