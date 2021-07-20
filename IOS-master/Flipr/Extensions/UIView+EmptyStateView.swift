//
//  EmptyState.swift
//  UGGO
//
//  Created by Benjamin McMurrich on 14/02/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let kStackViewTag = 4321

extension UIView {
    
    func showEmptyStateViewLoading(title: String?, message:String?) {
        showEmptyStateView(activityIndicatorType:EmptyStateViewTheme.shared.activityIndicatorType, image: nil, title: title, message: message, buttonTitle: nil, buttonAction: nil, theme:EmptyStateViewTheme.shared)
    }
    
    func showEmptyStateViewLoading(title: String?, message:String?, theme:EmptyStateViewTheme) {
        showEmptyStateView(activityIndicatorType:EmptyStateViewTheme.shared.activityIndicatorType, image: nil, title: title, message: message, buttonTitle: nil, buttonAction: nil, theme:theme)
    }

    func showEmptyStateView(image:UIImage?, title: String?, message:String?) {
        showEmptyStateView(activityIndicatorType:nil, image: image, title: title, message: message, buttonTitle: nil, buttonAction: nil, theme:EmptyStateViewTheme.shared)
    }
    
    func showEmptyStateView(image:UIImage?, title: String?, message:String?, theme:EmptyStateViewTheme) {
        showEmptyStateView(activityIndicatorType:nil, image: image, title: title, message: message, buttonTitle: nil, buttonAction: nil, theme:theme)
    }
    
    func showEmptyStateView(image: UIImage?, title: String?, message:String?, buttonTitle:String?, buttonAction:(_: () -> Void)?) {
        showEmptyStateView(activityIndicatorType:nil, image: image, title: title, message: message, buttonTitle: buttonTitle, buttonAction: buttonAction, theme:EmptyStateViewTheme.shared)
    }
    
    func showEmptyStateView(image: UIImage?, title: String?, message:String?, buttonTitle:String?, buttonAction:(_: () -> Void)?, theme:EmptyStateViewTheme) {
        showEmptyStateView(activityIndicatorType:nil, image: image, title: title, message: message, buttonTitle: buttonTitle, buttonAction: buttonAction, theme:EmptyStateViewTheme.shared)
    }
    
    private func showEmptyStateView(activityIndicatorType:NVActivityIndicatorType?, image: UIImage?, title: String?, message:String?, buttonTitle:String?, buttonAction:(_: () -> Void)?, theme:EmptyStateViewTheme) {
        
        hideStateView()
        
        let margin:CGFloat = theme.margin
        
        let stackView = UIStackView()
        stackView.tag = kStackViewTag
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 8.0
        
        if let activityIndicatorType = activityIndicatorType {
            let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: activityIndicatorType, color: theme.activityIndicatorColor, padding: 0)
            indicator.startAnimating()
            stackView.addArrangedSubview(indicator)
            
            let margeView = UIView()
            margeView.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
            stackView.addArrangedSubview(margeView)
            
        } else if let image = image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
            
            let margeView = UIView()
            margeView.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
            stackView.addArrangedSubview(margeView)
        }
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.text = title
            titleLabel.font = theme.titleFont
            titleLabel.numberOfLines = 0
            titleLabel.textColor = theme.titleColor
            titleLabel.widthAnchor.constraint(equalToConstant: self.bounds.width - (2 * margin)).isActive = true
            stackView.addArrangedSubview(titleLabel)
        }
        
        if let message = message {
            let messageLabel = UILabel()
            messageLabel.textAlignment = .center
            messageLabel.text = message
            messageLabel.font = theme.messageFont
            messageLabel.numberOfLines = 0
            messageLabel.textColor = theme.titleColor
            messageLabel.widthAnchor.constraint(equalToConstant: self.bounds.width - (2 * margin)).isActive = true
            stackView.addArrangedSubview(messageLabel)
        }
        
        if (buttonTitle != nil) && (buttonAction != nil) {
            
            let margeView = UIView()
            margeView.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
            stackView.addArrangedSubview(margeView)
            
            let button = BlockButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.backgroundColor = .white
            button.tintColor = theme.buttonTintColor
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.layer.cornerRadius = 22
            button.contentEdgeInsets = UIEdgeInsets.init(top: 0,left: 32,bottom: 0,right: 32)
            button.clipsToBounds = true
            button.touchUpInside {
                buttonAction?()
            }
            stackView.addArrangedSubview(button)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addSubview(stackView)
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    
//        let val =  stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//        val.isActive = true
//        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 200).isActive  = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150).isActive = true
    }
    
    func hideStateView() {
        var stackView = self.viewWithTag(kStackViewTag)
        stackView?.removeFromSuperview()
        stackView = nil
    }
    
}

class EmptyStateViewTheme {
    
    static let shared : EmptyStateViewTheme = {
        let instance = EmptyStateViewTheme()
        return instance
    }()
    
    var margin:CGFloat = 32.0
    var tintColor:UIColor
    var activityIndicatorType:NVActivityIndicatorType = .ballPulse
    var activityIndicatorColor:UIColor
    var titleColor:UIColor = .gray
    var titleFont:UIFont = UIFont.boldSystemFont(ofSize: 16)
    var messageColor:UIColor = .gray
    var messageFont:UIFont = UIFont.systemFont(ofSize: 14)
    var buttonTintColor:UIColor
    
    init() {
        let windowTintColor = UIApplication.shared.delegate?.window??.tintColor
        if windowTintColor != nil {
            tintColor = windowTintColor!
        } else {
            tintColor = .gray
        }
        activityIndicatorColor = tintColor
        //activityIndicatorColor = .lightText
        buttonTintColor = tintColor
    }
}

class BlockButton: UIButton {
    
    var touchUpInsideBlock:(_: () -> Void)?
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
    
    func touchUpInside(block: @escaping () -> Void) {
        touchUpInsideBlock = block
    }
    
    @objc func didTouchUpInside() {
        touchUpInsideBlock?()
    }
}
