//
//  FliprSettingsTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 18/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class FliprSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var serialNoLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!

    @IBOutlet weak var lastMesureLbl: UILabel!
    @IBOutlet weak var batteryInfoLbl: UILabel!
    @IBOutlet weak var firmwareVerLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        container1.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container2.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container3.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
