//
//  AddV3IntroViewController.swift
//  Flipr
//
//  Created by Ajish on 14/08/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class AddV3IntroViewController: BaseViewController {
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var isSignupFlow = false
    var isPushFlow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.setTitle("Next".localized(), for: .normal)
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        let trnText = "addV3Intro".localized
        subTitleLbl.text = trnText

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButtonAction(){
        let fliprStoryboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let viewController = fliprStoryboard.instantiateViewController(withIdentifier: "AddFliprViewController") as! AddFliprViewController
        viewController.isPushFlow = self.isPushFlow
        viewController.isSignupFlow = self.isSignupFlow
        AppSharedData.sharedInstance.isAddDeviceStarted = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func cancelButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }

}
