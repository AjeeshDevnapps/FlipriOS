//
//  HubProgramViewController.swift
//  Flipr
//
//  Created by Ajeesh on 05/11/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class HubProgramViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addButton: UIButton!

    var hub:HUB?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.roundCorner(corner: 12)
        NotificationCenter.default.addObserver(forName: K.Notifications.ReloadProgrameList, object: nil, queue: nil) { (notification) in
            self.reloadList()
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                }, completion: nil)

//        self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    @IBAction func addButtonClicked(){
        let sb = UIStoryboard.init(name: "HUB", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func reloadList(){
        HUB.currentHUB = hub
        HUB.saveCurrentHUBLocally()
        HUB.currentHUB?.getPlannings(completion: { (error) in
            if error != nil {
               
            } else {
//                self.hub = HUB.currentHUB
                self.tableView.reloadData()

//                if HUB.currentHUB!.plannings.count == 0 {
//
//                    self.hub = HUB.currentHUB
//                } else {
//
//                }
                
            }
        })
    }
    
    @IBAction func planningSwitchValueDidChanged(_ sender: Any) {
        if let pSwitch = sender as? PlanningSwitch {
            
            if !pSwitch.isOn {
                HUB.currentHUB?.updateBehavior(value: "manual", completion: { (message, error) in
                    if error != nil {
                        self.showError(title: "Error".localized(), message: error?.localizedDescription)
                        pSwitch.setOn(true, animated: true)
//                        self.refreshHUBdisplay()
                    } else {
                        pSwitch.planning.isActivated = false
//                        self.refreshHUBdisplay()
                        HUB.currentHUB!.behavior = "manual"
                    }
                    self.reloadList()
                    NotificationCenter.default.post(name: K.Notifications.UpdateHubViews, object: nil)
                })
                /*
                let alert = UIAlertController(title: "Désactivation du mode Programme", message:"Tous les programmes ", preferredStyle:.actionSheet)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Continuer".localized, style: .default, handler: { (action) in
                    self.renameButtonAction(self)
                }))
                alert.addAction(UIAlertAction(title: "Réglages WIFI".localized, style: .default, handler: { (action) in
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
                        viewController.serial = hub.serial
                        viewController.fromSetting = true
                        self.navigationController?.pushViewController(viewController, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                */
            }
            else {
                print("pSwitch.planning.name: \(pSwitch.planning.name)")
                for planning in HUB.currentHUB!.plannings {
                    if planning.id == pSwitch.planning.id {
                        planning.isActivated = true
                    } else {
                        planning.isActivated = false
                    }
                }
                HUB.currentHUB!.behavior = "planning"
                tableView.reloadData()
                
                let hud = JGProgressHUD(style:.dark)
                hud?.show(in: self.containerView)
                
                HUB.currentHUB!.syncPlannings { (error) in
                    print("Sync Planning error : \(error?.localizedDescription)")
                    if (error != nil) {
                        hud?.textLabel.text = error?.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    } else {
                        hud?.dismiss(afterDelay: 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) ) {
                            self.hub?.getState { (state, pError) in
                                
                                if error != nil {
                                    self.showError(title: "Error".localized, message: pError!.localizedDescription)
                                }
                                
                                if state != nil {
                                    HUB.currentHUB!.equipementState = state!
                                    self.hub?.equipementState = state!
                                    self.reloadList()
                                }
                            }
                        }
                    }
                    self.reloadList()
                    NotificationCenter.default.post(name: K.Notifications.UpdateHubViews, object: nil)
                }
            }
            
            
        }
    }
    

}

extension HubProgramViewController:UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HUB.currentHUB!.plannings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanningCell", for: indexPath)
        
        let planning = HUB.currentHUB!.plannings[indexPath.row]
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = planning.name
        }
        if let activatedSwitch = cell.viewWithTag(2) as? PlanningSwitch {
            activatedSwitch.planning = planning
            
        }
        
        if let monday = cell.viewWithTag(10) as? UILabel, let tuesday = cell.viewWithTag(11) as? UILabel, let weenesday = cell.viewWithTag(12) as? UILabel, let thursday = cell.viewWithTag(13) as? UILabel, let friday = cell.viewWithTag(14) as? UILabel, let saturday = cell.viewWithTag(15) as? UILabel, let sunday = cell.viewWithTag(16) as? UILabel {
            
            monday.text = "DAY_1".localized()
            tuesday.text = "DAY_2".localized()
            weenesday.text = "DAY_3".localized()
            thursday.text = "DAY_4".localized()
            friday.text = "DAY_5".localized()
            saturday.text = "DAY_6".localized()
            sunday.text = "DAY_7".localized()
    
            
            refresh(planning: planning, label: monday, atIndex: 0)
            refresh(planning: planning, label: tuesday, atIndex: 1)
            refresh(planning: planning, label: weenesday, atIndex: 2)
            refresh(planning: planning, label: thursday, atIndex: 3)
            refresh(planning: planning, label: friday, atIndex: 4)
            refresh(planning: planning, label: saturday, atIndex: 5)
            refresh(planning: planning, label: sunday, atIndex: 6)
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            let planning = HUB.currentHUB!.plannings[indexPath.row]
            HUB.currentHUB!.deletePlanning(planningId: planning.id) { (error) in
                if error == nil {
                    HUB.currentHUB!.plannings.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                    if HUB.currentHUB!.plannings.count == 0 {
                        /*
                        self.programView.showEmptyStateView(image: nil, title: nil, message: "No program".localized(), buttonTitle: "Add a new program".localized()) {
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        */
                    }
                } else {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
       
    }
    
    func refresh(planning:Planning, label:UILabel, atIndex:Int) {
        if planning.days[atIndex] == "1" {
            label.textColor = .black
            label.font = .systemFont(ofSize: 15, weight: .regular)
        } else {
            label.textColor = .gray
            label.font = .systemFont(ofSize: 15, weight: .light)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.isEditing {
            if HUB.currentHUB == nil{
                return
            }
        
            let planning = HUB.currentHUB!.plannings[indexPath.row]
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                vc.planning = planning
                self.present(vc, animated: true, completion: nil)
            }
//        }
    }
    
}
