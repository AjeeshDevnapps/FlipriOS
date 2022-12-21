//
//  NewLocationViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 30/10/22.
//  Copyright © 2022 I See U. All rights reserved.NewLocationTableViewCellID
//

import UIKit
import JGProgressHUD

enum LocationTypes: String, CaseIterable {
    case pool = "Pool"
    case spa = "SPA"
    case garden = "Garden"
    case aquarium = "Aquarium"
    case aquaponie = "Aquaponie"
    case lake = "Lake"
}

class NewLocationViewController: UIViewController {

    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleVC: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    let hud = JGProgressHUD(style:.dark)

    var selectedIndex: IndexPath!
    var placeTypes = PlaceTypes()
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
        self.hideBackButtonForAddPlaceflow()
        getPlaceTypes()
    }
    
    func getPlaceTypes() {
        let router = PlaceRouter()
        hud?.show(in: self.view)
        router.getPlaceTypes { types, error in
            self.hud?.dismiss(afterDelay: 0)
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.placeTypes = types ?? []
            if self.placeTypes.count > 0 {
                self.placeTypes.sort { $0.isAvailableAsPlace! && !$1.isAvailableAsPlace! }
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableHeightConstraint.constant = CGFloat(50 * self.placeTypes.count)
                self.view.layoutIfNeeded()
//                self.tableView.addShadow(offset: CGSize(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
            }
        }
    }
    
    func formatUI() {
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
//        tableView.tableFooterView = UIView()
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        tableView.tableFooterView = footerView

        tableView.contentInsetAdjustmentBehavior = .never
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        textField.attributedPlaceholder = NSAttributedString(string: "Nom de l'Emplacement",
                                                             attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
//        tableView.clipsToBounds = false
//        tableView.layer.masksToBounds = false
//        tableView.layer.shadowColor = UIColor.lightGray.cgColor
//        tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        tableView.layer.shadowRadius = 5.0
//        tableView.layer.shadowOpacity = 0.5
        tableView.layer.cornerRadius = 10
        self.view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.9568627477, blue: 0.9568629861, alpha: 1)
        submitButton.cornerRadius = 10
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.isScrollEnabled = false
    }
    
//    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
//        tableView.layer.masksToBounds = false
//        tableView.layer.shadowOffset = offset
//        tableView.layer.shadowColor = color.cgColor
//        tableView.layer.shadowRadius = radius
//        tableView.layer.shadowOpacity = opacity
//
//        let backgroundCGColor = tableView.backgroundColor?.cgColor
//        tableView.backgroundColor = nil
//        tableView.layer.backgroundColor =  backgroundCGColor
//    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let name:String = textField.text ?? ""
        if selectedIndex != nil && name.isValidString{
            AppSharedData.sharedInstance.addPlaceName = name
            showLocationSelectionVC()
        }
    }
    
    func showLocationSelectionVC(){
        let sb = UIStoryboard(name: "NewPool", bundle: nil)
        if let locationVC = sb.instantiateViewController(withIdentifier: "NewPoolLocationViewController") as? NewPoolLocationViewController {
            locationVC.title = "Localisation"
            AppSharedData.sharedInstance.isAddPlaceFlow = true 
            navigationController?.pushViewController(locationVC)
        }
    }
    
}

extension NewLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewLocationTableViewCellID", for: indexPath) as! LocationTypeTableViewCell
        if let iconName  = placeTypes[indexPath.row].typeIcon{
            let iconnameArray = iconName.components(separatedBy: ".")
            let iconname: String = iconnameArray[0]
            cell.icon.image = UIImage(named: iconname )
        }
        cell.titleName.text = placeTypes[indexPath.row].name
        if let isPlaceTypeAvailable = placeTypes[indexPath.row].isAvailableAsPlace{
            if isPlaceTypeAvailable{
                
            }else{
                
            }
        }
        
        let place = placeTypes[indexPath.row]
        cell.disableView.isHidden = place.isAvailableAsPlace ?? true
        cell.contentView.alpha = 0.5
        if let isAvaible = placeTypes[indexPath.row].isAvailableAsPlace{
            if isAvaible == false{
                cell.contentView.alpha = 0.5
            }else{
                cell.contentView.alpha = 1.0
            }
        }

        
//        cell.textLabel?.text = placeTypes[indexPath.row].name
//        cell.imageView?.image = UIImage(named: "menu_picto_pool")
//        cell.imageView?.backgroundColor = .black
//        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if indexPath.row == placeTypes.count - 1 {
               cell.separatorInset.left = UIScreen.main.bounds.width
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let isAvaible = placeTypes[indexPath.row].isAvailableAsPlace{
            if isAvaible == false{
                return
            }
        }
        if selectedIndex != nil {
            tableView.cellForRow(at: selectedIndex)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        AppSharedData.sharedInstance.addPlaceLocationInfo.palceId = placeTypes[indexPath.row].id ?? 0
        AppSharedData.sharedInstance.addPlaceLocationInfo.typeIcon = placeTypes[indexPath.row].typeIcon ?? ""
        AppSharedData.sharedInstance.addPlaceLocationInfo.IsAvailableAsPlace = placeTypes[indexPath.row].isAvailableAsPlace ?? false
        AppSharedData.sharedInstance.addPlaceLocationInfo.name = placeTypes[indexPath.row].name ?? ""

    }
}
