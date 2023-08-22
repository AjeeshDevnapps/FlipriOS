//
//  PoolLogTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 25/07/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit

let FliprLogDidChanged = Notification.Name("FliprLogDidChange")

class PoolLogTableViewController: UITableViewController, PoolLogViewControllerDelegate {
    
    var page = 1
    var loading = false
    var logs = [Log]()
    let limit = 25
    var deletedItemsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Service book".localized()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor =  K.Color.DarkBlue
        navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:UIColor.white])
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:UIColor.white])
        }
        
        NotificationCenter.default.addObserver(forName: FliprLogDidChanged, object: nil, queue: nil) { (notification) in
            self.logs = [Log]()
            self.tableView.reloadData()
            self.page = 1
            self.view.showEmptyStateViewLoading(title: nil, message: nil)
            self.refresh()
        }
        
//        if let module = Module.currentModule {
////            if module.isSubscriptionValid {
//                NotificationCenter.default.addObserver(forName: FliprLogDidChanged, object: nil, queue: nil) { (notification) in
//                    self.logs = [Log]()
//                    self.tableView.reloadData()
//                    self.page = 1
//                    self.view.showEmptyStateViewLoading(title: nil, message: nil)
//                    self.refresh()
//                }
//
//                self.view.showEmptyStateViewLoading(title: nil, message: nil)
//                refresh()
////            } else {
////                self.view.showEmptyStateView(image: nil, title: "[Texte à mettre]", message: "[Texte à mettre]", buttonTitle: "Upgrade to Flipr Infinite".localized) {
////                    if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
////                        self.present(vc, animated: true, completion: nil)
////                    }
////                }
////            }
//        } else {
//
//        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let module = Module.currentModule {
//            if module.isSubscriptionValid {
//                NotificationCenter.default.addObserver(forName: FliprLogDidChanged, object: nil, queue: nil) { (notification) in
//                    self.logs = [Log]()
//                    self.tableView.reloadData()
//                    self.page = 1
//                    self.view.showEmptyStateViewLoading(title: nil, message: nil)
//                    self.refresh()
//                }
                
                self.view.showEmptyStateViewLoading(title: nil, message: nil)
                self.page = 1
                self.logs.removeAll()
                refresh()
//            } else {
//                self.view.showEmptyStateView(image: nil, title: "[Texte à mettre]", message: "[Texte à mettre]", buttonTitle: "Upgrade to Flipr Infinite".localized) {
//                    if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
//                        self.present(vc, animated: true, completion: nil)
//                    }
//                }
//            }
        } else {
            
        }
//        refresh()
    }
    
    func refresh() {
        
        if !loading {
            loading = true
            if logs.count == page * limit - deletedItemsCount{
                page = page + 1
            }
            if (Pool.currentPool?.id) != nil {
                Pool.currentPool?.getLog(page: page) { (logItems, error) in
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    } else {
                        if let logs = logItems {
                            self.logs.append(contentsOf: logs)
                        }
                        self.tableView.reloadData()
                        self.view.hideStateView()
                    }
                    self.loading = false
                }
            }
        }
    }

    // MARK: - Table view data source

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if logs.count < limit * page - deletedItemsCount {
            return logs.count
        }
        return logs.count + 1
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == logs.count {
            refresh()
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= logs.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
            if let control = cell.viewWithTag(1) as? UIActivityIndicatorView {
                control.startAnimating()
            }
            return cell
        }
        
        var identifier:String!
        if indexPath.row % 2 == 0 {
            identifier = "logCellLeft"
        } else {
            identifier = "logCellRight"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LogTableViewCell
        cell.log = logs[indexPath.row]
        if indexPath.row == logs.count - 1 {
            cell.endLineView.isHidden = true
        } else  {
            cell.endLineView.isHidden = false
        }
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PoolLogViewController {
            if let path = tableView.indexPathForSelectedRow {
                vc.log = logs[path.row]
                vc.delegate = self
            }
        }
    }
    
    func poolLogItemDidDelete(log: Log) {
        var i = 0
        var indexToDelete = -1
        for item in logs {
            if item.id == log.id {
                indexToDelete = i
            }
            i = i + 1
        }
        if indexToDelete >= 0 {
            deletedItemsCount = deletedItemsCount + 1
            self.logs.remove(at: indexToDelete)
            self.tableView.deleteRows(at: [IndexPath(row: indexToDelete, section: 0)], with: .fade)
        }
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }

}
