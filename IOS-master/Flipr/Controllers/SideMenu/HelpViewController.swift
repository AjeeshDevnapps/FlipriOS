//
//  HelpViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import SafariServices

class HelpViewController: UIViewController {
    @IBOutlet weak var tipsContainerView: UIView!
    @IBOutlet weak var faqContainerView: UIView!
    @IBOutlet weak var helpContainerView: UIView!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var faqLbl: UILabel!
    @IBOutlet weak var helpLbl: UILabel!
    @IBOutlet weak var provacyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help".localized
        self.tipLbl.text = "Tips & Tricks".localized
        self.faqLbl.text = "FAQ".localized
        self.helpLbl.text = "I need help !".localized
        provacyButton.setTitle("Terms & privacy".localized, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))
        setupViews()
        // Do any additional setup after loading the view.
    }
 

    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupViews(){
        tipsContainerView.layer.cornerRadius = 15.0
        tipsContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        faqContainerView.layer.cornerRadius = 15.0
        faqContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        helpContainerView.layer.cornerRadius = 15.0
        helpContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
    }

    @IBAction func tipsButtonClicked(){
        if let url = URL(string: "BLOG_URL".localized.remotable) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func  faqButtonClicked(){
        if let url = URL(string: "FAQ_URL".localized.remotable) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(vc, animated: true)
        }
    }
    
    
    @IBAction func helpButtonClicked(){
//        if let url = URL(string: "HELP_DESK_URL".localized.remotable) {
        if let url = URL(string: "https://fliprshop.zohodesk.com/") {

            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(vc, animated: true)
        }
    }
    
    
    @IBAction func privacyButtonClicked(){
        if let url = URL(string: "CGU_URL".localized.remotable) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            self.present(vc, animated: true)
        }
    }

}
