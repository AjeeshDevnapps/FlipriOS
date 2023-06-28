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


class GatewaywifiViewController: BaseViewController {
    @IBOutlet weak var controllerTitle: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var manualEntryLabel: UILabel!


    var serial:String?
    var wifiList = [AnyObject]()
    var isChangePassword : Bool = false
    var hud : JGProgressHUD?
    var selectedSsid:String = ""
    var ssid:String = ""
    
    var isCalledChangePassword : Bool = false

    
    override func viewDidLoad() {
        self.hidCustombackbutton = true
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        cancelBtn.setTitle("Cancel".localized(), for: .normal)
//        self.subTitleLable.text = "First connect your iPhone to the wifi network to which you want to connect your gateway".localized
        var str1 = "WifiText!".localized
        str1.append(" \n\n👇\n ")
        self.subTitleLable.text =  str1
//        self.manualEntryLabel.text = "Manual entry".localized
        
        manualEntryLabel.attributedText = NSAttributedString(string: "Manual entry".localized, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])

      
       // self.controllerTitle.text = "Choisissez le réseau Wi-Fi ".localized
//        GatewayManager.shared.scanForGateways(serials: [serial ?? ""], completion: { (gatewayinfo) in
//
//
//        })
//        findSelectedGateway()
        getAllWiFiNameList()
        // Do any additional setup after loading the view.
    }
    

    func findSelectedGateway(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        GatewayManager.shared.connect(serial: self.serial ?? "") { (error) in
            hud?.dismiss(animated: false)
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.setSsid()
                }
            }
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
    
    
    @IBAction func manulEnteryButtonClicked(){
        var ssidTextField: UITextField?
        let alertController = UIAlertController(title: "Manual Enntry".localized, message: "Provide you Wifi SSID".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Set".localized, style: .default, handler: { (action) -> Void in
            let ssid = ssidTextField?.text ?? ""
            self.ssid = ssid
            self.selectedSsid = ssid
            self.findSelectedGateway()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        alertController.preferredAction = sendAction
        alertController.addTextField { (textField) -> Void in
            ssidTextField = textField
            //passwordTextField?.isSecureTextEntry = true
            //passwordTextField?.text = "NMQ0QHFFTA0"
            let pwStr = "SSID".localized
            ssidTextField?.placeholder = "\(pwStr)..."
        }
        alertController.view.tintColor = #colorLiteral(red: 0.08259455115, green: 0.1223137602, blue: 0.2131385803, alpha: 1)
        present(alertController, animated: true, completion: nil)
        
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
        if let info  = wifiList[indexPath.row] as? NSDictionary{
            self.ssid = info["SSID"] as? String ?? ""
            selectedSsid = info["SSID"] as? String ?? ""
        }
        findSelectedGateway()
        /*
        var ssid = ""
        if let info  = wifiList[indexPath.row] as? NSDictionary{
            ssid = info["SSID"] as? String ?? ""
        }
        
        selectedSsid = ssid
        GatewayManager.shared.setSSID(ssid: ssid) { error in
            if error != nil{
                print("Error")
                self.navigationController?.popViewController()
                //                        self.hud?.dismiss()

            }else{
                self.showPasswordInputView(ssid: ssid)
            }
            
        }
        
       */
        
        
    }
    
    
    func setSsid(){
        GatewayManager.shared.setSSID(ssid: self.ssid) { error in
            GatewayManager.shared.removeConnection()
            if error != nil{
                print("Error")
                self.navigationController?.popViewController()

            }else{
                self.showPasswordInputView(ssid: self.ssid)
            }
            
        }
    }
    
    func showPasswordInputView(ssid:String){
        selectedSsid = ssid
        var passwordTextField: UITextField?
        let alertController = UIAlertController(title: ssid, message: "Enter wifi password".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Connect".localized, style: .default, handler: { (action) -> Void in
            self.hud = JGProgressHUD(style:.dark)
            self.hud?.show(in: self.navigationController!.view)

            if self.isChangePassword{
                let passwd = passwordTextField?.text ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.writePassword(password: passwd)
                }
            }else{
                print("Success setSSID")
                let passwd = passwordTextField?.text ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    if self.isCalledChangePassword ==  false{
                        self.isCalledChangePassword = true
                        self.reconnectGateway(password: passwd)
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
            let pwStr = "Password".localized
            passwordTextField?.placeholder = "\(pwStr)..."
        }
        alertController.view.tintColor = #colorLiteral(red: 0.08259455115, green: 0.1223137602, blue: 0.2131385803, alpha: 1)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func reconnectGateway(password:String){
//        let hud = JGProgressHUD(style:.dark)
//        hud?.show(in: self.navigationController!.view)
        
        GatewayManager.shared.connect(serial: self.serial ?? "") { error in
            if error != nil{
                print("Failed Reconnection after setSSID")
            }else{
                print("Reconnection Success after setSSID ")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.writePassword(password: password)
                }
            }
        }
      
    }
    
    func writePassword(password:String){
        
        GatewayManager.shared.setPassword(password: password) { error in
//            hud?.dismiss()
//            self.dismiss(animated: true)
            self.hud?.dismiss()
            if error != nil{
                print("Failed add password Gateway!!")
                
                self.showPasswordInputView(ssid: self.selectedSsid)
            }else{
                print("Success add password Gateway!!")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GatewaySuccessViewController") as? GatewaySuccessViewController {
                    vc.serial = self.serial
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
