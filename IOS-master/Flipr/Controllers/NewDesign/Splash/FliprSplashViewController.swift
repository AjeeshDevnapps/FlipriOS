//
//  FliprSplashViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 31/03/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

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
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    var places = [PlaceDropdown]()
    
    var placesList = [PlaceDropdown]()
    var invitationList = [PlaceDropdown]()
    
    
    var placesModules = [PlaceModule]()
    
    let hud = JGProgressHUD(style:.light)
    var haveInvitation = false
    var havePlace = false
    var placeTitle : String?
    
    var selectedPlace : PlaceDropdown?
    
    
    var userStatusChecking = false
    var isAnimationCompleted = false
    var isApiCallOnProgress = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userStatusChecking = true
        self.imageView.isHidden = true
        self.isApiCallOnProgress = true
        self.checkUserStatusForWatr()
        perform(#selector(showWaveAnimation), with: nil, afterDelay: 0.5)
        perform(#selector(showEducationScreen), with: nil, afterDelay: 2.0)
        addRightImage()
        //        self.titleLabel.text = "Goodbye to troubled waters".localized
//        self.checkUserStatusForWatr()
        //        self.checkUserStatus()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppSharedData.sharedInstance.logout{
            AppSharedData.sharedInstance.logout = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isNeedToHideBackButton = true
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = false
            } else {
                // Fallback on earlier versions
            }
            self.navigationController?.setViewControllers([vc], animated: true)
        }
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
//        self.logoImageViewYpost.constant =  self.logoImageViewYpost.constant - 100
        UIView.animate(withDuration: 0.5) {
            self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                self.checkUserStatus()
//                self.checkUserStatusForWatr()
            }
        }
    }
    
    
    
    func checkUserStatusForWatr(){
        if User.currentUser == nil {
            userStatusChecking = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EducationScreenContainerViewController") as! EducationScreenContainerViewController
            self.navigationController?.pushViewController(vc)
            
        }
        else{
            if let user = User.currentUser {
                //            Omnisense.currentUser().registered = true
                //            Omnisense.saveCurrentUser()
                
                Alamofire.request(Router.updateLanguage).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        print("Update language response: \(value)")
                    case .failure(let error):
                        print("Update language error: \(error.localizedDescription)")
                    }
                })
//                DispatchQueue.main.async {
//                    self.indicator.startAnimating()
//                }
                DispatchQueue.global().async {
                    self.checkUserPlaces()
                }
                
                
                /*
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
                 */
            }
            
        }
        
    }
    
    
    func checkUserPlaces(){
//        hud?.show(in: self.view)
        User.currentUser?.getPlaces(completion: { (placesResult,error) in
            DispatchQueue.main.async {
//                self.indicator.stopAnimating()
            }

            if (error != nil) {
                DispatchQueue.main.async {
                    self.showError(title: "Error", message: error?.localizedDescription)
                }
//                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
//                self.hud?.textLabel.text = error?.localizedDescription
//                self.hud?.dismiss(afterDelay: 0)
            } else {
                if placesResult != nil{
                    self.places = placesResult!
                    self.placesList = self.places.filter { $0.isPending == false }
                    self.invitationList = self.places.filter { $0.isPending == true }
                    self.haveInvitation = false
                    self.havePlace = false
                    AppSharedData.sharedInstance.havePlace = false
                    AppSharedData.sharedInstance.haveInvitation = false
                    if self.placesList.count > 0 {
                        self.havePlace = true
                        AppSharedData.sharedInstance.havePlace = true
                    }
                    if self.invitationList.count > 0 {
                        self.haveInvitation = true
                        AppSharedData.sharedInstance.haveInvitation = true
                    }
//                    self.hud?.dismiss(afterDelay: 0)
                }
            }
            self.processFlow()
        })
    }
    
    
    func processFlow(){
        
        let fName = User.currentUser?.firstName ?? ""
        let lName = User.currentUser?.lastName ?? ""

        if fName.isValidString && lName.isValidString{
            if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                if (currentUnit != 1) && (currentUnit != 2){
                    self.showUnitSelectionView()
                }else{
                    self.checkPlaceViewFlow()
                }
            }else{
                self.showUnitSelectionView()
            }
        }else{
            self.showUpdateProfile()
        }
        
    }
    
    
    func checkPlaceViewFlow(){
        if haveInvitation{
            if AppSharedData.sharedInstance.havePlace{
                self.showPlaceDropdownView()
            }else{
                showNoPlaceVC()
            }
        }else{
            if AppSharedData.sharedInstance.havePlace{
                self.showDashboardView()
            }
            else{
                showNoPlaceVC()
//                self.addPlaceView()
            }
        }
    }
    
    func showNoPlaceVC(){
        let sb = UIStoryboard.init(name: "Watr", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NoPlaceIntroViewController") as? NoPlaceIntroViewController {
            if haveInvitation{
                viewController.haveInvitation = haveInvitation
                viewController.invitationList =  self.invitationList
            }
//            viewController.delegate = self
//            viewController.placeTitle = self.selectedPlaceDetailsLbl.text
//            viewController.modalPresentationStyle = .overCurrentContext
//            self.present(viewController, animated: true) {
//            }
//            viewController.isInvitationFlow = true
            self.navigationController?.pushViewController(viewController, completion: nil)
        }

    }
    
    func showPlaceDropdownView(){
        let sb = UIStoryboard.init(name: "Watr", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "PlaceDropdownViewController") as? PlaceDropdownViewController {
//            viewController.delegate = self
//            viewController.placeTitle = self.selectedPlaceDetailsLbl.text
//            viewController.modalPresentationStyle = .overCurrentContext
//            self.present(viewController, animated: true) {
//            }
            viewController.isInvitationFlow = true
            self.navigationController?.pushViewController(viewController, completion: nil)
        }
    }
    
    
    func addPlaceView(){
        let sb = UIStoryboard(name: "NewLocation", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NewLocationViewControllerID") as? NewLocationViewController {
//            AppSharedData.sharedInstance.isAddPlaceFlow = true
            self.navigationController?.pushViewController(viewController, completion: nil)
            //            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true)
        }
    }
    
    
    func showUnitSelectionView(){
        let sb = UIStoryboard.init(name: "Settings", bundle: nil)
        if let unintVC = sb.instantiateViewController(withIdentifier: "PreferenceViewController") as? PreferenceViewController{
            unintVC.isLoginFlow = true
            self.navigationController?.pushViewController(unintVC)
        }
    }
    
    func showDashboardView(){
        presentDashboard(animated: false)

    }
    
    
    func showUpdateProfile(){
        let completeProfileVC =  self.storyboard?.instantiateViewController(withIdentifier: "CompleteProfileViewController") as! CompleteProfileViewController
        self.navigationController?.pushViewController(completeProfileVC, completion: nil)
    }
    
    
    func checkUserStatus(){
        
        if User.currentUser == nil {
            userStatusChecking = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EducationScreenContainerViewController") as! EducationScreenContainerViewController
            self.navigationController?.pushViewController(vc)
            
        }
        
        if let user = User.currentUser {
            //            Omnisense.currentUser().registered = true
            //            Omnisense.saveCurrentUser()
            
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
        let viewController = hubStoryboard.instantiateViewController(withIdentifier: "LandingViewControllerID") as! LandingViewController
        viewController.isSignupFlow = true
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

