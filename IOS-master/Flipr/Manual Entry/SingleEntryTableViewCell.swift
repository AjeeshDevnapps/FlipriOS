//
//  SingleEntryTableViewCell.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 29/11/23.
//

import UIKit

enum SingleValueType {
    case stabilizer
    case free
    case total
}

protocol SingleEntryTableViewCellDelegate {
    func valueEntered(textField: UITextField?, text: String, valueType: SingleValueType)
}

class SingleEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var unitText: UILabel!
    @IBOutlet weak var textField: UITextField!
    var valueType: SingleValueType!
    var delegate: SingleEntryTableViewCellDelegate?
    var input: SingleEntryInput? {
        didSet {
            assignValues()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignValues() {
        if let imageName = input?.imageName {
            iconImage.image = UIImage(named: imageName)
        }
        titleText.text = input?.text
        unitText.text = input?.unit
        textField.text = input?.initialValue
    }

    @IBAction func textUpdated(_ sender: UITextField) {
        guard sender.text != "" else { return }
        self.delegate?.valueEntered(textField: sender, text: textField.text ?? "", valueType: valueType)
    }
    
    
    @IBAction func firstTextFieldBtnClicked(_ sender: UIButton) {
        delegate?.valueEntered(textField: nil, text: textField.text ?? "", valueType: self.valueType)
    }
}
