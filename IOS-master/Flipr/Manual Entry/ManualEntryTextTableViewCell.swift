//
//  ManualEntryTextTableViewCell.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 29/11/23.
//

import UIKit

enum TextValueType {
    case tac
    case th
    case ph
}

protocol ManualEntryTableViewCellDelegate {
    func firstTextFieldUpdated(textField: UITextField?, value: String, valueType: TextValueType)
    func secondTextFieldUpdated(textField: UITextField?, value: String, valueType: TextValueType)
}

class ManualEntryTextTableViewCell: UITableViewCell {

    @IBOutlet weak var secondValueUnitLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var firstValueUnitLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    
    var valueType: TextValueType!
    var input: DualEntryText? {
        didSet {
            updateValues()
        }
    }
    var delegate: ManualEntryTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
    
    @IBAction func firstTextFieldBtnClicked(_ sender: UIButton) {
        delegate?.firstTextFieldUpdated(textField: nil, value: firstTextField.text ?? "", valueType: self.valueType)
    }
    
    @IBAction func secondTextFieldBtnClicked(_ sender: UIButton) {
        if self.valueType == .tac{
            return
        }
        if self.valueType == .th{
            return
        }
        delegate?.firstTextFieldUpdated(textField: nil, value: secondTextField.text ?? "", valueType: self.valueType)
    }

  
    @IBAction func firstTextFieldChanged(_ sender: UITextField) {
        guard sender.text != "" else { return }
        delegate?.firstTextFieldUpdated(textField: sender, value: sender.text ?? "", valueType: self.valueType)
    }


    @IBAction func secondTextFieldChanged(_ sender: UITextField) {
        guard sender.text != "" else { return }
        delegate?.secondTextFieldUpdated(textField: sender, value: sender.text ?? "", valueType: self.valueType)
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        let enteredValue = Double(firstTextField.text ?? "0")
        secondTextField.text = "\((enteredValue ?? 0) / 10)"
    }
    
    func updateValues() {
        if let titleImage = input?.imageName {
            titleImageView.image = UIImage(named: titleImage)
        }
        titleText.text = input?.text
        firstTextField.text = input?.firstInitialValue
        firstValueUnitLabel.text = input?.firstValueUnit
        secondTextField.text = input?.secondInitialValue
        secondValueUnitLabel.text = input?.secondValueUnit
    }
}
