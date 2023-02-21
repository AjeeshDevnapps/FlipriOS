//
//  EqipmentsTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 21/02/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit


protocol EqipmentsTableViewCellDelegate{
    func didSelectSettingsButton(deviceInfo:Equipments?)
}

class EqipmentsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    var delegate:EqipmentsTableViewCellDelegate?
    var deviceInfo:Equipments?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func settingsButtonAction() {
        self.delegate?.didSelectSettingsButton(deviceInfo: self.deviceInfo)
    }

}
