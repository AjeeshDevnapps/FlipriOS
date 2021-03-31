//
//  EquipmentTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 31/08/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class EquipmentTableViewController: UITableViewController {
    
    var categories = [EquipmentCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My equipments".localized
        
        var bakcgroundFileName = "BG"
        
        if let module = Module.currentModule {
            if module.isForSpa {
                bakcgroundFileName = "BG_spa"
            }
        }
        
        let imvTableBackground = UIImageView.init(image: UIImage(named: bakcgroundFileName))
        imvTableBackground.frame = self.tableView.frame
        self.tableView.backgroundView = imvTableBackground
        
        refresh()
    
    }
    
    func refresh() {
        
        self.view.showEmptyStateViewLoading(title: nil, message: nil)
        
        if let pool = Pool.currentPool {
            pool.getEquipments(completion: { (equipmentCategories, error) in
                if equipmentCategories != nil {
                    
                    var hasActive = false
                    for cat in equipmentCategories! {
                        for equipment in cat.equipments {
                            if equipment.active {
                                hasActive = true
                                break
                            }
                        }
                    }
                    if hasActive {
                        UserDefaults.standard.set(true, forKey: "EquipmentCount")
                    }
                    
                    self.tableView.hideStateView()
                    self.categories = equipmentCategories!
                    self.tableView.reloadData()
                } else {
                    if error != nil {
                        let darkTheme = EmptyStateViewTheme.shared
                        darkTheme.titleColor = K.Color.DarkBlue
                        darkTheme.messageColor = .lightGray
                        self.tableView.showEmptyStateView(image: nil, title: "Unable to retrieve data".localized, message: error?.localizedDescription, buttonTitle: "Retry".localized, buttonAction: {
                            self.refresh()
                        }, theme: darkTheme)
                    }
                }
            })
        } else {
            let darkTheme = EmptyStateViewTheme.shared
            darkTheme.titleColor = K.Color.DarkBlue
            darkTheme.messageColor = .lightGray
            self.tableView.showEmptyStateViewLoading(title: "Equipment not available".localized, message: "Please first fill in your pool data before allocating equipment.".localized, theme: darkTheme)
        }
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        
        if let aSwitch = sender as? EquipmentSwitch {
            categories[aSwitch.section].equipments[aSwitch.index].active = aSwitch.isOn
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.save()
    
    }
    
    
    func save(){
        UserDefaults.standard.set(true, forKey: "EquipmentCount")
        
        var activeEquipmentIds = [Int]()
        for category in categories {
            for equipment in category.equipments {
                if equipment.active {
                    activeEquipmentIds.append(equipment.id)
                }
            }
        }
        print("Active equipments: \(activeEquipmentIds)")
        
        let hud = JGProgressHUD(style:.dark)
//        hud?.show(in: self.navigationController!.view)
        hud?.show(in: self.view)
        
        Alamofire.request(Router.updatePoolEquipments(poolId: Pool.currentPool!.id!, equipmentIds: activeEquipmentIds)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success:
                
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
                NotificationCenter.default.post(name: FliprLogDidChanged, object: nil)
                self.dismiss(animated: true, completion: {
                   
                })
                
            case .failure(let error):
                
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                
                if let serverError = User.serverError(response: response) {
                    hud?.textLabel.text = serverError.localizedDescription
                } else {
                    hud?.textLabel.text = error.localizedDescription
                }
                
                
                hud?.dismiss(afterDelay: 3)
                
                
            }
            
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return categories[section - 1].equipments.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return categories[section - 1].name
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 178, green: 184, blue: 200)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentSubscriptionCell", for: indexPath)
            if let label = cell.viewWithTag(1) as? UILabel {
                label.text = "Get Flipr Infinite".localized
            }
            if let label = cell.viewWithTag(2) as? UILabel {
                label.text = "Receive tips tailored to your equipment".localized
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentCell", for: indexPath)
        
        let equipment = categories[indexPath.section - 1].equipments[indexPath.row]
        
        if let nameLabel = cell.viewWithTag(1) as? UILabel {
            nameLabel.text = equipment.name
        }
        
        print("Active: \(equipment.active)")
        
        if let activeSwitch = cell.viewWithTag(2) as? EquipmentSwitch {
            activeSwitch.section = indexPath.section - 1
            activeSwitch.index = indexPath.row
            activeSwitch.setOn(equipment.active, animated: true)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let module = Module.currentModule {
                if module.isSubscriptionValid {
                    return 0
                }
            }
            return 120
        }
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
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
