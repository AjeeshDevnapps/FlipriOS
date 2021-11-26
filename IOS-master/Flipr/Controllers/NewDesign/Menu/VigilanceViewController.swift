//
//  VigilanceViewController.swift
//  Flipr
//
//  Created by Ajeesh on 04/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class VigilanceViewController: BaseViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "Vigilance en cours".localized
        subtitleLbl.text = "Actuellement, des variations sont observées dans les paramètres de la qualité de l'eau de votre bassin.".localized
        contentLbl.text = "Flipr suit l'évolution de la situation, et vous alertera si votre action est nécessaire. Vous n'avez rien à faire pour l'instant.".localized
    }
    
    @IBAction func closeButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
