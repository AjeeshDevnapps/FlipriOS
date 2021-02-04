//
//  WaterLevelViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 18/04/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class WaterLevelViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var fillPercentageLabel: UILabel!
    @IBOutlet weak var fillPercentageValueLabel: UILabel!
    @IBOutlet weak var fillPercentageSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New draining".localized
        datePickerLabel.text = "Draining date".localized.uppercased()
        fillPercentageLabel.text = "Fill percentage".localized.uppercased()
        
        if let module = Module.currentModule {
            if module.isForSpa {
                backgroundImageView.image = UIImage(named:"BG_spa")
            }
        }
        
        // Do any additional setup after loading the view.
        datePicker.maximumDate = Date()
        datePicker.date = Date()
        //datePicker.setValue(UIColor.black, forKey: "textColor")
        fillPercentageValueLabel.text = "50 %"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        let value = self.fillPercentageSlider.value
        
        if let poolId = Pool.currentPool?.id {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
                print("Add draining with poolID: \(poolId), date: \(datePicker.date), quantity \(value)")
                
                Alamofire.request(Router.addWaterLevel(poolId: poolId, date: datePicker.date, quantity: 1 - Double(value))).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        print("Add draining response.result.value: \(value)")
                        
                        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud?.dismiss(afterDelay: 1)
                        NotificationCenter.default.post(name: FliprLogDidChanged, object: nil)
                        self.dismiss(animated: true, completion: nil)
                        
                    case .failure(let error):
                        
                        print("Add draing did fail with error: \(error)")
                        
                        if let serverError = User.serverError(response: response) {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = serverError.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        } else {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = error.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        }
                    }
                    
                })
            
        } else {
            self.showError(title: "Error".localized, message: "Please first fill in the data for your pool".localized)
        }
    }
    @IBAction func fillPercentageSliderValueChange(_ sender: Any) {
        self.fillPercentageValueLabel.text = "\(String(format:"%.0f",fillPercentageSlider.value * 100)) %"
    }

}
