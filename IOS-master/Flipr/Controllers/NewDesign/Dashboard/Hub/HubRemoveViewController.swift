//
//  HubRemoveViewController.swift
//  Flipr
//
//  Created by Ajeesh on 26/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class HubRemoveViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var hubNameLbl: UILabel!

    var hub: HUB?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)
        cancelButton.roundCorner(corner: 12)
        saveButton.roundCorner(corner: 12)
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(hexString: "97A3B6").cgColor
        self.hubNameLbl.text = hub?.equipementName.capitalizingFirstLetter()
        setUI()

        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        titleLbl.text = "Settings".localized
        subTitleLbl.text = "Are you sure you want to delete the Hub?".localized
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        saveButton.setTitle("Save".localized(), for: .normal)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonClicked(){
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.containerView)
        HUB.currentHUB?.remove(completion: { (error) in
            if (error != nil) {
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 3)
            } else {
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
                NotificationCenter.default.post(name: K.Notifications.UpdateHubViews, object: nil)
                self.dismiss(animated: true)
//                if self.hubs.count > 1 {
//                    HUB.currentHUB = nil
//                    UserDefaults.standard.removeObject(forKey: "CurrentHUB")
//                    self.loadHUBs()
//                } else {
//                    self.dismiss(animated: true) {
//                        HUB.currentHUB = nil
//                        UserDefaults.standard.removeObject(forKey: "CurrentHUB")
//                    }
//                }
                
            }
        })
        
    }
    

  

}
