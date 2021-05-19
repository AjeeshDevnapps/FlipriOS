//
//  PairingSuccessViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 21/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class PairingSuccessViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var viewSubTitleLbl: UILabel!
    @IBOutlet weak var submitBtb: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        imgView.roundCorner(corner: 12)
        submitBtb.roundCorner(corner: 12)
        setCustomBackbtn()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submit(_ sender: UIButton) {
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
}
