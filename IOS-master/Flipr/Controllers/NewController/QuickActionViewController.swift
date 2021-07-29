//
//  QuickActionViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class QuickActionViewController: UIViewController {
    @IBOutlet weak var triggerContainerView: UIView!
    @IBOutlet weak var expertContainerView: UIView!
    @IBOutlet weak var calibrationContainerView: UIView!
    @IBOutlet weak var drainingContainerView: UIView!
    @IBOutlet weak var newStripContainerView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var measurementLbl: UILabel!
    @IBOutlet weak var expertLbl: UILabel!
    @IBOutlet weak var callibrationLbl: UILabel!
    @IBOutlet weak var drainingLbl: UILabel!
    @IBOutlet weak var stripTestLbl: UILabel!

    @IBOutlet  var bottonContainerContraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        containerView.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(rawValue: 0), animations: {
//            self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        }, completion: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                }, completion: nil)

//        self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    func setupViews(){
        if UIScreen.main.nativeBounds.height < 1334{
            bottonContainerContraint.constant = 576 - 70
        }
        titleLbl.text = "Quick Actions".localized
        measurementLbl.text = "Trigger a Measurement".localized
        expertLbl.text  = "Expert Mode".localized
        callibrationLbl.text  = "New Calibration".localized
        drainingLbl.text  = "Add a Flipr Hub".localized
        if Module.currentModule == nil{
            triggerContainerView.alpha = 0.3
        }else{
            triggerContainerView.alpha = 1.0
        }
        
        stripTestLbl.text  = "New strip test".localized
//
//        triggerContainerView.layer.cornerRadius = 15.0
//        triggerContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        expertContainerView.layer.cornerRadius = 15.0
//        expertContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        calibrationContainerView.layer.cornerRadius = 15.0
//        calibrationContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        drainingContainerView.layer.cornerRadius = 15.0
//        drainingContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
//        newStripContainerView.layer.cornerRadius = 15.0
//        newStripContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHubButtonClicked(){
    
        let fliprStoryboard = UIStoryboard(name: "HUBElectrical", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "ElectricalSetupViewController") as! ElectricalSetupViewController
        viewController.isPresentView = true
        let navigationVC = UINavigationController.init(rootViewController: viewController)
        self.present(navigationVC, animated: true)
    }
    
    @IBAction func triggerMeasureButtonClicked(){
        if  Module.currentModule == nil{
            return
        }
        
    /*
        if let module = Module.currentModule {
            if !module.isSubscriptionValid {
                if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
       */
                
                let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
                if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                    viewController.calibrationType = .simpleMeasure
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                }
//            }
//        }
    }

    @IBAction func expertModeButtonClicked(){
//        self.newStripTestButtonClicked()
//        return
        let tmpSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let navigationController = tmpSb.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
            if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
                navigationController.modalPresentationStyle = .fullScreen
                viewController.isDirectPresenting = true
                navigationController.setViewControllers([viewController], animated: false)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func newCalibrationButtonClicked(){
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        let alert = UIAlertController(title: "Calibration".localized, message:"Are you sure you want to calibrate the probes again?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            self.showCalibrationView()
//            if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
//                viewController.recalibration = true
//                viewController.calibrationType = .ph7
//                viewController.modalPresentationStyle = .fullScreen
//                let nav = UINavigationController.init(rootViewController: viewController)
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
//            }
        }))
        alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
            if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func drainingButtonClicked(){
//        WaterLevelTableViewController
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewController = mainSb.instantiateViewController(withIdentifier: "WaterLevelTableViewController") as? WaterLevelTableViewController {
//            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true, completion: nil)
//
            let navigationController = LightNavigationViewController.init(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion:nil)

        }
    }
    
    @IBAction func newStripTestButtonClicked(){
        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
        let alert = UIAlertController(title: "Strip test".localized, message:"Are you sure you want to do a new strip test?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            let sb:UIStoryboard = UIStoryboard.init(name: "Calibration", bundle: nil)
            if let viewController = sb.instantiateViewController(withIdentifier: "StripViewControllerID") as? StripViewController {
                viewController.recalibration = true
                viewController.isPresentView = true
//                viewController.modalPresentationStyle = .fullScreen
//                self.present(viewController, animated: true, completion: nil)
//                let navigationController = LightNavigationViewController.init(rootViewController: viewController)
//                navigationController.modalPresentationStyle = .fullScreen
//                self.present(navigationController, animated: true, completion:nil)
//                
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)

            }
        }))
        alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
            if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
        
        
    // Helper function inserted by Swift 4.2 migrator.
     func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }

   
    func showCalibrationView(){
        
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationPh7IntroViewController") as! CalibrationPh7IntroViewController
        vc.isPresentedFlow = true
        vc.recalibration = true
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
