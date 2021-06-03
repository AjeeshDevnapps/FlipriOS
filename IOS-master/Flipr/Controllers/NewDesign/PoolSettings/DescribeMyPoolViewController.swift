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
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewTitleLbl: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)

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
