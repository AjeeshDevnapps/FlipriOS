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
    func didSelectPlaceModules(placeModules:[PlaceModule])
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
    
    
    func getPlaceModules(placeId:String){
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
                        self.callDidSelectedDelegate(modules: placesModuleResult!)
                    }else{
                        self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud?.textLabel.text = "This place have no modules"
                        self.hud?.dismiss(afterDelay: 3)
                    }
                }
            }
                    
        })
    }
    
    
    func callDidSelectedDelegate(modules:[PlaceModule]){
        self.delegate?.didSelectPlaceModules(placeModules: modules)
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
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PlaceDropdownTableViewCell",
                                                 for: indexPath) as! PlaceDropdownTableViewCell
        if indexPath.row >  self.places.count{
            return cell
        }
//        if let plc =
//        cell.delegate = self
        let place = self.places[indexPath.row]
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
        
        if place.placeType == "SwimmingPool"{
            cell.iconImageView.image = UIImage(named: "SwimmingPool")
        }
        else{
            cell.iconImageView.image = UIImage(named: "spaPlaceType")

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
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeId:String = "\(String(describing: self.places[indexPath.row].placeId ?? 0))"
        self.getPlaceModules(placeId: placeId)
    }
    
    
    
    @IBAction func addPlaceButtonClicked(){
        
    }
    
    

    

}
