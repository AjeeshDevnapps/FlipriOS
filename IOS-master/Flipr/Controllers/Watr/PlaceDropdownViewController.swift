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
    var placesModules = [PlaceModule]()
    
    let hud = JGProgressHUD(style:.dark)
    
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var delegate:PlaceDropdownDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTableView.tableFooterView = UIView()
        callPlacesApi()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func callPlacesApi(){
        hud?.show(in: self.view)
        User.currentUser?.getPlaces(completion: { (placesResult,error) in
            if (error != nil) {
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud?.textLabel.text = error?.localizedDescription
                self.hud?.dismiss(afterDelay: 0)
            } else {
                if placesResult != nil{
                    self.places = placesResult!
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
                        self.callDidSelectedDelegate(modules: placesModuleResult!, placeInfo: placeDetails)
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
}


extension PlaceDropdownViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PlaceDropdownTableViewCell",
                                                 for: indexPath) as! PlaceDropdownTableViewCell
        if indexPath.row >  self.places.count{
            return cell
        }
        cell.delegate = self
        let place = self.places[indexPath.row]
        cell.place = place
        if place.permissionLevel == "Admin"{
            cell.badgeButton.setImage(UIImage(named: "settingPlace"), for: .normal)
        }
        //        else if place.permissionLevel == "View"{
        else{
            cell.badgeButton.setImage(UIImage(named: "viewer"), for: .normal)
        }
        
        /*
         if place.permissionLevel == "Admin"{
         cell.badgeButton.setImage(UIImage(named: "levelBadge"), for: .normal)
         }
         else if place.permissionLevel == "View"{
         cell.badgeButton.setImage(UIImage(named: "viewOnly"), for: .normal)
         }
         else if place.permissionLevel == "Manage"{
         cell.badgeButton.setImage(UIImage(named: "manageBig"), for: .normal)
         }
         else{
         cell.badgeButton.setImage(UIImage(named: "levelBadge"), for: .normal)
         }
         */
        //        if place.placeType == "SwimmingPool"{
        //            cell.iconImageView.image = UIImage(named: "SwimmingPool")
        //        }
        //        else{
        //            cell.iconImageView.image = UIImage(named: "spaPlaceType")
        //
        //        }
        
        if let iconName  = place.typeIcon{
            let iconnameArray = iconName.components(separatedBy: ".")
            let iconname: String = iconnameArray[0]
            cell.iconImageView.image = UIImage(named: iconname )
        }
        
        cell.typeLbl.text = place.name
        var loc = place.placeOwnerFirstName
        if !place.placeOwnerLastName.isEmpty{
            loc?.append(" ")
            loc?.append(place.placeOwnerLastName)
        }
        loc?.append(", ")
        loc?.append(place.placeCity)
        cell.locationLbl.text = loc
        
        //        if place.placeOwner == 1{
        //            cell.badgeButton.setImage(UIImage(named: "settingPlace"), for: .normal)
        //        }else{
        //            cell.badgeButton.setImage(UIImage(named: "viewer"), for: .normal)
        //
        //        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeId:String = "\(String(describing: self.places[indexPath.row].placeId ?? 0))"
        let place = self.places[indexPath.row]
        self.getPlaceModules(placeId: placeId, placeDetails: place)
    }
    
    
    
    @IBAction func addPlaceButtonClicked(){
        let sb = UIStoryboard(name: "NewLocation", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NewLocationViewControllerID") as? NewLocationViewController {
            //            self.navigationController?.pushViewController(viewController, completion: nil)
            //            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    
    
    
    
}

extension PlaceDropdownViewController: PlaceDropdownCellDelegate{
    
    func didSelectSettings(place: PlaceDropdown?) {
        if let permision = place?.permissionLevel{
            if permision == "Admin"{
                let sb = UIStoryboard(name: "NewPool", bundle: nil)
                if let viewController = sb.instantiateViewController(withIdentifier: "NewPoolViewControllerID") as? UINavigationController {
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
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
        let alertVC = UIAlertController(title: "Supprimer le partage", message: "Cet utilisateur ne pourra plus consulter les données et agir sur vos équipements", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Annuler", style: .cancel)
        let confirmAction = UIAlertAction(title: "Supprimer le partage", style: .destructive) { action in
            self.deleteShare(email: email, placeId: placeId)
            self.dismiss(animated: true)
        }
        alertVC.addAction(confirmAction)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
    
    func deleteShare(email: String,placeId:String) {
        FliprShare().deleteShareWithPoolId(email: email, poolID: placeId) { error in
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }else{
                self.callPlacesApi()
            }
        }
    }
    
}
