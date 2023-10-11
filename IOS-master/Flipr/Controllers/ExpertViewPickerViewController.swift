//
//  ExpertViewPickerViewController.swift
//  Flipr
//
//  Created by Ajish on 24/08/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

protocol ExpertViewPickerViewControllerDelegate {
    func didSelectPikcer(type:ExpertViewPickerType, value1:String, value2:String )
}


enum ExpertViewPickerType {
    case Ph
    case Temp
    case Redox
}

class ExpertViewPickerViewController: UIViewController {
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var titleStr = ""
    var delegate:ExpertViewPickerViewControllerDelegate?
    var isSingleItem = false
    
    var isInvalidData = false

    
    var firstItemArray = [""]
    var secondItemArray = [""]
    var currentType = ExpertViewPickerType.Ph
    
    var selectedItem1 = ""
    var selectedItem2 = ""
    
    
    var defaultValue1 = ""
    var defaultValue2 = ""
    var defaultValue1Index = 0
    var defaultValue2Index =  0


    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = titleStr.localized
        submitButton.setTitle("Confirm".localized, for: .normal)
        // Do any additional setup after loading the view.
        setupArray()
        self.showDefaultValue()
    }

    
    func setupArray(){
        
        switch (currentType){
            
            case .Ph :
                firstItemArray = ["6.0","6.1","6.2","6.3","6.4","6.5","6.6","6.7","6.8","6.9","7.0","7.1","7.2","7.3","7.4","7.5","7.6","7.7","7.8","7.9","8.0","8.1","8.2","8.3","8.4","8.5","8.6","8.7","8.8","8.9","9.0"]
                secondItemArray = ["6.0","6.1","6.2","6.3","6.4","6.5","6.6","6.7","6.8","6.9","7.0","7.1","7.2","7.3","7.4","7.5","7.6","7.7","7.8","7.9","8.0","8.1","8.2","8.3","8.4","8.5","8.6","8.7","8.8","8.9","9.0"]

            break
            case .Temp :
            
            if let currentUnit = UserDefaults.standard.object(forKey: "CurrentUnit") as? Int{
                if currentUnit == 2{
                    firstItemArray = ["32.0","33.0","34.0","35.0","36.0","37.0","38.0","39.0","40.0","41.0","42.0","43.0","44.0","45.0","46.0","47.0","48.0","49.0","50.0","60.0","61.0","62.0","63.0","64.0","65.0","66.0","67.0","68.0"]
                    secondItemArray = ["70.0","71.0","72.0","73.0","74.0","75.0","76.0","77.0","78.0","79.0","80.0","81.0","82.0","83.0","84.0","85.0","86.0","87.0","88.0","89.0","90.0","91.0","92.0","93.0","94.0","95.0","96.0","97.0","98.0","99.0","100.0","101.0","102.0"]
                }
                else{
                    firstItemArray = ["0.0","1.0","2.0","3.0","4.0","5.0","6.0","7.0","8.0","9.0","10.0","11.0","12.0","13.0","14.0","15.0","16.0","17.0","18.0","19.0","20.0","21.0","22.0","23.0","24.0","25.0","26.0","27.0","28.0","29.0","30.0","31.0","32.0","33.0","34.0","35.0"]
                    secondItemArray = ["15.0","16.0","17.0","18.0","19.0","20.0","21.0","22.0","23.0","24.0","25.0","26.0","27.0","28.0","29.0","30.0","31.0","32.0","33.0","34.0","35.0","36.0","37.0","38.0","39.0","40.0","41.0","42.0","43.0","44.0","45.0"]
                }
            }else{
                firstItemArray = ["0.0","1.0","2.0","3.0","4.0","5.0","6.0","7.0","8.0","9.0","10.0","11.0","12.0","13.0","14.0","15.0","16.0","17.0","18.0","19.0","20.0","21.0","22.0","23.0","24.0","25.0","26.0","27.0","28.0","29.0","30.0","31.0","32.0","33.0","34.0","35.0"]
                secondItemArray = ["15.0","16.0","17.0","18.0","19.0","20.0","21.0","22.0","23.0","24.0","25.0","26.0","27.0","28.0","29.0","30.0","31.0","32.0","33.0","34.0","35.0","36.0","37.0","38.0","39.0","40.0","41.0","42.0","43.0","44.0","45.0"]
            }
            break
            case .Redox :
                firstItemArray = ["50", "100", "150", "200", "250", "300", "350", "400", "450", "500", "550", "600", "650", "700", "750", "800", "850", "900", "950", "1000", "1050", "1100", "1150", "1200", "1250", "1300", "1350", "1400", "1450", "1500"]
            break

        }
        
    }
    
    
    func showDefaultValue(){
        
        switch (currentType){
            
        case .Ph :
            
            if let index1 = firstItemArray.firstIndex(of:defaultValue1){
                defaultValue1Index = index1
            }
            
            if let index2 = secondItemArray.firstIndex(of:defaultValue2){
                defaultValue2Index = index2
            }
            
            pickerView.selectRow(defaultValue1Index, inComponent: 0, animated: true)
            
            pickerView.selectRow(defaultValue2Index, inComponent: 1, animated: true)
            
            break
        case .Temp :
            
            if let index1 = firstItemArray.firstIndex(of:defaultValue1){
                defaultValue1Index = index1
            }
            if let index2 = secondItemArray.firstIndex(of:defaultValue2){
                defaultValue2Index = index2
            }
            pickerView.selectRow(defaultValue1Index, inComponent: 0, animated: true)
            
            pickerView.selectRow(defaultValue2Index, inComponent: 1, animated: true)
            
            break

        case .Redox :
            
            if let index1 = firstItemArray.firstIndex(of:defaultValue1){
                defaultValue1Index = index1
            }
            pickerView.selectRow(defaultValue1Index, inComponent: 0, animated: true)
            
            
            break
            
        }
        
    }
    
    func showBackgroundView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                }, completion: nil)

