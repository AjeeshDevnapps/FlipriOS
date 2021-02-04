//
//  UIButton+activity.swift
//  UGGO
//
//  Created by Benjamin McMurrich on 22/02/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

let kActivityIndicatorViewTag = 847462499

extension UIButton {
    
    func showActivityIndicator() {
        showActivityIndicator(type: .ballClipRotate, color: self.tintColor)
    }
    
    func showActivityIndicator(type:NVActivityIndicatorType) {
        showActivityIndicator(type: type, color: self.tintColor)
    }
    
    func showActivityIndicator(type:NVActivityIndicatorType, color:UIColor) {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: (self.bounds.width - 25)/2, y: (self.bounds.height - 25)/2, width: 25, height: 25), type: type, color: color, padding: 0)
        indicator.startAnimating()
        indicator.tag = kActivityIndicatorViewTag
        indicator.alpha = 0
        self.setTitleColor(.clear, for: .normal)
        self.addSubview(indicator)
        UIView.animate(withDuration: 0.25, animations: {
            indicator.alpha = 1
        })
    }
    
    func hideActivityIndicator() {
        var activityIndicatorView = self.viewWithTag(kActivityIndicatorViewTag)
        activityIndicatorView?.removeFromSuperview()
        self.setTitleColor(self.tintColor, for: .normal)
        activityIndicatorView = nil
    }
}
