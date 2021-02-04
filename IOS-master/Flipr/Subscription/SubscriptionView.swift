//
//  SubscriptionView.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 15/04/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit

class SubscriptionView: UIView {

    var subscription:Subscription? {
        didSet {
            
            if let view  = self.viewWithTag(5) {
                view.layer.borderColor = K.Color.LightBlue.cgColor
                view.layer.borderWidth = 2
                view.layer.cornerRadius = 7
                view.clipsToBounds = true
            }
            
            
            if subscription != nil {
                if let label = self.viewWithTag(1) as? UILabel {
                    label.text = subscription!.label
                }
                if let label = self.viewWithTag(2) as? UILabel {
                    if subscription!.label == "1" {
                        label.text = "month".localized()
                    } else {
                        label.text = "months".localized()
                    }
                }
                if let label = self.viewWithTag(3) as? UILabel {
                    label.text = subscription!.formattedPrice
                }
                if let label = self.viewWithTag(4) as? UILabel {
                    //label.text = "(soit \(subscription!.formattedPrice))"
                    label.text = "(\("ie".localized) \(subscription!.formattedMonthPrice)/\("month".localized))"
                }
            }
        }
    }
    
    func setSelected(_ selected:Bool) {
        if selected {
            for view in self.subviews {
                if let label  = view as? UILabel {
                    label.textColor = .white
                }
            }
            if let view  = self.viewWithTag(5) {
                view.backgroundColor = K.Color.LightBlue
            }
            if let view  = self.viewWithTag(6) {
                view.isHidden = false
            }
        } else {
            for view in self.subviews {
                if let label  = view as? UILabel {
                    label.textColor = K.Color.LightBlue
                }
            }
            if let view  = self.viewWithTag(5) {
                view.backgroundColor = .white
            }
            if let view  = self.viewWithTag(6) {
                view.isHidden = true
            }
        }
        
    }
}