//        self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(){
        if isInvalidData { return }
        let row1 = pickerView.selectedRow(inComponent: 0)
        selectedItem1 = firstItemArray[row1]
        if !isSingleItem{
            let row2 = pickerView.selectedRow(inComponent: 1)
            selectedItem2 = secondItemArray[row2]
        }else{
            selectedItem2 = "0"
        }

        self.delegate?.didSelectPikcer(type: self.currentType, value1: selectedItem1, value2: selectedItem2)
        self.dismiss(animated: true)
//        selectedItem1 = pickerData[pickerView.selectedRow(inComponent: 0)]
//        selectedItem2 = pickerData[pickerView.selectedRow(inComponent: 1)]
    }
    
}

extension ExpertViewPickerViewController:  UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return isSingleItem ? 1 : 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isSingleItem{
            return firstItemArray.count
        }else{
            if component == 0 {
                return firstItemArray.count
            } else {
                return secondItemArray.count
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return firstItemArray[row]
        } else {
            return secondItemArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currentType == .Redox{
            return
        }
        
        let row1 = pickerView.selectedRow(inComponent: 0)
        selectedItem1 = firstItemArray[row1]
        if !isSingleItem{
            let row2 = pickerView.selectedRow(inComponent: 1)
            selectedItem2 = secondItemArray[row2]
            
        }else{
            selectedItem2 = "0"
        }

        var min = 0.0
        min = selectedItem1.doubleValue
        var max = 0.0
        max = selectedItem2.doubleValue
        
        if min < max{
            isInvalidData = false
        }else{
            isInvalidData = true
            if currentType == .Ph{
                self.showError(title: "", message: "You can't set a pH min > pH max")
            }
            else{
                self.showError(title: "", message: "You can't set a temp min > temp max")
            }
        }

//        selectedItem1 = firstItemArray[row]
//        selectedItem2 = secondItemArray[row]
    }
    
}
