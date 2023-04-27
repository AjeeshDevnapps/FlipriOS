
//
//  NewPoolViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 07/08/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class NewPoolViewController: UIViewController {
    
    @IBOutlet weak var segmentStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parametersButton: UIButton!
    @IBOutlet weak var partagesButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabelOnTop: UILabel!
    var hasLoadedShares = false
    var isCreatingPlace = false
    var loadedShares = [ShareModel]()
//    var contactList = [ContactsWatr]()
    var contacts = [ShareModel]()


    var placeDetailsRespose: PlaceSettingsDetails?

    var poolSettings: PoolSettingsModel?
    var placeTitle:String?
    var placeDetails:PlaceDropdown?
    let hud = JGProgressHUD(style:.dark)
    var volume = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if AppSharedData.sharedInstance.isAddPlaceFlow{
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.submitButton.isHidden = false
            parametersButton.isSelected = true
            parametersButton.isUserInteractionEnabled = false
        }else{
            parametersButton.isSelected = true
//            self.submitButton.isHidden = true
            setCustomBackbtn()
            getPoolSettings()
        }
        let settingsTitle =  "      \("Paramètres".localized)"
        parametersButton.setTitle(settingsTitle, for: .normal)
        
        let partagesTitle =  "      \("Partages".localized)"
        partagesButton.setTitle(partagesTitle, for: .normal)

        submitButton.setTitle("Supprimer".localized, for: .normal)

        
        tableView.backgroundColor = UIColor(hexString: "#eeeee4")
        view.backgroundColor = UIColor(hexString: "#eeeee4")
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#eeeee4")
        title = placeTitle
//        setCustomBackbtn()
        segmentStackView.cornerRadius = 10
        segmentStackView.clipsToBounds = true
        partagesButton.isSelected = false
        adjustColorForSegmentButtons()
        submitButton.cornerRadius = 10.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SystemCellForEmails")
        if isCreatingPlace{
            self.partagesButton.isUserInteractionEnabled = false
            self.partagesButton.isEnabled = false
            self.parametersButton.isUserInteractionEnabled = false
        }
        if AppSharedData.sharedInstance.isAddPlaceFlow{
//            createPlace()
        }
