//
//  PoolViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 05/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD

class PoolViewController: UITableViewController {
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var isPublicSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberOfPlacesTextField: UITextField!
    @IBOutlet weak var numberOfUsersTextField: UITextField!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var tresholdTextField: UITextField!
    
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var spaKindLabel: UILabel!
    @IBOutlet weak var yearContructionLabel: UILabel!
    @IBOutlet weak var shapeLabel: UILabel!
    @IBOutlet weak var coatingLabel: UILabel!
    @IBOutlet weak var integrationLabel: UILabel!
    @IBOutlet weak var treatmentLabel: UILabel!
    @IBOutlet weak var filtrationLabel: UILabel!
    
    @IBOutlet weak var modeTitleLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var situationTitleLabel: UILabel!
    @IBOutlet weak var spaKindTitleLabel: UILabel!
    @IBOutlet weak var numbersOfPlacesTitleLabel: UILabel!
    @IBOutlet weak var numbersOfUsersTitleLabel: UILabel!
    @IBOutlet weak var yearContructionTitleLabel: UILabel!
    @IBOutlet weak var volumeTitleLabel: UILabel!
    @IBOutlet weak var shapeTitleLabel: UILabel!
    @IBOutlet weak var coatingTitleLabel: UILabel!
    @IBOutlet weak var integrationTitleLabel: UILabel!
    @IBOutlet weak var treatmentTitleLabel: UILabel!
    @IBOutlet weak var filtrationTitleLabel: UILabel!
    
    @IBOutlet weak var saltLevelTitleLabel: UILabel!
    @IBOutlet weak var saltLevelDescriptionLabel: UILabel!
    var isInitialPoolSetup = false

    
    
    var pool = Pool()
    var backFromWintering = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bakcgroundFileName = "BG"
        
        self.title = "My pool".localized
        if let module = Module.currentModule {
            if module.isForSpa {
                self.title = "My spa".localized
                bakcgroundFileName = "BG_spa"
            }
//            if !module.isSubscriptionValid {
//                tableView.contentInset =  UIEdgeInsets.init(top: -44, left: 0, bottom: 0, right: 0)
//                tableView.scrollIndicatorInsets = UIEdgeInsets.init(top:-44, left: 0, bottom: 0, right: 0)
//            }
        }
        
        let imvTableBackground = UIImageView.init(image: UIImage(named: bakcgroundFileName))
        imvTableBackground.frame = self.tableView.frame
        self.tableView.backgroundView = imvTableBackground
        
        modeTitleLabel.text = "Mode".localized
        locationTitleLabel.text = "City".localized
        situationTitleLabel.text = "Situation".localized
        numbersOfPlacesTitleLabel.text = "Number of places".localized
        numbersOfUsersTitleLabel.text = "Number of usual users".localized
        yearContructionTitleLabel.text = "Year of construction".localized
        volumeTitleLabel.text = "Volume (m3)".localized
        shapeTitleLabel.text = "Shape".localized
        coatingTitleLabel.text = "Type of coating".localized
        integrationTitleLabel.text = "Integration".localized
        treatmentTitleLabel.text = "Treatment".localized
        filtrationTitleLabel.text = "Filtration".localized
        spaKindTitleLabel.text = "Spa kind".localized
        isPublicSegmentedControl.setTitle("Private".localized, forSegmentAt: 0)
        isPublicSegmentedControl.setTitle("Public".localized, forSegmentAt: 1)
        
        saltLevelTitleLabel.text = "Salt level (g/L)".localized
        saltLevelDescriptionLabel.text = "Recommended for the operation of your device".localized
        
//        if isInitialPoolSetup{
//            navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backArrowBlack")
//        }
        
