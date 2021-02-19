//
//  AddnewDeviceViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 19/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class AddnewDeviceViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 32
        addButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.init(hexString: "#3DA0FF"), radius: 32.0, opacity: 0.25)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addButtonClicked(){
    
    }

}
