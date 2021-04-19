//
//  CustomTextField.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 06/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {

    var externalDelegate: UITextFieldDelegate?
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.placeholderColor(color: #colorLiteral(red: 0.5921568627, green: 0.6392156863, blue: 0.7137254902, alpha: 1))
        self.textColor = #colorLiteral(red: 0.06666666667, green: 0.09019607843, blue: 0.1607843137, alpha: 1)
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        delegate = self
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Editing begun")
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor.white.cgColor
        color.toValue = UIColor.black.cgColor
        color.duration = 0.25
        color.repeatCount = 1
        textField.layer.add(color, forKey: "borderColor")
        textField.layer.borderColor = UIColor.black.cgColor
        
        textField.layer.borderWidth = 1
        
        textField.tintColor = .black
        externalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.white.cgColor
        externalDelegate?.textFieldDidEndEditing?(textField)
    }
}

extension UITextField {
    func addPaddingRightButton(target: UIViewController,
                               _ image: UIImage,
                               selectedImage: UIImage? = nil,
                               padding: CGFloat = 0,
                               action: Selector) {
        let parent = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: image.size.width + padding,
                                          height: image.size.height))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        button.setImage(image, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.contentMode = .center
        button.addTarget(target, action: action, for: .touchUpInside)
        parent.addSubview(button)
        rightView = parent
        rightViewMode = .always
    }
}
