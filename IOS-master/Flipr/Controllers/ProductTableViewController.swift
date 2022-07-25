//
//  ProductTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 20/06/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import BarcodeScanner
import Alamofire
import JGProgressHUD
import AVKit

protocol ProductTableViewControllerDelegate {
    func productTableViewControllerDidSelect(product:Product)
}

class ProductTableViewController: UITableViewController, ProductTypeTableViewControllerDelegate {
    
    var delegate:ProductTableViewControllerDelegate?
    
    var stocks = [Stock]()
    
    var EAN:Int64?
    let barcodeScannerController = BarcodeScannerViewController()
    var newProduct:Product?
    var slider = UISlider()
    var stopScan = false
    
    var selection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My stock".localized
        
        if selection {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
        
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
        
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDidAddProduct(_:)), name: NSNotification.Name(rawValue: "UserDidAddProduct"), object: nil)
    }
    
    func refresh() {
        
        if let poolId = Pool.currentPool?.id {
            
            Alamofire.request(Router.getStock(poolId: poolId)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                self.view.hideStateView()
                
                if response.response?.statusCode == 401 {
                    NotificationCenter.default.post(name: K.Notifications.SessionExpired, object: nil)
                }
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("get stock response.result.value: \(value)")
                    
                    self.stocks.removeAll()
                    
                    if let stocks = value as? [[String:Any]] {
                        
                        for JSON in stocks {
                            if let stock = Stock(withJSON: JSON) {
                                self.stocks.append(stock)
                            }
                        }
                        
                        if self.stocks.count > 0 {
                            self.view.hideStateView()
                            
                            UserDefaults.standard.set(true, forKey: "StockProductCount")
    
                        } else {
                            
                            UserDefaults.standard.removeObject(forKey: "StockProductCount")
                            
                            let darkTheme = EmptyStateViewTheme.shared
                            darkTheme.titleColor = K.Color.DarkBlue
                            darkTheme.messageColor = .lightGray
                            self.view.showEmptyStateView(image: UIImage(named:"barcode"), title: "No product".localized, message: "Scan the barcodes of your products and enter the remaining quantity to add them to your stock.".localized, buttonTitle: "Add product".localized, buttonAction: {
                                self.addButtonAction(self)
                            }, theme: darkTheme)
                            
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

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        self.addProduct()

    }
    
    func addProduct(){
        if TARGET_OS_SIMULATOR != 0 {
            
            enterEANButtonAction()
            
            
        } else {
            barcodeScannerController.codeDelegate = self
            barcodeScannerController.errorDelegate = self
            barcodeScannerController.dismissalDelegate = self
            
            // Strings
            barcodeScannerController.headerViewController.titleLabel.text = "New product".localized
            barcodeScannerController.headerViewController.closeButton.setTitle("Cancel".localized, for: .normal)
            barcodeScannerController.cameraViewController.settingsButton.setTitle("Settings".localized, for: .normal)
            barcodeScannerController.messageViewController.textLabel.text = "Place the product barcode in the center. The search will start automatically.".localized
            
            /*
            BarcodeScanner.Info.loadingText = "Product search...".localized
            BarcodeScanner.Info.notFoundText = "Product not referenced".localized
            BarcodeScanner.Info.settingsText = "To be able to scan barcodes you must allow access to the camera in your settings.".localized
            */
            
            // Colors
            barcodeScannerController.headerViewController.titleLabel.textColor = K.Color.DarkBlue
            barcodeScannerController.headerViewController.closeButton.setTitleColor(K.Color.DarkBlue, for: .normal)
            barcodeScannerController.cameraViewController.settingsButton.setTitleColor(UIColor.white, for: .normal)
            
            /*
            BarcodeScanner.Info.textColor = K.Color.DarkBlue
            BarcodeScanner.Info.tint = K.Color.DarkBlue
            BarcodeScanner.Info.loadingTint = K.Color.DarkBlue
            BarcodeScanner.Info.notFoundTint = K.Color.Red
            */
            
            barcodeScannerController.messageViewController.regularTintColor = K.Color.DarkBlue
            barcodeScannerController.messageViewController.errorTintColor = K.Color.Red
            barcodeScannerController.messageViewController.textLabel.textColor = K.Color.DarkBlue
            
            present(barcodeScannerController, animated: true, completion: {
                self.view.hideStateView()
                let button = UIButton(frame: CGRect(x: 0, y: self.barcodeScannerController.view.bounds.height - 120, width: self.barcodeScannerController.view.bounds.width, height: 44))
                button.setTitle("Enter manually".localized, for: .normal)
                self.barcodeScannerController.view.addSubview(button)
                button.backgroundColor = .clear
                button.tintColor = .white
                button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            })
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        self.barcodeScannerController.reset()
        self.barcodeScannerController.dismiss(animated: true, completion: {
            self.enterEANButtonAction()
        })
    }
    
    func enterEANButtonAction() {
        
        var loginTextField: UITextField?
        
        let alertController = UIAlertController(title:"Barcode".localized, message: "Enter the barcode number".localized, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Ok".localized, style: .default, handler: { (action) -> Void in
            
            if let code = loginTextField?.text {
                self.EAN = Int64(code)
                print("Product EAN Int: \(self.EAN)")
                self.getProduct(fromScan: false)
            }
            
        })
        
        //sendAction.isEnabled = (loginTextField?.text?.isEmail)!
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            loginTextField = textField
            loginTextField?.keyboardType = .numberPad
            loginTextField?.placeholder = "EAN 13...".localized
        }
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 { return 0}
        return stocks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockSubscriptionCell", for: indexPath)
            if let label = cell.viewWithTag(1) as? UILabel {
                label.text = "Get Flipr Infinite".localized
            }
            if let label = cell.viewWithTag(2) as? UILabel {
                label.text = "Simplify product management".localized
            }
            return cell
        }
        
        var identifier = "StockCell"
        if selection {
            identifier = "StockSelectionCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! StockTableViewCell

        cell.stock = stocks[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateInitialViewController() {
                self.present(vc, animated: true, completion: nil)
            }
        } else if let delegate = delegate {
            delegate.productTableViewControllerDidSelect(product: stocks[indexPath.row].product)
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let module = Module.currentModule {
                if module.isSubscriptionValid {
                    return 0
                }
            }
            return 120
        }
        return 166
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func getProductFromScan() {
        getProduct(fromScan: true)
    }
    
    @objc func getProduct(fromScan:Bool) {
        
        stopScan = false
        
        if !fromScan {
            if let EAN = EAN {
                Alamofire.request(Router.getProduct(EAN: EAN)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        print("Get product response.result.value: \(value)")
                        
                        if let products = value as? [[String:Any]] {
                            
                            if products.count > 0 {
                                if let product = Product.init(withJSON: products.first!) {
                                    if product.isValidated {
                                        self.newProduct = product
                                        self.showQuantityAlert()
                                    } else {
                                        //On présente le formulaire prérempli pour éventuelle modification
                                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewControllerID") as? ProductViewController {
                                            vc.product = product
                                            let navC = UINavigationController(rootViewController: vc)
                                            self.present(navC, animated: true, completion: nil)
                                        }
                                    }
                                } else {
                                    self.showError(title: "Server Response Error", message: "Product could not be serialized")
                                }
                                
                            } else {
                            
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
                                                    controller.EAN = EAN
                                                    controller.delegate = self
                                                    self.present(navController, animated: true, completion: nil)
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
                                    
                                })
                                
                            }
                            
                            
                        } else {
                            self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                        }
                        
                        
                        
                    case .failure(let error):
                        
                        print("Get product did fail with error: \(error)")
                        
                        if let serverError = User.serverError(response: response) {
                            self.showError(title: "Error".localized, message: serverError.localizedDescription)
                        } else {
                            self.showError(title: "Error".localized, message: error.localizedDescription)
                        }
                    }
                })
            } else {
                self.showError(title: "Error".localized, message: "Invalid barcode".localized)
            }
        } else {
            if let EAN = EAN {
                Alamofire.request(Router.getProduct(EAN: EAN)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        print("Get product response.result.value: \(value)")
                        
                        if let products = value as? [[String:Any]] {
                            
                            if products.count > 0 {
                                
                                if let product = Product.init(withJSON: products.first!) {
                                    if product.isValidated {
                                        self.newProduct = product
                                        self.barcodeScannerController.reset()
                                        self.barcodeScannerController.dismiss(animated: true, completion: {
                                            self.showQuantityAlert()
                                        })
                                    } else {
                                        self.barcodeScannerController.reset()
                                        self.barcodeScannerController.dismiss(animated: true, completion: {
                                            //On présente le formulaire prérempli pour éventuelle modification
                                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewControllerID") as? ProductViewController {
                                                vc.product = product
                                                let navC = UINavigationController(rootViewController: vc)
                                                self.present(navC, animated: true, completion: nil)
                                            }
                                        })
                                    }
                                } else {
                                    self.showError(title: "Server Response Error", message: "Product could not be serialized")
                                }
                                
                            } else {
                                
                                
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
                                            self.barcodeScannerController.reset()
                                            self.barcodeScannerController.dismiss(animated: true, completion: {
                                                if let navController = self.storyboard?.instantiateViewController(withIdentifier: "ProductTypeNavigationControllerID") as? UINavigationController {
                                                    if let controller = navController.viewControllers.first as? ProductTypeTableViewController {
                                                        controller.EAN = EAN
                                                        controller.productTypes = types
                                                        controller.delegate = self
                                                        self.present(navController, animated: true, completion: nil)
                                                    }
                                                }
                                            })
                                            
                                        } else {
                                            self.barcodeScannerController.resetWithError(message: "Oups, we're sorry but something went wrong :/".localized)
                                        }
                                        
                                    case .failure(let error):
                                        
                                        print("Get product types did fail with error: \(error)")
                                        
                                        if let serverError = User.serverError(response: response) {
                                            self.barcodeScannerController.resetWithError(message: serverError.localizedDescription)
                                        } else {
                                            self.barcodeScannerController.resetWithError(message: error.localizedDescription)
                                        }
                                    }
                                    
                                })
                                
                            }
                            
                            
                        } else {
                            self.barcodeScannerController.resetWithError(message: "Oups, we're sorry but something went wrong :/".localized)
                        }
                        
                        
                        
                    case .failure(let error):
                        
                        print("Get product did fail with error: \(error)")
                        
                        if let serverError = User.serverError(response: response) {
                            self.barcodeScannerController.resetWithError(message: serverError.localizedDescription)
                        } else {
                            self.barcodeScannerController.resetWithError(message: error.localizedDescription)
                        }
                    }
                })
            } else {
                self.barcodeScannerController.resetWithError(message: "Invalid barcode".localized)
            }
        }
        
    }
    
    func productTypeDidSelect(productType: ProductType) {
        print("Oh yeah")
        
        if let EAN = EAN {
            
            // On ne créer plus le produit maintenant, on passe au formulaire...
            /*
            print("create Product: \(EAN) - type: \(productType.name)")
            Alamofire.request(Router.addProduct(EAN: EAN, type: productType)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("add product success: \(value)")
                    
                    self.newProduct = Product(EAN: EAN, type: productType, name: nil, brandName: nil)
                    
                    self.showQuantityAlert()
                    
                case .failure(let error):
                    
                    if let serverError = User.serverError(response: response) {
                        self.showError(title: "Error".localized, message: serverError.localizedDescription)
                    } else {
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                }
                
            })
            */
        }
    }
    
    @objc func userDidAddProduct(_ notification: NSNotification) {
        
        if let product = notification.userInfo?["product"] as? Product {
            self.newProduct = product
            showQuantityAlert()
        }
    }
    
    func showQuantityAlert() {
        let alertController = UIAlertController(title: "How much product is left in the packaging?".localized, message: "Indicate approximately the amount of remaining product to be used.".localized + "\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Validate".localized, style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            
            
            let value = self.slider.value
            
            if let poolId = Pool.currentPool?.id {
                
                let hud = JGProgressHUD(style:.dark)
//                hud?.show(in: self.navigationController!.view)
                hud?.show(in: self.view)

                if let newProduct = self.newProduct {
                    
                    print("Add stock with poolID: \(poolId), EAN: \(newProduct.EAN), quantity \(value)")
                    
                    Alamofire.request(Router.addStock(poolId: poolId, product: newProduct, quantity: Double(value))).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                        
                        switch response.result {
                            
                        case .success(let value):
                            
                            print("Add stock response.result.value: \(value)")
                            
                            hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud?.dismiss(afterDelay: 1)
                            
                            self.refresh()
                            
                        case .failure(let error):
                            
                            print("Add stock did fail with error: \(error)")
                            
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
                
            } else {
                self.showError(title: "Error".localized, message: "Please first fill in the data for your pool".localized)
            }
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true) {
            self.slider = UISlider(frame: CGRect(x: 10, y: 120, width: 250, height: 33))
            self.slider.setValue(0.5)
            alertController.view.addSubview(self.slider)
        }
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        
        if let button = sender as? StockButton, let poolId = Pool.currentPool?.id {
            
            let alertController = UIAlertController(title: "Product removal".localized, message: "Are you sure you want to delete this product from your inventory?".localized, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
            {
                (result : UIAlertAction) -> Void in
                
            }
            
            let okAction = UIAlertAction(title: "Delete".localized, style: UIAlertAction.Style.destructive)
            {
                (result : UIAlertAction) -> Void in
                
                let hud = JGProgressHUD(style:.dark)
//                hud?.show(in: self.navigationController!.view)
                hud?.show(in: self.view)

                print("Delete stock with poolID: \(poolId), stock id: \(button.stock!.id)")
                
                Alamofire.request(Router.deleteStock(poolId: poolId, stockId: button.stock!.id)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        print("Delete stock response.result.value: \(value)")
                        
                        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud?.dismiss(afterDelay: 1)
                        
                        self.refresh()
                        
                    case .failure(let error):
                        
                        print("Delete stock did fail with error: \(error)")
                        
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
    
    @IBAction func editButtonAction(_ sender: Any) {
        
        if let button = sender as? StockButton {
            let alertController = UIAlertController(title: "How much product is left in the packaging?".localized, message: "Indicate approximately the amount of remaining product to be used.".localized + "\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
            {
                (result : UIAlertAction) -> Void in
                
            }
            
            let okAction = UIAlertAction(title: "valider", style: UIAlertAction.Style.default)
            {
                (result : UIAlertAction) -> Void in
                
                
                let value = self.slider.value
                
                if let poolId = Pool.currentPool?.id {
                    
                    let hud = JGProgressHUD(style:.dark)
//                    hud?.show(in: self.navigationController!.view)
                    hud?.show(in: self.view)

                        
                        print("Update stock with poolID: \(poolId), quantity \(value)")
                        
                        Alamofire.request(Router.updateStock(poolId: poolId, stockId: button.stock!.id, quantity: Double(value))).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                            
                            switch response.result {
                                
                            case .success(let value):
                                
                                print("Update stock response.result.value: \(value)")
                                
                                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                                hud?.dismiss(afterDelay: 1)
                                
                                self.refresh()
                                
                            case .failure(let error):
                                
                                print("Update stock did fail with error: \(error)")
                                
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
                    self.showError(title: "Error".localized, message: "Please first fill in the data for your pool".localized)
                }
                
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true) {
                self.slider = UISlider(frame: CGRect(x: 10, y: 120, width: 250, height: 33))
                self.slider.setValue(Float(button.stock!.percentageLeft))
                alertController.view.addSubview(self.slider)
            }
        
        }
        
    }
    
}

extension ProductTableViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        EAN = Int64(code)
        if !stopScan {
            print("Product EAN Int: \(EAN)")
            self.perform(#selector(self.getProductFromScan), with: nil, afterDelay: 2)
        }
        stopScan = true
        controller.reset()
    }
    
    /*
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("Product EAN: \(code)")
        EAN = Int64(code)
        print("Product EAN Int: \(EAN)")
        self.perform(#selector(self.getProduct), with: nil, afterDelay: 2)
        
    }
    */
    
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.reset()
        controller.dismiss(animated: true, completion: nil)
    }
}
