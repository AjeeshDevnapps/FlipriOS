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
    @IBOutlet weak var researchButton: UIButton!
    
    @IBOutlet weak var bleSearchingHeaderLbl: UILabel!
    @IBOutlet weak var bleSearchingSubTitleLbl: UILabel!
    @IBOutlet weak var bleOffWarningLbl: UILabel!
    @IBOutlet weak var bleOffMsgLbl: UILabel!
    
    @IBOutlet weak var notFindTitleLbl: UILabel!
    @IBOutlet weak var notFindSubTitleLbl: UILabel!
    @IBOutlet weak var helpTitleLbl: UILabel!


    var fromMenu = false
    
    var equipmentCode:String!
    var hubs:[String:CBPeripheral] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        localiseText()
        connectioButton.roundCorner(corner: 12.0)
        searchHub()
        // Do any additional setup after loading the view.
    }
    
    func localiseText(){
        bleSearchingHeaderLbl.text = "Recherche d’un Flipr Hub en cours".localized
        bleSearchingSubTitleLbl.text = "Stay close to your Flipr. The activation of the bluetooth is necessary".localized
        bleOffWarningLbl.text = "Bluetooth not activated.".localized
        bleOffMsgLbl.text = "Bluetooth not activated Activate your smartphone's Bluetooth to associate Flipr Start with your device.".localized
        notFindTitleLbl.text  = "Aucun appareil n’a été trouvé".localized
        notFindSubTitleLbl.text  = "Vérifiez que vous êtes bien à proximité de votre appareil et que le bluetooth est bien activé.".localized
        helpTitleLbl.text  = "Obtenir de l’aide".localized
        self.connectioButton.setTitle("Relaunch a search".localized, for: .normal)

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
        hubListVC.equipmentCode = self.equipmentCode
        self.navigationController?.pushViewController(hubListVC)
        
    }
    
    @IBAction func scanButtonAction(_ sender: Any) {
        connectioButton.isHidden = true        
        self.helpButtonContainerView.isHidden = true
        self.fliprNotDiscoverContainerView.isHidden = true
        self.bluetoothAlertContainerView.isHidden = true
        self.scanningAlertContainerView.isHidden = false
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballSpinFadeLoader
        theme.activityIndicatorColor = .black
        self.loaderView.showEmptyStateViewLoading(title: nil,
                                            message: nil,
                                            theme: theme)
        self.scanHub()
    }
    
    
    @IBAction func helpButtonAction(_ sender: Any) {
    
    }
    
    @IBAction func reserchButtonAction(_ sender: Any) {
    
        self.helpButtonContainerView.isHidden = true
        self.fliprNotDiscoverContainerView.isHidden = true
        self.bluetoothAlertContainerView.isHidden = true
        self.scanningAlertContainerView.isHidden = false
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballSpinFadeLoader
        theme.activityIndicatorColor = .black
        self.loaderView.showEmptyStateViewLoading(title: nil,
                                            message: nil,
                                            theme: theme)
        self.scanHub()

        
    }
    
    func showHubNotDiscoveredBanner(){
        connectioButton.isHidden = false
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
