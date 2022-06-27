//
//  WifiListViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class WifiListViewController: BaseViewController {
    @IBOutlet weak var controllerTitle: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var serial:String?

    var isFromSetting = false
    var networks: [HUBWifiNetwork] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        self.navigationController?.isNavigationBarHidden = true
        connectWifi()
        
    }
    
    func connectWifi(){
        if HUBManager.shared.connectedHub == nil, let serial = serial {
            let theme = EmptyStateViewTheme.shared
            theme.activityIndicatorType = .orbit
            theme.titleColor = K.Color.DarkBlue
            theme.messageColor = .lightGray
            let msg = "Searching for HUB with serial:".localized
            self.view.showEmptyStateViewLoading(title: "\(msg) \(serial)", message: "Be sure to be close to your HUB and your Bluetooth is turned on.".localized, theme: theme)
            HUBManager.shared.detectedHubs.removeAll()
            HUBManager.shared.scanForHubs(serials: [serial]) { (info) in
                self.view.hideStateView()
                HUBManager.shared.connect(serial: serial) { (error) in
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    } else {
                        self.tableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.refreshWifiList()
                        }
                        
                    }
                    HUBManager.shared.stopScanForHubs()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.refreshWifiList()
            }
        }
    }
    
    
    func refreshWifiList() {
        HUBManager.shared.getAvailableWifi { (network, error) in
            if error != nil {
                self.showError(title: "Error".localized, message: error!.localizedDescription)
//                self.networks.append(HUBWifiNetwork(withJSON: ["r": "Freebox de Max", "b": "qweda", "q":1, "g": 32, "e": false])!)
            } else if network != nil {
                self.networks.append(network!)
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        goBack()
    }
}

extension WifiListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WifiListTableViewCell") as! WifiListTableViewCell
        let network = networks[indexPath.row]
        cell.wifiNameLabel.text = network.ssid
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard networks.count > 0 else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HUBNamingViewController") as! HUBNamingViewController
            vc.serial = self.serial
            navigationController?.pushViewController(vc)
            return
        }
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
                        self.refreshWifiList()
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
                    self.refreshWifiList()
                }
                if !self.isFromSetting {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HUBNamingViewController") as? HUBNamingViewController {
                        viewController.serial = self.serial
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                
            }
            
        })
        
        //sendAction.isEnabled = (loginTextField?.text?.isEmail)!
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        alertController.preferredAction = sendAction
        alertController.addTextField { (textField) -> Void in
            passwordTextField = textField
            //passwordTextField?.isSecureTextEntry = true
            //passwordTextField?.text = "NMQ0QHFFTA0"
            let pwStr = "Password".localized
            passwordTextField?.placeholder = "\(pwStr)..."
        }
        alertController.view.tintColor = #colorLiteral(red: 0.08259455115, green: 0.1223137602, blue: 0.2131385803, alpha: 1)
        present(alertController, animated: true, completion: nil)
    }
}
