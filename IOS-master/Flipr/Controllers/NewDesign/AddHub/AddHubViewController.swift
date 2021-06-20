//
//  AddHubViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 01/06/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth

class AddHubViewController: BaseViewController {
    @IBOutlet weak var scanningAlertContainerView: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var bluetoothAlertContainerView: UIView!
    @IBOutlet weak var fliprNotDiscoverContainerView: UIView!
    @IBOutlet weak var helpButtonContainerView: UIView!
    @IBOutlet weak var connectioButton: UIButton!

    var fromMenu = false
    
    var equipmentCode:String!
    var hubs:[String:CBPeripheral] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectioButton.roundCorner(corner: 12.0)
        searchHub()
        // Do any additional setup after loading the view.
    }
    
    func searchHub(){
        
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballSpinFadeLoader
        theme.activityIndicatorColor = .black
        self.loaderView.showEmptyStateViewLoading(title: nil,
                                            message: nil,
                                            theme: theme)

        NotificationCenter.default.addObserver(forName: K.Notifications.BluetoothNotAvailble, object: nil, queue: nil) { _ in
            self.scanningAlertContainerView.isHidden = true
            self.bluetoothAlertContainerView.isHidden = false
            self.connectioButton.isHidden = false
            self.loaderView.hideStateView()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.HUBNotDiscovered, object: nil, queue: nil) { (notification) in
            self.showHubNotDiscoveredBanner()
        }
        
        self.scanHub()
       
    }
    
    
    override func backButtonTapped() {
        HUBManager.shared.stopScanForHubs()
        HUBManager.shared.detectedHubs.removeAll()
        navigationController?.popViewController(animated: true)

    }
    
    
    func scanHub(){
        HUBManager.shared.scanForHubs(serials: nil) { (hubInfo) in
            print("HUB detected: \(hubInfo.keys.first ?? "???")")
            self.hubs = hubInfo
            self.showHubList()
        }
    }
    
    func showHubList(){
        HUBManager.shared.stopScanForHubs()
        HUBManager.shared.detectedHubs.removeAll()
        let  hubListVC = self.storyboard?.instantiateViewController(withIdentifier: "HubListViewController") as! HubListViewController
        hubListVC.hubs = self.hubs
        self.navigationController?.pushViewController(hubListVC)
        
    }
    
    @IBAction func scanButtonAction(_ sender: Any) {
        self.bluetoothAlertContainerView.isHidden = true
        self.scanningAlertContainerView.isHidden = false
        self.scanHub()
    }
    
    
    @IBAction func helpButtonAction(_ sender: Any) {
    
    }
    
    func showHubNotDiscoveredBanner(){
        HUBManager.shared.stopScanForHubs()
        HUBManager.shared.detectedHubs.removeAll()
        self.helpButtonContainerView.isHidden = false
        self.fliprNotDiscoverContainerView.isHidden = false
        self.bluetoothAlertContainerView.isHidden = true
        self.scanningAlertContainerView.isHidden = true
    }
    
    func showHubList(serialKey:String){
        HUBManager.shared.stopScanForHubs()
        if let fliprListVC = self.storyboard?.instantiateViewController(withIdentifier: "FliprListViewController") as? FliprListViewController{
            fliprListVC.serialKey = serialKey
            fliprListVC.flipType = "Flipr"
            self.navigationController?.pushViewController(fliprListVC)
        }
    }
    
    

}