//        AppSharedData.sharedInstance.isAddPlaceFlow = false
    }
    
    override func goBack() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if parametersButton.isSelected {
            self.deletePlacePrompt()
        } else {
            showAddShareAlert()
//            let sb = UIStoryboard(name: "NewPool", bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: "PoolShareViewControllerID") as! PoolShareViewController
//            vc.changeDelegate = self
//            vc.isAddingNew = true
//            self.present(vc, animated: true)
        }
    }
    
    
    func updatePlaceDetails(){
        AppSharedData.sharedInstance.updatePlaceInfo = self.poolSettings ?? PoolSettingsModel()
        User.currentUser?.updatePlace( completion: { (settings,error) in
//            if (error != nil) {
//                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
//                self.hud?.textLabel.text = error?.localizedDescription
//                self.hud?.dismiss(afterDelay: 3)
//            } else {
//                self.hud?.dismiss(afterDelay: 0)
                self.poolSettings = settings
//                self.tableView.reloadData()
//            }
            
        })
    }
    
    
    func deletePlace(){
        var placeId:String = ""
        if let pId = self.placeDetails?.placeId{
            placeId = "\(pId)"
            FliprShare().poolId = placeId
        }
        FliprShare().deletePlace(placeId: placeId) { error in
            
            if error != nil {
//                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
//                alertVC.addAction(alertAction)
//                self.present(alertVC, animated: true)
//                return
            }
            else{
//                self.dismiss(animated: true, completion: nil)
            }
            if BLEManager.shared.flipr != nil{
                BLEManager.shared.centralManager.cancelPeripheralConnection(BLEManager.shared.flipr!)
            }
            
//            if self.placeDetails.
            NotificationCenter.default.post(name: K.Notifications.PlaceDeleted, object: nil)
            self.dismiss(animated: true, completion: nil)

        }
    }

    
    func showAddShareAlert(){
        self.alertWithTextField(title: "Ajout d’un invité\n"
                                    .localized, message: nil, placeholder: "email".localized) { email in
            if email == "cancel"
            {
                
            }else{
                if email.isValidEmail {
                    var placeId:String = ""
                    if let pId = self.placeDetails?.placeId{
                        placeId = "\(pId)"
                        FliprShare().poolId = placeId
                    }
                    self.callShareApi(email: email, poolId: placeId)
                  /*
                    FliprShare().addShare(poolId: placeId, email:email, role: .guest) { error in
                        if error != nil {
                            let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                            alertVC.addAction(alertAction)
                            self.present(alertVC, animated: true)
                            return
                        }
    //                    DispatchQueue.main.async {
                            self.getCurrentShares()
    //                    }
                    }
                    */
                }
                else {
                    self.showAlert(title: "Email incorrect".localized, message: "Invalid email address format".localized)
                }
            }
            
        }
    }
    
    
    
    func callShareApi(email:String,poolId:String){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        FliprShare().addShare(poolId: poolId, email:email, role: .guest) { error in
            hud?.dismiss()
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
//                    DispatchQueue.main.async {
                self.getCurrentShares()
            self.getContactList()
                
//                    }
        }
    }
    
    
    func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Annuler".localized, style: .cancel) { _ in completion("cancel") })
        alert.addAction(UIAlertAction(title: "Inviter".localized, style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        navigationController?.present(alert, animated: true)
    }
    
    
    @IBAction func segmentClicked(_ sender: UIButton) {
        parametersButton.isSelected = !parametersButton.isSelected
        partagesButton.isSelected = !partagesButton.isSelected
        adjustColorForSegmentButtons()
        toggleSubmitButtonStyleAndText()
        tableView.reloadData()
        if partagesButton.isSelected && !hasLoadedShares {
            getCurrentShares()
            getContactList()
        }
    }
    
    func toggleSubmitButtonStyleAndText() {
        if parametersButton.isSelected {
            submitButton.setTitle("Supprimer".localized, for: .normal)
            submitButton.setTitleColor(UIColor.init(hexString: "#FE0101"), for: .normal)
            submitButton.backgroundColor = .clear
        } else {
            submitButton.setTitle("Ajouter un invité".localized, for: .normal)
            submitButton.setTitleColor(.black, for: .normal)
            submitButton.backgroundColor = .white
        }
    }
    
    func adjustColorForSegmentButtons() {
        let color = UIColor(hexString: "#98A3B3")
        parametersButton.backgroundColor = parametersButton.isSelected ? UIColor.black : color
        partagesButton.backgroundColor = partagesButton.isSelected ? UIColor.black : color
    }
    
    func getPoolSettings() {
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        var placeId:String = ""
        if let pId = self.placeDetails?.placeId{
            placeId = "\(pId)"
            FliprShare().poolId = placeId

        }
        PoolSettingsRouter().getPoolSettings(poolId: placeId) { settings, error in
            hud?.dismiss()
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.placeDetailsRespose = settings
            self.poolSettings = settings?.poolSettingsModel
            var titleStr = self.poolSettings?.privateName ?? ""
            titleStr.append(" - ")
            titleStr.append(self.poolSettings?.owner?.firstName ?? "")
            titleStr.append(" ")
            titleStr.append(self.poolSettings?.owner?.lastName ?? "")

            titleStr.append(" - ")
            titleStr.append(self.poolSettings?.city?.name ?? "")
            self.title = titleStr
            self.tableView.reloadData()
        }
    }
    
    func getCurrentShares() {
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        var placeId:String = ""
        if let pId = self.placeDetails?.placeId{
            placeId = "\(pId)"
            FliprShare().poolId = placeId
        }
        FliprShare().viewShares(poolId: placeId) { shares, error in
            hud?.dismiss()
            if error != nil {
                self.hasLoadedShares = false
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            
            if shares != nil{
                if shares!.count > 0 {
                    
                    self.loadedShares =  shares!.filter { $0.isInvited == true }
                    self.contacts =  shares!.filter { $0.isInvited == false }

                    self.hasLoadedShares = true
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func getContactList() {
        return
//        let hud = JGProgressHUD(style:.dark)#imageLiteral(resourceName: "simulator_screenshot_30A5A067-CC76-4FBF-80B8-1231C3934D90.png")
//        hud?.show(in: self.navigationController!.view)
        let email:String = self.poolSettings?.owner?.email ?? ""
//        if let pId = self.placeDetails?.placeId{
//            placeId = "\(pId)"
//            FliprShare().poolId = placeId
//        }
        FliprShare().getContacts(email: email) { contacts, error in
//            hud?.dismiss()
            if error != nil {
                return
            }
//            self.contactList = contacts ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func closeButtonAction(sender:UIButton){
        let shareInfo  = self.loadedShares[sender.tag]
        var placeId:String = ""
        if let pId = self.placeDetails?.placeId{
            placeId = "\(pId)"
            FliprShare().poolId = placeId
        }
        FliprShare().deleteShareWithPoolId(email: shareInfo.guestUser, poolID: placeId) { error in
            if error != nil {
//                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
//                alertVC.addAction(alertAction)
//                self.present(alertVC, animated: true)
//                return

            }else{
            }
            
        }
    }
    
    
    func createPlace(){
        hud?.show(in: self.view)
        User.currentUser?.createPlace( completion: { (settings,error) in
            if (error != nil) {
                self.hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud?.textLabel.text = error?.localizedDescription
                self.hud?.dismiss(afterDelay: 3)
            } else {
                self.hud?.dismiss(afterDelay: 0)
                self.poolSettings = settings
                self.tableView.reloadData()
            }
            
        })
    }
    
    
    func getPlaceSettings() {
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        var placeId:String = ""
        if let pId = self.placeDetails?.placeId{
            placeId = "\(pId)"
            FliprShare().poolId = placeId

        }
        PoolSettingsRouter().getPoolSettings(poolId: placeId) { settings, error in
            hud?.dismiss()
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.placeDetailsRespose = settings
            self.poolSettings = settings?.poolSettingsModel
            self.tableView.reloadData()
        }
    }
    
    
    func updateSettings(){
        updatePlaceDetails()
    }

}



extension NewPoolViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if parametersButton.isSelected {
            return NewPoolTitles.PoolSectionTitles.allCases.count
        } else {
            return 2
            /*
            let shareCount = self.loadedShares.count
            let contactCount = self.contacts.count
            var numberOfsection = 0
            if shareCount > 0 {
                numberOfsection = numberOfsection + 1
            }
            if contactCount > 0{
                numberOfsection = numberOfsection + 1
            }
            return numberOfsection
            */
        }
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        55
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if parametersButton.isSelected {
            switch section {
            case 0: return NewPoolTitles.PoolGeneralTitles.allCases.count
            case 1: return NewPoolTitles.Characteristics.allCases.count
            case 2: return NewPoolTitles.Maintenance.allCases.count
            case 3: return NewPoolTitles.Usage.allCases.count
            default: return 0
            }
        } else {
//            let contactCount = self.contacts.count
//            if contactCount > 0{
                if section == 0{
                    return loadedShares.count
                }else{
                    return contacts.count
                }
//            }
//            return loadedShares.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewPoolSettingsTableViewCell", for: indexPath) as! NewPoolSettingsTableViewCell
        var primaryText: String?
        var secondaryText: String?
        var hasSwitch = false
        var isSwitchSelected = false
        if parametersButton.isSelected {
            switch indexPath.section {
            case 0:
                primaryText = NewPoolTitles.PoolGeneralTitles.allCases[indexPath.row].rawValue.localized
                switch indexPath.row {
                case 0:
                    secondaryText = poolSettings?.privateName

                case 1:
                    var name:String = ""
                    name = poolSettings?.owner?.firstName ?? ""
                    name.append(" ")
                    name.append(poolSettings?.owner?.lastName ?? "")
                    secondaryText = name
                case 2:
                    secondaryText = poolSettings?.type?.name
                case 3:
                    secondaryText = poolSettings?.city?.name
                default:
                    secondaryText = "Définir"
                }
            case 1:
                primaryText = NewPoolTitles.Characteristics.allCases[indexPath.row].rawValue.localized
                switch indexPath.row {
                case 0:
                    let vol = String(format: "%.2f", poolSettings?.volume ?? 0.00)
//                    secondaryText = poolSettings?.volume?.toString
                    secondaryText = vol
                    var volUnitStr = ""
                    volUnitStr = secondaryText ?? ""
                    
                    self.volume = Int(poolSettings?.volume ?? 0)
                    let voltitle = NewPoolTitles.Characteristics.allCases[indexPath.row].rawValue
                    if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                        if currentUnit == 2{
                            let val: Double =  Double(poolSettings?.volume ?? 0)
                            let funit = Int(val * 264.172052)
                            self.volume = funit
                            secondaryText = funit.toString
                            volUnitStr = secondaryText ?? ""
                            volUnitStr.append(" gal")
                        }else{
                            volUnitStr.append(" m³")
                        }
                    }else{
                        volUnitStr.append(" m³")
                    }
                    if secondaryText != nil{
                        secondaryText = volUnitStr
                    }
                    primaryText = voltitle
                    
                    
                case 1:
                    secondaryText = poolSettings?.shape?.name
                case 2:
                    secondaryText = poolSettings?.coating?.name
                case 3:
                    secondaryText = poolSettings?.integration?.name
                case 4:
                    secondaryText = poolSettings?.builtYear?.toString
                default:
                    secondaryText = "Définir"
                }
            case 2:
                primaryText = NewPoolTitles.Maintenance.allCases[indexPath.row].rawValue.localized
                switch indexPath.row {
                case 0:
                    secondaryText = poolSettings?.treatment?.name
                case 1:
                    secondaryText = poolSettings?.filtration?.name
                default:
                    secondaryText = poolSettings?.mode?.name
                }
                
            case 3:
                primaryText = NewPoolTitles.Usage.allCases[indexPath.row].rawValue.localized
                hasSwitch = indexPath.row == 0 || indexPath.row == 3
                if indexPath.row != 0 && indexPath.row != 3 {
                    if indexPath.row == 1 {
                        secondaryText = poolSettings?.numberOfUsers?.toString ?? "0"
                    } else if indexPath.row == 2 {
                        secondaryText = poolSettings?.mode?.name
                    }
                } else {
                    if indexPath.row == 0 {
                        isSwitchSelected = poolSettings?.isPublic ?? false
                    } else if indexPath.row == 3 {
                        let loc = poolSettings?.location?.id ?? 0
                        isSwitchSelected = (loc == 1) ? true : false
                    }
                }
                default: break;
            }
        }
        /*
        if #available(iOS 14.0, *) {
            var content = tableViewCell.defaultContentConfiguration()
            if parametersButton.isSelected {
                content.text = primaryText
                content.secondaryText = hasSwitch ? "" : (secondaryText ?? "Définir")
                content.prefersSideBySideTextAndSecondaryText = true
                content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16)
                if content.secondaryText?.isEmpty ?? true || content.secondaryText == "Définir" {
                    content.secondaryTextProperties.color = .red
                } else {
                    content.secondaryTextProperties.color = .darkText
                }
                tableViewCell.contentConfiguration = content
                let indicator = UISwitch()
                indicator.isOn = isSwitchSelected
                tableViewCell.accessoryView = hasSwitch ? indicator : nil
                if !isSwitchSelected {
                    tableViewCell.accessoryType = .disclosureIndicator
                    if indexPath.section == 0{
                        if indexPath.row == 0 || indexPath.row == 01{
                            tableViewCell.accessoryType = .none
                        }
                    }
                }
                tableViewCell.selectionStyle = .none
            } else {
                
                if indexPath.section == 0 {
                    var content = tableViewCell.defaultContentConfiguration()
                    let user = loadedShares[indexPath.row]
                    var name:String = ""
                    
                    if user.isKnow {
                        name = loadedShares[indexPath.row].guestUser
                        if let fname = loadedShares[indexPath.row].guestFirstName as? String{
                            name = fname
                            if let lname = loadedShares[indexPath.row].guestLastName as? String{
                                name.append(" ")
                                name.append(lname)
                            }
                        }else{
                            
                        }
                    }else{
                        name = loadedShares[indexPath.row].email
                    }
                    
                    if user.isPending {
                        
                    }else{
                        
                    }
//                    tableViewCell.infoLbl.isHidden = !user.isPending
//
//                    tableViewCell.titleName = name
    //                name.append(" ")
    //                name.append(loadedShares[indexPath.row].placeOwnerLastName)
                    content.text = name
    //                content.text = loadedShares[indexPath.row].guestUser
//                    let role = loadedShares[indexPath.row].permissionLevel
//                    switch role {
//                    case "View":
//                        content.image = UIImage(named: "guest_role")
//                    case "Admin":
//                        content.image = UIImage(named: "man_role")
//                    case "Manage":
//                        content.image = UIImage(named: "boy_role")
//                    default:
//                        content.image = UIImage(named: "guest_role")
//                    }
                   // tableViewCell.closeButton.tag = indexPath.row
                    tableViewCell.contentConfiguration = content
                    tableViewCell.accessoryType = .none
                    tableViewCell.selectionStyle = .none
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                    imgView.image = UIImage(named: "ButtonClose")!
                    tableViewCell.accessoryView = imgView
                }

                else{
                    var content = tableViewCell.defaultContentConfiguration()
                    var name:String = contacts[indexPath.row].guestFirstName ?? ""
                    name.append(" ")
                    name.append(contacts[indexPath.row].guestLastName ?? "")
                    content.text = name
                    tableViewCell.contentConfiguration = content
                    tableViewCell.accessoryType = .none
                    tableViewCell.selectionStyle = .none
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
                    imgView.image = UIImage(named: "contacts")!
                    tableViewCell.accessoryView = imgView
                }
                

            }
            return tableViewCell
        }
        else {
            */
            if parametersButton.isSelected {
                tableViewCell.titleName?.text = primaryText
                tableViewCell.valueText?.text = hasSwitch ? "" : (secondaryText ?? "Définir")
                if tableViewCell.detailTextLabel?.text?.isEmpty ?? true || tableViewCell.detailTextLabel?.text == "Définir" {
                    tableViewCell.detailTextLabel?.textColor = .red
                } else {
                    tableViewCell.detailTextLabel?.textColor = .darkText
                }
                tableViewCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
                let indicator = UISwitch()
                indicator.isOn = isSwitchSelected
                tableViewCell.accessoryView = hasSwitch ? indicator : nil
                if !isSwitchSelected {
                    tableViewCell.accessoryType = .disclosureIndicator
                }
                if indexPath.section == 0{
                    if indexPath.row == 1 || indexPath.row == 2{
                        tableViewCell.accessoryType = .none
                    }
                }
                tableViewCell.selectionStyle = .none
                return tableViewCell
            } else {
                
                if indexPath.section == 0{
                    
                    /*
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SystemCellForEmails")
                    let role = loadedShares[indexPath.row].permissionLevel
                    switch role {
                    case "View":
                        cell?.imageView?.image = UIImage(named: "guest_role")
                    case "Admin":
                        cell?.imageView?.image = UIImage(named: "man_role")
                    case "Manage":
                        cell?.imageView?.image = UIImage(named: "boy_role")
                    default:
                        cell?.imageView?.image = UIImage(named: "guest_role")
                    }
    //                cell?.textLabel?.text = loadedShares[indexPath.row].guestUser
                    
                    var name:String = loadedShares[indexPath.row].placeOwnerFirstName
                    name.append(" ")
                    name.append(loadedShares[indexPath.row].placeOwnerLastName)
                    cell?.textLabel?.text = name

                    cell?.accessoryType = .none
                    cell?.selectionStyle = .none
                    
                    */
                    let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewPlaceShareTableViewCell", for: indexPath) as! NewPoolSettingsTableViewCell
                    let user = loadedShares[indexPath.row]
                    var name:String = ""
                    
                    if user.isKnow {
                        name = loadedShares[indexPath.row].guestUser
                        if let fname = loadedShares[indexPath.row].guestFirstName{
                            name = fname
                            if let lname = loadedShares[indexPath.row].guestLastName{
                                name.append(" ")
                                name.append(lname)
                            }
                        }else{
                            
                        }
                    }else{
                        name = loadedShares[indexPath.row].email
                    }
                    
                    if user.isPending {
                        tableViewCell.titleConstraint.constant = 10.5
                    }else{
                        tableViewCell.titleConstraint.constant = 17.5
                    }
                    tableViewCell.titleName.text = name
                    tableViewCell.infoLbl.text = "Invitation en attente"
                    
                    tableViewCell.infoLbl.isHidden = !user.isPending
                    
                    return tableViewCell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SystemCellForEmails")
                  
                    var name:String = contacts[indexPath.row].guestFirstName ?? ""
                    name.append(" ")
                    name.append(contacts[indexPath.row].guestLastName ?? "")
                    cell?.textLabel?.text = name
                    cell?.accessoryType = .none
                    cell?.selectionStyle = .none
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
                    imgView.image = UIImage(named: "contacts")!
                    cell?.accessoryView = imgView
                    

                    return cell!
                }
                
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (parametersButton.isSelected) {
            if #available(iOS 14.0, *) {
                var config = UIListContentConfiguration.plainHeader()
                config.text = NewPoolTitles.PoolSectionTitles.allCases[section].rawValue.localized.uppercased()
                let view = UIListContentView(configuration: config)
                return view
            } else {
                let label = UILabel()
                label.text = NewPoolTitles.PoolSectionTitles.allCases[section].rawValue.localized.uppercased()
                return label
            }
        } else {
            if section == 0{
                return nil
            }else{
                if #available(iOS 14.0, *) {
                    var config = UIListContentConfiguration.plainHeader()
                    config.text = "Contacts".localized.uppercased()
                    let view = UIListContentView(configuration: config)
                    return view
                } else {
                    let label = UILabel()
                    label.text = "Contacts".localized.uppercased()
                    return label
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let shareCount = self.loadedShares.count
        let contactCount = self.contacts.count
        if section == 0 {
            return shareCount > 0 ? 0 :0
        }else{
            return contactCount > 0 ? 0 :0
        }
//        return 40
    }
}

extension NewPoolViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if parametersButton.isSelected {
            if indexPath.section == 0 {
                let listVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPoolSimpleListViewController") as! NewPoolSimpleListViewController
                switch indexPath.row {
                case 0:
                    let sb = UIStoryboard(name: "NewPool", bundle: nil)
                    let listVC = sb.instantiateViewController(withIdentifier: "WatrInputViewController") as! WatrInputViewController
                    listVC.order = 0
                    listVC.isNonType = true
                    listVC.defaultValue = poolSettings?.privateName
                    listVC.titleStr = "Libellé ".localized //+ " - m³"
                    listVC.completion(block: { (inputValue) in
                            self.poolSettings?.privateName = inputValue
                            self.tableView.reloadData()
                            self.updateSettings()
                        })
                    navigationController?.pushViewController(listVC, animated: true)
                    break
                    
                case 1:
//                    listVC.listItems = []
//                    listVC.isTextField = true
//                    listVC.inputType = UIKeyboardType.default
//                    listVC.title = NewPoolTitles.PoolGeneralTitles.poolType.rawValue
//                    navigationController?.pushViewController(listVC, animated: true)
                    break; //Type
                case 2:
                   
                    break
                case 3:
                    let locationVC = storyboard?.instantiateViewController(withIdentifier: "NewPoolLocationViewController") as! NewPoolLocationViewController
                    locationVC.title = "Localisation"
                    locationVC.completion { value, latitude, longitude in
                        self.poolSettings?.longitude = longitude
                        self.poolSettings?.latitude = latitude
                        self.poolSettings?.city?.name = value.name
                        self.poolSettings?.city?.zipCode = value.zipCode
                        self.poolSettings?.city?.longitude = value.longitude
                        self.poolSettings?.city?.latitude = value.latitude

                        self.tableView.reloadData()
                        self.updateSettings()
                    }
                    navigationController?.pushViewController(locationVC)
                    break;
                default: break;
                }
            }
            else if indexPath.section == 1 {
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as! ValuePickerController
                let listVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPoolSimpleListViewController") as! NewPoolSimpleListViewController
                switch indexPath.row {
                case 0:
                    
                    let sb = UIStoryboard(name: "NewPool", bundle: nil)
                    let listVC = sb.instantiateViewController(withIdentifier: "WatrInputViewController") as! WatrInputViewController
                    listVC.order = 0
                    listVC.defaultValue = self.volume.toString
                    listVC.title = "Volume".localized //+ " - m³"
                    listVC.completion(block: { (inputValue) in
                        if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                            if currentUnit == 2{
                                let inputVal = Double(inputValue) ?? 1
                                let m3Val = Double(inputVal / 264.172052 )
                                self.poolSettings?.volume = m3Val
                            }else{
//                                let m3Val = 264.172052 * (Double(input) ?? 1)
                                self.poolSettings?.volume = Double(inputValue)
                            }
                        }else{
                            self.poolSettings?.volume = Double(inputValue)
                        }
//                            self.poolSettings?.volume = Double(inputValue) ?? 0
                            self.tableView.reloadData()
                            self.updateSettings()
                        })
                    navigationController?.pushViewController(listVC, animated: true)

                    
//                    listVC.isTextField = true
//                    listVC.title = NewPoolTitles.Characteristics.Volume.rawValue + " - m³"
//                    navigationController?.pushViewController(listVC, animated: true)
                    break;  //Volume
                case 1:
                    viewController.apiPath = "shapes"
                    viewController.title = "Shape".localized
                    viewController.completion(block: { (formValue) in
                        self.poolSettings?.shape = TypeInfo.init(id: formValue.id, name: formValue.label)
                        self.tableView.reloadData()
                        self.updateSettings()
                    })

//                    listVC.isTextField = false
//                    listVC.listItems = ["Rectagle", "Oval", "Circle", "Sqauere"]
//                    listVC.title = NewPoolTitles.Characteristics.Shape.rawValue
                    navigationController?.pushViewController(viewController, animated: true)
                    break; //Forme
                case 2:
                    viewController.apiPath = "coatings"
                    viewController.title = "Coatingsg".localized
                    viewController.completion(block: { (formValue) in
                        self.poolSettings?.coating = TypeInfo.init(id: formValue.id, name: formValue.label)
                        self.tableView.reloadData()
                        self.updateSettings()
                    })
                    navigationController?.pushViewController(viewController, animated: true)

//                    listVC.isTextField = false
//                    listVC.listItems = ["Rectagle", "Oval", "Circle"]
//                    listVC.title = NewPoolTitles.Characteristics.CoatingType.rawValue
//                    navigationController?.pushViewController(listVC, animated: true)
                    break; //revetement
                case 3:
                    viewController.apiPath = "integration"
                    viewController.title = "Integration".localized
                    viewController.completion(block: { (formValue) in
                        self.poolSettings?.integration = TypeInfo.init(id: formValue.id, name: formValue.label)
                        self.tableView.reloadData()
                        self.updateSettings()
                    })
                    navigationController?.pushViewController(viewController, animated: true)

                    //integration
                case 4:
//                    viewController.apiPath = "integration"
                    let sb = UIStoryboard(name: "NewPool", bundle: nil)
                    let listVC = sb.instantiateViewController(withIdentifier: "WatrInputViewController") as! WatrInputViewController
                    listVC.order = 0
                    listVC.isNonType = true
                    listVC.isNumberKey = true
                    listVC.defaultValue = poolSettings?.builtYear?.toString
                    listVC.titleStr = NewPoolTitles.Characteristics.allCases[indexPath.row].rawValue.localized
                    listVC.completion(block: { (inputValue) in
                            self.poolSettings?.builtYear = Int(inputValue) ?? 0
                            self.tableView.reloadData()
                            self.updateSettings()
                        })
                    navigationController?.pushViewController(listVC, animated: true)


                    
                    break; //anne de construction
                default : break;
                }
            }
            
            
            else if indexPath.section == 2{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as! ValuePickerController

                switch indexPath.row {
                
                case 0:
                    viewController.apiPath = "treatment"
                    viewController.title = "Treatement".localized
                    viewController.completion(block: { (formValue) in
                        self.poolSettings?.treatment = TypeInfo.init(id: formValue.id, name: formValue.label)
                        self.tableView.reloadData()
                        self.updateSettings()
                    })
                    navigationController?.pushViewController(viewController, animated: true)


                    break; //Forme
                case 1:
                    viewController.apiPath = "filtrations"
                    viewController.title = "Filtration".localized
                    viewController.completion(block: { (formValue) in
                        self.poolSettings?.filtration = TypeInfo.init(id: formValue.id, name: formValue.label)
                        self.tableView.reloadData()
                        self.updateSettings()
                    })
                    navigationController?.pushViewController(viewController, animated: true)

                    break;
                
                default : break;
                }
                
            }

            
            
            else if indexPath.section == 3{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as! ValuePickerController

                switch indexPath.row {
                case 0:
                    
                    break;
                case 1:
                    let sb = UIStoryboard(name: "NewPool", bundle: nil)
                    let listVC = sb.instantiateViewController(withIdentifier: "WatrInputViewController") as! WatrInputViewController
                    listVC.order = 1
                    listVC.defaultValue = poolSettings?.numberOfUsers?.toString
                    listVC.title = "Utilisateurs".localized
                    listVC.completion(block: { (inputValue) in
                            self.poolSettings?.numberOfUsers = Int(inputValue) ?? 0
                            self.tableView.reloadData()
                            self.updateSettings()
                        })
                    navigationController?.pushViewController(listVC, animated: true)
                    break; //Forme
                case 2:
                    
                    if self.placeDetailsRespose?.analysRAssociated == false{
                        return
                    }
                    
                    viewController.title = "Statut".localized
                    viewController.apiPath = "modes"
                    viewController.completion(block: { (formValue) in
                        self.poolSettings?.mode = TypeInfo.init(id: formValue.id, name: formValue.label)
                        self.tableView.reloadData()
                        self.updateSettings()
                    })
                    navigationController?.pushViewController(viewController, animated: true)

//                    listVC.isTextField = false
//                    listVC.listItems = ["Rectagle", "Oval", "Circle"]
//                    listVC.title = NewPoolTitles.Characteristics.CoatingType.rawValue
//                    navigationController?.pushViewController(listVC, animated: true)
                    break; //revetement
                
                    //integration
                case 4: break; //anne de construction
                default : break;
                }
                
            }
        } else {
           
            if indexPath.section == 0 {
                var placeId:String = ""
                if let pId = self.placeDetails?.placeId{
                    placeId = "\(pId)"
                    FliprShare().poolId = placeId
                }
                let shareInfo = loadedShares[indexPath.row]
                
                self.deleteSharePrompt(email: shareInfo.email, placeId: placeId)

            }else{
                
                var placeId:String = ""
                if let pId = self.placeDetails?.placeId{
                    placeId = "\(pId)"
                    FliprShare().poolId = placeId
                }
                let contactInfoInfo = contacts[indexPath.row]
                self.addContact(placeId: placeId, email: contactInfoInfo.email )

            }
//            let sb = UIStoryboard(name: "NewPool", bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: "PoolShareViewControllerID") as! PoolShareViewController
//            vc.selectedShare = loadedShares[indexPath.row]
//            vc.selectedIndex = indexPath.row
//            vc.changeDelegate = self
//            vc.isAddingNew = false
//            vc.shareModel = loadedShares[indexPath.row]
//            self.present(vc, animated: true)
        }
    }
    
    func addContact(placeId:String, email:String){
        self.callShareApi(email: email, poolId: placeId)
    }
    
    
    func deleteSharePrompt(email: String,placeId:String){
        
        let msg = "Supprimer le partage de \nEMAIL@gmail.com\nCet utilisateur ne pourra plus consulter cet emplacement".localized
        let replaced = msg.replacingOccurrences(of: "EMAIL@gmail.com", with: email)

        
        let alertVC = UIAlertController(title: "", message:replaced , preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Annuler".localized, style: .cancel)
        let confirmAction = UIAlertAction(title: "Supprimer le partage".localized, style: .destructive) { action in
            self.deleteShare(email: email, placeId: placeId)
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

            }else{
            }
            self.getCurrentShares()
        }
    }
    
    
    func deletePlacePrompt(){
        let alertVC = UIAlertController(title: "Supprimer l’emplacement".localized, message: "Elle entrainera la supression et l’arret des équipements et des partages.La suppression est définitive.".localized, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Annuler".localized, style: .cancel)
        let confirmAction = UIAlertAction(title: "Supprimer l’emplacement".localized, style: .destructive) { action in
//            self.deleteShare(email: email, placeId: placeId)
            self.callDeletePlaceApi()
        }
        alertVC.addAction(confirmAction)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
    func callDeletePlaceApi(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)

            var placeId:String = ""
            if let pId = self.placeDetails?.placeId{
                placeId = "\(pId)"
                FliprShare().poolId = placeId
            }
            FliprShare().deletePlace(placeId: placeId) { error in
                hud?.dismiss()
                if error != nil {
                }
                else{
                }
                NotificationCenter.default.post(name: K.Notifications.PlaceDeleted, object: nil)
                self.dismiss(animated: true, completion: nil)

            }
    }
    
}

extension NewPoolViewController: ChangeShareEmailDelegate {
    func deleteEmail(_ email: ShareModel?, index: Int) {
        getCurrentShares()
    }
    
    func changedEmail(_ email: ShareModel?, index: Int) {
        getCurrentShares()
    }
    
    func addedEmail() {
        getCurrentShares()
    }
}
