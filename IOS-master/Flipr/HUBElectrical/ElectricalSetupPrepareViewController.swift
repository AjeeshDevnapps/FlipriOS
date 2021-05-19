//
//  ElectricalSetupPrepareViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 06/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class ElectricalSetupPrepareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        tableView.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.isHidden = true
        submitButton.layer.cornerRadius = 12
        tableView.alwaysBounceVertical = false
        
        submitButton.setTitle("J’ai compris".localized, for: .normal)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 580
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    @IBAction func backAction(_ sender: Any) {
        goBack()
    }
    
    @IBAction func goToNextOnSubmit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as! ElectricalVideoViewController
        vc.equipmentCode = "84"
        vc.inf90 = false
        vc.simultaneous = false
        vc.showHelperLabel = false
        vc.step = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class ElectricalSetupPrepareCell: UITableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var view1Title: UILabel!
    @IBOutlet weak var view1SubTitle: UILabel!
    @IBOutlet weak var view2Title: UILabel!
    @IBOutlet weak var view2SubTitle: UILabel!
    @IBOutlet weak var view3Title: UILabel!
    @IBOutlet weak var view3SubTitle: UILabel!
    @IBOutlet weak var view4Title: UILabel!
    @IBOutlet weak var view4SubTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTextLabel.text = "Assurez-vous de bien avoir préparé votre équipement".localized
        subtitleLabel.text = "Pour l'installation de votre Flipr Hub, Flipr vous recommande l’utilisation de outils suivants : ".localized
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = #colorLiteral(red: 0.239353925, green: 0.5618935227, blue: 0.6831510663, alpha: 1)
        
        view1SubTitle.text = "Pour sectionner le câble d'alimentation".localized
        view2SubTitle.text = "Pour dénuder le câble d'alimentation".localized
        view3SubTitle.text = "Pour dévisser les caches de Flipr Hub".localized
        view4SubTitle.text = "Pour découper les œillets de protection".localized
   }
}
