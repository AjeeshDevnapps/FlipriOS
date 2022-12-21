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
    
    var value:FormValue!
    
    var completionBlock:(_: (_ value:FormValue) -> Void)?
    
    func completion(block: @escaping (_ value:FormValue) -> Void) {
        completionBlock = block
    }
    var nextButton:UIButton!
    
    var order = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppSharedData.sharedInstance.isAddPlaceFlow{
//            self.navigationItem.setHidesBackButton(true, animated: true)
            let bkView = UIView.init(frame: CGRect(x:0,y:0,width:self.view.frame.size.width,height:100))
            bkView.backgroundColor = .clear
            nextButton = UIButton.init(frame:CGRect(x:20,y:25,width:bkView.frame.size.width - 40,height:50))
            nextButton.setTitle("Suivant".localized, for: .normal)
            nextButton.backgroundColor = .black
            nextButton.titleLabel?.textColor = .white
            nextButton.roundCorner(corner: 12)
            nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
            bkView.addSubview(nextButton)
            tableView.tableFooterView = bkView
            nextButton.isHidden = true
        }
        
        
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
                        let range = NSMakeRange(0, self.tableView.numberOfSections)
                        let sections = NSIndexSet(indexesIn: range)
                        self.tableView.reloadSections(sections as IndexSet, with: .bottom)
                        if AppSharedData.sharedInstance.isAddPlaceFlow{
                            self.nextButton.isHidden = false
                        }
                        
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
        
//        if apiPath == "modes" {
//            cell.accessoryType = .none
////            cell.accessoryType = .detailButton
//        } else
        if let selectedValue = selectedValue {
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
        value = self.values[indexPath.row]
        if AppSharedData.sharedInstance.isAddPlaceFlow{
            self.showNextScreen()
        }else{
            completionBlock?(value)
            navigationController?.popViewController()
        }
    }
    
    @objc func nextButtonPressed(){
        showNextScreen()
    }
    
    
    func showNextScreen(){
        switch order{
            case 0:
            AppSharedData.sharedInstance.addPlaceInfo.shape = value
            self.showCoatingView()
            break;
            case 1:
            AppSharedData.sharedInstance.addPlaceInfo.coating = value
            self.showIntegrationView()
            case 2:
            AppSharedData.sharedInstance.addPlaceInfo.integration = value
            showTreatmentView()
            case 3:
            AppSharedData.sharedInstance.addPlaceInfo.treatment = value
            showFiltrationView()
            case 4:
            AppSharedData.sharedInstance.addPlaceInfo.filtration = value
            showNoOfUsers()
            case 5:
            AppSharedData.sharedInstance.addPlaceInfo.mode = value
            showEditPlaceView()
            break;
            
            default : break;
        }
    }
    
    
    func showEditPlaceView(){
        let sb = UIStoryboard(name: "NewPool", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "NewPoolViewControllerSettings") as? NewPoolViewController {
            viewController.placeTitle = AppSharedData.sharedInstance.addPlaceName
            self.navigationController?.pushViewController(viewController, completion: nil)
//            let nav = UINavigationController.init(rootViewController: viewController)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
    func showCoatingView(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as? ValuePickerController {
            viewController.order = 1
            viewController.apiPath = "coatings"
            viewController.title = "Type of coating".localized
            viewController.completion(block: { (formValue) in

            })
            navigationController?.pushViewController(viewController)
        }
    }
    
    
    func showIntegrationView(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as? ValuePickerController {
            viewController.order = 2
            viewController.apiPath = "integration"
            viewController.title = "Integration".localized
            viewController.completion(block: { (formValue) in
           })
            navigationController?.pushViewController(viewController)
        }
    }
    
    
    func showTreatmentView(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as? ValuePickerController {
            viewController.order = 3
            viewController.apiPath = "treatment"
            viewController.title = "Treatement".localized
            viewController.completion(block: { (formValue) in
            })
            navigationController?.pushViewController(viewController)
        }
    }
    
    
    func showFiltrationView(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: "ValuePickerController") as? ValuePickerController {
            viewController.order = 4
            viewController.apiPath = "filtrations"
            viewController.title = "Filtration".localized
            viewController.completion(block: { (formValue) in
             })
            navigationController?.pushViewController(viewController)
        }
    }
    
    
    func showNoOfUsers(){
        let sb = UIStoryboard(name: "NewPool", bundle: nil)
        let listVC = sb.instantiateViewController(withIdentifier: "WatrInputViewController") as! WatrInputViewController
        listVC.order = 1
        listVC.title = "Nombre d’utilisateurs".localized
        navigationController?.pushViewController(listVC, animated: true)
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
