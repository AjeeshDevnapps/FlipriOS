//
//  ManualEntryViewController.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 28/11/23.
//

import UIKit
import JGProgressHUD
import Alamofire

protocol ManualEntryViewControllerDelegate {
    func valuesEnteredToValidate(combinedEntry: ValidationInputs)
}

class ManualEntryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var validateBtn: UIButton!

    var isMetric = true
    var isBrominePool = true
    var combinedEntry = ValidationInputs()
    var delegate: ManualEntryViewControllerDelegate?
    var currentType = 0
    
    var isSelectedPh = false
    var isSelectedTac = false
    var isSelectedTh = false
    var isSelectedStabilizer = false
    var isSelectedFreeChlorine = false
    var isSelectedTotalBromine = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateBtn.setTitle("Validate".localized, for: .normal)
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        segmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitle("4274:65789".localized, forSegmentAt: 0)
        segmentedControl.setTitle("4274:65791".localized, forSegmentAt: 1)

        
        tableView.allowsSelection = false
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        combinedEntry.pH  = 0
        
        if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
            if currentUnit == 2{
                isMetric = false
            }
            else{
                isMetric = true
            }
        }

    }
    

    @IBAction func validateAction(_ sender: UIButton) {
        callMethod()
//        self.dismiss(animated: true)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func callMethod(){
        if isSelectedPh && isSelectedTac && isSelectedTh && isSelectedStabilizer && isSelectedFreeChlorine && isSelectedTotalBromine {
           let identifier = Module.currentModule?.serial ?? ""

            let parameters: [String : Any] = [
                "serial": identifier,
                "PH": combinedEntry.pH,
                "Temp": combinedEntry.temperature,
                "TAC": combinedEntry.tac,
                "TH": combinedEntry.th,
                "Stabilizer": combinedEntry.stabilizer,
                "FreeChlorine": combinedEntry.free,
                "TotalBr": combinedEntry.total,
         ]
        
            if let module = Module.currentModule {
                let hud = JGProgressHUD(style:.dark)
                hud?.show(in: self.view)
                Alamofire.request(Router.manualEntry(data: parameters)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        hud?.dismiss(afterDelay: 0)
                        self.dismiss(animated: true)
                    case .failure(let error):
                        hud?.dismiss(afterDelay: 0)
                        self.dismiss(animated: true)

//                        self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)

                        print("callAddDelayApi did fail with error: \(error)")
                        
                    }
                })
            }
            
        }else{
            self.showError(title: "Error", message: "Fill All values")
        }
    }
}

extension ManualEntryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManualEntryImageTableViewCell", for: indexPath) as! ManualEntryImageTableViewCell
            cell.input = DualEntryImage(isMetric: isMetric, imageName: "ph", secondImageName: "ph_sec", text: "pH", secondValueUnit: isMetric ? "°C" : "°F", firstInitialValue: "0", secondInitialValue: "0")
            cell.delegate = self
            cell.valueType = .ph
            cell.firstTextField.text = "\(combinedEntry.pH)"
            cell.secondTextField.text = "\(combinedEntry.temperature)"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManualEntryTextTableViewCell", for: indexPath) as! ManualEntryTextTableViewCell
            cell.input = DualEntryText(isMetric: isMetric, imageName: "tac", text: "TAC",firstValueUnit: "ppm", secondValueUnit: "°f", firstInitialValue: "0", secondInitialValue: "0")
            cell.delegate = self
            cell.secondTextField.isEnabled = false
            cell.secondTextField.backgroundColor = .gray
            cell.firstTextField.text = "\(combinedEntry.tac)"
            cell.secondTextField.text = "\(combinedEntry.tacTemperature)"
            cell.valueType = .tac
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManualEntryTextTableViewCell", for: indexPath) as! ManualEntryTextTableViewCell
            cell.input = DualEntryText(isMetric: isMetric, imageName: "th", text: "TH",firstValueUnit: "ppm", secondValueUnit: "°f", firstInitialValue: "0", secondInitialValue: "0")
            cell.delegate = self
            cell.secondTextField.isEnabled = false
            cell.secondTextField.backgroundColor = .gray
            cell.firstTextField.text = "\(combinedEntry.th)"
            cell.secondTextField.text = "\(combinedEntry.thTemperature)"
            
            cell.valueType = .th
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEntryTableViewCell", for: indexPath) as! SingleEntryTableViewCell
            cell.input = SingleEntryInput(isMetric: isMetric,
                                          imageName: "stabilizer",
                                          text: "Stabilizer".localized,
                                          unit: "ppm",
                                          initialValue: "0")
            cell.delegate = self
            cell.valueType = .stabilizer
            cell.textField.text = "\(combinedEntry.stabilizer)"

            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEntryTableViewCell", for: indexPath) as! SingleEntryTableViewCell
            cell.input = SingleEntryInput(isMetric: isMetric,
                                          imageName: "free_chlorine",
                                          text: "4274:66174".localized ,
                                          unit: "ppm",
                                          initialValue: "0")
            cell.delegate = self
            cell.valueType = .free
            cell.textField.text = "\(combinedEntry.free)"
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEntryTableViewCell", for: indexPath) as! SingleEntryTableViewCell
            cell.input = SingleEntryInput(isMetric: isMetric,
                                          imageName: "total_chlorine",
                                          text: isBrominePool ? "4274:66198".localized : "4274:65888".localized ,
                                          unit: "ppm",
                                          initialValue: "0")
            cell.delegate = self
            cell.valueType = .total
            cell.textField.text = "\(combinedEntry.total)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension ManualEntryViewController: SingleEntryTableViewCellDelegate {
   
    func valueEntered(textField: UITextField?, text: String, valueType: SingleValueType) {
        switch valueType {
        case .stabilizer:
//            combinedEntry.stabilizer = Double(text) ?? 0
            self.showStabilizerPicker()
        case .free:
            self.showFreeChlorinePicker()
        case .total:
            self.showTotalBrominePicker()
        }
    }
}

