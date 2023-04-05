//
//  GatewaywifiViewController.swift
//  Flipr
//
//  Created by Ajeesh on 03/04/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import JGProgressHUD


class GatewaywifiViewController: UIViewController {
    @IBOutlet weak var controllerTitle: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var serial:String?
    var wifiList = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        GatewayManager.shared.scanForGateways(serials: [serial ?? ""], completion: { (gatewayinfo) in
//
//
//        })
        findSelectedGateway()
//        getAllWiFiNameList()
        // Do any additional setup after loading the view.
    }
    

    func findSelectedGateway(){
        GatewayManager.shared.detectedHubs.removeAll()
        GatewayManager.shared.scanForGateways(serials: [serial ?? ""]) { (info) in
//            self.getAllWiFiNameList()

          //  self.view.hideStateView()
            /*
            GatewayManager.shared.connect(serial: self.serial ?? "") { (error) in
                if error != nil {
                    self.showError(title: "Error".localized, message: error?.localizedDescription)
                } else {
//                    self.tableView.reloadData()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        self.refreshButtonAction(self)
//                    }
                }
//                GatewayManager.shared.stopScanForHubs()
                */
                self.getAllWiFiNameList()
//            }
            
        }
    }
    
    func getAllWiFiNameList() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    print(interfaceInfo)
                    wifiList.append(interfaceInfo)
                    self.tableView.reloadData()
//                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
//                    break
                }
            }
        }
        return ssid
    }
}


extension GatewaywifiViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WifiListTableViewCell") as! WifiListTableViewCell
//        let network = networks[indexPath.row]
        if let info  = wifiList[indexPath.row] as? NSDictionary{
            cell.wifiNameLabel.text = info["SSID"] as? String
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ssid = ""
        if let info  = wifiList[indexPath.row] as? NSDictionary{
            ssid = info["SSID"] as? String ?? ""
        }
        var passwordTextField: UITextField?
        
        let alertController = UIAlertController(title: ssid, message: "Enter wifi password".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Connect".localized, style: .default, handler: { (action) -> Void in
            GatewayManager.shared.stopScanForHubs()
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            GatewayManager.shared.setSSID(ssid: ssid) { error in
                if error != nil{
                    print("Success")
                    let passwd = passwordTextField?.text ?? ""
                    GatewayManager.shared.setPassword(password: passwd) { error in
                        hud?.dismiss()
                        self.dismiss(animated: true)
                        if error != nil{
                            print("Success")
                        }else{
                            print("Error")
                        }
                    }
                }else{
                    hud?.dismiss()
                    print("Error")
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
