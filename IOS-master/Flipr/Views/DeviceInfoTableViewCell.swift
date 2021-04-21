//
//  DeviceInfoTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit




class DeviceInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var keyIdLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var modelTitleLabel: UILabel!
    @IBOutlet weak var serialTitleLabel: UILabel!
    @IBOutlet weak var keyIdTitleLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        modelTitleLabel.text = "Model".localized
        serialTitleLabel.text = "Serial Number".localized
        keyIdTitleLabel.text = "Key ID".localized
        titleLabel.text = "Details".localized

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class DeviceWifiInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var wifeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        wifeView.layer.cornerRadius = 10.0
        titleLabel.text = "Last Measure".localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class DeviceWifiStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var wifeView: UIView!
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var modeTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        wifeView.layer.cornerRadius = 10.0
        statusTitleLabel.text = "Status :".localized
        modeTitleLabel.text = "Actual Mode :".localized

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class DeviceActionTableViewCell: UITableViewCell {
    @IBOutlet weak var actionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var forgetDeviceLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15.0
        containerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        actionLabel.text = "ActionsTitle".localized
        forgetDeviceLabel.text = "Forget this device".localized

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
