//
//  DescribeMyPoolViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class DescribeMyPoolViewController: BaseViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var viewSubTitleLbl: UILabel!
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var descTitleLbl: UILabel!

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewTitleLbl: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        descTitleLbl.text = "La première analyse est déjà en cours d'exécution".localized
        viewSubTitleLbl.text = "Flipr a besoin d'en savoir plus sur votre bassin afin de vous fournir des analyses plus rapide et fiables à 100% .".localized
        viewTitleLbl.text = "Décrivez votre piscine à Flipr Start".localized
        submitBtn.setTitle("Décrire ma piscine".localized, for: .normal)
        messageView.roundCorner(corner: 12)
        submitBtn.roundCorner(corner: 12)
        setCustomBackbtn()
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
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
