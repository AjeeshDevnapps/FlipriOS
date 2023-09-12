//
//  StripTestIntroViewController.swift
//  Flipr
//
//  Created by Ajish on 14/08/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class StripTestIntroViewController: BaseViewController {
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var recalibration = false
    var isPresentView = false
    var isFromExpertView = false

    
    override func viewDidLoad() {
        self.hidCustombackbutton = true
        super.viewDidLoad()
        self.title = "Strip Test".localized
        nextButton.setTitle("Next".localized(), for: .normal)
        let trnText = "Flipr was designed to spare you from the hassle of daily strip tests. However, the initial and annual strip tests are essential to unveil some juicy, hidden physico-chemical secrets not captured by our sensors – think hardness, alkalinity, and the elusive presence of stabilizers! You don't want our algorithms to miss out on the spicy details, do you?\n\nPro tip: Don't forget to redo the test after a pool drain or some fancy treatments related to hardness or alkalinity. If you neglect this vital information, Flipr's suggestions might end up feeling a bit wobbly!\n\nBut fear not, my adventurous pool owner! You can check out all these exciting data in the expert view of Flipr. Get ready to dive into a world of detailed pool water wonders, where precision meets party! Keep an eye on those numbers, and you'll be swimming in the ultimate pool enjoyment. Cowabunga! 🏊‍♂️🌊😎".localized
        subTitleLbl.text = trnText

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }

    @IBAction func nextButtonAction(){
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StripViewControllerID") as? StripViewController {
            viewController.recalibration = true
            viewController.isPresentView = false
            viewController.isNewFlowwithIntro = false
            viewController.isFromExpertView = self.isFromExpertView
            if self.isFromExpertView {
                viewController.recalibration = false
            }
            self.navigationController?.pushViewController(viewController)
//            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true, completion: nil)

        }
        
    }

   
}
