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



class GateWayListingViewController: BaseViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var controllerTitle: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!

    var gateWays = [NWEndpoint]()
    var gatewayArray = [String]()
    @IBOutlet weak var tableView: UITableView!
    var isSkipping = false
    var serialNo = ""
    
    override func viewDidLoad() {
        self.hidCustombackbutton = true
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
//        self.controllerTitle.text = "Branchez la passerelle au moyen du câble USB et restez à proximité.\n\nAttendez quelques secondes...".localized
        self.controllerTitle.text = "Branchez la passerelle au moyen du câble USB et restez à proximité.\n\nChoisissez la passerelle à associer".localized
        self.subTitleLable.text = "".localized
        cancelBtn.setTitle("Cancel".localized(), for: .normal)

        NotificationCenter.default.addObserver(forName: K.Notifications.GatewayDiscovered, object: nil, queue: nil) { (notification) in
            //            self.scanningAlertContainerView.isHidden = true
            //            self.loaderView.hideStateView()
            if let serial = notification.userInfo?["serial"] as? String {
                if let index = self.gatewayArray.firstIndex(of: serial) {
                    print(index) // Output: 4
                }else{
                    self.gatewayArray.append(serial)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }else{
                
            }
        }
        findFliprGatways()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        GatewayManager.shared.stopScanForGateway()
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        
        if isSkipping{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
            dashboard.modalTransitionStyle = .flipHorizontal
            dashboard.modalPresentationStyle = .fullScreen
            self.present(dashboard, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: false)
            })

        }else{
            self.navigationController?.popViewController(animated: true)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GatewayInfoTableViewCell") as! GatewayInfoTableViewCell
        //        let network = networks[indexPath.row]
        cell.modelLabel.text = "N° Série".localized
        cell.serialLabel.text = gatewayArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let serialNo = gatewayArray[indexPath.row]
        self.addGatewayInUserAccount(serialNo: serialNo)
        
    }
    
    func addGatewayInUserAccount(serialNo:String){
        self.serialNo = serialNo
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        User.currentUser?.activateGateWay(serialNo: serialNo, completion: { gatewayInfo, error in
            hud?.dismiss()
            if error != nil{
                print(error)
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            }else{
                print(gatewayInfo)
                GatewayManager.shared.stopScanForGateway()
                GatewayManager.shared.removeConnection()
                self.showWifiVC()
                /*
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
                */
            }
           
        })
       
    }
    
    
    func showWifiVC(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GatewaywifiViewController") as? GatewaywifiViewController {
            vc.serial = self.serialNo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
