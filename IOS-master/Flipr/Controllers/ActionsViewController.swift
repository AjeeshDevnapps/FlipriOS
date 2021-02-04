//
//  ActionsViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 18/04/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit

class ActionsViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var stripLabel: UILabel!
    @IBOutlet weak var calibrationLabel: UILabel!
    @IBOutlet weak var expertModeLabel: UILabel!
    
    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var drainingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flipr Expert".localized
        
        if let module = Module.currentModule {
            if module.isForSpa {
                backgroundImageView.image = UIImage(named:"BG_spa")
            }
            if module.isSubscriptionValid {
                subscriptionImageView.isHidden = true
            } else {
                subscriptionImageView.isHidden = false
            }
        }
        
        stripLabel.text = "New strip test".localized.uppercased()
        calibrationLabel.text = "New calibration".localized.uppercased()
        drainingLabel.text = "Draining".localized.uppercased()
        expertModeLabel.text = "Expert mode".localized.uppercased()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func calibrationButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Calibration".localized, message:"Are you sure you want to calibrate the probes again?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                viewController.recalibration = true
                viewController.calibrationType = .ph7
                self.navigationController?.pushViewController(viewController, animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }))
        alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
            if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func stripButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Strip test".localized, message:"Are you sure you want to do a new strip test?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StripViewControllerID") as? StripViewController {
                viewController.recalibration = true
                self.navigationController?.pushViewController(viewController, animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }))
        alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
            if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "expert" {
            if let module = Module.currentModule {
                if !module.isSubscriptionValid {
                    if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                        self.present(vc, animated: true, completion: nil)
                    }
                    return false
                }
            }
        }
        return true
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