        if let currentPool = Pool.currentPool {
            if let draftPool = Pool.init(withJSON: currentPool.serialized) {
                pool = draftPool
                updateDisplay()
            }
        } else {
            pool.mode = FormValue(id: 0, label: "In activity".localized)
            modeLabel.text = pool.mode?.label
        }
        
    }
    
    func updateDisplay() {
        
        if let city = pool.city {
            self.locationLabel.text = city.name
        }
        if let builtYear = pool.builtYear {
            yearContructionLabel.text = String(describing: builtYear)
        } else {
            yearContructionLabel.text = ""
        }
        
        if let numberOfPlaces = pool.numberOfPlaces {
            numberOfPlacesTextField.text = String(describing: numberOfPlaces)
        } else {
            numberOfPlacesTextField.text = ""
        }
        
        if let numberOfUsers = pool.numberOfUsers {
            numberOfUsersTextField.text = String(describing: numberOfUsers)
        } else {
            numberOfUsersTextField.text = ""
        }
        
        if let volume = pool.volume {
            volumeTextField.text = String(format: "%.1f", volume)
        } else {
            volumeTextField.text = ""
        }
        
        if let value = pool.electrolyzerThreshold {
            tresholdTextField.text = String(format: "%.1f", value)
        } else {
            tresholdTextField.text = ""
        }
        

        shapeLabel.text = pool.shape?.label
        coatingLabel.text = pool.coating?.label
        integrationLabel.text = pool.integration?.label
        treatmentLabel.text = pool.treatment?.label
        filtrationLabel.text = pool.filtration?.label
        modeLabel.text = pool.mode?.label
        situationLabel.text = pool.situation?.label
        spaKindLabel.text = pool.spaKind?.label
        
        if pool.isPublic {
            isPublicSegmentedControl.selectedSegmentIndex = 1
        } else {
            isPublicSegmentedControl.selectedSegmentIndex = 0
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func showDashboard(){
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballZigZag
        self.view.showEmptyStateViewLoading(title: "Launch of the 1st measure".localized, message: "Connecting to flipr...".localized, theme: theme)
        
        BLEManager.shared.startMeasure { (error) in
            
            BLEManager.shared.doAcq = false
            
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                self.view.hideStateView()
                self.showIntialDashBoard()
            }
            else {
                self.showIntialDashBoard()
            }
        }
    }
    
    
    func showIntialDashBoard(){
        UserDefaults.standard.set(Date(), forKey:"FirstMeasureStartDate")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: false)
        })
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        if self.isInitialPoolSetup {
            self.showDashboard()
        }else{
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        
        
        if pool.city == nil {
            showError(title: "Error".localized, message: "The field 'City' is mandatory".localized)
            return
        }
        if pool.treatment == nil {
            showError(title: "Error".localized, message: "The field 'Treatment' is mandatory".localized)
            return
        }
        
        if isPublicSegmentedControl.selectedSegmentIndex == 1 {
            pool.isPublic = true
        } else {
            pool.isPublic = false
        }
        if let value = self.numberOfPlacesTextField.text?.int {
            pool.numberOfPlaces = value
        }
        if let value = self.numberOfUsersTextField.text?.int {
            pool.numberOfUsers = value
        }
        if let value = Double(self.volumeTextField.text!) {
            pool.volume = value
        }
        if let value = Double(self.tresholdTextField.text!) {
            pool.electrolyzerThreshold = value
        }
        
        if pool.id == nil {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            pool.create(completion: { (error) in
                
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                    if self.isInitialPoolSetup {
                        self.showDashboard()
                    }
                } else {
                    NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                    if self.isInitialPoolSetup {
                        self.showDashboard()
                    }else{
                        self.dismiss(animated: true, completion:nil)
                    }
                    
                }
            })
        } else {
            
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.navigationController!.view)
            
            pool.update(completion: { (error) in
                
                if (error != nil) {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                } else {
                    NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                    if self.backFromWintering {
                        self.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(name: K.Notifications.BackFromWintering, object: nil)
                        })
                    } else {
                        NotificationCenter.default.post(name: K.Notifications.PoolSettingsUpdated, object: nil)
                        self.dismiss(animated: true, completion:nil)
                    }
                }
            })
        }
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if let module = Module.currentModule {
                if module.isForSpa {
                    return "Spa's status".localized
                }
//                if !module.isSubscriptionValid {
//                    return nil
//                }
            } else {
                return nil
            }
            return "Pool's status".localized
        }
        if section == 1 { return "Location".localized }
        if section == 2 { return "Use".localized }
        if section == 3 { return "Characteristics".localized }
        if section == 4 { return "Maintenance".localized }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 178, green: 184, blue: 200)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 4 && indexPath.row == 1 {
            if let value = self.pool.treatment {
             if value.id == 4 {
                return super.tableView(tableView, heightForRowAt: indexPath)
             }
            }
            return 0
        }
        
        if let module = Module.currentModule {
            if module.isForSpa {
                return super.tableView(tableView, heightForRowAt: indexPath)
            } else {
                if indexPath.section == 3 && indexPath.row == 0 { return 0 }
                if indexPath.section == 2 && indexPath.row == 1 { return 0 }
            }
//            if !module.isSubscriptionValid {
//                if indexPath.section == 0 { return 0 }
//            }
        } else {
            if indexPath.section == 0 { return 0 }
            if indexPath.section == 3 && indexPath.row == 0 { return 0 }
            if indexPath.section == 2 && indexPath.row == 1 { return 0 }
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? CityPickerViewController {
            viewController.title = "Location".localized
            viewController.completion(block: { (city,latitude,longitude) in
                self.pool.city = city
                self.locationLabel.text = city.name
                self.pool.latitude = latitude
                self.pool.longitude = longitude
            })
        } else if let viewController = segue.destination as? ValuePickerController {
            
            if segue.identifier == "constructionYear" {
                var values = [FormValue]()
                for index in 0...100 {
                    let year = Date().year - index
                    let value = FormValue.init(id: year, label: String(year))
                    values.append(value)
                }
                viewController.values = values
                viewController.title = "Year of construction".localized
                viewController.completion(block: { (formValue) in
                    self.pool.builtYear = formValue.id
                    self.yearContructionLabel.text = formValue.label
                })
            } else {
                viewController.apiPath = segue.identifier
                if segue.identifier == "coatings" {
                    viewController.title = "Type of coating".localized
                    viewController.completion(block: { (formValue) in
                        self.pool.coating = formValue
                        self.coatingLabel.text = formValue.label
                    })
                }
                if segue.identifier == "integration" {
                    viewController.title = "Integration".localized
                    viewController.completion(block: { (formValue) in
                        self.pool.integration = formValue
                        self.integrationLabel.text = formValue.label
                    })
                }
                if segue.identifier == "shapes" {
                    viewController.title = "Shape".localized
                    viewController.completion(block: { (formValue) in
                        self.pool.shape = formValue
                        self.shapeLabel.text = formValue.label
                    })
                }
                if segue.identifier == "treatment" {
                    viewController.title = "Treatement".localized
                    viewController.completion(block: { (formValue) in
                        self.pool.treatment = formValue
                        self.treatmentLabel.text = formValue.label
                        self.tableView.reloadData()
                    })
                }
                if segue.identifier == "filtrations" {
                    viewController.title = "Filtration".localized
                    viewController.completion(block: { (formValue) in
                        self.pool.filtration = formValue
                        self.filtrationLabel.text = formValue.label
                    })
                }
                if segue.identifier == "locations" {
                    viewController.title = "Situation".localized
                    viewController.completion(block: { (formValue) in
                        self.pool.situation = formValue
                        self.situationLabel.text = formValue.label
                    })
                }
                if segue.identifier == "spaTypes" {
                    viewController.title = "Spa kind".localized
                    viewController.completion(block: { (formValue) in
                        self.pool.spaKind = formValue
                        self.spaKindLabel.text = formValue.label
                    })
                }
                if segue.identifier == "modes" {
                    viewController.title = "Pool's status".localized
                    if let module = Module.currentModule {
                        if module.isForSpa {
                            viewController.title = "Spa's status".localized
                        }
                    }
                    viewController.completion(block: { (formValue) in
                        if let id = self.pool.mode?.id {
                            if id > 1 {
                                if formValue.id == 0 {
                                    self.backFromWintering = true
                                }
                            }
                        }
                        self.pool.mode = formValue
                        self.modeLabel.text = formValue.label
                        /*
                        if formValue.id == 2 {
                            let alert = Alert.init(id: "0", title: formValue.label, subtitle: "Follow the tips below to prepare your Flipr to spend the winter".localized)
                            alert.steps = ["PASSIVE_MODE_STEP1".localized,"PASSIVE_MODE_STEP2".localized,"PASSIVE_MODE_STEP3".localized,"PASSIVE_MODE_STEP4".localized,"PASSIVE_MODE_STEP5".localized]
                            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewControllerID") as? AlertViewController {
                                viewController.infoMode = true
                                viewController.alert = alert
                                self.present(viewController, animated: true, completion: nil)
                            }
                        }*/
                    })
                }
            }
        }
    }


}
