
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
    var poolSettings: PoolSettingsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(hexString: "#eeeee4")
        view.backgroundColor = UIColor(hexString: "#eeeee4")
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#eeeee4")
        title = "Piscine 123456 123345 - Melbourne"
        setCustomBackbtn()
        getPoolSettings()
        segmentStackView.cornerRadius = 10
        segmentStackView.clipsToBounds = true
        parametersButton.isSelected = true
        partagesButton.isSelected = false
        adjustColorForSegmentButtons()
        submitButton.cornerRadius = 10.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SystemCellForEmails")
        if isCreatingPlace{
            self.partagesButton.isUserInteractionEnabled = false
            self.partagesButton.isEnabled = false
            self.parametersButton.isUserInteractionEnabled = false
        }
    }
    
    override func goBack() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        if parametersButton.isSelected {
            
        } else {
            let sb = UIStoryboard(name: "NewPool", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PoolShareViewControllerID") as! PoolShareViewController
            vc.changeDelegate = self
            vc.isAddingNew = true
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func segmentClicked(_ sender: UIButton) {
        parametersButton.isSelected = !parametersButton.isSelected
        partagesButton.isSelected = !partagesButton.isSelected
        adjustColorForSegmentButtons()
        toggleSubmitButtonStyleAndText()
        tableView.reloadData()
        if partagesButton.isSelected && !hasLoadedShares {
            getCurrentShares()
        }
    }
    
    func toggleSubmitButtonStyleAndText() {
        if parametersButton.isSelected {
            submitButton.setTitle("Submit", for: .normal)
            submitButton.setTitleColor(.white, for: .normal)
            submitButton.backgroundColor = .black
        } else {
            submitButton.setTitle("Add share", for: .normal)
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
        PoolSettingsRouter().getPoolSettings(poolId: "") { settings, error in
            hud?.dismiss()
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.poolSettings = settings
            self.tableView.reloadData()
        }
    }
    
    func getCurrentShares() {
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        FliprShare().viewShares { shares, error in
            hud?.dismiss()
            if error != nil {
                self.hasLoadedShares = false
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.loadedShares = shares ?? []
            self.hasLoadedShares = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension NewPoolViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if parametersButton.isSelected {
            return NewPoolTitles.PoolSectionTitles.allCases.count
        } else {
            return 1
        }
    }

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
            return loadedShares.count
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
                primaryText = NewPoolTitles.PoolGeneralTitles.allCases[indexPath.row].rawValue
                switch indexPath.row {
                case 0:
                    secondaryText = poolSettings?.owner
                case 1:
                    secondaryText = poolSettings?.type?.name
                case 2:
                    secondaryText = poolSettings?.type?.name
                case 3:
                    secondaryText = poolSettings?.city?.name
                default:
                    secondaryText = "Définir"
                }
            case 1:
                primaryText = NewPoolTitles.Characteristics.allCases[indexPath.row].rawValue
                switch indexPath.row {
                case 0:
                    secondaryText = poolSettings?.volume?.toString
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
                primaryText = NewPoolTitles.Maintenance.allCases[indexPath.row].rawValue
                switch indexPath.row {
                case 0:
                    secondaryText = poolSettings?.volume?.toString
                case 1:
                    secondaryText = poolSettings?.shape?.name
                default:
                    secondaryText = "Définir"
                }
                
            case 3:
                primaryText = NewPoolTitles.Usage.allCases[indexPath.row].rawValue
                hasSwitch = indexPath.row == 0 || indexPath.row == 3
                if indexPath.row != 0 && indexPath.row != 3 {
                    if indexPath.row == 1 {
                        secondaryText = poolSettings?.numberOfUsers?.toString ?? "0"
                    } else if indexPath.row == 2 {
                        secondaryText = "Définir"//poolSettings?.status
                    }
                } else {
                    if indexPath.row == 0 {
                        isSwitchSelected = poolSettings?.isPublic ?? false
                    } else if indexPath.row == 1 {
                        isSwitchSelected = poolSettings?.isDefective ?? false
                    }
                }
            default: break;
            }
        }
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
                }
                tableViewCell.selectionStyle = .none
            } else {
                var content = tableViewCell.defaultContentConfiguration()
                content.text = loadedShares[indexPath.row].guestUser
                let role = loadedShares[indexPath.row].permissionLevel
                switch role {
                case "View":
                    content.image = UIImage(named: "guest_role")
                case "Admin":
                    content.image = UIImage(named: "man_role")
                case "Manage":
                    content.image = UIImage(named: "boy_role")
                default:
                    content.image = UIImage(named: "guest_role")
                }
                tableViewCell.contentConfiguration = content
                tableViewCell.accessoryType = .disclosureIndicator
                tableViewCell.selectionStyle = .none
            }
            return tableViewCell
        } else {
            if parametersButton.isSelected {
                tableViewCell.textLabel?.text = primaryText
                tableViewCell.detailTextLabel?.text = hasSwitch ? "" : (secondaryText ?? "Définir")
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
                tableViewCell.selectionStyle = .none
                return tableViewCell
            } else {
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
                cell?.textLabel?.text = loadedShares[indexPath.row].guestUser
                cell?.accessoryType = .disclosureIndicator
                cell?.selectionStyle = .none
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (parametersButton.isSelected) {
            if #available(iOS 14.0, *) {
                var config = UIListContentConfiguration.plainHeader()
                config.text = NewPoolTitles.PoolSectionTitles.allCases[section].rawValue
                let view = UIListContentView(configuration: config)
                return view
            } else {
                let label = UILabel()
                label.text = NewPoolTitles.PoolSectionTitles.allCases[section].rawValue
                return label
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension NewPoolViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if parametersButton.isSelected {
            if indexPath.section == 0 {
                let listVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPoolSimpleListViewController") as! NewPoolSimpleListViewController
                
                switch indexPath.row {
                case 1:
                    listVC.listItems = []
                    listVC.isTextField = true
                    listVC.inputType = UIKeyboardType.default
                    listVC.title = NewPoolTitles.PoolGeneralTitles.poolType.rawValue
                    navigationController?.pushViewController(listVC, animated: true)
                    break; //Type
                case 3:
                    let locationVC = storyboard?.instantiateViewController(withIdentifier: "NewPoolLocationViewController") as! NewPoolLocationViewController
                    locationVC.title = "Localisation"
                    navigationController?.pushViewController(locationVC)
                    break;
                default: break;
                }
            } else if indexPath.section == 1 {
                let listVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPoolSimpleListViewController") as! NewPoolSimpleListViewController
                switch indexPath.row {
                case 0:
                    listVC.isTextField = true
                    listVC.title = NewPoolTitles.Characteristics.Volume.rawValue + " - m³"
                    navigationController?.pushViewController(listVC, animated: true)
                    break;  //Volume
                case 1:
                    listVC.isTextField = false
                    listVC.listItems = ["Rectagle", "Oval", "Circle", "Sqauere"]
                    listVC.title = NewPoolTitles.Characteristics.Shape.rawValue
                    navigationController?.pushViewController(listVC, animated: true)
                    break; //Forme
                case 2:
                    listVC.isTextField = false
                    listVC.listItems = ["Rectagle", "Oval", "Circle"]
                    listVC.title = NewPoolTitles.Characteristics.CoatingType.rawValue
                    navigationController?.pushViewController(listVC, animated: true)
                    break; //revetement
                case 3: break; //integration
                case 4: break; //anne de construction
                default : break;
                }
            }
        } else {
            let sb = UIStoryboard(name: "NewPool", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PoolShareViewControllerID") as! PoolShareViewController
            vc.selectedShare = loadedShares[indexPath.row]
            vc.selectedIndex = indexPath.row
            vc.changeDelegate = self
            vc.isAddingNew = false
            vc.shareModel = loadedShares[indexPath.row]
            self.present(vc, animated: true)
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
