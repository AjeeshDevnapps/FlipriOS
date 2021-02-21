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
        UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }, completion: nil)

    }
    
    
    func setupViews(){
        triggerContainerView.layer.cornerRadius = 15.0
        triggerContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        expertContainerView.layer.cornerRadius = 15.0
        expertContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        calibrationContainerView.layer.cornerRadius = 15.0
        calibrationContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        drainingContainerView.layer.cornerRadius = 15.0
        drainingContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        newStripContainerView.layer.cornerRadius = 15.0
        newStripContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    @IBAction func triggerMeasureButtonClicked(){
    
    }

    @IBAction func expertModeButtonClicked(){
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

    }
    
    @IBAction func drainingButtonClicked(){
    
    }
    
    @IBAction func newStripTestButtonClicked(){
        
    }
        
        
        
        
        
        
    

}
