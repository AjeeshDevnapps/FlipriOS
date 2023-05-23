//
//  NoPlaceIntroViewController.swift
//  Flipr
//
//  Created by Ajeesh on 19/05/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class NoPlaceIntroViewController: BaseViewController {
    var invitationList = [PlaceDropdown]()
    var places = [PlaceDropdown]()

    @IBOutlet weak var placesTableView: UITableView!
//    @IBOutlet weak var infoLabel: UILabel!

//    @IBOutlet weak var addPlaceButton: UIButton!
//    @IBOutlet weak var deleteUserButton: UIButton!
//    @IBOutlet weak var disconnectButton: UIButton!
    var haveInvitation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension NoPlaceIntroViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.haveInvitation{
            return 3
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        else if section == 1{
            if self.haveInvitation{
                return self.invitationList.count
            }else{
                return 1
            }
        }else{
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.haveInvitation{
            if section == 1{
                return 50.0
            }else{
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.haveInvitation{
            if section == 1{
                return "Invitations".localized
            }
            else{
                return nil
            }
        }else{
            return nil
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 391
        }
        else if indexPath.section == 1{
            if self.haveInvitation{
                return 110
            }else{
                return 300
            }
        }else{
            return 300
        }
        
       
       
    }
//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier:"NoPlaceIntroInfoTableViewCell",
                                                     for: indexPath) as! NoPlaceIntroInfoTableViewCell
            return cell;
        }
        
        else if indexPath.section == 1{
            if self.haveInvitation{
                
//                if indexPath.section == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier:"InvitationTableViewCell",
                                                             for: indexPath) as! InvitationTableViewCell
                    cell.delegate = self
                    let place = self.invitationList[indexPath.row]
                    cell.place = place
                    cell.typeLbl.text = place.privateName
                    var loc = place.placeOwnerFirstName
                    if place.placeOwnerLastName != nil{
                        loc?.append(" ")
                        loc?.append(place.placeOwnerLastName ?? "")
                    }
                    loc?.append(", ")
                    if place.placeCity != nil{
                        loc?.append(place.placeCity ?? "")
                    }
                    cell.locationLbl.text = loc
                    
                    if let iconName  = place.typeIcon{
                        let iconnameArray = iconName.components(separatedBy: ".")
                        let iconname: String = iconnameArray[0]
                        cell.iconImageView.image = UIImage(named: iconname )
                    }
                    cell.contentView.alpha = 1.0
                    return cell;
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:"NoPlaceIntroableViewCell",
                                                         for: indexPath) as! NoPlaceIntroableViewCell
                cell.delegate = self
                return cell;
                
            }
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"NoPlaceIntroableViewCell",
                                                     for: indexPath) as! NoPlaceIntroableViewCell
            cell.delegate = self
            return cell;
            
        }
       
    }
    
    
    @IBAction func addPlaceButtonClicked(){
        let sb = UIStoryboard(name: "NewLocation", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NewLocationViewControllerID") as? NewLocationViewController {
            //            self.navigationController?.pushViewController(viewController, completion: nil)
            //            viewController.modalPresentationStyle = .fullScreen
            let nav = UINavigationController.init(rootViewController: viewController)
            self.present(nav, animated: true)
        }
    }
    
    
    @IBAction func deleteUserButtonClicked(){
        
    }
    
    @IBAction func disconnectButtonClicked(){
        
    }
}


extension NoPlaceIntroViewController: InvitationTableViewCellDelegate{

    func didSelectAccept(place:PlaceDropdown?){
        if let placeId = place?.placeId{
            let placeIdStr = "\(placeId)"
            self.acceptShare(email: place?.guestUser ?? "" , placeId: placeIdStr)
        }
    }
    
    func didSelectDecline(place:PlaceDropdown?){
        
        if let placeId = place?.placeId{
            let placeIdStr = "\(placeId)"
            self.declineSharePrompt(email: place?.guestUser ?? "" , placeId: placeIdStr)
        }
    }
    
    
    
