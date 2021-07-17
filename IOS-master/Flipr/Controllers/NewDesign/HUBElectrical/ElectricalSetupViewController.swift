//
//  ElectricalSetupViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 06/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class ElectricalSetupViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backbutton: UIButton!

    var isPresentView = false
    
    override func viewDidLoad() {
//        self.isPresentingView = isPresentView
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        tableView.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.isHidden = true
        tableView.alwaysBounceVertical = false
        if isPresentView{
            backbutton.setImage(#imageLiteral(resourceName: "Button Close"), for: .normal)
        }
        

    }
    
    @IBAction func backActoin(_ sender: Any) {
        if isPresentView {
            self.dismiss(animated: true, completion: nil)
        }else{
            goBack()
        }
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalSetupPrepareViewController")
        AppSharedData.sharedInstance.selectedEquipmentCode = 86
        self.navigationController?.pushViewController(vc!)
    }
    
    @IBAction func secondAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "ATTENTION".localized(), message:"If your filtration pump is not equipped with a Flipr HUB, make sure that it is always started up when the heat pump is switched on.".localized(), preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:"I get it".localized(), style: .default, handler: { (action) in
            AppSharedData.sharedInstance.selectedEquipmentCode = 85

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalSetupPrepareViewController")
            self.navigationController?.pushViewController(vc!)
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoHelpViewControllerID") as?  VideoHelpViewController {
//                vc.equipmentCode = "85"
//                vc.step = 1
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func thirdAction(_ sender: UIButton) {
        AppSharedData.sharedInstance.selectedEquipmentCode = 84
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElectricalSetupPrepareViewController")
        self.navigationController?.pushViewController(vc!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView.isScrollEnabled = tableView.contentSize.height >= view.frame.height
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 630
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}


class ElectricalSetupCell: UITableViewCell {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view1TitleLabel: UILabel!
    @IBOutlet weak var view2TitleLable: UILabel!
    @IBOutlet weak var view3TitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view1.layer.cornerRadius = 12
        view2.layer.cornerRadius = 12
        view3.layer.cornerRadius = 12
        
        view1.addCustomShadow()
        view2.addCustomShadow()
        view3.addCustomShadow()

        titleTextLabel.text = "Choisissez l'équipement que vous souhaitez connecter à votre Flipr Hub".localized
        subtitleLabel.text = "Choisissez un équipement".localized
        
        view1TitleLabel.text = "Pompe à filtration".localized
        view2TitleLable.text = "Pompe à chaleur".localized
        view3TitleLabel.text = "Éclairage".localized

   }
}
