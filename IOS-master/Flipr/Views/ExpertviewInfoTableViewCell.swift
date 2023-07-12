//
//  ExpertviewInfoTableViewCell.swift
//  Flipr
//
//  Created by Ajish on 12/07/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class ExpertviewInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var phValLbl: UILabel!
    @IBOutlet weak var phLbl: UILabel!
    
    @IBOutlet weak var redoxValLbl: UILabel!
    @IBOutlet weak var redoxLbl: UILabel!

    
    @IBOutlet weak var airTempValLbl: UILabel!
    @IBOutlet weak var airTempLbl: UILabel!

    @IBOutlet weak var waterTempValLbl: UILabel!
    @IBOutlet weak var waterTempLbl: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




class ExpertviewCalibrationInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calibrationTilteLbl: UILabel!

    @IBOutlet weak var ph4ValLbl: UILabel!
    @IBOutlet weak var ph4Lbl: UILabel!
    @IBOutlet weak var ph4DateLbl: UILabel!

    
    @IBOutlet weak var ph7ValLbl: UILabel!
    @IBOutlet weak var ph7Lbl: UILabel!
    @IBOutlet weak var ph7DateLbl: UILabel!

    
    @IBOutlet weak var newCalibrationBtn: UIButton!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
