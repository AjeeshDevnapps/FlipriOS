
//
//  PoolShareViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

protocol ChangeShareEmailDelegate {
    func changedEmail(_ share: ShareModel?, index: Int)
    func deleteEmail(_ share: ShareModel?, index: Int)
    func addedEmail()
}

class PoolShareViewController: UIViewController {

    @IBOutlet weak var shareTitleLavel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteShareButton: UIButton!
    @IBOutlet weak var inviteShareButton: UIButton!
    @IBOutlet weak var changeShareButton: UIButton!
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    var selectedShare: ShareModel?
    var selectedIndex: Int = 0
    var isAddingNew = true
    var selectedRole = FliprRole.guest
    var changeDelegate: ChangeShareEmailDelegate?
    var shareModel: ShareModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePage()
        tableView.backgroundColor = UIColor(hexString: "#eeeee4")
        view.backgroundColor = UIColor(hexString: "#eeeee4")
        self.locationValueLabel.text =  (selectedShare?.name ?? "") + "-" +  (selectedShare?.placeCity ?? "")
        if selectedShare ==  nil{
            self.locationValueLabel.text = ""
            self.locationTitleLabel.text = ""
        }
        if !isAddingNew {
            switch selectedShare?.permissionLevel {
            case "View":
                selectedRole = .guest
            case "Manage":
                selectedRole = .boy
            case "Admin":
                selectedRole = .man
            default:
                selectedRole = .guest
            }
        }

    }
    
    func configurePage() {
        if isAddingNew {
            shareTitleLavel.text = "Ajout d'un partage"
            deleteShareButton.isHidden = true
            changeShareButton.isHidden = true
        } else {
            shareTitleLavel.text = "Modification du partage"
            inviteShareButton.isHidden = true
        }
        if let share = selectedShare  {
            emailTextField.text = share.guestUser
        }
        deleteShareButton.setTitle("Supprimer le partage", for: .normal)
        changeShareButton.setTitle("Modifier le partage", for: .normal)
        inviteShareButton.setTitle("Inviter au partager", for: .normal)
        locationTitleLabel.text = "Emplacement :"
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SystemCell")
    }

    @IBAction func deleteShareAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Supprimer le partage", message: "Cet utilisateur ne pourra plus consulter les données et agir sur vos équipements", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Annuler", style: .cancel)
        let confirmAction = UIAlertAction(title: "Supprimer le partage", style: .destructive) { action in
            self.deleteShare()
            self.dismiss(animated: true)
        }
        alertVC.addAction(confirmAction)
        alertVC.addAction(action)
        present(alertVC, animated: true)

    }
    
    @IBAction func inviteShareAction(_ sender: Any) {
        guard validateEmail() else { return }
        inviteNewShare()
    }
    
    @IBAction func changeShareAction(_ sender: Any) {
        guard validateEmail() else { return }
        self.selectedShare?.guestUser = emailTextField.text!
        changeShare()
    }
    
    
    func validateEmail() -> Bool {
        guard let email = emailTextField.text, email.isValidEmail else {
            let alertVC = UIAlertController(title: "Error".localized, message: "Invalid email address format".localized, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK".localized, style: .cancel)
            alertVC.addAction(action)
            present(alertVC, animated: true)
            return false
        }
        return true
    }
    
    func deleteShare() {
        FliprShare().deleteShare(email: emailTextField.text!, role: selectedRole) { error in
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.changeDelegate?.deleteEmail(self.selectedShare,
                                             index: self.selectedIndex)
            self.dismiss(animated: true)
        }
    }
    
    func inviteNewShare() {
        FliprShare().addShare(email: emailTextField.text!, role: selectedRole) { error in
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            DispatchQueue.main.async {
                self.changeDelegate?.addedEmail()
                self.dismiss(animated: true)
            }
        }
    }
    
    func changeShare() {
        FliprShare().updateShare(email: emailTextField.text!, role: selectedRole) { error in
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.changeDelegate?.changedEmail(self.selectedShare, index: self.selectedIndex)
            self.dismiss(animated: true)
        }
    }
}

extension PoolShareViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SystemCell")
        if (cell == nil)
        {
            cell = UITableViewCell(style: .subtitle,
                        reuseIdentifier: "SystemCell")
        }
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Flipr Guest"
            cell?.imageView?.image = UIImage(named: "guest_role")
        case 1:
            cell?.textLabel?.text = "Flipr Boy"
            cell?.imageView?.image = UIImage(named: "boy_role")
        case 2:
            cell?.textLabel?.text = "Flipr Man"
            cell?.imageView?.image = UIImage(named: "man_role")
        default:
            cell?.textLabel?.text = ""
        }
        let roleInCell = FliprRole.allCases[indexPath.row]
        cell?.detailTextLabel?.text = roleInCell.rawValue
        if isAddingNew {
            let role = selectedRole
            cell?.accessoryView = nil
            if role == .guest && indexPath.row == 0 {
                cell?.accessoryView = UIImageView(image: UIImage(named: "check_icon1"))
            } else if role == .boy && indexPath.row == 1 {
                cell?.accessoryView = UIImageView(image: UIImage(named: "check_icon1"))
            } else if role == .man && indexPath.row == 2 {
                cell?.accessoryView = UIImageView(image: UIImage(named: "check_icon1"))
            }

        } else {
            let role = selectedShare?.permissionLevel
            cell?.accessoryView = nil
            if role == "View" && indexPath.row == 0 {
                cell?.accessoryView = UIImageView(image: UIImage(named: "check_icon1"))
            } else if role == "Manage" && indexPath.row == 1 {
                cell?.accessoryView = UIImageView(image: UIImage(named: "check_icon1"))
            } else if role == "Admin" && indexPath.row == 2 {
                cell?.accessoryView = UIImageView(image: UIImage(named: "check_icon1"))
            }
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRole = FliprRole.allCases[indexPath.row]
        if indexPath.row == 0 {
            selectedRole = .guest
            selectedShare?.permissionLevel = "View"
        } else if indexPath.row == 1 {
            selectedRole = .boy
            selectedShare?.permissionLevel = "Manage"
        } else if indexPath.row == 2 {
            selectedRole = .man
            selectedShare?.permissionLevel = "Admin"
        }
        tableView.reloadData()
    }
}
