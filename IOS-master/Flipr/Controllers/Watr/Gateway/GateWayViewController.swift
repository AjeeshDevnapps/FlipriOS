//
//  GateWayViewController.swift
//  Flipr
//
//  Created by Ajeesh on 17/03/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD


class GateWayViewController: UIViewController {

    @IBOutlet weak var gatewayTableView: UITableView!
    @IBOutlet weak var addGatewayBtn: UIButton!

    var gatewayList:[UserGateway]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Passerelles".localized
        AppSharedData.sharedInstance.isFlipr3 = false
        addGatewayBtn.setTitle("Add a gateway".localized, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGatewayList()
        GatewayManager.shared.removeConnection()
    }
    
    func getGatewayList() {
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        User.currentUser?.getUserGateways(completion: { gateways, error in
            print(gateways)
            hud?.dismiss()
            self.gatewayList = gateways
            self.gatewayTableView.reloadData()
        })
    }
    
    @IBAction func addButtonAction() {
               
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GateWayListingViewController") as? GateWayListingViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension GateWayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gatewayList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GatewayTableViewCell") as! GatewayTableViewCell
        cell.delegate = self
        cell.info = gatewayList?[indexPath.row]
        cell.gatewayNameLabel.text = gatewayList?[indexPath.row].serial
        cell.selectionStyle = .none
        return cell
    }
}


extension GateWayViewController: GatewayTableViewCellDelegate {
    func addGateway(cell: GatewayTableViewCell, gateWay: String){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GatewaySettingsViewController") as? GatewaySettingsViewController {
            vc.info = cell.info
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
