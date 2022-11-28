//
//  LocationTypeTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 01/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class LocationTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var disableView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
