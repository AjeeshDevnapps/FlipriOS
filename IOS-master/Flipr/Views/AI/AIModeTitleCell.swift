//
//  TableViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 01/12/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit



class AIModeTitleCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class AIResetCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.text = "".localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class AIModeSelectionCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var selctionBtn: UIButton!
    @IBOutlet weak var selectionImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.text = "".localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
