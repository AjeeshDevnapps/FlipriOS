//
//  HUBViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 24/04/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class HUBViewController: UIViewController {
    
    var hub:HUB?
    var hubs:[HUB] = []
    
    @IBOutlet weak var enabledLabel: UILabel!
    @IBOutlet weak var disabledLabel: UILabel!
    @IBOutlet weak var programsTitleLabel: UILabel!
    
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var offLabel: UILabel!
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var programView: UIView!
    @IBOutlet weak var automView: UIView!
    
    @IBOutlet weak var progButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var automButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var modeValueLabel: UILabel!
    @IBOutlet weak var hubButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    
    @IBOutlet weak var manualSwitch: UISwitch!
    @IBOutlet weak var automSwitch: UISwitch!
    
    @IBOutlet weak var autoMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programsTitleLabel.text = "Programs".localized()
        enabledLabel.text = "Enabled".localized()
        disabledLabel.text = "Disabled".localized()
        onLabel.text = "On".localized()
        offLabel.text = "Off".localized()
        self.editButton.setTitle("Edit".localized(), for: .normal)
        self.addButton.setTitle("Add".localized(), for: .normal)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        manualView.alpha = 0
        programView.alpha = 0
        automView.alpha = 0
        self.controlView.alpha = 0
        
        autoMessageLabel.isHidden = true
        
        loadHUBs()
        
        
        NotificationCenter.default.addObserver(forName: FliprHUBPlanningsDidChange, object: nil, queue: nil) { (notification) in
            self.tableView.setEditing(false, animated: true)
            self.editButton.setTitle("Edit".localized(), for: .normal)
            self.refreshPlannings()
        }
        
    }
    
    func loadHUBs() {
        manualView.alpha = 0
        programView.alpha = 0
        automView.alpha = 0
        self.controlView.alpha = 0
        
        autoMessageLabel.isHidden = true
        
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballPulse

        self.view.showEmptyStateViewLoading(title: nil, message: nil, theme: theme)
            
        Pool.currentPool?.getHUBS(completion: { (hubs, error) in
            
            self.view.hideStateView()
            
            if error != nil {
                self.showError(title: "Error".localized, message: error!.localizedDescription)
            } else if hubs != nil {
                if hubs!.count > 0 {
                    self.hubs = hubs!
                    if let currentHub = HUB.currentHUB {
                        for hub in hubs! {
                            if currentHub.serial == hub.serial {
                                self.hub = hub
                                HUB.currentHUB = hub
                                HUB.saveCurrentHUBLocally()
                                self.refreshHUBdisplay()
                                UIView.animate(withDuration: 0.25) {
                                    self.controlView.alpha = 1
                                }
                                break
                            }
                        }
                    } else {
                        self.hub = hubs!.first
                        HUB.currentHUB = hubs!.first
                        HUB.saveCurrentHUBLocally()
                        self.refreshHUBdisplay()
                        UIView.animate(withDuration: 0.25) {
                            self.controlView.alpha = 1
                        }
                    }
                } else {
                   self.showError(title: "Error".localized, message: "No hubs :/")
                }
            } else {
                self.showError(title: "Error".localized, message: "No hubs :/")
            }
        })
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func refreshHUBdisplay() {
        if let hub = hub {
            hubButton.setTitle(hub.equipementName, for: .normal)
            if hub.equipementState {
                stateLabel.text = "Working".localized()
                stateImageView.image = UIImage(named: "play_circle")
                manualSwitch.isOn = hub.equipementState
            } else {
                stateLabel.text = "Stopped".localized()
                stateImageView.image = UIImage(named: "stop_circle")
                manualSwitch.isOn = hub.equipementState
            }
            if hub.behavior == "manual" {
                modeValueLabel.text = "Manual".localized()
                automSwitch.isOn = false
                manualButtonAction(self)
            } else if hub.behavior == "planning" {
                modeValueLabel.text = "Program".localized()
                automSwitch.isOn = false
                progButtonAction(self)
            } else if hub.behavior == "auto" {
                modeValueLabel.text = "Smart Control"
                automSwitch.isOn = true
                automButtonAction(self)
                hub.getAutomMessage { (message) in
                    if message != nil {
                        self.autoMessageLabel.text = message
                        self.autoMessageLabel.isHidden = false
                    }
                }
            } else {
                modeValueLabel.text = "Unkown mode"
                automSwitch.isOn = false
                manualButtonAction(self)
            }
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func wifiButtonAction(_ sender: Any) {
        
        if let hub = hub {
            let alert = UIAlertController(title: hub.equipementName, message:"Flipr HUB\nN° \(hub.serial)", preferredStyle:.actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Rename".localized, style: .default, handler: { (action) in
                self.renameButtonAction(self)
            }))
            alert.addAction(UIAlertAction(title: "WIFI settings".localized, style: .default, handler: { (action) in
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HUBWifiTableViewControllerID") as? HUBWifiTableViewController {
                    viewController.serial = hub.serial
                    viewController.fromSetting = true
                    self.navigationController?.pushViewController(viewController, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { (action) in
                
                let confirmAlert = UIAlertController(title: "Flipr HUB\nN° \(hub.serial)", message: "Are you sure you want to delete this HUB from your account?".localized, preferredStyle:.alert)
                
                confirmAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                confirmAlert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { (action) in
                    let hud = JGProgressHUD(style:.dark)
                    hud?.show(in: self.navigationController!.view)
                    
                    HUB.currentHUB?.remove(completion: { (error) in
                        if (error != nil) {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = error?.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        } else {
                            
                            hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud?.dismiss(afterDelay: 1)
                            
                            if self.hubs.count > 1 {
                                HUB.currentHUB = nil
                                UserDefaults.standard.removeObject(forKey: "CurrentHUB")
                                self.loadHUBs()
                            } else {
                                self.dismiss(animated: true) {
                                    HUB.currentHUB = nil
                                    UserDefaults.standard.removeObject(forKey: "CurrentHUB")
                                }
                            }
                            
                        }
                    })
                }))
                
                self.present(confirmAlert, animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    
    @IBAction func renameButtonAction(_ sender: Any) {
        
        var nameTextField: UITextField?
        
        let alertController = UIAlertController(title: "Rename".localized, message: "Enter the new name".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Save".localized, style: .default, handler: { (action) -> Void in
            print("Send Button Pressed, email : \(nameTextField?.text)")
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            HUB.currentHUB!.updateEquipmentName(value: nameTextField!.text!, completion: { (error) in
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    HUB.currentHUB!.equipementName = nameTextField!.text!
                    self.hubButton.setTitle(nameTextField!.text!, for: .normal)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                }
            })
            
        })
        
        //sendAction.isEnabled = (loginTextField?.text?.isEmail)!
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            nameTextField = textField
            nameTextField?.text = self.hub?.equipementName
            nameTextField?.placeholder = "Name...".localized
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func manualSwitchValueChanged(_ sender: Any) {
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        
        HUB.currentHUB?.updateState(value: manualSwitch.isOn, completion: { (error) in
            if error != nil {
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 3)
            } else {
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
            }
            self.refreshHUBdisplay()
            self.view.hideStateView()
        })
        
    }
    
    @IBAction func automSwitchValueChanged(_ sender: Any) {
        
        self.automView.showEmptyStateViewLoading(title: nil, message: nil)
        if automSwitch.isOn {
            HUB.currentHUB?.updateBehavior(value: "auto", completion: { (message, error) in
                if error != nil {
                    self.showError(title: "Error", message: error?.localizedDescription)
                    self.automSwitch.setOn(false, animated: true)
                } else {
                    HUB.currentHUB?.behavior = "auto"
                    self.autoMessageLabel.text = message
                    self.autoMessageLabel.isHidden = false
                }
                self.hub?.getState { (state, error) in
                    if state != nil {
                        HUB.currentHUB!.equipementState = state!
                        self.hub?.equipementState = state!
                        self.refreshHUBdisplay()
                    }
                }
                self.automView.hideStateView()
            })
        } else {
            HUB.currentHUB?.updateBehavior(value: "manual", completion: { (message, error) in
                if error != nil {
                    self.showError(title: "Error", message: error?.localizedDescription)
                    self.automSwitch.setOn(true, animated: true)
                } else {
                    self.autoMessageLabel.isHidden = true
                }
                self.refreshHUBdisplay()
                self.automView.hideStateView()
            })
        }
    }
    
    
    @IBAction func progButtonAction(_ sender: Any) {
        progButton.setImage(UIImage(named: "Timer_select"), for: .normal)
        manualButton.setImage(UIImage(named: "cached"), for: .normal)
        automButton.setImage(UIImage(named: "Flash"), for: .normal)
        modeValueLabel.text = "Programme"
        
        manualView.alpha = 0
        automView.alpha = 0
        
        refreshPlannings()
        
        UIView.animate(withDuration: 0.25) {
            self.programView.alpha = 1
        }
    }
    
    func refreshPlannings() {
        self.programView.showEmptyStateViewLoading(title: nil, message: nil)
        HUB.currentHUB?.getPlannings(completion: { (error) in
            if error != nil {
                if HUB.currentHUB!.plannings.count > 0 {
                    self.programView.showEmptyStateViewLoading(title: "Error".localized, message: error?.localizedDescription)
                } else {
                    self.showError(title: "Error".localized, message: error?.localizedDescription)
                }
            } else {
                if HUB.currentHUB!.plannings.count == 0 {
                    self.programView.showEmptyStateView(image: nil, title: nil, message: "No program".localized(), buttonTitle: "Add a new program".localized()) {
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                } else {
                    self.programView.hideStateView()
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    
    @IBAction func manualButtonAction(_ sender: Any) {
        progButton.setImage(UIImage(named: "Timer"), for: .normal)
        manualButton.setImage(UIImage(named: "cached_select"), for: .normal)
        automButton.setImage(UIImage(named: "Flash"), for: .normal)
        modeValueLabel.text = "Manual".localized()
        
        programView.alpha = 0
        automView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.manualView.alpha = 1
        }
    }
    
    @IBAction func automButtonAction(_ sender: Any) {
        
        if let hub = HUB.currentHUB {
            if hub.equipementCode == 84 {
                self.showError(title: "Smart Control unavailable".localized(), message: "La fonction Smart Control n'est pas disponible pour les HUB liés à l'éclairage")
                return
            }
            if hub.equipementCode == 86 && Module.currentModule == nil {
                self.showError(title: "Smart Control unavailable".localized(), message: "The Smart Control function requires a Flipr Start.".localized())
                return
            }
            if hub.equipementCode == 85 {
                var hasFiltrationHub = false
                for hub in hubs {
                    if hub.equipementCode == 86 {
                        hasFiltrationHub = true
                    }
                }
                if !hasFiltrationHub {
                    self.showError(title: "Smart Control unavailable".localized(), message: "The Smart Control function for heat pumps requires a Flipr HUB associated with a filtration pump".localized())
                    return
                } else if Module.currentModule == nil {
                    self.showError(title: "Smart Control unavailable".localized(), message: "The Smart Control function requires a Flipr Start.".localized())
                }
                return
            }
        }
        progButton.setImage(UIImage(named: "Timer"), for: .normal)
        manualButton.setImage(UIImage(named: "cached"), for: .normal)
        automButton.setImage(UIImage(named: "Flash_select"), for: .normal)
        modeValueLabel.text = "Smart Control"
        
        manualView.alpha = 0
        programView.alpha = 0
        
        
        UIView.animate(withDuration: 0.25) {
            self.automView.alpha = 1
        }
    }
    
    
    @IBAction func hubButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Select your HUB".localized(), message:"or add a new one...".localized(), preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        var index = 0
        for hub in hubs {
            alert.addAction(UIAlertAction(title: hub.equipementName, style: .default, handler: { (action) in
                //TODO
                HUB.currentHUB? = hub
                self.hub = hub
                HUB.saveCurrentHUBLocally()
                self.tableView.reloadData()
                self.refreshHUBdisplay()
            }))
            index = index + 1
        }

        alert.addAction(UIAlertAction(title: "Add a new HUB".localized, style: .default, handler: { (action) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HubTypeSelectionViewControllerID") {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addProgramButtonAction(_ sender: Any) {
    }
    @IBAction func editProgramButtonAction(_ sender: Any) {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
            self.editButton.setTitle("Edit".localized(), for: .normal)
        } else {
            self.tableView.setEditing(true, animated: true)
            self.editButton.setTitle("Done".localized(), for: .normal)
        }
    }
    
    @IBAction func planningSwitchValueDidChanged(_ sender: Any) {
        if let pSwitch = sender as? PlanningSwitch {
            
            if !pSwitch.isOn {
                HUB.currentHUB?.updateBehavior(value: "manual", completion: { (message, error) in
                    if error != nil {
                        self.showError(title: "Error".localized(), message: error?.localizedDescription)
                        pSwitch.setOn(true, animated: true)
                        self.refreshHUBdisplay()
                    } else {
                        pSwitch.planning.isActivated = false
                        self.refreshHUBdisplay()
                        HUB.currentHUB!.behavior = "manual"
                    }
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
            } else {
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
                hud?.show(in: self.navigationController!.view)
                
                HUB.currentHUB!.syncPlannings { (error) in
                    print("Sync Planning error : \(error?.localizedDescription)")
                    if (error != nil) {
                        hud?.textLabel.text = error?.localizedDescription
                        hud?.dismiss(afterDelay: 3)
                    } else {
                        hud?.dismiss(afterDelay: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) ) {
                            self.hub?.getState { (state, pError) in
                                
                                if error != nil {
                                    self.showError(title: "Error".localized, message: pError!.localizedDescription)
                                }
                                
                                if state != nil {
                                    HUB.currentHUB!.equipementState = state!
                                    self.hub?.equipementState = state!
                                    self.refreshHUBdisplay()
                                }
                            }
                        }
                    }
                    self.refreshPlannings()
                    
                }
            }
            
            
        }
    }
    
    
}

extension HUBViewController:UITableViewDataSource, UITableViewDelegate {
    
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
                        self.programView.showEmptyStateView(image: nil, title: nil, message: "No program".localized(), buttonTitle: "Add a new program".localized()) {
                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
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
            label.textColor = .white
            label.font = .systemFont(ofSize: 15, weight: .regular)
        } else {
            label.textColor = .lightText
            label.font = .systemFont(ofSize: 15, weight: .light)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if HUB.currentHUB == nil{
                return
            }
            let planning = HUB.currentHUB!.plannings[indexPath.row]
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
                vc.planning = planning
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

class PlanningSwitch: UISwitch {
    
    var planning:Planning! {
        didSet {
            print("HUB.currentHUB!.behavior => \(HUB.currentHUB!.behavior)")
            if HUB.currentHUB!.behavior == "planning" {
                self.isOn = planning.isActivated
            } else {
                self.isOn = false
            }
        }
    }

}
