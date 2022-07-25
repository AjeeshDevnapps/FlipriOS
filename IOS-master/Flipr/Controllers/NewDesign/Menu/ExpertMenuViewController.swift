//
//  ExpertMenuViewController.swif
//  Flipr
//
//  Created by Ajeesh on 06/09/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class ExpertMenuViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var titleLbl: UILabel!


    var cellTitleList = ["Mode Expert","Trigger a measurement","Nouveau calibrage","Nouveau test bandelette","Vidange de la piscine","Diagnostic","Flipr Firmware Update"]
    var imageNames = ["expertMenu1","expertMenu2","expertMenu3","expertMenu4","expertMenu5","diagnostic","upgradebtn"]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable.tableFooterView = UIView()
        NotificationCenter.default.addObserver(forName: K.Notifications.showFirmwereUpgradeScreen, object: nil, queue: nil) { (notification) in
            self.showFirmwereUdpateScreen()
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
   

}

extension ExpertMenuViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cellTitleList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell =  tableView.dequeueReusableCell(withIdentifier:"MenuTableViewCell",
                                             for: indexPath) as! MenuTableViewCell
        
        cell.menuTitleLbl.text = cellTitleList[indexPath.row].localized
        cell.menuIcon.image =  UIImage(named: imageNames[indexPath.row])
        return cell
    }
        
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let tmpSb = UIStoryboard.init(name: "Main", bundle: nil)
            if let navigationController = tmpSb.instantiateViewController(withIdentifier: "SettingsNavingation") as? UINavigationController {
                if let viewController = tmpSb.instantiateViewController(withIdentifier: "ExpertModeViewController") as? ExpertModeViewController {
                    navigationController.modalPresentationStyle = .fullScreen
                    viewController.isDirectPresenting = true
                    navigationController.setViewControllers([viewController], animated: false)
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
        else if indexPath.row == 1{
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
                viewController.calibrationType = .simpleMeasure
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 2{
            
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            let alert = UIAlertController(title: "Calibration".localized, message:"Are you sure you want to calibrate the probes again?".localized, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
                self.showCalibrationView()
    //            if let viewController = mainSb.instantiateViewController(withIdentifier: "CalibrationViewControllerID") as? CalibrationViewController {
    //                viewController.recalibration = true
    //                viewController.calibrationType = .ph7
    //                viewController.modalPresentationStyle = .fullScreen
    //                let nav = UINavigationController.init(rootViewController: viewController)
    //                nav.modalPresentationStyle = .fullScreen
    //                self.present(nav, animated: true, completion: nil)
    //            }
            }))
            alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
                if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                    UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        else if indexPath.row == 3{
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            let alert = UIAlertController(title: "Strip test".localized, message:"Are you sure you want to do a new strip test?".localized, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
                let sb:UIStoryboard = UIStoryboard.init(name: "Calibration", bundle: nil)
                if let viewController = sb.instantiateViewController(withIdentifier: "StripViewControllerID") as? StripViewController {
                    viewController.recalibration = true
                    viewController.isPresentView = true
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)

                }
            }))
            alert.addAction(UIAlertAction(title: "Order a calibration kit".localized, style: .default, handler: { (action) in
                if let url = URL(string:"https://www.goflipr.com/produit/kit-de-calibration/".remotable) {
                    UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        else if indexPath.row == 4{
            let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
            if let viewController = mainSb.instantiateViewController(withIdentifier: "WaterLevelTableViewController") as? WaterLevelTableViewController {
    //            viewController.modalPresentationStyle = .fullScreen
    //            self.present(viewController, animated: true, completion: nil)
    //
                let navigationController = LightNavigationViewController.init(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion:nil)

            }
        }
        else if indexPath.row == 5{
            self.showFirmwereDiagnosticScreen()
        }
        else if indexPath.row == 6{
            self.showFirmwereUdpateScreen()
        }
        else{
        }
        
    }
    
    func showFirmwereUdpateScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    func showFirmwereDiagnosticScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "DiganosticNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
  
    func showCalibrationView(){
        
        let sb = UIStoryboard(name: "Calibration", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CalibrationPh7IntroViewController") as! CalibrationPh7IntroViewController
        vc.isPresentedFlow = true
        vc.recalibration = true
        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
       return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
   }

}
