//
//  AISettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 01/12/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

protocol AISettingsDelegate {
    func didResetChat()
}

class AISettingsViewController: UIViewController {
    @IBOutlet weak var settingTable: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tapView: UIView!
    var currentSelection = 0
    var delegate:AISettingsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    


    func setupView(){
        if let currentUnit = UserDefaults.standard.object(forKey: "CurrentAIMode") as? Int{
            self.currentSelection = currentUnit

        }else{
            self.currentSelection = 0
            UserDefaults.standard.set(0, forKey: "CurrentAIMode")
        }
        hideTableViewLastSeparator()
        titleLbl.text = "Quick Actions".localized
        menuView.layer.cornerRadius = 14
        menuView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        settingTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)

    }
    
    
    func hideTableViewLastSeparator() {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        settingTable.tableFooterView = footerView
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }
    
    @IBAction func closeButtonAction(){
        self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }, completion: nil)
    }
    
    @IBAction func selectionButtonAction(sender:UIButton){
        currentSelection = sender.tag
        self.settingTable.reloadData()
        
        UserDefaults.standard.set(currentSelection, forKey: "CurrentAIMode")
        

    }
    
    func showResetAI(){
        let alertController = UIAlertController(title: nil, message: "Reset conversation".localized, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Confirm".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            self.callResetAiApi()
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func callResetAiApi(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        Alamofire.request(Router.deleteAiMsg).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String:Any] {
                    let reply:AIReply = AIReply(fromDictionary: JSON)
                    //                    let obj = self.chats[self.chats.count - 1]
                    //                    obj.message = reply.message
                    //                        self.chatTableView
                    //                        self.chats.append(reply)
                }
                hud?.dismiss(afterDelay: 0)
                self.delegate?.didResetChat()
            case .failure(let error):
                hud?.dismiss(afterDelay: 0)
                //                self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                print(" GetAIinfo did fail with error: \(error)")
            }
        })
        
    }

}


extension AISettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if indexPath.row == 0{
            let cell =  tableView.dequeueReusableCell(withIdentifier:"AIResetCell",
                                                      for: indexPath) as! AIResetCell
            cell.titleLbl.text = "Reset conversation".localized
            return cell

        }
        else if indexPath.row == 1{
            let cell =  tableView.dequeueReusableCell(withIdentifier:"AIModeTitleCell",
                                                      for: indexPath) as! AIModeTitleCell
            return cell

        }
        else if indexPath.row == 2{
            let cell =  tableView.dequeueReusableCell(withIdentifier:"AIModeSelectionCell",
                                                      for: indexPath) as! AIModeSelectionCell
            cell.selctionBtn.tag = 0
            cell.selectionImageView.image = currentSelection == 0 ? UIImage(named:"radioSelected") : UIImage(named:"radioUnSelected")
            cell.infoLbl.text = "4774:64624".localized
            cell.titleLbl.text = "4774:64605".localized
            return cell

        }
        else if indexPath.row == 3{
            let cell =  tableView.dequeueReusableCell(withIdentifier:"AIModeSelectionCell",
                                                      for: indexPath) as! AIModeSelectionCell
            cell.selctionBtn.tag = 1
            cell.selectionImageView.image = currentSelection == 1 ? UIImage(named:"radioSelected") : UIImage(named:"radioUnSelected")
            cell.infoLbl.text = "4774:64629".localized
            cell.titleLbl.text = "4774:64613".localized
            return cell

        }
        
        else if indexPath.row == 4{
            let cell =  tableView.dequeueReusableCell(withIdentifier:"AIModeSelectionCell",
                                                      for: indexPath) as! AIModeSelectionCell
            cell.selctionBtn.tag = 2
            cell.selectionImageView.image = currentSelection == 2 ? UIImage(named:"radioSelected") : UIImage(named:"radioUnSelected")
            cell.infoLbl.text = "4774:64634".localized
            cell.titleLbl.text = "4774:64616".localized
            return cell

        }
        
        else
        {
            let cell =  tableView.dequeueReusableCell(withIdentifier:"AIModeTitleCell",
                                                      for: indexPath) as! AIModeTitleCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.showResetAI()
        }
    }
}
