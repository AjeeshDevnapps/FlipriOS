//
//  RoundBorderedButton.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class RoundBorderedButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
            super.layoutSubviews()
            setup()
        }

        func setup() {
            self.clipsToBounds = true
            self.layer.cornerRadius = 12.0
        }

}
