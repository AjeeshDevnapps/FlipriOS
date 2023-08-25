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
    
    var firstItemArray = [""]
    var secondItemArray = [""]
    var currentType = ExpertViewPickerType.Ph
    
    var selectedItem1 = ""
    var selectedItem2 = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = titleStr.localized
        submitButton.setTitle("Confirm".localized, for: .normal)
        // Do any additional setup after loading the view.
        setupArray()
    }

    
    func setupArray(){
        
        switch (currentType){
            
            case .Ph :
                firstItemArray = ["5.0","5.1","5.2","5.3","5.4","5.5","5.6","5.7","5.8","5.9","6.0","6.1","6.2","6.3","6.4","6.5","6.6","6.7","6.8","6.9","7.0","7.1","7.2","7.3","7.4"]
                secondItemArray = ["7.4","7.5","7.6","7.7","7.8","7.9","8.0","8.1","8.2","8.3","8.4","8.5","8.6","8.7","8.8","8.9","9.0"]

            break
            case .Temp :
                firstItemArray = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
                secondItemArray = ["20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39"]
            break
            case .Redox :
                firstItemArray = ["50", "100", "150", "200", "250", "300", "350", "400", "450", "500", "550", "600", "650", "700", "750", "800", "850", "900", "950", "1000", "1050", "1100", "1150", "1200", "1250", "1300", "1350", "1400", "1450", "1500"]
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
//        selectedItem1 = firstItemArray[row]
//        selectedItem2 = secondItemArray[row]
    }
    
}
