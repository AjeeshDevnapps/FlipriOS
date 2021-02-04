//
//  ValuePickerController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 02/05/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import Alamofire

class FormValue {
    var id:Int
    var label:String
    
    init(id: Int, label:String) {
        self.id = id
        self.label = label
    }
    
    convenience init?(withJSON JSON:[String:Any]) {
        guard let id = JSON["Id"] as? Int, let name = JSON["Name"] as? String else {
            return nil
        }
        self.init(id: id, label:name)
    }
    
    var serialized: [String : Any] {
        let JSON : [String:Any] = ["Id":id,"Name":label]
        return JSON
    }
}

class ValuePickerController: UITableViewController {
    
    var apiPath:String?
    var values = [FormValue]()
    var selectedValue:FormValue?
    
    var completionBlock:(_: (_ value:FormValue) -> Void)?
    
    func completion(block: @escaping (_ value:FormValue) -> Void) {
        completionBlock = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = self.apiPath {
            
            Alamofire.request(Router.getFormValues(apiPath: path)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print(value)
                    
                    if let JSON = value as? [[String:Any]] {
                        print("JSON: \(JSON)")
                        
                        var formValues = [FormValue]()
                        
                        for value in JSON {
                            if let formValue = FormValue.init(withJSON: value) {
                                formValues.append(formValue)
                            }
                        }
                        
                        self.values = formValues
                        self.tableView.reloadData()
                        
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
        }
    }

    func detailTextWith(id: Int) -> String {
        var text = ""
        if apiPath == "modes" {
            switch id {
            case 0:
                text = "ACTIVE_MODE_DETAIL".localized
            case 1:
                text = "ACTIVE_WINTERING_MODE_DETAIL".localized
            case 2:
                text = "PASSIVE_WINTERING_MODE_DETAIL".localized
            default:
                text = ""
            }
        }
        return text
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
        return values.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ValueCell", for: indexPath)

        let value = self.values[indexPath.row]
        cell.textLabel?.text = value.label
        
        if apiPath == "modes" {
            cell.accessoryType = .detailButton
        } else if let selectedValue = selectedValue {
            if value.id == selectedValue.id {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.accessoryType = .none
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = self.values[indexPath.row]
        completionBlock?(value)
        navigationController?.popViewController()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let value = self.values[indexPath.row]
        let alertController = UIAlertController(title: value.label, message: detailTextWith(id: value.id) , preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Ok".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

}
