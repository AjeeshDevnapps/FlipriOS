//
//  ProductViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 09/03/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class ProductViewController: UITableViewController, UITextFieldDelegate, ProductAttributesViewControllerDelegate, ProductTypeTableViewControllerDelegate {
    
    var product:Product!
    
    
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var brandTitleLabel: UILabel!
    @IBOutlet weak var conditioningTitleLabel: UILabel!
    @IBOutlet weak var unitTitleLabel: UILabel!
    @IBOutlet weak var qunatityTitleLabel: UILabel!
    @IBOutlet weak var unitWeightTitleLabel: UILabel!
    @IBOutlet weak var multifunctionTitleLabel: UILabel!
    @IBOutlet weak var dissolutionTitleLabel: UILabel!
    @IBOutlet weak var stabilizationTitleLabel: UILabel!
    @IBOutlet weak var reducerTitleLabel: UILabel!
    @IBOutlet weak var doseUnitTitleLabel: UILabel!
    @IBOutlet weak var volumeTitleLabel: UILabel!
    @IBOutlet weak var VolumeSubtitleLabel: UILabel!
    @IBOutlet weak var addPHTitleLabel: UILabel!
    @IBOutlet weak var addDoseUnitTitleLabel: UILabel!
    @IBOutlet weak var placeTreatmentTitleLabel: UILabel!
    @IBOutlet weak var chocDoseTitleLabel: UILabel!
    @IBOutlet weak var startDoseTitleLabel: UILabel!
    
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var conditionningLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var pebbleWeightTextField: UITextField!
    @IBOutlet weak var applicationMethodLabel: UILabel!
    @IBOutlet weak var dosageUnitLabel: UILabel!
    @IBOutlet weak var referenceWaterVolumeForDosageTextField: UITextField!
    @IBOutlet weak var weeklyDosageTextField: UITextField!
    @IBOutlet weak var adjustmentTextField: UITextField!
    @IBOutlet weak var chockDosageTextField: UITextField!
    @IBOutlet weak var initialDosageTextField: UITextField!
    @IBOutlet weak var isStabilizedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var isMultiFunctionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var isSlowDissolutionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var isReducerSegmentedControl: UISegmentedControl!
    
    var warningAlreadyShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bakcgroundFileName = "BG"
        
        self.title = "New product".localized
        
        if let module = Module.currentModule {
            if module.isForSpa {
                bakcgroundFileName = "BG_spa"
            }
        }
        
        let imvTableBackground = UIImageView.init(image: UIImage(named: bakcgroundFileName))
        imvTableBackground.frame = self.tableView.frame
        self.tableView.backgroundView = imvTableBackground
        
        let cancelButon = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonAction))
        self.navigationItem.leftBarButtonItem = cancelButon
        
        typeTitleLabel.text = "Type".localized
        nameTitleLabel.text = "Name".localized
        nameTextField.placeholder = "Product name...".localized
        brandTitleLabel.text = "Brand".localized
        conditioningTitleLabel.text = "Product form".localized
        unitTitleLabel.text = "Unit of measure".localized
        qunatityTitleLabel.text = "Total quantity".localized
        unitWeightTitleLabel.text = "Unit weight (g)".localized
        multifunctionTitleLabel.text = "Multifunction".localized
        dissolutionTitleLabel.text = "Dissolution".localized
        stabilizationTitleLabel.text = "Stabilizing".localized
        reducerTitleLabel.text = "Action".localized
        doseUnitTitleLabel.text = "Unit of dosage".localized
        volumeTitleLabel.text = "For a volume of water (m3):".localized
        VolumeSubtitleLabel.text = "Example: \"For 25m3 of water, add 1 roll.\" Enter 25 in the field opposite.".localized
        addPHTitleLabel.text = "To increase the ph of:".localized
        addDoseUnitTitleLabel.text = "Insert (unit of dosage)".localized
        placeTreatmentTitleLabel.text = "Application method".localized
        chocDoseTitleLabel.text = "Insert (unit of dosage)".localized
        startDoseTitleLabel.text = "Insert (unit of dosage)".localized
        
        isMultiFunctionSegmentedControl.setTitle("No".localized, forSegmentAt: 0)
        isMultiFunctionSegmentedControl.setTitle("Yes".localized, forSegmentAt: 1)
        
        isSlowDissolutionSegmentedControl.setTitle("Fast".localized, forSegmentAt: 0)
        isSlowDissolutionSegmentedControl.setTitle("Slow".localized, forSegmentAt: 1)
        
        isStabilizedSegmentedControl.setTitle("No".localized, forSegmentAt: 0)
        isStabilizedSegmentedControl.setTitle("Yes".localized, forSegmentAt: 1)
        
        isReducerSegmentedControl.setTitle("Not applicable".localized, forSegmentAt: 0)
        isReducerSegmentedControl.setTitle("Reduce".localized, forSegmentAt: 1)
        isReducerSegmentedControl.setTitle("Reinforce".localized, forSegmentAt: 2)
        
        if product.id != nil {
            fillForm()
        }
    }
    
    func fillForm() {
        
        typeLabel.text = product.productType.name
        
        nameTextField.text = product.name
        brandLabel.text = product.brand?.name
        
        quantityTextField.text = String(product.quantity)
        pebbleWeightTextField.text = String(product.pebleWeight)
        referenceWaterVolumeForDosageTextField.text = String(product.referenceWaterVolumeForDosage)
        applicationMethodLabel.text = product.applicationMethod?.name
            
        conditionningLabel.text = product.conditioning?.name
        unitLabel.text = product.conditioningUnit?.name
        dosageUnitLabel.text = product.doseUnit?.name
        
        weeklyDosageTextField.text = String(product.weeklyDosage)
        adjustmentTextField.text = String(product.adjustment)
        chockDosageTextField.text = String(product.chocDosage)
        initialDosageTextField.text = String(product.initialDosage)
        
        
        if(product.isStabilized) {
            isStabilizedSegmentedControl.selectedSegmentIndex = 1
        } else {
            isStabilizedSegmentedControl.selectedSegmentIndex = 0
        }
        
        if(product.isMultiFunction) {
            isMultiFunctionSegmentedControl.selectedSegmentIndex = 1
        } else {
            isMultiFunctionSegmentedControl.selectedSegmentIndex = 0
        }
        
        if(product.isSlowDissolution) {
            isSlowDissolutionSegmentedControl.selectedSegmentIndex = 1
        } else {
            isSlowDissolutionSegmentedControl.selectedSegmentIndex = 0
        }
        
        if product.isReducerApplicable {
            if(product.isReducer) {
                isReducerSegmentedControl.selectedSegmentIndex = 2
            } else {
                isReducerSegmentedControl.selectedSegmentIndex = 1
            }
        } else {
            isReducerSegmentedControl.selectedSegmentIndex = 0
        }
        
        
    }
    
    func productTypeDidSelect(productType: ProductType) {
        product.productType = productType
        tableView.reloadData()
        fillForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if product.id != nil && !warningAlreadyShown {
            
            let alertController = UIAlertController(title: nil, message: "Check the information below, and change it if necessary. All is well ? Click on \"Save\"!".localized, preferredStyle: UIAlertController.Style.alert)
            
            let okAction =  UIAlertAction(title: "I understood".localized, style: UIAlertAction.Style.cancel)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            warningAlreadyShown = true
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if self.nameTextField.text!.count > 0 {
            product.name = self.nameTextField.text
        } else {
            showError(title: "Error".localized, message: "Name".localized + " is mandatory".localized)
            return
        }
        
        
        if self.quantityTextField.text!.count > 0 {
            product.quantity = self.quantityTextField.text!.doubleValue
        } else {
            showError(title: "Error".localized, message: "Total quantity".localized + " is mandatory".localized)
            return
        }
        if self.pebbleWeightTextField.text!.count > 0 {
            product.pebleWeight = self.pebbleWeightTextField.text!.doubleValue
        } else {
            if let conditioning = product.conditioning {
                if conditioning.id == 2 || conditioning.id == 7 {
                    showError(title: "Error".localized, message: "Unit weight (g)".localized + " is mandatory".localized)
                    return
                }
            }
        }
        if self.referenceWaterVolumeForDosageTextField.text!.count > 0 {
            product.referenceWaterVolumeForDosage = self.referenceWaterVolumeForDosageTextField.text!.doubleValue
        } else {
            showError(title: "Error".localized, message: "For Volume of water (m3)".localized + " is mandatory".localized)
            return
        }
        
        if product.productType.hasChockDosage && product.productType.hasInitialDosage {
            
            
            if self.chockDosageTextField.text!.count > 0 {
                product.chocDosage = self.chockDosageTextField.text!.doubleValue
                product.initialDosage = self.initialDosageTextField.text!.doubleValue
                product.weeklyDosage = self.weeklyDosageTextField.text!.doubleValue
            } else {
                if self.initialDosageTextField.text!.count > 0 {
                    product.initialDosage = self.initialDosageTextField.text!.doubleValue
                } else {
                    if self.weeklyDosageTextField.text!.count > 0 {
                        product.weeklyDosage = self.weeklyDosageTextField.text!.doubleValue
                    } else {
                        showError(title: "Error".localized, message: "You must provide at least a normal, chock or an initial dosage.".localized)
                        return
                    }
                }
            }
        } else if product.productType.hasChockDosage {
            if self.chockDosageTextField.text!.count > 0 {
                product.chocDosage = self.chockDosageTextField.text!.doubleValue
            } else {
                showError(title: "Error".localized, message: "Chock dosage".localized + " is mandatory".localized)
                return
            }
        } else if product.productType.hasInitialDosage {
            if self.initialDosageTextField.text!.count > 0 {
                product.initialDosage = self.initialDosageTextField.text!.doubleValue
            } else {
                showError(title: "Error".localized, message: "Initial dosage".localized + " is mandatory".localized)
                return
            }
        } else {
            if self.weeklyDosageTextField.text!.count > 0 {
                product.weeklyDosage = self.weeklyDosageTextField.text!.doubleValue
            } else {
                showError(title: "Error".localized, message: "Dosage for reference volume of water".localized + " is mandatory".localized)
                return
            }
        }
        
        if product.productType.hasAdjustment {
            if self.adjustmentTextField.text!.count > 0 {
                product.adjustment = self.adjustmentTextField.text!.doubleValue
            } else {
                product.adjustment = 0.0
                //showError(title: "Wrong format", message: "adjustment")
                //return
            }
        }
        if (isStabilizedSegmentedControl.selectedSegmentIndex > 0) {
            product.isStabilized = true
        } else {
            product.isStabilized = false
        }
        
        if (isMultiFunctionSegmentedControl.selectedSegmentIndex > 0) {
            product.isMultiFunction = true
        } else {
            product.isMultiFunction = false
        }
        
        if (isSlowDissolutionSegmentedControl.selectedSegmentIndex > 0) {
            product.isSlowDissolution = true
        } else {
            product.isSlowDissolution = false
        }
        if (isReducerSegmentedControl.selectedSegmentIndex == 0) {
            product.isReducerApplicable = false
        } else if isReducerSegmentedControl.selectedSegmentIndex == 1 {
            product.isReducer = true
        } else {
            product.isReducer = false
        }
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        
        if product.id == nil {
            Alamofire.request(Router.addProduct(product: self.product)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("add product success: \(value)")
                    
                    //self.newProduct = Product(EAN: EAN, type: productType, name: nil, brandName: nil)
                    
                    //self.showQuantityAlert()
                    
                    if let JSON = value as? [String:Any] {
                        if let newProduct = Product(withJSON: JSON) {
                            hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud?.dismiss(afterDelay: 1)
                            NotificationCenter.default.post(name: FliprLogDidChanged, object: nil)
                            self.dismiss(animated: true, completion: {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidAddProduct"), object: nil, userInfo: ["product": newProduct])
                            })
                        }
                    }
                    
                    
                    
                case .failure(let error):
                    
                    print("add product error: \(error)")
                    
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
        } else {
            Alamofire.request(Router.updateProduct(product: self.product)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("update product success: \(value)")
                    
                    //self.newProduct = Product(EAN: EAN, type: productType, name: nil, brandName: nil)
                    
                    //self.showQuantityAlert()
                    
                    if let JSON = value as? [String:Any] {
                        if let newProduct = Product(withJSON: JSON) {
                            hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud?.dismiss(afterDelay: 1)
                            
                            self.dismiss(animated: true, completion: {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidAddProduct"), object: nil, userInfo: ["product": newProduct])
                            })
                        }
                    }
                    
                case .failure(let error):
                    
                    print("add product error: \(error)")
                    
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
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 178, green: 184, blue: 200)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !product.productType.hasChockDosage && section == 4 { return nil }
        if !product.productType.hasInitialDosage && section == 5 { return nil }
        
        if section == 0 { return "Your product".localized}
        if section == 1 { return "Product details".localized}
        if section == 3 { return "Normal dosage".localized}
        if section == 4 { return "Chock dosage".localized}
        if section == 5 { return "Initial dosage".localized}
        
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            if product.id == nil {
                return 0
            }
        }
        
        if (indexPath.section == 1 && indexPath.row == 3) {
            if let conditioning = product.conditioning {
                if conditioning.id == 2 || conditioning.id == 7 {
                    return super.tableView(tableView, heightForRowAt: indexPath)
                }
            }
            return 0
        }
        
        if !product.productType.canBeMultifunction && indexPath.section == 2 && indexPath.row == 0 { return 0 }
        if !product.productType.hasDifferentDissolutionSpeeds && indexPath.section == 2 && indexPath.row == 1 { return 0 }
        if !product.productType.canBeStabilized && indexPath.section == 2 && indexPath.row == 2 { return 0 }
        if !product.productType.canIncrementOrDecrementMeasure && indexPath.section == 2 && indexPath.row == 3 { return 0 }
        if !product.productType.hasAdjustment && indexPath.section == 3 && indexPath.row == 2 { return 0 }
        
        if !product.productType.hasChockDosage && indexPath.section == 4 { return 0 }
        if !product.productType.hasInitialDosage && indexPath.section == 5 { return 0 }
   
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            
            Alamofire.request(Router.getProductTypes).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("Get product types response.result.value: \(value)")
                    
                    if let productTypes = value as? [[String:Any]] {
                        var types = [ProductType]()
                        for JSON in productTypes {
                            if let productType = ProductType(JSON: JSON) {
                                types.append(productType)
                            }
                        }
                        
                        if let navController = self.storyboard?.instantiateViewController(withIdentifier: "ProductTypeNavigationControllerID") as? UINavigationController {
                            if let controller = navController.viewControllers.first as? ProductTypeTableViewController {
                                controller.productTypes = types
                                controller.EAN = self.product.EAN
                                controller.isUpdate = true
                                controller.delegate = self
                                self.navigationController?.pushViewController(controller)
                            }
                        }
                        
                    } else {
                        self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                    }
                    
                case .failure(let error):
                    
                    print("Get product types did fail with error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        self.showError(title: "Error".localized, message: serverError.localizedDescription)
                    } else {
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                }
                
                hud?.dismiss()
                
            })
        }
    }

    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == ProductAttributeType.conditioningUnit.rawValue || identifier == ProductAttributeType.doseUnit.rawValue) {
            if product.conditioning == nil {
                self.showError(title: "Error".localized, message: "Please select the product conditioning first.".localized)
                return false
            }
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? ProductAttributesViewController, let identifier = segue.identifier {
            if let conditioning = product.conditioning {
                controller.conditioning = conditioning
            }
            controller.product = self.product
            controller.attributeType = ProductAttributeType(rawValue: identifier)
            controller.delegate = self
        }
    }
    
    func productAttributesDidSelect(attributeType: ProductAttributeType, attribute: ProductAttribute) {
        if attributeType == .brand {
            product.brand = attribute
            brandLabel.text = attribute.name
        } else if attributeType == .conditioning {
            product.conditioning = attribute
            conditionningLabel.text = attribute.name
            product.doseUnit = nil
            dosageUnitLabel.text = ""
            product.conditioningUnit = nil
            unitLabel.text = ""
            tableView.reloadData()
        } else if attributeType == .conditioningUnit {
            product.conditioningUnit = attribute
            unitLabel.text = attribute.name
        } else if attributeType == .doseUnit {
            product.doseUnit = attribute
            dosageUnitLabel.text = attribute.name
        } else if attributeType == .applicationMethod {
            product.applicationMethod = attribute
            applicationMethodLabel.text = attribute.name
        }
    }
    
}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
