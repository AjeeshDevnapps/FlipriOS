//
//  NotificationSwitchTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 17/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class NotificationSwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var alertActivationSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        let value = UserDefaults.standard.bool(forKey: notificationOnOffValuesKey)
        alertActivationSwitch.isOn = value
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
