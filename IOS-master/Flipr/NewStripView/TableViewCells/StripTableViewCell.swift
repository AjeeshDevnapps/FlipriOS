//
//  StripTableViewCell.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 13/11/23.
//

import UIKit

class StripTableViewCell: UITableViewCell {

    @IBOutlet weak var stripView: StripsView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
