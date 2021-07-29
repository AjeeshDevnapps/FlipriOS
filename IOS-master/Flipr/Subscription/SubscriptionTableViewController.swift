//
//  SubscriptionTableViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 26/03/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import SafariServices

class SubscriptionTableViewController: UITableViewController {
    
    let forLifePeriodAllowed:Double = 3600 * 24 * 30 * 6 //6 mois (in sec)
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var month1Label: UILabel!
    @IBOutlet weak var month3Label: UILabel!
    @IBOutlet weak var month12Label: UILabel!
    @IBOutlet weak var allFeaturesLabel: UILabel!
    @IBOutlet weak var guaranteeLabel: UILabel!
    @IBOutlet weak var freeTrialLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var autoRenewedLabel: UILabel!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var selectedPriceLabel: UILabel!
    
    
    @IBOutlet weak var conditionsTitleLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var conditionsTextLabel: UILabel!
    
    @IBOutlet weak var cguButton: UIButton!
    
    @IBOutlet weak var confidentialityButton: UIButton!
    
    @IBOutlet weak var checkImageView1: UIImageView!
    @IBOutlet weak var checkImageView2: UIImageView!
    @IBOutlet weak var fliprIconImageView: UIImageView!
    
    
    let purchaseHud = JGProgressHUD(style:.dark)
    
