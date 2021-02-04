//
//  PoolLogEditViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 29/07/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class PoolLogEditViewController: UITableViewController, ProductTableViewControllerDelegate {
    
    var logType:LogType!
    var log:Log?
    var date = Date()
    var product:Product?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var quantityTitleLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var productFieldVisible = false
    var productQuantityVisible = false
    var detePickerExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTitleLabel.text = "Product".localized
        dateTitleLabel.text = "Date".localized
        quantityTitleLabel.text = "Quantity".localized
        
        if logType.id == 5 {
            productFieldVisible = true
        }
        
        if let log = log {
            self.title = logType.value
            if let qty = log.quantity {
                quantityTextField.text = String(qty)
            }
            if let prd = log.product {
                product = prd
                productLabel.text = product?.name
                productQuantityVisible = true
            }
            titleTextField.text = log.title
            date = log.date
            commentTextView.text = log.userComment
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        } else {
            self.titleTextField.text = logType.value
            self.title = "New item".localized()
        }
        
        self.datePicker.date = date
        self.datePicker.maximumDate = Date()
        formatDateLabel()
        
    }
    
    @objc func cancelTapped() {
        titleTextField.resignFirstResponder()
        commentTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func formatDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM HH:mm"
        dateLabel.text = formatter.string(from: date)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.commentTextView.becomeFirstResponder()
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        if let poolId = Pool.currentPool?.id {
            
            if self.quantityTextField.text!.count == 0 && logType.id == 5 {
                showError(title: "Error".localized, message: "Quantity".localized + " is mandatory".localized)
                return
            }
            
            if let title = titleTextField.text {
                titleTextField.resignFirstResponder()
                commentTextView.resignFirstResponder()
                
                let hud = JGProgressHUD(style:.dark)
                hud?.show(in: self.navigationController!.view)
                
                var attributes = [String:Any]()
                if let log = log {
                    if let product = product, let doseUnitId = product.doseUnitId  {
                        attributes = ["TypeId":logType.id,"Title":title,"ItemId":product.id,"DoseUnitId":doseUnitId,"Quantity":self.quantityTextField.text!.doubleValue,"UserComment":commentTextView.text!,"Date":date.timeIntervalSince1970*1000]
                    } else {
                        attributes = ["TypeId":logType.id,"Title":title, "UserComment":commentTextView.text!,"Date":date.timeIntervalSince1970*1000]
                    }
                    Pool.currentPool!.updateLog(id: log.id, attributes: attributes) { (error) in
                        if (error != nil) {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = error?.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        } else {
                            hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud?.dismiss(afterDelay: 1)
                            self.dismiss(animated: true, completion: {
                                NotificationCenter.default.post(name: FliprLogDidChanged, object: nil)
                            })
                        }
                    }
                } else {
                    if let product = product, let doseUnitId = product.doseUnitId {
                        attributes = ["TypeId":logType.id,"Title":title,"ItemId":product.id,"DoseUnitId":doseUnitId,"Quantity":self.quantityTextField.text!.doubleValue,"UserComment":commentTextView.text!,"Date":date.timeIntervalSince1970*1000]
                    } else {
                        attributes = ["TypeId":logType.id,"Title":title, "UserComment":commentTextView.text!,"Date":date.timeIntervalSince1970*1000]
                    }
                    Pool.currentPool!.addLog(attributes: attributes) { (error) in
                        if (error != nil) {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = error?.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        } else {
                            NotificationCenter.default.post(name: FliprLogDidChanged, object: nil)
                            hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud?.dismiss(afterDelay: 1)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
            } else {
                self.showError(title: "Error".localized, message: "The field \"title\" is mandotary")
            }
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comment".localized
        }
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 1 && !productFieldVisible {
            return 0
        }
        if indexPath.section == 0 && indexPath.row == 2 && !productQuantityVisible {
            return 0
        }
        if indexPath.section == 2 && indexPath.row == 1 && !detePickerExpanded {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            if let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ProductTableViewControllerID") as? ProductTableViewController {
                vc.selection = true
                vc.delegate = self
                navigationController?.show(vc, sender: self)
            }
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            detePickerExpanded = !detePickerExpanded
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        date = datePicker.date
        formatDateLabel()
    }
    
    func productTableViewControllerDidSelect(product: Product) {
        self.product = product
        self.productLabel.text = product.name
        if let unit = product.conditioning?.name {
            self.quantityTitleLabel.text = "Quantity".localized + " (\(unit))"
        } else {
            self.quantityTitleLabel.text = "Quantity".localized
        }
        self.productQuantityVisible = true
        self.tableView.reloadData()
    }
    
    
}
