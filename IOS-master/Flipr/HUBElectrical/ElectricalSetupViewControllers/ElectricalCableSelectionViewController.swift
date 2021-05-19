//
//  ElectricalCableSelectionViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 09/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import SafariServices

class ElectricalCableSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    var equipmentCode = ""
    var inf90 = false
    var simultaneous = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ElectricalCableCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height > 700 ? tableView.frame.height : 700
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    @IBAction func backButtonAction(_ sender: Any) {
        goBack()
    }
    
    @IBAction func webviewButtonAction(_ sender: Any) {
        if let url = URL(string: "https://videoapp.goflipr.com/MANUEL_HUB_zoom_cablages.pdf".localized) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(vc, animated: true)
        }
    }

    @IBAction func cables2ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            if inf90 {
                vc.guideName = "GUIDE_5"
                vc.showHelperLabel = true
            } else {
                vc.guideName = "GUIDE_2"
            }
            vc.step = 5
            vc.needsAlert = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cables3ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            if inf90 {
                vc.guideName = "GUIDE_5"
                vc.showHelperLabel = true
            } else {
                if simultaneous {
                    vc.guideName = "GUIDE_6"
                } else {
                    vc.guideName = "GUIDE_3"
                }
            }
            vc.step = 5
            vc.needsAlert = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func cables4ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            vc.guideName = "GUIDE_4"
            vc.cable4 = true
            vc.step = 5
            vc.needsAlert = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cables5ButtonAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalVideoViewController") as?  ElectricalVideoViewController {
            vc.equipmentCode = equipmentCode
            vc.inf90 = inf90
            vc.simultaneous = simultaneous
            vc.step = 5
            vc.guideName = "GUIDE_1"
            vc.needsAlert = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

class ElectricalCableCell: UITableViewCell {
   
    @IBOutlet weak var cableView2: UIView!
    @IBOutlet weak var cableView3: UIView!
    @IBOutlet weak var cableView4: UIView!
    @IBOutlet weak var cableView5: UIView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    @IBOutlet weak var cables2Button: UIButton!
    @IBOutlet weak var cables3Button: UIButton!
    @IBOutlet weak var cables4Button: UIButton!
    @IBOutlet weak var cables5Button: UIButton!
    @IBOutlet weak var utilView: UIView!
    @IBOutlet weak var webViewButton: UIButton!
    @IBOutlet weak var utilTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cableView2.layer.cornerRadius = 12
        cableView3.layer.cornerRadius = 12
        cableView4.layer.cornerRadius = 12
        cableView5.layer.cornerRadius = 12
        utilView.layer.cornerRadius = 12
        
        cableView2.addCustomShadow()
        cableView3.addCustomShadow()
        cableView4.addCustomShadow()
        cableView5.addCustomShadow()
        utilView.addCustomShadow()
        
        webViewButton.setTitle("I have a doubt".localized(), for: .normal)
        titleTextLabel.text = "Bravo !".localized
        subtitleTextLabel.text = "À présent, choisissez le schéma qui correspond à votre installation.".localized
        cables2Button.setTitle("2 câbles".localized, for: .normal)
        cables3Button.setTitle("3 câbles".localized, for: .normal)
        cables4Button.setTitle("4 câbles".localized, for: .normal)
        cables5Button.setTitle("5 câbles".localized, for: .normal)
        
        let regularAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let boldAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)]
        let text = NSMutableAttributedString(string: "Tout sauf".localized, attributes: regularAttrs)
        text.append(NSAttributedString(string: " "))
        text.append(NSAttributedString(string: "blue".localized, attributes: boldAttrs))
        text.append(NSAttributedString(string: ", "))
        text.append(NSAttributedString(string: "jaune".localized, attributes: boldAttrs))
        text.append(NSAttributedString(string: " "))
        text.append(NSAttributedString(string: "et".localized, attributes: regularAttrs))
        text.append(NSAttributedString(string: " "))
        text.append(NSAttributedString(string: "vert".localized, attributes: boldAttrs))

        utilTextLabel.attributedText = text
    }
}

extension UIView {
    func addCustomShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 24)
        layer.shadowOpacity = 1
        layer.shadowRadius = 40
        layer.shadowColor = UIColor(red: 0, green: 0.071, blue: 0.278, alpha: 0.14).cgColor
    }
}
