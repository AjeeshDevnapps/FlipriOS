//
//  NumericTextField.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 02/12/23.
//

import UIKit

class NumericTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up the text field to allow only numbers
        keyboardType = .numberPad
        delegate = self
    }

}

extension NumericTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow backspace
        if string.isEmpty {
            return true
        }
        
        // Allow only numeric characters
        let allowedCharacterSet = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: characterSet)
    }
}
