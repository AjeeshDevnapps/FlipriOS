//
//  ActionsTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 06/04/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit

class ActionsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var stripLabel: UILabel!
    @IBOutlet weak var calibrationLabel: UILabel!
    @IBOutlet weak var expertModeLabel: UILabel!
    
    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var subscriptionImageView2: UIImageView!
    @IBOutlet weak var drainingLabel: UILabel!
    @IBOutlet weak var startMeasureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Flipr Expert".localized
        
        stripLabel.text = "New strip test".localized.uppercased()
        calibrationLabel.text = "New calibration".localized.uppercased()
        drainingLabel.text = "Draining".localized.uppercased()
        expertModeLabel.text = "Expert mode".localized.uppercased()
        startMeasureLabel.text = "Trigger a measurement".localized.uppercased()
        
        if let module = Module.currentModule {
            if module.isSubscriptionValid {
                subscriptionImageView.isHidden = true
                subscriptionImageView2.isHidden = true
            } else {
                subscriptionImageView.isHidden = false
                subscriptionImageView2.isHidden = false
            }
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
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
        
        if indexPath.row == 1 {
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
        
        if indexPath.row == 4 {
            
            if let module = Module.currentModule {
                if !module.isSubscriptionValid {
                    if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                        viewController.calibrationType = .simpleMeasure
                        self.navigationController?.pushViewController(viewController, animated: true)
                        self.navigationController?.setNavigationBarHidden(true, animated: false)
                    }
                }
            }
            
            
        }
        
    }
    
    /*
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
                        vc.modalPresentationStyle = .fullScreen
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