    var options: [Subscription]?
    var selectedOption:Subscription? {
        didSet {
            if selectedOption?.product.productIdentifier == "com.goflipr.flipr.sub.infinitemonthly" {
                savingView.isHidden = true
            } else {
                if let selectedOption = selectedOption {
                    savingView.isHidden = true
                    for option in self.options ?? [] {
                        if option.product.productIdentifier == "com.goflipr.flipr.sub.infinitemonthly" {
                            optionSaving.text = "Save \(String(format: "%.0f", 100 - (Double(truncating: selectedOption.monthPrice)*100/Double(truncating: option.product.price))))%"
                            savingView.isHidden = false
                        }
                    }
                }
            }
            fliprInfiniteFromPrice.text = selectedOption?.formattedMonthPrice
            selectedOptionLabel.text = "Pour \(selectedOption?.label ?? "NaN")"
            selectedOptionPriceLabel.text = "(soit \(selectedOption?.formattedPrice ?? "NaN"))"
            
            selectedPriceLabel.text = selectedOption?.labelPrice
            
            
            if #available(iOS 11.2, *) {
                if let period = selectedOption?.product.introductoryPrice?.subscriptionPeriod {
                    print("Start your \(period.numberOfUnits) \(unitName(unitRawValue: period.unit.rawValue)) free trial")
                    var name = unitName(unitRawValue: period.unit.rawValue)
                    if period.numberOfUnits > 1 {
                        name = unitNamePlural(unitRawValue: period.unit.rawValue)
                    }
                    trialPeriodLabel.text = "\(period.numberOfUnits) \(name)"
                }
            } else {
                if selectedOption?.product.productIdentifier == "com.goflipr.flipr.sub.4lifemonthly" {
                    trialPeriodLabel.text = "1 mois"
                } else {
                    trialPeriodLabel.text = "7 jours"
                }
            }
            
            if selectedOption?.product.productIdentifier == "com.goflipr.flipr.sub.4lifemonthly" {
                checkImageView1.tintColor = .white
                checkImageView2.tintColor = .white
                fliprIconImageView.tintColor = .white
            } else {
                fliprIconImageView.tintColor = K.Color.DarkBlue
                checkImageView1.tintColor = K.Color.DarkBlue
                checkImageView2.tintColor = K.Color.DarkBlue
            }
            
        }
    }
    
    func unitName(unitRawValue:UInt) -> String {
        switch unitRawValue {
        case 0: return "day".localized
        case 1: return "week".localized
        case 2: return "month".localized
        case 3: return "year".localized
        default: return ""
        }
    }
    func unitNamePlural(unitRawValue:UInt) -> String {
        switch unitRawValue {
        case 0: return "days".localized
        case 1: return "weeks".localized
        case 2: return "months".localized
        case 3: return "years".localized
        default: return ""
        }
    }
    
    
    @IBOutlet weak var monthySubscriptionView: SubscriptionView!
    @IBOutlet weak var quarterlySubscriptionView: SubscriptionView!
    @IBOutlet weak var annuallySubscriptionView: SubscriptionView!
    @IBOutlet weak var forLifeSubscriptionView: SubscriptionView!
    
    
    
    var pickerViewExpanded = false
    @IBOutlet weak var pickerViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var fliprInfiniteFromPrice: UILabel!
    @IBOutlet weak var optionSaving: UILabel!
    @IBOutlet weak var savingView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var selectedOptionLabel: UILabel!
    @IBOutlet weak var selectedOptionPriceLabel: UILabel!
    
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var montlyPriceLabel: UILabel!
    @IBOutlet weak var monthlyMPriceLabel: UILabel!
    
    @IBOutlet weak var quarterlyLabel: UILabel!
    @IBOutlet weak var quarterlyPriceLabel: UILabel!
    @IBOutlet weak var quarterlyMPriceLabel: UILabel!
    
    @IBOutlet weak var annuallyLabel: UILabel!
    @IBOutlet weak var annuallyPriceLabel: UILabel!
    @IBOutlet weak var annuallyMPriceLabel: UILabel!
    
    @IBOutlet weak var trialPeriodLabel: UILabel!
    @IBOutlet weak var trialPeriodMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Get Flipr Infinite".localized
        selectLabel.text = "Select your subscription".localized
        month1Label.text = "month".localized
        month3Label.text = "months".localized
        month12Label.text = "months".localized
        allFeaturesLabel.text = "All Infinite features".localized
        guaranteeLabel.text = "Your Flipr traded for life!".localized
        freeTrialLabel.text = "free trial".localized
        startButton.setTitle("Start".localized, for: .normal)
        autoRenewedLabel.text = "Automatically renewed, cancel anytime.".localized
        restoreButton.setTitle("Restore purchase".localized, for: .normal)
        conditionLabel.text = "(1) Your Flipr 100% guaranteed for the duration of the subscription, maintenance (excluding product calibration and wintering), theft and breakage included. The 4life subscription will be offered up to 6 months maximum after the activation of your Flipr Start.".localized
        
        conditionsTitleLabel.text = "Subscription conditions".localized
        conditionsTextLabel.text = "Flipr Infinite is available as a monthly, quarterly or annual subscription. You can subscribe to this subscription through your iTunes account. Payment will be invoiced by iTunes upon confirmation of purchase. The subscription is automatically renewed, unless you cancel it at least 24 hours before the end of its validity period. The renewal will be invoiced to your account within 24 hours of the end of the current period. Once you have subscribed, you can deactivate automatic renewal or unsubscribe by accessing the Settings of your App Store account after purchase. Any unused portion of a free trial, if such a trial is offered, will be lost when the user subscribes to the publication concerned.".localized
        cguButton.setTitle("Terms and conditions".localized, for: .normal)
        confidentialityButton.setTitle("Privacy Policy".localized, for: .normal)
        
        monthLabel.text = "/" + "month".localized
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
//        options = SubscriptionService.shared.options
//        if options == nil {
//            self.tableView.showEmptyStateViewLoading(title: "LOADING_PRODUCTS", message: "PLEASE_WAIT")
//        }
//
        self.tableView.showEmptyStateViewLoading(title: nil, message: nil)
        
        SubscriptionService.shared.loadSubscriptionOptions()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOptionsLoaded(notification:)),
                                               name: SubscriptionService.optionsLoadedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseSuccessfull(notification:)),
                                               name: SubscriptionService.purchaseSuccessfulNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseFailed(notification:)),
                                               name: SubscriptionService.purchaseFailedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseCancelation(notification:)),
                                               name: SubscriptionService.purchaseCanceledNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRestoreSuccessfull(notification:)),
                                               name: SubscriptionService.restoreSuccessfulNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRestoreFailed(notification:)),
                                               name: SubscriptionService.restoreFAiledNotification,
                                               object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        }



    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        }
    
    func customNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }

    @IBAction func cancelButonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func optionSelectButtonAction(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.tag == 1 {
                monthySubscriptionView.setSelected(true)
                self.selectedOption = monthySubscriptionView.subscription
                quarterlySubscriptionView.setSelected(false)
                annuallySubscriptionView.setSelected(false)
                forLifeSubscriptionView.setSelected(false)
            }
            if button.tag == 2 {
                monthySubscriptionView.setSelected(false)
                quarterlySubscriptionView.setSelected(true)
                self.selectedOption = quarterlySubscriptionView.subscription
                annuallySubscriptionView.setSelected(false)
                forLifeSubscriptionView.setSelected(false)
            }
            if button.tag == 3 {
                monthySubscriptionView.setSelected(false)
                quarterlySubscriptionView.setSelected(false)
                annuallySubscriptionView.setSelected(true)
                forLifeSubscriptionView.setSelected(false)
                self.selectedOption = annuallySubscriptionView.subscription
            }
            if button.tag == 4 {
                monthySubscriptionView.setSelected(false)
                quarterlySubscriptionView.setSelected(false)
                annuallySubscriptionView.setSelected(false)
                forLifeSubscriptionView.setSelected(true)
                self.selectedOption = forLifeSubscriptionView.subscription
            }
        }
        
    }
    
    
    
    @IBAction func expandPickerViewButtonAction(_ sender: Any) {
        if pickerViewExpanded {
            pickerViewHeightConstraint.constant = 44
        } else {
            pickerViewHeightConstraint.constant = 177
        }
        pickerViewExpanded = !pickerViewExpanded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    
    @IBAction func selectMonhtlyButtonAction(_ sender: Any) {
        for option in self.options ?? [] {
            if option.product.productIdentifier == "com.goflipr.flipr.sub.infinitemonthly" {
                self.selectedOption = option
            }
        }
        self.expandPickerViewButtonAction(self)
        fromLabel.isHidden = true
    }
    
    @IBAction func selectQuarterlyButtonAction(_ sender: Any) {
        for option in self.options ?? [] {
            if option.product.productIdentifier == "com.goflipr.flipr.sub.infinitequartely" {
                self.selectedOption = option
            }
        }
        self.expandPickerViewButtonAction(self)
        fromLabel.isHidden = true
    }
    
    @IBAction func selectAnnuallyButtonAction(_ sender: Any) {
        for option in self.options ?? [] {
            if option.product.productIdentifier == "com.goflipr.flipr.sub.infiniteannually" {
                self.selectedOption = option
            }
            self.expandPickerViewButtonAction(self)
            fromLabel.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 {
            if let module = Module.currentModule {
                print("Activation Date: \(module.activationDate.timeIntervalSinceNow)")
                if module.activationDate.timeIntervalSinceNow < -1 * forLifePeriodAllowed  {
                    return 0
                }
            }
        }
        
        if pickerViewExpanded && indexPath.row == 2 { return 500 }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @IBAction func restorePurchaseButtonAction(_ sender: Any) {
        
        purchaseHud?.show(in: self.navigationController!.view)
        
        SubscriptionService.shared.restorePurchases()
    }
    
    @IBAction func viewOffersButtonAction(_ sender: Any) {
        
        purchaseHud?.show(in: self.navigationController!.view)
        
        guard let option = selectedOption else {
            purchaseHud?.indicatorView = JGProgressHUDErrorIndicatorView()
            purchaseHud?.textLabel.text = "No selected product".localized
            purchaseHud?.dismiss(afterDelay: 3)
            return
        }
        SubscriptionService.shared.purchase(subscription: option)
        
    }
    
    @objc func handleOptionsLoaded(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            
            self?.options = SubscriptionService.shared.options
            
            for option in self?.options ?? [] {
                if option.product.productIdentifier == "com.goflipr.flipr.sub.infinitemonthly" {
                    /*
                    self?.monthlyLabel.text = option.label
                    self?.montlyPriceLabel.text = ""
                    self?.monthlyMPriceLabel.text = option.formattedMonthPrice
                    */
                    self?.monthySubscriptionView.subscription = option
                }
                if option.product.productIdentifier == "com.goflipr.flipr.sub.infinitequartely" {
                    /*
                    self?.quarterlyLabel.text = option.label
                    self?.quarterlyPriceLabel.text = "soit \(option.formattedPrice)"
                    self?.quarterlyMPriceLabel.text = option.formattedMonthPrice
                    */
                    self?.quarterlySubscriptionView.subscription = option
                }
                if option.product.productIdentifier == "com.goflipr.flipr.sub.infiniteannually" {
                    /*
                    self?.annuallyLabel.text = option.label
                    self?.annuallyPriceLabel.text = "soit \(option.formattedPrice)"
                    self?.annuallyMPriceLabel.text = option.formattedMonthPrice
                    self?.selectedOption = option
                    */
                    self?.annuallySubscriptionView.subscription = option
                    self?.annuallySubscriptionView.setSelected(true)
                    self?.selectedOption = option
                    
                }
                if option.product.productIdentifier == "com.goflipr.flipr.sub.4lifemonthly" {
                    self?.forLifeSubscriptionView.subscription = option
                }
            }
            //cell.nameLabel.text = option.product.localizedTitle
            //cell.descriptionLabel.text = option.product.localizedDescription
            //cell.priceLabel.text = option.formattedPrice
            
            
            
            self?.tableView.reloadData()
            self?.tableView.hideStateView()
            
            for option in self?.options ?? [] {
                if option.product.productIdentifier == "com.goflipr.flipr.sub.infinitemonthly" {

                    if let label = self?.quarterlySubscriptionView.viewWithTag(7) as? UILabel, let selectedOption = self?.quarterlySubscriptionView.subscription {
                        label.text = "- \(String(format: "%.0f", 100 - (Double(truncating: selectedOption.monthPrice)*100/Double(truncating: option.product.price))))%"
                    }
                    if let label = self?.annuallySubscriptionView.viewWithTag(7) as? UILabel, let selectedOption = self?.annuallySubscriptionView.subscription {
                        label.text = "- \(String(format: "%.0f", 100 - (Double(truncating: selectedOption.monthPrice)*100/Double(truncating: option.product.price))))%"
                    }
                }
            }
        }
    }
    
    @objc func handlePurchaseSuccessfull(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.purchaseHud?.indicatorView = JGProgressHUDSuccessIndicatorView()
            self?.purchaseHud?.dismiss(afterDelay: 1)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handlePurchaseFailed(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.purchaseHud?.indicatorView = JGProgressHUDErrorIndicatorView()
            self?.purchaseHud?.dismiss(afterDelay: 3)
            self?.purchaseHud?.dismiss(animated: true)
        }
    }
    
    @objc func handlePurchaseCancelation(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.purchaseHud?.dismiss(animated: true)
        }
    }
    
    @objc func handleRestoreSuccessfull(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.purchaseHud?.indicatorView = JGProgressHUDSuccessIndicatorView()
            self?.purchaseHud?.dismiss(afterDelay: 1)
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleRestoreFailed(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.purchaseHud?.indicatorView = JGProgressHUDErrorIndicatorView()
            self?.purchaseHud?.dismiss(afterDelay: 3)
            self?.purchaseHud?.dismiss(animated: true)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if let products = options {
            if products.count > 0 {
                return 1
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let module = Module.currentModule {
            if module.activationDate.timeIntervalSinceNow  < -1 * forLifePeriodAllowed  {
                return 5
            }
        }
        return 6
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func scrollToOptionsButtonAction(_ sender: Any) {
        self.tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .top, animated: true)
    }
    
    @IBAction func cguButtonAction(_ sender: Any) {
        if let url = URL(string: "TERMS_OF_USE_URL".localized) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func confidentialityButtonAction(_ sender: Any) {
        if let url = URL(string: "DATA_USE_POLICY_URL".localized) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(vc, animated: true)
        }
    }
    

}
