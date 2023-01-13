//
//  NewPoolSettingsTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 19/08/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class NewPoolSettingsTableViewCell: UITableViewCell {

    var isToggle: Bool = false
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var valueText: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!

    var switchy: UISwitch = UISwitch()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func makeCellAsToggle() {
        valueText.isHidden = true
        accessoryView = switchy
    }
    
    func makeCellAcceptText() {
        valueText.isHidden = false
        accessoryType = .disclosureIndicator
    }
    
    func applyUndefinedUI() {
        valueText.textColor = .red
        titleName.textColor = .red
        valueText.text = "Definir"
        switchy.setOn(false, animated: true)
    }
}
