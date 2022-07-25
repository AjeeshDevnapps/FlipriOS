//
//  AlertTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 07/03/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import ActiveLabel
import SafariServices
import AlamofireImage

class AlertTableViewController: UITableViewController {
    
    var alert:Alert!
    var infoMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if infoMode {
            self.title = "INFORMATION".localized
        } else {
            self.title = "ALERT IN PROGRESS".localized
        }
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 3 {
            if alert?.shop != nil {
                return 1
            }
            return 0
        }
        if section == 1 { return alert.steps.count }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertShopCell", for: indexPath)
            if let button = cell.viewWithTag(1) as? UIButton {
                button.setTitle("Buy cleaning products".localized().uppercased(), for: .normal)
            }
            if let icon = cell.viewWithTag(6) as? UIImageView, let label = cell.viewWithTag(7) as? UILabel {
                if let urlString = alert?.shop?["LocomotionIcon"] as? String {
                    if let url = URL(string: urlString) {
                        icon.af_setImage(withURL: url)
                    }
                }
                label.text = alert!.shop!["Locomotion"] as? String
            }
            if let icon = cell.viewWithTag(8) as? UIImageView, let label = cell.viewWithTag(9) as? UILabel {
                if let urlString = alert?.shop?["SatisfactionIcon"] as? String {
                    if let url = URL(string: urlString) {
                        icon.af_setImage(withURL: url)
                    }
                }
                label.text = alert!.shop!["Satisfaction"] as? String
            }
            return cell
        }
        
        if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertActionCell", for: indexPath)
            
            if let doneButton = cell.viewWithTag(1) {
                if alert?.status == 0 {
                    doneButton.isHidden = false
                } else {
                    doneButton.isHidden = true
                }
            }
            
            if let doneButtonLabel = cell.viewWithTag(3) as? UILabel {
                doneButtonLabel.text = "It's done".localized
            }
            
            if let doneLabel = cell.viewWithTag(2) as? UILabel {
                doneLabel.text = "Correction in progress...".localized
                if alert?.status == 0 {
                    doneLabel.isHidden = true
                } else {
                    doneLabel.isHidden = false
                }
            }
            
            if let laterButton = cell.viewWithTag(4) as? UIButton {
                laterButton.setTitle("Later".localized, for: .normal)
                if alert?.status == 0 {
                    laterButton.isHidden = false
                } else {
                    laterButton.isHidden = true
                }
            }
            
            return cell
        
        } else if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertInfoCell", for: indexPath)
            if let label = cell.viewWithTag(1) as? UILabel {
                label.text = alert?.title
            }
            if let label = cell.viewWithTag(2) as? UILabel {
                label.text = alert?.subtitle
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertStepCell", for: indexPath)
        
        if let module = Module.currentModule {
            if module.isForSpa {
                
            }
        }
        
        // Configure the cell...
        if let stepNumberLabel = cell.viewWithTag(1) as? UILabel {
            stepNumberLabel.text = String(indexPath.row + 1)
        }
        if let stepLabel = cell.viewWithTag(2) as? ActiveLabel {
            
            let linkType = ActiveType.custom(pattern: "\\s" + "here".localized + "\\b")
            stepLabel.enabledTypes = [linkType]
            stepLabel.customColor[linkType] = K.Color.Green
            stepLabel.handleCustomTap(for: linkType) { (element) in
                if let url = URL(string: "https://www.youtube.com/watch?v=D_h5jIhm-3U&feature=youtu.be".localized) {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    self.present(vc, animated: true)
                }
            }
            
            stepLabel.text = alert?.steps[indexPath.row]
            
            if indexPath.row == (alert?.steps.count)! - 1  {
                if let view = cell.viewWithTag(3) {
                    view.isHidden = true
                }
            }
            
        }

        return cell
    }

    @IBAction func doneButtonAction(_ sender: Any) {
        
        if infoMode {
            self.dismiss(animated: true, completion: nil)
        } else {
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            
            alert?.close(completion: { (error) in
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    NotificationCenter.default.post(name: K.Notifications.AlertDidClose, object: nil)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 3)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    @IBAction func laterButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Offset alerts".localized, message: "When do you want to receive alerts again?".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
        let action1 = UIAlertAction(title: "In 3 hours".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("Dans 3 heures")
            
            self.postponeAlerts(value: 3)
            
        }
        
        let action2 = UIAlertAction(title: "From 19:00".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("A partir de 19h")
            
            var component       = DateComponents()
            component.calendar  = Calendar.current
            component.year      = Date().year
            component.month     = Date().month
            if Date().hour < 19 {
                component.day       = Date().day
            } else {
                component.day       = Date().day + 1
            }
            component.hour      = 19
            component.minute    = 0
            
            if let date19 = component.date?.timeIntervalSinceNow {
                print("Soit dans \(String(format: "%.0f", date19/3600))h")
                
                if let value = Int(String(format: "%.0f", date19/3600)) {
                    self.postponeAlerts(value: value)
                }
            }
            
        }
        
        let action3 = UIAlertAction(title: "Tomorrow".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("Dans 24 heures")
            
            self.postponeAlerts(value: 24)
            
        }
        
        let action4 = UIAlertAction(title: "This week-end".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("Ce WE, ie Ven. 19h")
            
            var component       = DateComponents()
            component.calendar  = Calendar.current
            component.year      = Date().year
            component.month     = Date().month
            component.day       = Date().day
            component.hour      = 19
            component.minute    = 0
            
            var dateWE = component.date
            if Date().weekday < 6 && Date().weekday > 0 {
                dateWE?.add(Calendar.Component.day, value: 6 - Date().weekday)
            } else if Date().weekday == 0 {
                dateWE?.add(Calendar.Component.day, value: 5)
            } else {
                dateWE?.add(Calendar.Component.day, value: 6)
            }

            
            print("Soit dans \(String(format: "%.0f", dateWE!.timeIntervalSinceNow/3600))h - \(Date().weekday)")
            
            if let value = Int(String(format: "%.0f", dateWE!.timeIntervalSinceNow/3600)) {
                self.postponeAlerts(value: value)
            }
        }
        
        let action5 = UIAlertAction(title: "Select a date".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("Date select")
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            datePicker.minimumDate = Date()
            //datePicker.date = Date()?.adding(Calendar.Component.hour, value: 3)
            
            let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
            alert.view.addSubview(datePicker)
            
            datePicker.center.x = alert.view.center.x

            
            let ok = UIAlertAction(title: "Shift to this date".localized, style: .default) { (action) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = dateFormatter.string(from: datePicker.date)
                print(dateString)
                print("Soit dans \(String(format: "%.0f", datePicker.date.timeIntervalSinceNow/3600))h")
                
                if let value = Int(String(format: "%.0f", datePicker.date.timeIntervalSinceNow/3600)) {
                    self.postponeAlerts(value: value)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func postponeAlerts(value:Int) {
        if let module = Module.currentModule {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            
            module.postponeAlerts(value: value) { (error) in
                if error != nil {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    NotificationCenter.default.post(name: K.Notifications.AlertDidClose, object: nil)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 3)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func shopButtonAction(_ sender: Any) {
        if let urlString = alert.shop?["SpecificLink"] as? String {
            if let url = URL(string: urlString) {
                if #available(iOS 11.0, *) {
                    let vc = SFSafariViewController(url: url)
                    self.present(vc, animated: true)

                } else {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    self.present(vc, animated: true)

                }
            }
        }
    }
    
    
}
