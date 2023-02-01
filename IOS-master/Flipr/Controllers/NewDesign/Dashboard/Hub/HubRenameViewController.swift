//
//  HubRenameViewController.swift
//  Flipr
//
//  Created by Ajeesh on 26/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

class HubRenameViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    var completionBlock:(_: (_ value:String?) -> Void)?
    
    func completion(block: @escaping (_ value:String?) -> Void) {
        completionBlock = block
    }

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
        setUI()
    }
    
    
    func setUI(){
        titleLbl.text = "Settings".localized
        subTitleLbl.text = "How do you want to rename your Hub?".localized
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        saveButton.setTitle("Save".localized(), for: .normal)
        textField.placeholder = "Program's name".localized
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
            
            
            Alamofire.request(Router.updateHUBName(serial: self.hub?.serial ?? "", value: name)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                          
                          switch response.result {
                              
                          case .success(_):
                              hud?.dismiss(afterDelay: 0)

                              NotificationCenter.default.post(name: K.Notifications.UpdateHubViews, object: nil)
                              self.completionBlock?(name)
                              self.dismiss(animated: true)
/*
                           if let JSON = value as? [String:Any] {

                              if let errorCode = JSON["ErrorCode"] as? String {
                                  if errorCode == "200" {
                                      //self.showSuccessView()
                                  } else if let message = JSON["Message"] as? String {
//                                      completion?(NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:message]))
                                  } else {
//                                      completion?(NSError(domain: "flipr", code: (response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey:"Oups, we're sorry but something went wrong."]))
                                  }
                              }
                           }
                              
                              */
                           
                          case .failure(let error):
                              hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                              hud?.textLabel.text = error.localizedDescription
                              hud?.dismiss(afterDelay: 3)
                              self.completionBlock?(nil)

                          }
                          
               })

            
            /*
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
            
            */
        }
    }
    
  
  

}
