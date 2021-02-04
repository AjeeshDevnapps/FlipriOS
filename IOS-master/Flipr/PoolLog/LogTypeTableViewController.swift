//
//  LogTypeTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 26/07/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit
import Alamofire

class LogTypeTableViewController: UITableViewController {
    
    let nativeTypes = [3,4,10,7]
    var logTypes = [LogType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Categories".localized()
        
        Alamofire.request(Router.getLogTypes).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                if let JSON = value as? [[String:Any]] {
                    
                    print("get log types JSON \(JSON)")
                    
                    for item in JSON {
                        if let logType = LogType(withJSON: item) {
                            if logType.isAutoEntry < 1 || self.nativeTypes.contains(logType.id) {
                                self.logTypes.append(logType)
                            }
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    print("response.result.value: \(value)")
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    self.showError(title: "Error".localized, message: error.localizedDescription)
                }
                
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    self.showError(title: "Error".localized, message: serverError.localizedDescription)
                } else {
                     self.showError(title: "Error".localized, message: error.localizedDescription)
                }
            }
            
        })
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return logTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logTypeCell", for: indexPath)

        cell.textLabel?.text = logTypes[indexPath.row].value

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let indexPath = tableView.indexPathForSelectedRow {
            let id = logTypes[indexPath.row].id
            if self.nativeTypes.contains(id) {
                if id == 3 {
                    //Nouvel équipement
                    if let navC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EquipmentNavigationControllerID") as? UINavigationController {
                        if let vc = navC.viewControllers[0] as? EquipmentTableViewController {
                            navigationController?.show(vc, sender: self)
                        }
                    }
                }
                if id == 4 {
                    //Nouvel produit
                    if let navC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StockNavigationControllerID") as? UINavigationController {
                        if let vc = navC.viewControllers[0] as? ProductTableViewController {
                            navigationController?.show(vc, sender: self)
                        }
                    }
                }
                if id == 10 {
                    //Nouvel bandelette
                    let alert = UIAlertController(title: "Strip test".localized, message:"Are you sure you want to do a new strip test?".localized, preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripViewControllerID") as? StripViewController {
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
                if id == 7 {
                    //Nouvel videnage
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WaterLevelViewControllerID") as? WaterLevelViewController {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PoolLogEditViewController, let indexPath = tableView.indexPathForSelectedRow {
            vc.logType = logTypes[indexPath.row]
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