    func declineSharePrompt(email: String,placeId:String){
        let alertVC = UIAlertController(title: "Refuser le partage", message: "Vous ne serez pas en mesure de consulter cet emplacement", preferredStyle: .alert)
        let action = UIAlertAction(title: "Annuler", style: .cancel)
        let confirmAction = UIAlertAction(title: "Refuser le partage", style: .destructive) { action in
            self.deleteShare(email: email, placeId: placeId)
            self.dismiss(animated: true)
        }
        alertVC.addAction(confirmAction)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
    
    func acceptShare(email: String,placeId:String) {
        FliprShare().acceptShareWithPoolId( poolID: placeId) { error in
            if error != nil {
//                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
//                alertVC.addAction(alertAction)
//                self.present(alertVC, animated: true)
//                return
            }else{
                self.presentDashboard()
            }
        }
    }
    
    
    func presentDashboard() {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let dashboard = mainSB.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: false, completion: {
        })
    }
    
    
    
    func deleteSharePrompt(email: String,placeId:String){
        let alertVC = UIAlertController(title: "Quitter le partage", message: "Vous ne serez plus en mesure de consulter cet emplacement", preferredStyle: .alert)
        let action = UIAlertAction(title: "Annuler", style: .cancel)
        let confirmAction = UIAlertAction(title: "Quitter le partage", style: .destructive) { action in
            self.deleteShare(email: email, placeId: placeId)
//            self.dismiss(animated: true)
        }
        alertVC.addAction(confirmAction)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
    
    
    
    
    func deleteShare(email: String,placeId:String) {
        FliprShare().deleteShareWithPoolId(email: email, poolID: placeId) { error in
            if error != nil {
//                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
//                alertVC.addAction(alertAction)
//                self.present(alertVC, animated: true)
//                return
                self.callPlacesApi()

            }else{
                self.callPlacesApi()
            }
        }
    }
    
    func callPlacesApi(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        User.currentUser?.getPlaces(completion: { (placesResult,error) in
            if (error != nil) {
//                self.clearData()
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 0)
            }
            else {
                if placesResult != nil{
                   // print(placesResult)
                    self.places = placesResult!
                    if self.places.count > 0 {
                    }
//                    self.places.sort { $0.isPending && !$1.isPending }
//                     self.placesList = self.places.filter { $0.isPending == false }
                    self.invitationList = self.places.filter { $0.isPending == true }
                    self.haveInvitation = false
                   
                    if self.invitationList.count > 0 {
                        self.haveInvitation = true
                    }
//                    for obj in self.places {
//                        if obj.isPending{
//                            self.haveInvitation = true
//                            self.havePlace = true
//                        }
//                    }
                    hud?.dismiss(afterDelay: 0)
                    self.placesTableView.reloadData()
                }
            }
        })
    }


}

extension NoPlaceIntroViewController: NoPlaceIntroCellDelegate{
    
    func didSelectAddPlace(){
        addPlaceView()
    }
    
    func didSelectDeleteUser(){
        deleteAccount()
    }
    
    func didSelectDisconnect(){
        self.logout()

    }

    
    func deleteAccount(){
        let alertController = UIAlertController(title: "Delete Account".localized, message: "Delete Account info".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        let okAction = UIAlertAction(title: "Delete Account".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            self.callDeleteUserApi()
//            User.logout()
//            self.dismiss(animated: true, completion: {
//                NotificationCenter.default.post(name: K.Notifications.UserDidLogout, object: nil)
//            })
            
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func addPlaceView(){
        let sb = UIStoryboard(name: "NewLocation", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NewLocationViewControllerID") as? NewLocationViewController {
//            AppSharedData.sharedInstance.isAddPlaceFlow = true
            self.navigationController?.pushViewController(viewController, completion: nil)
            //            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true)
        }
    }
    
    func logout(){
        let alertController = UIAlertController(title: "LOGOUT_TITLE".localized, message: "Are you sure you want to log out?".localized, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Log out".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            AppSharedData.sharedInstance.logout = true

            User.logout()
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func callDeleteUserApi(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        User.currentUser?.deleteUser(completion: { (error) in
            AppSharedData.sharedInstance.logout = true
            if error != nil {
//                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
//                hud?.textLabel.text = error?.localizedDescription
//                hud?.dismiss(afterDelay: 3)
                hud?.dismiss(afterDelay: 0)
                User.logout()
                NotificationCenter.default.post(name: K.Notifications.UserDidLogout, object: nil)
            } else {
                hud?.dismiss(afterDelay: 0)
                User.logout()
                NotificationCenter.default.post(name: K.Notifications.UserDidLogout, object: nil)
            }
        })
    }
}
