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
    
    @IBOutlet weak var notFindTitleLbl: UILabel!
    @IBOutlet weak var notFindSubTitleLbl: UILabel!
    @IBOutlet weak var helpTitleLbl: UILabel!


    var serialKey:String = ""
    var fromMenu = false
    var isPresent = false
    var isSignupFlow = false
    var fliprArray = [String]()


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
        notFindTitleLbl.text  = "Aucun appareil n’a été trouvé".localized
        notFindSubTitleLbl.text  = "Vérifiez que vous êtes bien à proximité de votre appareil et que le bluetooth est bien activé.".localized
        helpTitleLbl.text  = "Obtenir de l’aide".localized
        self.connectioButton.setTitle("Relaunch a search".localized, for: .normal)

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
//            self.scanningAlertContainerView.isHidden = true
//            self.loaderView.hideStateView()
            if let serial = notification.userInfo?["serial"] as? String {
                if let index = self.fliprArray.firstIndex(of: serial) {
                    print(index) // Output: 4
                }else{
                    self.fliprArray.append(serial)
                }
//                self.showFliprList(serialKey: serial)
            }else{
                
            }
        }
        
        
    }
    
    func showFliprList(serialKey:String){
        if let fliprListVC = self.storyboard?.instantiateViewController(withIdentifier: "FliprListViewController") as? FliprListViewController{
            fliprListVC.serialKey = serialKey
            fliprListVC.flipType = "Flipr"
            fliprListVC.isSignupFlow = isSignupFlow
//            self.navigationController?.pushViewController(fliprListVC)
        }
    }
    
    override func backButtonTapped() {
        BLEManager.shared.centralManager.stopScan()
        if isSignupFlow {
            var isPoped = false
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: WelcomeViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: EducationScreenContainerViewController.self) {
//                    isPoped = true
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
            if isPoped { return }
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LandingViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            if isPoped { return }
            self.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
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
        self.connectioButton.isHidden = true
        self.bluetoothAlertContainerView.isHidden = true
        self.scanningAlertContainerView.isHidden = false
        self.searchFlipr()
    }
    
    
    @IBAction func helpButtonAction(_ sender: Any) {
    
    }
    
    func showFliprNotDiscoveredBanner(){
        
        if fliprArray.count > 0 {
            self.scanningAlertContainerView.isHidden = true
            self.loaderView.hideStateView()
            showFliprList()
        }else{
            self.helpButtonContainerView.isHidden = false
            self.fliprNotDiscoverContainerView.isHidden = false
            self.bluetoothAlertContainerView.isHidden = true
            self.scanningAlertContainerView.isHidden = true
        }
       
        
    }

    func showFliprList(){
        if let fliprListVC = self.storyboard?.instantiateViewController(withIdentifier: "FliprListViewController") as? FliprListViewController{
            fliprListVC.fliprList = self.fliprArray
//            fliprListVC.serialKey = serialKey
//            fliprListVC.flipType = "Flipr"
            fliprListVC.isSignupFlow = isSignupFlow
            self.navigationController?.pushViewController(fliprListVC)
        }
    }
    

}
