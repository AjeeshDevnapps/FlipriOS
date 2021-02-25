//
//  WaterLevelTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 17/04/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class WaterLevelTableViewController: UITableViewController {
    
    var waterLevels = [WaterLevel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Draining".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))

        var bakcgroundFileName = "BG"
        
        if let module = Module.currentModule {
            if module.isForSpa {
                bakcgroundFileName = "BG_spa"
            }
        }
        
        let imvTableBackground = UIImageView.init(image: UIImage(named: bakcgroundFileName))
        imvTableBackground.frame = self.tableView.frame
        self.tableView.backgroundView = imvTableBackground
        
        self.view.showEmptyStateViewLoading(title: nil, message: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if let navC = self.storyboard?.instantiateViewController(withIdentifier: "WaterLevelNavigationControllerID") {
            self.present(navC, animated: true, completion: nil)
        }
        
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonAction(_ sender:Any) {
        if let button = sender as? WaterLevelButton, let poolId = Pool.currentPool?.id {
            
            let alertController = UIAlertController(title: "Draining removal".localized, message: "Are you sure you want to delete this draining data?".localized, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
            {
                (result : UIAlertAction) -> Void in
                
            }
            
            let okAction = UIAlertAction(title: "Delete".localized, style: UIAlertAction.Style.destructive)
            {
                (result : UIAlertAction) -> Void in
                
                let hud = JGProgressHUD(style:.dark)
                hud?.show(in: self.navigationController!.view)
                
                
                Alamofire.request(Router.deleteWaterLevel(poolId: poolId, waterLevelId: button.waterLevel!.id)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
                    if response.response?.statusCode == 401 {
                        NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                    }
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        print("Delete draining response.result.value: \(value)")
                        
                        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud?.dismiss(afterDelay: 1)
                        
                        self.refresh()
                        
                    case .failure(let error):
                        
                        print("Delete draining did fail with error: \(error)")
                        
                        if let serverError = User.serverError(response: response) {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = serverError.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        } else {
                            hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud?.textLabel.text = error.localizedDescription
                            hud?.dismiss(afterDelay: 3)
                        }
                    }
                    
                })
                
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true) {
                
            }
        }
    }
    
    func refresh() {
        
        if let poolId = Pool.currentPool?.id {
            
            Alamofire.request(Router.getWaterLevels(poolId: poolId)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                self.view.hideStateView()
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("get stock response.result.value: \(value)")
                    
                    self.waterLevels.removeAll()
                    
                    if let stocks = value as? [[String:Any]] {
                        
                        for JSON in stocks {
                            if let item = WaterLevel(withJSON: JSON) {
                                self.waterLevels.append(item)
                            }
                        }
                        
                        if self.waterLevels.count > 0 {
                            self.view.hideStateView()

                            
                        } else {

                            self.view.showEmptyStateView(image: UIImage(named:"no_draining"), title: "No draining".localized, message: "NO_DRAINING_MESSAGE".localized, buttonTitle: "Add draining".localized, buttonAction: {
                                self.addButtonAction(self)
                            })
                        }
                        self.tableView.reloadData()
                        
                    } else {
                        self.showError(title: "Error".localized, message: "Data format returned by the server is not supported.".localized)
                    }
                    
                case .failure(let error):
                    
                    print("get stock did fail with error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        self.showError(title: "Error".localized, message: serverError.localizedDescription)
                    } else {
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                }
                
            })
            
        } else {
            self.showError(title: "Error".localized, message: "Please first fill in the data for your pool".localized)
        }
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return waterLevels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaterLevelCell", for: indexPath) as! WaterLevelTableViewCell
        
        cell.waterLevel = waterLevels[indexPath.row]

        return cell
    }

}
