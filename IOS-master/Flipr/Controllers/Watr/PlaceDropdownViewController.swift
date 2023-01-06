//
//  PlaceDropdownViewController.swift
//  Flipr
//
//  Created by Ajeesh on 03/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol PlaceDropdownDelegate {
    func didSelectPlaceModules(placeModules:[PlaceModule],placeDetails:PlaceDropdown)
}


class PlaceDropdownViewController: UIViewController {
    var places = [PlaceDropdown]()
    
    var placesList = [PlaceDropdown]()
    var invitationList = [PlaceDropdown]()
    

    
    var placesModules = [PlaceModule]()
    
    let hud = JGProgressHUD(style:.dark)
    var haveInvitation = false
    var havePlace = false
    var placeTitle : String?
    
    var selectedPlace : PlaceDropdown?
    
    var isInvitationFlow = false



    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backgrndView: UIView!
    @IBOutlet weak var noPlaceMsgStack: UIStackView!
    @IBOutlet weak var noPlaceMsgLabel: UILabel!


    var delegate:PlaceDropdownDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isInvitationFlow{
            self.title = "Place"
        }
        backgrndView.isHidden = !isInvitationFlow
        placesTableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(forName: K.Notifications.PlaceDeleted, object: nil, queue: nil) { (notification) in
            self.callPlacesApi()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callPlacesApi()
    }
    
    
    func clearData(){
     //   self.noPlaceMsgLabel.text = "noPlaceMsg".localized
        self.noPlaceMsgStack.isHidden = false
        self.haveInvitation = false
        self.havePlace = false
        self.placesList.removeAll()
        self.invitationList.removeAll()
        self.places.removeAll()
        
    }
    
    
    func callPlacesApi(){
        hud?.show(in: self.view)
        User.currentUser?.getPlaces(completion: { (placesResult,error) in
            if (error != nil) {
                self.clearData()
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud?.textLabel.text = error?.localizedDescription
                self.hud?.dismiss(afterDelay: 0)
            } else {
                if placesResult != nil{
                   // print(placesResult)
                    self.places = placesResult!
                    if self.places.count > 0 {
                        self.noPlaceMsgStack.isHidden = true
                    }
//                    self.places.sort { $0.isPending && !$1.isPending }
                     self.placesList = self.places.filter { $0.isPending == false }
                    self.invitationList = self.places.filter { $0.isPending == true }
                    self.haveInvitation = false
                    self.havePlace = false
                    if self.placesList.count > 0 {
                        self.havePlace = true
                    }
                    if self.invitationList.count > 0 {
                        self.haveInvitation = true
                    }
//                    for obj in self.places {
//                        if obj.isPending{
//                            self.haveInvitation = true
//                            self.havePlace = true
//                        }
//                    }
                    self.hud?.dismiss(afterDelay: 0)
                    self.placesTableView.reloadData()
                }
            }
            
        })
    }
    
    
    func getPlaceModules(placeId:String,placeDetails:PlaceDropdown){
        hud?.show(in: self.view)
        User.currentUser?.getPlaceModules(placeId: placeId, completion: { (placesModuleResult,error) in
            if (error != nil) {
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud?.textLabel.text = error?.localizedDescription
                self.hud?.dismiss(afterDelay: 3)
            } else {
                if placesModuleResult != nil{
                    
                    self.placesModules = placesModuleResult!
                    if self.placesModules.count > 0{
                        self.hud?.dismiss(afterDelay: 0)
                        if self.isInvitationFlow{
                            self.presentDashboard()
                        }else{
                            self.callDidSelectedDelegate(modules: placesModuleResult!, placeInfo: placeDetails)
                        }
                    }else{
                        self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud?.textLabel.text = "This place have no modules"
                        self.hud?.dismiss(afterDelay: 3)
                    }
                }
            }
            
        })
    }
    
    
    func callDidSelectedDelegate(modules:[PlaceModule],placeInfo: PlaceDropdown){
        self.delegate?.didSelectPlaceModules(placeModules: modules, placeDetails: placeInfo)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentDashboard() {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let dashboard = mainSB.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: false, completion: {
        })
    
    }
}


