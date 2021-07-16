//
//  HubDeviceTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 16/07/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

protocol HubDeviceDelegate {
    func didSelectSettingsButton()
}

class HubDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var innerContainerViewView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var modeNameLbl: UILabel!
    var delegate:HubDeviceDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.innerContainerViewView.roundCorner(corner: 12)
        innerContainerViewView.addShadow(offset: CGSize.init(width: 0, height: 3), color:UIColor(red: 0.621, green: 0.633, blue: 0.677, alpha: 0.13), radius: 14, opacity:1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tapSettingsButton(){
        self.delegate?.didSelectSettingsButton()
    }
}
