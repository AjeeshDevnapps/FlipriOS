//
//  ProductAttributesViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 21/03/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

protocol ProductAttributesViewControllerDelegate {
    func productAttributesDidSelect(attributeType:ProductAttributeType, attribute:ProductAttribute)
}

class ProductAttributesViewController: UITableViewController {
    
    var delegate:ProductAttributesViewControllerDelegate?
    
    var product:Product!
    var attributeType:ProductAttributeType!
    var attributes = [ProductAttribute]()
    var conditioning : ProductAttribute?
    var selectedAttributes:[ProductAttribute]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = attributeType.title
        if (attributeType != .brand) {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        if (conditioning != nil && (attributeType == .doseUnit || attributeType == .conditioningUnit)) {
            Alamofire.request(Router.getProductUnits(type: attributeType, conditioning: conditioning!)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print(value)
                    
                    if let JSON = value as? [[String:Any]] {
                        print("JSON: \(JSON)")
                        
                        var formValues = [ProductAttribute]()
                        
                        for value in JSON {
                            if let formValue = ProductAttribute.init(JSON: value) {
                                formValues.append(formValue)
                            }
                        }
                        
                        self.attributes = formValues
                        self.tableView.reloadData()
                        
                    } else {
                        print("response.result.value: \(value)")
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        print("Error: \(error.localizedDescription)")
                        self.showError(title: "Server Error", message: error.localizedDescription)
                    }
                    
                case .failure(let error):
                    
                    if let serverError = User.serverError(response: response) {
                        print(serverError.localizedDescription)
                        self.showError(title: "Server Error", message: serverError.localizedDescription)
                    } else {
                        print(error.localizedDescription)
                        self.showError(title: "Server Error", message: error.localizedDescription)
                    }
                }
                
            })
        } else {
            Alamofire.request(Router.getProductAttributes(type: attributeType)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print(value)
                    
                    if let JSON = value as? [[String:Any]] {
                        print("JSON: \(JSON)")
                        
                        var formValues = [ProductAttribute]()
                        
                        for value in JSON {
                            if let formValue = ProductAttribute.init(JSON: value) {
                                formValues.append(formValue)
                            }
                        }
                        
                        self.attributes = formValues
                        self.tableView.reloadData()
                        
                    } else {
                        print("response.result.value: \(value)")
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        print("Error: \(error.localizedDescription)")
                        self.showError(title: "Server Error", message: error.localizedDescription)
                    }
                    
                case .failure(let error):
                    
                    if let serverError = User.serverError(response: response) {
                        print(serverError.localizedDescription)
                        self.showError(title: "Server Error", message: serverError.localizedDescription)
                    } else {
                        print(error.localizedDescription)
                        self.showError(title: "Server Error", message: error.localizedDescription)
                    }
                }
                
            })
        }
        
        
        
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        var inputTextField: UITextField?
        
        let alertController = UIAlertController(title: "Brand name".localized, message: "Enter your the new brand name".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Add".localized, style: .default, handler: { (action) -> Void in
            print("Add Button Pressed, email : \(inputTextField?.text)")
            
            if let name = inputTextField?.text {
                if let attribute = ProductAttribute(JSON:["Id":0,"Name":name]) {
                    self.delegate?.productAttributesDidSelect(attributeType: self.attributeType, attribute: attribute)
                }
                self.navigationController?.popViewController()
            }
            
        })
        
        //sendAction.isEnabled = (loginTextField?.text?.isEmail)!
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            inputTextField = textField
            inputTextField?.keyboardType = .emailAddress
            inputTextField?.placeholder = "Brand name...".localized
        }
        present(alertController, animated: true, completion: nil)
        
        /*
        Alamofire.request(Router.addProductAttribute(named: "Top!")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            
            switch response.result {
                
            case .success(let value):
                
                print(value)
                
                if let JSON = value as? [[String:Any]] {
                    
                    /*
                    print("JSON: \(JSON)")
                    
                    var formValues = [ProductAttribute]()
                    
                    for value in JSON {
                        if let formValue = ProductAttribute.init(JSON: value) {
                            formValues.append(formValue)
                        }
                    }
                    
                    self.attributes = formValues
                    self.tableView.reloadData()
                    */
                    
                } else {
                    print("response.result.value: \(value)")
                    let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                    print("Error: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    print(serverError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
            }
            
        })
         */
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
        return attributes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell", for: indexPath)

        cell.textLabel?.text = attributes[indexPath.row].name
        
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

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.productAttributesDidSelect(attributeType: attributeType, attribute: attributes[indexPath.row])
        self.navigationController?.popViewController()
    }

}