extension PlaceDropdownViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.haveInvitation && self.havePlace{
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.haveInvitation && self.havePlace{
            if section == 0{
                return self.placesList.count
            }else{
                return self.invitationList.count
            }
        }else{
            if self.haveInvitation{
                return self.invitationList.count
            }else{
                return self.placesList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.haveInvitation && self.havePlace{
            if section == 0{
                return "Emplacements actifs"
            }else{
                return "Invitations"
            }
        }else{
            if self.haveInvitation{
                return "Invitations"
            }else{
                return "Emplacements actifs"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.haveInvitation && self.havePlace{
            if indexPath.section == 0{
                return 80
            }else{
                return 110
            }
        }else{
            if self.haveInvitation{
                return 110
            }else{
                return 80
            }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if self.haveInvitation && self.havePlace{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier:"PlaceDropdownTableViewCell",
                                                         for: indexPath) as! PlaceDropdownTableViewCell
                if indexPath.row >  self.places.count{
                    return cell
                }
                cell.delegate = self
                let place = self.placesList[indexPath.row]
                cell.place = place
                if place.permissionLevel == "Admin"{
                    cell.badgeButton.setImage(UIImage(named: "settingPlace"), for: .normal)
                }
                //        else if place.permissionLevel == "View"{
                else{
                    cell.badgeButton.setImage(UIImage(named: "Button_Close"), for: .normal)
                }
                if let iconName  = place.typeIcon{
                    let iconnameArray = iconName.components(separatedBy: ".")
                    let iconname: String = iconnameArray[0]
                    cell.iconImageView.image = UIImage(named: iconname )
                }
                
                cell.typeLbl.text = place.privateName ??  place.name
                var loc = place.placeOwnerFirstName
                if !place.placeOwnerLastName.isEmpty{
                    loc?.append(" ")
                    loc?.append(place.placeOwnerLastName)
                }
                loc?.append(", ")
                loc?.append(place.placeCity)
                if place.permissionLevel == "Admin"{
                    cell.locationLbl.text = place.placeCity
                }else{
                    cell.locationLbl.text = loc
                }
                
                let moduelsNo = self.places[indexPath.row].numberOfModules
                cell.disableView.isHidden = true
                cell.contentView.alpha = 1.0
                if moduelsNo > 0 {
                    cell.disableView.isHidden = true
                }else{
                    cell.disableView.isHidden = false
                    cell.contentView.alpha = 0.5
                }

                return cell;
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:"InvitationTableViewCell",
                                                         for: indexPath) as! InvitationTableViewCell
                if indexPath.row >  self.places.count{
                    return cell
                }
                cell.delegate = self
                let place = self.invitationList[indexPath.row]
                cell.place = place
                cell.typeLbl.text = place.privateName
                var loc = place.placeOwnerFirstName
                if !place.placeOwnerLastName.isEmpty{
                    loc?.append(" ")
                    loc?.append(place.placeOwnerLastName)
                }
                loc?.append(", ")
                loc?.append(place.placeCity)
                cell.locationLbl.text = loc
               
                if let iconName  = place.typeIcon{
                    let iconnameArray = iconName.components(separatedBy: ".")
                    let iconname: String = iconnameArray[0]
                    cell.iconImageView.image = UIImage(named: iconname )
                }
                cell.contentView.alpha = 1.0
                return cell;
                
               
            }
        }else{
            if self.haveInvitation == false{
                let cell = tableView.dequeueReusableCell(withIdentifier:"PlaceDropdownTableViewCell",
                                                         for: indexPath) as! PlaceDropdownTableViewCell
                if indexPath.row >  self.places.count{
                    return cell
                }
                cell.delegate = self
                let place = self.placesList[indexPath.row]
                cell.place = place
                if place.permissionLevel == "Admin"{
                    cell.badgeButton.setImage(UIImage(named: "settingPlace"), for: .normal)
                }
                //        else if place.permissionLevel == "View"{
                else{
                    cell.badgeButton.setImage(UIImage(named: "Button_Close"), for: .normal)
                }
                if let iconName  = place.typeIcon{
                    let iconnameArray = iconName.components(separatedBy: ".")
                    let iconname: String = iconnameArray[0]
                    cell.iconImageView.image = UIImage(named: iconname )
                }
                
                cell.typeLbl.text = place.privateName ??  place.name
                
                var loc = place.placeOwnerFirstName
                if !place.placeOwnerLastName.isEmpty{
                    loc?.append(" ")
                    loc?.append(place.placeOwnerLastName)
                }
                loc?.append(", ")
                loc?.append(place.placeCity ?? "")
//                cell.locationLbl.text = loc
                if place.permissionLevel == "Admin"{
                    cell.locationLbl.text = place.placeCity
                }else{
                    cell.locationLbl.text = loc
                }
                let moduelsNo = self.places[indexPath.row].numberOfModules
                cell.disableView.isHidden = true
                cell.contentView.alpha = 1.0
                if moduelsNo > 0 {
                    cell.disableView.isHidden = true
                }else{
                    cell.disableView.isHidden = false
                    cell.contentView.alpha = 0.5
                }

                return cell;
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier:"InvitationTableViewCell",
                                                         for: indexPath) as! InvitationTableViewCell
                if indexPath.row >  self.places.count{
                    return cell
                }
                cell.delegate = self
                let place = self.invitationList[indexPath.row]
                cell.place = place
                cell.typeLbl.text = place.privateName ??  place.name
                
                var loc = place.placeOwnerFirstName
                if !place.placeOwnerLastName.isEmpty{
                    loc?.append(" ")
                    loc?.append(place.placeOwnerLastName)
                }
                loc?.append(", ")
                loc?.append(place.placeCity)
                cell.locationLbl.text = loc
                if let iconName  = place.typeIcon{
                    let iconnameArray = iconName.components(separatedBy: ".")
                    let iconname: String = iconnameArray[0]
                    cell.iconImageView.image = UIImage(named: iconname )
                }
                cell.contentView.alpha = 1.0
                
                return cell;
                
            }
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moduelsNo = self.places[indexPath.row].numberOfModules
        if moduelsNo > 0 {
            let placeId:String = "\(String(describing: self.places[indexPath.row].placeId ?? 0))"
            let place = self.places[indexPath.row]
            self.getPlaceModules(placeId: placeId, placeDetails: place)
        }else{
            
            let sb = UIStoryboard(name: "NewPool", bundle: nil)
            if let viewController = sb.instantiateViewController(withIdentifier: "AddDeviceListViewController") as? AddDeviceListViewController {
                AppSharedData.sharedInstance.addedPlaceId = self.places[indexPath.row].placeId 
                self.present(viewController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    @IBAction func addPlaceButtonClicked(){
        if placesList.count  < 50{
            let sb = UIStoryboard(name: "NewLocation", bundle: nil)
            if let viewController = sb.instantiateViewController(withIdentifier: "NewLocationViewControllerID") as? NewLocationViewController {
                //            self.navigationController?.pushViewController(viewController, completion: nil)
                //            viewController.modalPresentationStyle = .fullScreen
                let nav = UINavigationController.init(rootViewController: viewController)
                self.present(nav, animated: true)
            }
        }else{
            self.showError(title: "Warning!", message: "Exceeded the Max Count 3")
        }
       
    }
    
    
}


extension PlaceDropdownViewController: InvitationTableViewCellDelegate{

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
            }
            self.callPlacesApi()
        }
    }
    

}


extension PlaceDropdownViewController: PlaceDropdownCellDelegate{
    
    func didSelectSettings(place: PlaceDropdown?) {
        selectedPlace = place
        if let permision = place?.permissionLevel{
            if permision == "Admin"{
                let sb = UIStoryboard(name: "NewPool", bundle: nil)
                if let viewController = sb.instantiateViewController(withIdentifier: "NewPoolViewControllerSettings") as? NewPoolViewController {
                    viewController.placeTitle = self.placeTitle
                    viewController.placeDetails = selectedPlace
                    let nav = UINavigationController.init(rootViewController: viewController)
//                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            }else{
                if let placeId = place?.placeId{
                    let placeIdStr = "\(placeId)"
                    self.deleteSharePrompt(email: place?.guestUser ?? "" , placeId: placeIdStr)
                }
            }
        }
        
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
//                self.callPlacesApi()

            }else{
//                self.callPlacesApi()
            }
            self.callPlacesApi()
        }
    }
    
    
    
}
