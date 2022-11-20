//
//  WatrFliprSettingsViewController.swift
//  Flipr
//
//  Created by Ajeesh on 18/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import AVFoundation

class WatrFliprSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var placeDetails:PlaceDropdown!
    var placesModules:PlaceModule!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AnalysR"
        tableView.tableFooterView =  UIView()
        // Do any additional setup after loading the view.
    }

}


extension WatrFliprSettingsViewController: UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FliprSettingsTableViewCell", for: indexPath) as! FliprSettingsTableViewCell
        var name = ""
        if let fname = User.currentUser?.firstName{
            name.append(fname)
        }
        if let lname = User.currentUser?.lastName{
            name.append(" ")
            name.append(lname)
        }
        cell.ownerLbl.text = name
        cell.locationLbl.text = "Sample data"
        cell.serialNoLbl.text = Module.currentModule?.serial
//        cell.typeLbl.text = Module.currentModule?.deviceTypename

        return cell
    }
}


extension WatrFliprSettingsViewController{
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.showDelete()
    }
    
    @IBAction func updateButtonClicked(_ sender: UIButton) {
        self.showFirmwereUdpateScreen()
    }
    
    func showFirmwereUdpateScreen(){
        let navigationController = UIStoryboard(name:"Firmware", bundle: nil).instantiateViewController(withIdentifier: "FirmwareNav") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showDelete(){
        let alertController = UIAlertController(title: "Supprimer AnalysR".localized, message: "Ce Flipr AnalysR ne sera plus disponible".localized, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Supprimer".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            self.deleteFlipr()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteFlipr(){
        
    }
}
