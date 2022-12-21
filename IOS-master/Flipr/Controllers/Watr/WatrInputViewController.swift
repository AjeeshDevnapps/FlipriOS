//
//  WatrInputViewController.swift
//  Flipr
//
//  Created by Ajeesh on 15/12/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class WatrInputViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var order = 0
    var defaultValue:String?
    
    var completionBlock:(_: (_ value:String) -> Void)?
    
    func completion(block: @escaping (_ value:String) -> Void) {
        completionBlock = block
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if AppSharedData.sharedInstance.isAddPlaceFlow{
//            self.navigationItem.setHidesBackButton(true, animated: true)
            self.submitButton.isHidden = false
        }else{
            self.textField.text = defaultValue
            setCustomBackbtn()
        }
        self.submitButton.isHidden = false
        manageUnit()

    }
    
    func manageUnit(){
        if order == 0 {
            var isDegree =  true
            if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                if currentUnit == 2{
                    isDegree = false
                }else{
                    isDegree = true
                }
            }else{
    //            UserDefaults.standard.set(1, forKey: "CurrentUnit")
    //            NotificationCenter.default.post(name: K.Notifications.MeasureUnitSettingsChanged, object: nil)
            }
            var titleStr  = self.title ?? ""

            if !isDegree{
                titleStr = titleStr + " - m³"
                
            }else{
                titleStr = titleStr + " - gal"
            }
            self.title = titleStr
        }
       
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if AppSharedData.sharedInstance.isAddPlaceFlow{
            if let input = textField.text{
                if input.isValidString{
                    if order == 0{
                        AppSharedData.sharedInstance.addPlaceInfo.volume = Double(input) ?? 0.0
                        self.showShapeList()
                    }else{
                        AppSharedData.sharedInstance.addPlaceInfo.numberOfUsers = Int(input) ?? 0
//                        showModesSelectionVC()
                        self.showCreatePlaceVC()
                    }
                }
            }
        }else{
            completionBlock?(textField.text ?? "")
            navigationController?.popViewController()

        }
    }
    
    
    func showCreatePlaceVC(){
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatePlaceViewController") as? CreatePlaceViewController {
            navigationController?.pushViewController(viewController)
        }
        
    }
    
    
    func showModesSelectionVC(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as? ValuePickerController {
            viewController.order = 5
            viewController.title = "Statut".localized
            viewController.apiPath = "modes"
            viewController.completion(block: { (formValue) in
            })
            navigationController?.pushViewController(viewController)
        }
 
        
        
    }
                                  
    
    func showShapeList(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as? ValuePickerController {
            viewController.title = "Shape".localized
            viewController.apiPath = "shapes"
            viewController.completion(block: { (formValue) in
            })
            navigationController?.pushViewController(viewController)
        }
    }
    

}
