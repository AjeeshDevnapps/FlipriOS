//
//  HubSettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 26/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol HubSettingViewDelegate {
    func didSelectRenameButton(hub:HUB)
    func didSelectWifiButton(hub:HUB)
    func didSelectRemoveButton(hub:HUB)
}

class HubSettingsViewController: UIViewController {
    @IBOutlet weak var hubNameLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var renameTitleLbl: UILabel!
    @IBOutlet weak var wifeSettingTitleLbl: UILabel!
    @IBOutlet weak var removeHubTitleLbl: UILabel!

    var hub: HUB?
    var delegate:HubSettingViewDelegate?

    var name : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hubNameLbl.text = hub?.equipementName.capitalizingFirstLetter()
        containerView.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        titleLbl.text = "Settings".localized
        renameTitleLbl.text = "Rename".localized
        wifeSettingTitleLbl.text = "WIFI settings".localized
        removeHubTitleLbl.text = "Delete the Hub".localized
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hubNameLbl.text = HUB.currentHUB!.equipementName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hubNameLbl.text = HUB.currentHUB!.equipementName
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func renameButtonClicked(){
        self.dismiss(animated: true, completion: nil)
        self.delegate?.didSelectRenameButton(hub: self.hub!)
//        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HubRenameViewController") as? HubRenameViewController {
//            viewController.hub = self.hub
//            self.present(viewController, animated: true, completion: nil)
//        }
    }
    
    
    @IBAction func wifeSettingsButtonClicked(){
        self.dismiss(animated: true, completion: nil)

        self.delegate?.didSelectWifiButton(hub: self.hub!)

//        let sb = UIStoryboard(name: "HUB", bundle: nil)
//        if let viewController = sb.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
//            viewController.serial = hub?.serial
//            viewController.fromSetting = true
//            let nav = UINavigationController.init(rootViewController: viewController)
//            self.present(nav, animated: true, completion: nil)
////            self.navigationController?.pushViewController(viewController, animated: true)
////            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
        
    }
    
    @IBAction func removeHubButtonClicked(){
        self.dismiss(animated: true, completion: nil)

        self.delegate?.didSelectRemoveButton(hub: self.hub!)

//        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HubRemoveViewController") as? HubRemoveViewController {
//            viewController.hub = self.hub
//            self.present(viewController, animated: true, completion: nil)
//        }
//        
      

    }
    
    

 

}
