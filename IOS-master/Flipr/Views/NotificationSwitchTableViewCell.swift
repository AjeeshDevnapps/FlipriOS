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


class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var alertActivationSwitch: UISwitch!
    @IBOutlet weak var poolContainerView: UIView!
    @IBOutlet weak var devicesContainerView: UIView!
    @IBOutlet weak var accountContainerView: UIView!
    @IBOutlet weak var notificationContainerView: UIView!
    @IBOutlet weak var logoutContainerView: UIView!
    
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var poolLbl: UILabel!
    @IBOutlet weak var devicesLbl: UILabel!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var logoutLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        let value = UserDefaults.standard.bool(forKey: notificationOnOffValuesKey)
        alertActivationSwitch.isOn = value
        self.setupViews()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setupViews(){
        accountLbl.text = "Account".localized
        poolLbl.text = "Pool".localized
        devicesLbl.text = "Devices".localized
        notificationLbl.text = "Disable Flipr alerts and notifications".localized
        logoutLbl.text = "LOGOUT_TITLE".localized

        accountContainerView.layer.cornerRadius = 15.0
        accountContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        poolContainerView.layer.cornerRadius = 15.0
        poolContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        devicesContainerView.layer.cornerRadius = 15.0
        devicesContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        notificationContainerView.layer.cornerRadius = 27.0
        notificationContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        logoutContainerView.layer.cornerRadius = 15.0
        logoutContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
    }

}
