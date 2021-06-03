//
//  HUBNamingViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class HUBNamingViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textFieldTitle: UILabel!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        submitButton.layer.cornerRadius = 12
        nameTextField.text = "Pompe à filtration"
        nameTextField.becomeFirstResponder()
        
        nameTextField.addPaddingRightButton(target: self, #imageLiteral(resourceName: "delete-icon"), padding: 10, action: #selector(deleteText))
    }
    
    @objc func deleteText() {
        nameTextField.text = ""
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HUBPairingSuccessViewController") as! HUBPairingSuccessViewController
        navigationController?.pushViewController(vc)
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
