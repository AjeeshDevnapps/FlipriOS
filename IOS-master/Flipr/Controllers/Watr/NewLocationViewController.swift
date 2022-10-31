//
//  NewLocationViewController.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 30/10/22.
//  Copyright © 2022 I See U. All rights reserved.NewLocationTableViewCellID
//

import UIKit

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
    
    var selectedIndex: IndexPath!
    var placeTypes = PlaceTypes()
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
        getPlaceTypes()
    }
    
    func getPlaceTypes() {
        let router = PlaceRouter()
        router.getPlaceTypes { types, error in
            if error != nil {
                let alertVC = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true)
                return
            }
            self.placeTypes = types ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableHeightConstraint.constant = CGFloat(50 * self.placeTypes.count)
                self.view.layoutIfNeeded()
//                self.tableView.addShadow(offset: CGSize(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
            }
        }
    }
    
    func formatUI() {
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
        let sb = UIStoryboard(name: "NewPool", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NewPoolViewControllerID") as? UINavigationController {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewLocationTableViewCellID", for: indexPath)
        cell.textLabel?.text = placeTypes[indexPath.row].name
        cell.imageView?.image = UIImage(named: "menu_picto_pool")
        cell.imageView?.backgroundColor = .black
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex != nil {
            tableView.cellForRow(at: selectedIndex)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
