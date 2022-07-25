//
//  WifiListTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class WifiListTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var wifiNameLabel: UILabel!
    @IBOutlet weak var wifiImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 12
        containerView.addShadow(offset: CGSize(width: 0, height: 2),
                                color: UIColor(red: 0, green: 0.071, blue: 0.278, alpha: 0.14),
                                radius: 10.0,
                                opacity: 1)
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