extension ManualEntryViewController: ManualEntryTableViewCellDelegate {
    func firstTextFieldUpdated(textField: UITextField?, value: String, valueType: TextValueType) {
        switch valueType {
        case .tac:
//            combinedEntry.tac = Double(value) ?? 0
//            combinedEntry.tacTemperature = (Double(value) ?? 0) / 10
            self.showTacPicker()
        case .th:
            self.showTHPicker()
        case .ph:
            self.showPhPicker()
        }
    }
    
    func secondTextFieldUpdated(textField: UITextField?, value: String, valueType: TextValueType) {
        switch valueType {
        case .tac:break
//            combinedEntry.tacTemperature = Double(value) ?? 0
        case .th:break
//            combinedEntry.thTemperature = Double(value) ?? 0
        case .ph:
            self.showPhPicker()
        }
    }
}


extension ManualEntryViewController{
    
    
    func showPhPicker(){
        
        self.currentType = 1
        let sb = UIStoryboard.init(name: "ExpertView", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.currentType = .Ph
        vc.isPhManualEntry = true
        vc.titleStr = "4274:65922".localized
        vc.delegate = self
        vc.firstItemArray = ["0","20","30","40","50","60","80","100","125","150","175","200","250","300","400","500","600","700","800","900","1000"]
        vc.secondItemArray = ["0","20","30","40","50","60","80","100","125","150","175","200","250","300","400","500","600","700","800","900","1000"]

        if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
            if currentUnit == 2{
                vc.firstItemArray = ["5.8","5.9","6.0","6.1","6.2","6.3","6.4","6.5","6.6","6.7","6.8","6.9","7.0","7.1","7.2","7.3","7.4","7.5","7.6","7.7","7.8","7.9","8.0","8.1","8.2","8.3","8.4","8.5","8.6"]
                vc.secondItemArray = ["32","34","36","38","40","42","44","46","48","50","52","54","56","58","60","62","64","66","68","70","72","74","76","78","80","82","84","86","88","90","92","94","96","98","100","102"]
            }
            else{
                vc.firstItemArray = ["5.8","5.9","6.0","6.1","6.2","6.3","6.4","6.5","6.6","6.7","6.8","6.9","7.0","7.1","7.2","7.3","7.4","7.5","7.6","7.7","7.8","7.9","8.0","8.1","8.2","8.3","8.4","8.5","8.6"]
                vc.secondItemArray  = ["0.0","1.0","2.0","3.0","4.0","5.0","6.0","7.0","8.0","9.0","10.0","11.0","12.0","13.0","14.0","15.0","16.0","17.0","18.0","19.0","20.0","21.0","22.0","23.0","24.0","25.0","26.0","27.0","28.0","29.0","30.0","31.0","32.0","33.0","34.0","35.0","36.0","37.0","38.0","39.0","40"]
            }
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    func showTacPicker(){
        let sb = UIStoryboard.init(name: "ExpertView", bundle: nil)

        let vc = sb.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.titleStr = "4274:65959".localized
        vc.currentType = .Redox
        let tmpVal = combinedEntry.tac
        self.currentType = 2
        vc.defaultValue1 = tmpVal.string
        vc.firstItemArray = ["0","20","30","40","50","60","80","100","125","150","175","200","250","300","400","500","600","700","800","900","1000"]
        vc.delegate = self
        vc.isSingleItem = true
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    func showTHPicker(){
        let sb = UIStoryboard.init(name: "ExpertView", bundle: nil)

        let vc = sb.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.titleStr = "TH (Total Hardeness)".localized
        vc.currentType = .Redox
        let tmpVal = combinedEntry.th
        self.currentType = 3
        vc.defaultValue1 = tmpVal.string
        vc.firstItemArray = ["0","20","30","40","50","60","80","100","125","150","175","200","250","300","400","500","600","700","800","900","1000"]
        vc.delegate = self
        vc.isSingleItem = true
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    func showStabilizerPicker(){
        let sb = UIStoryboard.init(name: "ExpertView", bundle: nil)

        let vc = sb.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.titleStr = "Stabilizer".localized
        vc.currentType = .Redox
        let tmpVal = combinedEntry.stabilizer
        self.currentType = 4
        vc.defaultValue1 = tmpVal.string
        vc.firstItemArray = ["0","20","40","100","120","140","150","200","300","400"]
        vc.delegate = self
        vc.isSingleItem = true
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    func showFreeChlorinePicker(){
        let sb = UIStoryboard.init(name: "ExpertView", bundle: nil)

        let vc = sb.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.titleStr = "4274:66880".localized
        vc.currentType = .Redox
        let tmpVal = combinedEntry.free
        self.currentType = 5
        vc.defaultValue1 = tmpVal.string
        vc.firstItemArray = ["0","20","40","100","120","140","150","200","300","400"]
        vc.delegate = self
        vc.isSingleItem = true
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
    
    
    func showTotalBrominePicker(){
        let sb = UIStoryboard.init(name: "ExpertView", bundle: nil)

        let vc = sb.instantiateViewController(withIdentifier: "ExpertViewPickerViewController") as! ExpertViewPickerViewController
        vc.titleStr = "4274:66198".localized
        vc.currentType = .Redox
        let tmpVal = combinedEntry.total
        self.currentType = 6
        vc.defaultValue1 = tmpVal.string
        vc.firstItemArray = ["0","0.5","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17"]
        vc.delegate = self
        vc.isSingleItem = true
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true) {
            vc.showBackgroundView()
        }
    }
}

extension ManualEntryViewController : ExpertViewPickerViewControllerDelegate {
    
    func didSelectPikcer(type:ExpertViewPickerType, value1:String, value2:String ){
        
        if self.currentType == 1{
            self.isSelectedPh = true
            let tmp = value1.doubleValue
            combinedEntry.pH = tmp
            let tmp1 = value2.doubleValue
            combinedEntry.temperature = tmp1
            self.tableView.reloadData()
        }
        
        else if self.currentType == 2{
            self.isSelectedTac = true

            let tmp = value1.doubleValue
            combinedEntry.tac = tmp
            combinedEntry.tacTemperature = tmp / 10
            self.tableView.reloadData()
        }
        else if  self.currentType == 3{
            self.isSelectedTh = true

            let tmp = value1.doubleValue
            combinedEntry.th = tmp
            combinedEntry.thTemperature = tmp / 10
            self.tableView.reloadData()
        }
        else if  self.currentType == 4{
            self.isSelectedStabilizer = true

            let tmp = value1.doubleValue
            combinedEntry.stabilizer = tmp
            self.tableView.reloadData()
        }
        else if  self.currentType == 5{
            self.isSelectedFreeChlorine = true

            let tmp = value1.doubleValue
            combinedEntry.free = tmp
            self.tableView.reloadData()
        }
        else if  self.currentType == 6{
            self.isSelectedTotalBromine = true

            let tmp = value1.doubleValue
            combinedEntry.total = tmp
            self.tableView.reloadData()
        }
    }
    
}
