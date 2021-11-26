//
//  FliprHubNonSubscriptionMenuViewController.swift
//  Flipr
//
//  Created by Ajeesh on 06/09/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class FliprHubNonSubscriptionMenuViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var titleLbl: UILabel!

    var cellTitleList = ["Carnet d’entretien","Flipr Predict","Flipr Expert","Pool House","Flipr Store","Conseils et astuces","Paramètres","Aide","Déconnexion"]
    
    var imageNames = ["menu1","menu2","menu3","menu4","menu5","menu6","menu7","menu8","menu9"]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }

    
  
}

extension FliprHubNonSubscriptionMenuViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cellTitleList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell =  tableView.dequeueReusableCell(withIdentifier:"MenuTableViewCell",
                                             for: indexPath) as! MenuTableViewCell
        
        cell.menuTitleLbl.text = cellTitleList[indexPath.row]
        cell.menuIcon.image =  UIImage(named: imageNames[indexPath.row])
        return cell
    }
        
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2{
            
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpertMenuViewController") as? ExpertMenuViewController {
               // viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: true)
            }
        }
    }
    
  
}
