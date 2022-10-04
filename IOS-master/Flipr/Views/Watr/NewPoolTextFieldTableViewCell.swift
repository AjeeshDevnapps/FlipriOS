//
//  NewPoolTextFieldTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 29/08/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class NewPoolTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var inputType: UIKeyboardType = .numberPad
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.keyboardType = inputType
        textField.becomeFirstResponder()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
