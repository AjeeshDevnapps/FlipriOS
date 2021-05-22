//
//  PoolCharacteristicsViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

enum Characteristics: String, CaseIterable {
    case shape = "Shape"
    case coating = "Type of coating"
    case integration = "Integration"
    case treatment = "Treatment"
    case filtration = "Filtration"
}

class PoolCharacteristicsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constructionYearTitleLbl: UILabel!
    @IBOutlet weak var constructYearTF: UITextField!
    @IBOutlet weak var volumeTitleLbl: UILabel!
    @IBOutlet weak var volumeTF: UITextField!
    var characteristics = [""]
    var pool = Pool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        setCustomBackbtn()
        submitBtn.roundCorner(corner: 12)
        constructYearTF.text = "\(PoolSettings.shared.builtYear ?? Calendar.current.component(.year, from: Date()))"
        volumeTF.text = "\(PoolSettings.shared.volume ?? 0)"
    }
    
    @IBAction func submit(_ sender: UIButton) {
        PoolSettings.shared.builtYear = Int(constructYearTF.text ?? "0")
        PoolSettings.shared.volume = Double(volumeTF.text ?? "0")
        PoolSettings.shared.shape = self.pool.shape
        PoolSettings.shared.coating = self.pool.coating
        PoolSettings.shared.integration = self.pool.integration
        PoolSettings.shared.treatment = self.pool.treatment
        PoolSettings.shared.filtration = self.pool.filtration
        
        
        if PoolSettings.shared.city == nil {
            showError(title: "Error".localized, message: "The field 'City' is mandatory".localized)
            return
        }
        if PoolSettings.shared.treatment == nil {
            showError(title: "Error".localized, message: "The field 'Treatment' is mandatory".localized)
            return
        }

        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        PoolSettings.shared.create(completion: { (error) in
            
            if (error != nil) {
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 3)
            } else {
                NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
            }
        })
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Characteristics.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as! CharacterCell
        let type = Characteristics.allCases[indexPath.row]
        cell.textLabel?.text = type.rawValue
        switch type {
        case .shape:
            cell.detailLabel.text = self.pool.shape?.label
        case .coating:
            cell.detailLabel.text = self.pool.coating?.label
        case .integration:
            cell.detailLabel.text = self.pool.integration?.label
        case .treatment:
            cell.detailLabel.text = self.pool.treatment?.label
        case .filtration:
            cell.detailLabel.text = self.pool.filtration?.label
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as! ValuePickerController
        let selectedChar = Characteristics.allCases[indexPath.row]
        switch selectedChar {
        case .shape:
            viewController.apiPath = "shapes"
            viewController.title = "Shape".localized
            viewController.completion(block: { (formValue) in
                self.pool.shape = formValue
                self.tableView.reloadData()
            })
        case .coating:
            viewController.apiPath = "coatings"
            viewController.title = "Type of coating".localized
            viewController.completion(block: { (formValue) in
                self.pool.coating = formValue
                self.tableView.reloadData()
            })
        case .integration:
            viewController.apiPath = "integration"
            viewController.title = "Integration".localized
            viewController.completion(block: { (formValue) in
                self.pool.integration = formValue
                self.tableView.reloadData()
           })
        case .treatment:
            viewController.apiPath = "treatment"
            viewController.title = "Treatement".localized
            viewController.completion(block: { (formValue) in
                self.pool.treatment = formValue
                self.tableView.reloadData()
            })
        case .filtration:
            viewController.apiPath = "filtrations"
            viewController.title = "Filtration".localized
            viewController.completion(block: { (formValue) in
                self.pool.filtration = formValue
                self.tableView.reloadData()
             })
        }
        self.navigationController?.pushViewController(viewController)
    }

}

class CharacterCell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
}
