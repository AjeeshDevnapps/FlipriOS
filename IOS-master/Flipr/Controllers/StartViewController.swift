//
//  StartViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 26/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Calibration is complete!".localized
        messageLabel.text = "Now place the Flipr in your pool...".localized
        
        if let module = Module.currentModule {
            if module.isForSpa {
                messageLabel.text = "Now place the Flipr in your spa...".localized
            }
            if let version = module.version {
                if version > 1 {
                    imageView.image = UIImage(named:"illu_vise")
                    if module.isForSpa {
                        messageLabel.text = "Now place Flipr in your spa. Do not forget to unscrew the bottom part of the Flipr and screw the grid before filling!".localized
                    } else {
                        messageLabel.text = "Now place Flipr in your pool. Do not forget to unscrew the bottom part of the Flipr and screw the grid before filling!".localized
                    }
                }
            }
        }
        
        doneButton.setTitle("It's done!".localized, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneButtonAction(_ sender: Any) {
        
        stackView.isHidden = true
        
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballZigZag
        self.view.showEmptyStateViewLoading(title: "Launch of the 1st measure".localized, message: "Connecting to flipr...".localized, theme: theme)
        
        BLEManager.shared.startMeasure { (error) in
            
            BLEManager.shared.doAcq = false
            
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                self.view.hideStateView()
                self.stackView.isHidden = false
            } else {
                UserDefaults.standard.set(Date(), forKey:"FirstMeasureStartDate")
                if let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewControllerID") {
                    dashboard.modalTransitionStyle = .flipHorizontal
                    dashboard.modalPresentationStyle = .fullScreen
                    self.present(dashboard, animated: true, completion: { 
                        self.navigationController?.popToRootViewController(animated: false)
                    })
                }
            }
        }
        
        
    }

}
