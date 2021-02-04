//
//  HUBWifiTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/03/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class HUBWifiTableViewController: UITableViewController {
    
    var fromSetting = false
    var serial:String?
    var networks: [HUBWifiNetwork] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if HUBManager.shared.connectedHub == nil, let serial = serial {
            
            let theme = EmptyStateViewTheme.shared
            theme.activityIndicatorType = .orbit
            theme.titleColor = K.Color.DarkBlue
            theme.messageColor = .lightGray
            self.view.showEmptyStateViewLoading(title: "Searching for HUB with serial: \(serial)".localized, message: "Be sure to be close to your HUB and your Bluetooth is turned on.".localized, theme: theme)
            
            HUBManager.shared.detectedHubs.removeAll()
            HUBManager.shared.scanForHubs(serials: [serial]) { (info) in
                self.view.hideStateView()
                HUBManager.shared.connect(serial: serial) { (error) in
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    } else {
                        self.tableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.refreshButtonAction(self)
                        }
                        
                    }
                    HUBManager.shared.stopScanForHubs()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                 self.refreshButtonAction(self)
            }
           
        }
        
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        networks.removeAll()
        self.tableView.reloadData()
        HUBManager.shared.getAvailableWifi { (network, error) in
            if error != nil {
                self.showError(title: "Error".localized, message: error!.localizedDescription)
            } else if network != nil {
                self.networks.append(network!)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            if HUBManager.shared.connectedHub != nil {
                return 1
            } else {
                return 0
            }
        }
        return networks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FliprHUBWifiIndicatorCell", for: indexPath)
            if let indicator = cell.viewWithTag(1) as? UIActivityIndicatorView {
                indicator.startAnimating()
            }
            if let label = cell.viewWithTag(2) as? UILabel {
                label.text = "Recherche en cours..."
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wifiNetworkCell", for: indexPath)

        let network = networks[indexPath.row]
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = network.ssid
        }
        if let label = cell.viewWithTag(2) as? UILabel {
            if network.isHUBConnected {
                label.text = "Connecté"
                label.font = UIFont.boldSystemFont(ofSize: 17)
                label.textColor = K.Color.Green
            } else {
                label.text = "Non connecté"
                label.font = UIFont.systemFont(ofSize: 17)
                label.textColor = .lightGray
            }
        }
        
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let network = networks[indexPath.row]
        
        if network.isHUBConnected {
            
            let alertController = UIAlertController(title: network.ssid, message: "Voulez-vous déconnecter le HUB de ce réseau WIFI ?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Déconnecter".localized, style: .destructive, handler: { (action) -> Void in
                let hud = JGProgressHUD(style:.dark)
                hud?.show(in: self.navigationController!.view)
                HUBManager.shared.deleteWifi(index: network.index) { (error) in
                    if (error != nil) {
                        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud?.textLabel.text = error?.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    } else {
                        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud?.textLabel.text = "Disconnected!".localized
                        hud?.dismiss(afterDelay: 3)
                        self.refreshButtonAction(self)
                    }
                }
                
            })
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        var passwordTextField: UITextField?
        
        let alertController = UIAlertController(title: network.ssid, message: "Enter wifi password".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Connect".localized, style: .default, handler: { (action) -> Void in
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            HUBManager.shared.setWifi(network: network, password: (passwordTextField?.text)!) { (error) in
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.textLabel.text = "Connected!".localized
                    hud?.dismiss(afterDelay: 3)
                    self.refreshButtonAction(self)
                }
                if !self.fromSetting {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CongratsViewControllerID") as? CongratsViewController {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                
            }
            
        })
        
        //sendAction.isEnabled = (loginTextField?.text?.isEmail)!
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            passwordTextField = textField
            //passwordTextField?.isSecureTextEntry = true
            //passwordTextField?.text = "NMQ0QHFFTA0"
            passwordTextField?.placeholder = "Password...".localized
        }
        present(alertController, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
