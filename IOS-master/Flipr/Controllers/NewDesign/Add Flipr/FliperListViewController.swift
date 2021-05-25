//
//  FliperListViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 25/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class FliprListViewController: BaseViewController {
    @IBOutlet weak var fliprDetailsContainerView: UIView!
    @IBOutlet weak var serialKeyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

    var serialKey: String!
    var flipType: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        fliprDetailsContainerView.roundCorner(corner: 12)
        self.serialKeyLabel.text = serialKey
        self.typeLabel.text = flipType
//        selectButton.addTarget(self, action: #selector(fliprSelectButtonAction), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    

    @objc func fliprSelectButtonAction() {
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
            vc.serialKey = serialKey
            vc.flipType = flipType
            self.navigationController?.pushViewController(vc)
        }
    }
    

    @IBAction func necxtButtonAction() {
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "KeyEnterViewController") as? KeyEnterViewController{
            vc.serialKey = serialKey
            vc.flipType = flipType
            self.navigationController?.pushViewController(vc)
        }
    }

}
