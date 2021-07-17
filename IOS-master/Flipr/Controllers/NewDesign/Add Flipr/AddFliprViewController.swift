//
//  AddFliprViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 23/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class AddFliprViewController: BaseViewController {
    @IBOutlet weak var scanningAlertContainerView: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var bluetoothAlertContainerView: UIView!
    @IBOutlet weak var fliprNotDiscoverContainerView: UIView!
    @IBOutlet weak var helpButtonContainerView: UIView!
    @IBOutlet weak var connectioButton: UIButton!

    @IBOutlet weak var bleSearchingHeaderLbl: UILabel!
    @IBOutlet weak var bleSearchingSubTitleLbl: UILabel!
    @IBOutlet weak var bleOffWarningLbl: UILabel!
    @IBOutlet weak var bleOffMsgLbl: UILabel!

    var serialKey:String = ""
    var fromMenu = false
    var isPresent = false


    override func viewDidLoad() {
        self.isPresentingView = isPresent
        super.viewDidLoad()
        setupView()
        searchFlipr()
        localiseText()
        // Do any additional setup after loading the view.
    }
    
    func localiseText(){
        bleSearchingHeaderLbl.text = "Search for a Flipr Start in progress".localized
        bleSearchingSubTitleLbl.text = "Stay close to your Flipr. The activation of the bluetooth is necessary".localized
        bleOffWarningLbl.text = "Bluetooth not activated.".localized
        bleOffMsgLbl.text = "Bluetooth not activated Activate your smartphone's Bluetooth to associate Flipr Start with your device.".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func setupView(){
        connectioButton.roundCorner(corner: 12)
        if isPresent{
            
        }
    }
    
    func searchFlipr(){

        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballSpinFadeLoader
        theme.activityIndicatorColor = .black
        self.loaderView.showEmptyStateViewLoading(title: nil,
                                            message: nil,
                                            theme: theme)
        BLEManager.shared.startUpCentralManager(connectAutomatically: false, sendMeasure: false)
        NotificationCenter.default.addObserver(forName: K.Notifications.BluetoothNotAvailble, object: nil, queue: nil) { _ in
            self.scanningAlertContainerView.isHidden = true
            self.bluetoothAlertContainerView.isHidden = false
            self.connectioButton.isHidden = false
            self.loaderView.hideStateView()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprNotDiscovered, object: nil, queue: nil) { (notification) in
            self.showFliprNotDiscoveredBanner()
        }
        
        NotificationCenter.default.addObserver(forName: K.Notifications.FliprDiscovered, object: nil, queue: nil) { (notification) in
            self.scanningAlertContainerView.isHidden = true
            self.loaderView.hideStateView()
            if let serial = notification.userInfo?["serial"] as? String {
                self.showFliprList(serialKey: serial)
            }else{
                
            }
        }
        
        
    }
    
    func showFliprList(serialKey:String){
        if let fliprListVC = self.storyboard?.instantiateViewController(withIdentifier: "FliprListViewController") as? FliprListViewController{
            fliprListVC.serialKey = serialKey
            fliprListVC.flipType = "Flipr"
            self.navigationController?.pushViewController(fliprListVC)
        }
    }
    
    override func backButtonTapped() {
        if fromMenu {
            BLEManager.shared.centralManager.stopScan()
            dismiss(animated: true, completion: nil)
        } else {
            User.logout()
            BLEManager.shared.centralManager.stopScan()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if fromMenu {
            BLEManager.shared.centralManager.stopScan()
            dismiss(animated: true, completion: nil)
        } else {
            User.logout()
            BLEManager.shared.centralManager.stopScan()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func scanButtonAction(_ sender: Any) {
        self.bluetoothAlertContainerView.isHidden = true
        self.scanningAlertContainerView.isHidden = false
        self.searchFlipr()
    }
    
    
    @IBAction func helpButtonAction(_ sender: Any) {
    
    }
    
    func showFliprNotDiscoveredBanner(){
        self.helpButtonContainerView.isHidden = false
        self.fliprNotDiscoverContainerView.isHidden = false
        self.bluetoothAlertContainerView.isHidden = true
        self.scanningAlertContainerView.isHidden = true
        
    }


}
