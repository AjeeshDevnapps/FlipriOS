//
//  HubRenameViewController.swift
//  Flipr
//
//  Created by Ajeesh on 26/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class HubRenameViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textField: UITextField!

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
        textField.text  = hub?.equipementName.capitalizingFirstLetter()

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
        if let name =  textField.text {
            if name == "" {
                self.showError(title: "Error".localized, message: "Name is mandatory".localized)
                return
            }
//            planning?.name = name
            textField.resignFirstResponder()
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.containerView)
            HUB.currentHUB!.updateEquipmentName(value:name, completion: { (error) in
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    HUB.currentHUB!.equipementName = name
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                    NotificationCenter.default.post(name: K.Notifications.UpdateHubViews, object: nil)
                    self.dismiss(animated: true)
                }
            })
        }
    }
    

  

}
