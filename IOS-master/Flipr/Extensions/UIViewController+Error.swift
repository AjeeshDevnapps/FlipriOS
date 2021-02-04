//
//  UIViewController+Error.swift
//  UGGO
//
//  Created by Benjamin McMurrich on 23/02/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

extension UIViewController {
    
    func showError(title:String?, message:String?) {
        let hud = JGProgressHUD.init(style: .dark)
        hud?.indicatorView = JGProgressHUDErrorIndicatorView()
        if let title = title {
            hud?.textLabel.text = title
        }
        if let message = message {
            hud?.detailTextLabel.text = message
        }
        hud?.show(in: self.view)
        hud?.dismiss(afterDelay: 3.0)
    }
    
    func showSuccess(title:String?, message:String?) {
        let hud = JGProgressHUD.init(style: .dark)
        hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
        if let title = title {
            hud?.textLabel.text = title
        }
        if let message = message {
            hud?.detailTextLabel.text = message
        }
        hud?.show(in: self.view)
        hud?.dismiss(afterDelay: 3.0)
    }
    
}
