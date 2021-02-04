//
//  ProductTypeTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 21/06/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit

protocol ProductTypeTableViewControllerDelegate {
    func productTypeDidSelect(productType:ProductType)
}

class ProductTypeTableViewController: UITableViewController {
    
    var EAN:Int64!
    var productTypes = [ProductType]()
    var delegate:ProductTypeTableViewControllerDelegate?
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Product type".localized
        
        if isUpdate {
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isUpdate {
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddNew") {
            let controller = segue.destination as! ProductViewController
            let indexPath = self.tableView.indexPathForSelectedRow as IndexPath!
            let productType = self.productTypes[(indexPath?.row)!]
            let product = Product(withJSON: ["EAN":self.EAN,"ProductType":productType.serialized])
            controller.product = product
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productTypes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isUpdate {
            return nil
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeHeaderCell")
        if let label = cell?.viewWithTag(1) as? UILabel {
            label.text = "We do not know this product yet!".localized
        }
        if let label = cell?.viewWithTag(2) as? UILabel {
            label.text = "No worries: please choose the type of product!".localized
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isUpdate {
            return 0
        }
        return 100
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeCell", for: indexPath)

        cell.textLabel?.text = productTypes[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isUpdate {
            delegate?.productTypeDidSelect(productType: productTypes[indexPath.row])
            navigationController?.popViewController()
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    

}
