//
//  DashCollectionViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 22/10/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class DashCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textWrappingView: UIView!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
