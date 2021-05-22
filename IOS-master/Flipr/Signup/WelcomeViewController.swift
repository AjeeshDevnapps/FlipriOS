//
//  WelcomeViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 14/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeTitleLbl: UILabel!
    @IBOutlet weak var welcomeSubtitleLbl: UILabel!
    @IBOutlet weak var devicesListHdrLbl: UILabel!
    @IBOutlet weak var statrVw: UIView!
    @IBOutlet weak var hubVw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1213650182, green: 0.1445809603, blue: 0.213222146, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)

        statrVw.roundCorner(corner: 12)
        hubVw.roundCorner(corner: 12)
        statrVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        hubVw.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
    }
    
    @IBAction func clickedOnStr(_ sender: UIButton) {
    }
    
    @IBAction func clickedOnHub(_ sender: UIButton) {
    }
}
