//
//  GateWayListingViewController.swift
//  Flipr
//
//  Created by Ajeesh on 27/03/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import Network
import JGProgressHUD



class GateWayListingViewController: UIViewController {
    
    var gateWays = [NWEndpoint]()
    var gatewayArray = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: K.Notifications.GatewayDiscovered, object: nil, queue: nil) { (notification) in
            //            self.scanningAlertContainerView.isHidden = true
            //            self.loaderView.hideStateView()
            if let serial = notification.userInfo?["serial"] as? String {
                if let index = self.gatewayArray.firstIndex(of: serial) {
                    print(index) // Output: 4
                }else{
                    self.gatewayArray.append(serial)
                    self.tableView.reloadData()
                }
                //                self.showFliprList(serialKey: serial)
            }else{
                
            }
        }
        
        findFliprGatways()
        
    }
    
    func findFliprGatways(){
        
        GatewayManager.shared.scanForGateways(serials: nil, completion: { (gatewayinfo) in
            
            
        })
        
        
        //        let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        //        monitor.pathUpdateHandler = { path in
        //            if #available(iOS 13.0, *) {
        //                for item in path.gateways{
        //                    self.gateWays.append(item)
        //                }
        //                print(path.gateways)
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        }
        //        monitor.start(queue: DispatchQueue(label: "nwpathmonitor.queue"))
        //
    }
    
    
}

extension GateWayListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gatewayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceInfoTableViewCell") as! DeviceInfoTableViewCell
        //        let network = networks[indexPath.row]
        cell.modelLabel.text = "WIBLUE"
        cell.keyIdLabel.text = gatewayArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serialNo = gatewayArray[indexPath.row]
        self.addGatewayInUserAccount(serialNo: serialNo)

       
        
    }
    
    func addGatewayInUserAccount(serialNo:String){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        User.currentUser?.activateGateWay(serialNo: serialNo, completion: { gatewayInfo, error in
            hud?.dismiss()
            if error != nil{
                print(error)
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            }else{
                print(gatewayInfo)
                GatewayManager.shared.stopScanForHubs()
                GatewayManager.shared.connect(serial: serialNo) { error in
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    }
                    else {
                        print("Added selected Gateway")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GatewaywifiViewController") as? GatewaywifiViewController {
                            vc.serial = serialNo
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
           
        })
       
    }
    
    
    
}
