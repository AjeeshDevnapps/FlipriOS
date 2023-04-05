//
//  FliperListViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 25/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import CoreBluetooth
import JGProgressHUD

class FliprListViewController: BaseViewController {
    @IBOutlet weak var fliprListTableView: UITableView!
    @IBOutlet weak var fliprDetailsContainerView: UIView!
    @IBOutlet weak var serialKeyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serialTitleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    var fliprList = [String]()
    let hud = JGProgressHUD(style:.dark)

    var serialKey: String!
    var flipType: String!
    var isSignupFlow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.fliprListTableView.tableFooterView = UIView()
        fliprDetailsContainerView.roundCorner(corner: 12)
        fliprDetailsContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        self.serialKeyLabel.text = serialKey
        self.typeLabel.text = flipType
        titleLabel.text = "Choisissez le Flipr Start à associer".localized
        serialTitleLabel.text = "Serial".localized
//        selectButton.addTarget(self, action: #selector(fliprSelectButtonAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func backButtonTapped() {
        if isSignupFlow{
            var isPoped = false
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: EducationScreenContainerViewController.self) {
//                    isPoped = true
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//            if isPoped { return }
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: WelcomeViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            if isPoped { return }
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LandingViewController.self) {
                    isPoped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            if isPoped { return }
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController()
        }
    }

    @objc func fliprSelectButtonAction() {
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
            vc.serialKey = serialKey
            vc.flipType = flipType
            vc.isSignupFlow =  self.isSignupFlow
            self.navigationController?.pushViewController(vc)
        }
    }
    

    @IBAction func necxtButtonAction() {
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
            vc.serialKey = serialKey
            vc.flipType = flipType
            vc.isSignupFlow =  self.isSignupFlow
            self.navigationController?.pushViewController(vc)
        }
    }

}

extension FliprListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fliprList.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceInfoTableViewCell",
                                                     for: indexPath) as! DeviceInfoTableViewCell
        cell.keyIdLabel.text = fliprList[indexPath.row]
        cell.modelLabel.text = "Flipr"
        cell.shadowView.addShadow(offset: CGSize.init(width: 0, height: 24), color: UIColor(red: 0, green: 0.071, blue: 0.278, alpha: 0.14), radius: 40.0, opacity: 0.14)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let skey = fliprList[indexPath.row]
        hud?.show(in: self.view)
        Module.activate(serial:skey, activationKey: "123456", completion: { (error) in
            self.hud?.dismiss(afterDelay: 0)
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
            } else {
                self.showSuccessScreen()
            }
        })
        
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
//            vc.serialKey = fliprList[indexPath.row]
//            vc.flipType = flipType
//            vc.isSignupFlow =  self.isSignupFlow
//            self.navigationController?.pushViewController(vc)
//        }
        
    }
    
    func enableNewFliprV3(){
        
    }
    
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
        
    }
    
    
    
    func showSuccessScreen(){
        
        let sb = UIStoryboard(name: "FliprDevice", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "FliprActivationSuccessViewController") as? FliprActivationSuccessViewController {
            self.navigationController?.pushViewController(viewController)
            viewController.serialKey = self.serialKey
        }
    }

    
    
    
    
}
