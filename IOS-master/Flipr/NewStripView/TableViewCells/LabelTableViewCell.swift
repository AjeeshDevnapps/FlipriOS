//
//  LabelTableViewCell.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 13/11/23.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderColor = UIColor.init(hexString: "3D8FAE").cgColor
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 10
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
