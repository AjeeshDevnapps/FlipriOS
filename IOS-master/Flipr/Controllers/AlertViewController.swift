//
//  AlertViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 10/05/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import ActiveLabel
import SafariServices

class AlertViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var alert:Alert?
    var infoMode = false

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundHeaderView: UIImageView!
    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let module = Module.currentModule {
            if module.isForSpa {
                backgroundImageView.image = UIImage(named:"BG_spa")
                backgroundHeaderView.image = UIImage(named:"Bg_Informations_SPA")
            }
        }
        
        navigationTitleLabel.text = "ALERT IN PROGRESS".localized
        
        if infoMode {
            navigationTitleLabel.text = "INFORMATION".localized
        }
        
        print("Step count: \( (alert?.steps.count)!)")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset =  UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 54, left: 0, bottom: 0, right: 0)
        
        self.view.clipsToBounds = true
        
        self.titleLabel.text = alert?.title
        self.subtitleLabel.text = alert?.subtitle
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return 1
        }
        return (alert?.steps.count)!
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertActionCell", for: indexPath)
            
            if let doneButton = cell.viewWithTag(1) as? UIButton {
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
                doneLabel.text = "Correction in progress".localized
                if alert?.status == 0 {
                    doneLabel.isHidden = true
                } else {
                    doneLabel.isHidden = false
                }
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertStepCell", for: indexPath)
        
        if let module = Module.currentModule {
            if module.isForSpa {
                if let imageView = cell.viewWithTag(10) as? UIImageView {
                    imageView.image = UIImage(named:"BG_cellule_SPA")
                }
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
            
        }
        
        if indexPath.row == (alert?.steps.count)! - 2  {
            if let view = cell.viewWithTag(3) {
                view.isHidden = true
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
