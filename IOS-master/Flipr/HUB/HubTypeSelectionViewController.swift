//
//  HubTypeSelectionViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 16/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit

class HubTypeSelectionViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var dismissOnBack = false
    
    @IBOutlet weak var filtrationPumpButton: UIButton!
    @IBOutlet weak var heatPumpButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        label.text = "What equipment do you want to connect?".localized
        
        filtrationPumpButton.setTitle("Filtration pump".localized, for: .normal)
        heatPumpButton.setTitle("Heat pump".localized, for: .normal)
        lightButton.setTitle("Lighting".localized, for: .normal)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if dismissOnBack {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController()
        }

    }
    
    @IBAction func filtrationPumpButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Is your filtration directly connected to other equipment? (Example: an electrolyser, a heat pump, ...)".localized, message:nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "No".localized, style: .default, handler: { (action) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                vc.equipmentCode = "86"
                vc.simultaneous = false
                vc.step = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (action) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                vc.equipmentCode = "86"
                vc.simultaneous = true
                vc.step = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func heatPumpButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "ATTENTION".localized(), message:"If your filtration pump is not equipped with a Flipr HUB, make sure that it is always started up when the heat pump is switched on.".localized(), preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:"I get it".localized(), style: .default, handler: { (action) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                vc.equipmentCode = "85"
                vc.step = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func lightingButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Is the current greater or less than 90V?".localized(), message:nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Less than 90V".localized(), style: .default, handler: { (action) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                vc.equipmentCode = "84"
                vc.inf90 = true
                vc.step = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "More than 90V".localized(), style: .default, handler: { (action) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
                vc.equipmentCode = "84"
                vc.inf90 = false
                vc.step = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
