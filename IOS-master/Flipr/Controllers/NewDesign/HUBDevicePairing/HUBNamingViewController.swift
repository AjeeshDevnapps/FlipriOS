//
//  HUBNamingViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

class HUBNamingViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textFieldTitle: UILabel!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var submitButton: UIButton!
    var serial:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        submitButton.layer.cornerRadius = 12
        nameTextField.text = "Pompe à filtration".localized
        titleLabel.text  = "Donnez un nom à votre Flipr Hub".localized
        subtitleLabel.text  = "Ce nom sera utilisé sur votre tableau de bord. Optez de préférence pour un nom court associé à l'équipement connecté.".localized
        textFieldTitle.text = "Nom de votre Flipr Hub".localized
        submitButton.setTitle("Suivant".localized, for: .normal)

        nameTextField.becomeFirstResponder()
        
        nameTextField.addPaddingRightButton(target: self, #imageLiteral(resourceName: "delete-icon"), padding: 10, action: #selector(deleteText))
    }
    
    @objc func deleteText() {
        nameTextField.text = ""
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.addHubName()
    }
    
    func addHubName(){
        if let name =  nameTextField.text {
            if name == "" {
                self.showError(title: "Error".localized, message: "Name is mandatory".localized)
                return
            }
//            planning?.name = name
            nameTextField.resignFirstResponder()
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            Alamofire.request(Router.updateHUBName(serial: self.serial ?? "", value: name)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                          
                          switch response.result {
                              
                          case .success(let value):
                           
                           if let JSON = value as? [String:Any] {
                               hud?.dismiss(afterDelay: 0)
                               self.showSuccessView()

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
                           
                          case .failure(let error):
                              hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                              hud?.textLabel.text = error.localizedDescription
                              hud?.dismiss(afterDelay: 3)
                          }
                          
               })
            
        }
        else{
            self.showError(title: "Error".localized, message: "Name is mandatory".localized)
        }

    }
    
    
    func showSuccessView(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "HUBPairingSuccessViewController") as! HUBPairingSuccessViewController
        navigationController?.pushViewController(vc)

    }

}
