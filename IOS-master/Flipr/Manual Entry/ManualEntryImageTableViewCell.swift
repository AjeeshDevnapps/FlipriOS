//
//  ManualOneTableViewCell.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 28/11/23.
//

import UIKit

class ManualEntryImageTableViewCell: UITableViewCell {

    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var firstTitleText: UILabel!
    @IBOutlet weak var secondUnitLabel: UILabel!
    var input: DualEntryImage? {
        didSet {
            updateValues()
        }
    }
    var valueType: TextValueType!
    var delegate: ManualEntryTableViewCellDelegate?
    @IBOutlet weak var firstImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateValues() {
        if let image = input?.imageName {
            firstImageView.image = UIImage(named: image)
        }
        if let image = input?.secondImageName {
            secondImageView.image = UIImage(named: image)
        }
        firstTextField.text = input?.firstInitialValue
        secondTextField.text = input?.secondInitialValue
        firstTitleText.text = input?.text
        secondUnitLabel.text = input?.secondValueUnit
    }
    
    
    
    @IBAction func firstTextChanged(_ sender: UITextField) {
        guard sender.text != "" else { return }
        delegate?.firstTextFieldUpdated(textField: sender, value: sender.text ?? "", valueType: valueType)
    }
    
    @IBAction func secondTextChanged(_ sender: UITextField) {
        guard sender.text != "" else { return }
        delegate?.secondTextFieldUpdated(textField: sender, value: sender.text ?? "", valueType: valueType)
    }
    
    
    @IBAction func firstTextFieldBtnClicked(_ sender: UIButton) {
        delegate?.firstTextFieldUpdated(textField: nil, value: firstTextField.text ?? "", valueType: valueType)
    }
    
    @IBAction func secondTextFieldBtnClicked(_ sender: UIButton) {
        delegate?.secondTextFieldUpdated(textField: nil, value: secondTextField.text ?? "", valueType: valueType)
    }
}
