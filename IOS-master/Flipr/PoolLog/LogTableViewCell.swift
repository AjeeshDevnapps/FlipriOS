//
//  LogTableViewCell.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 25/07/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit
import AlamofireImage

class LogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var endLineView: UIView!
    
    var log:Log! {
        didSet {
            titleLabel.text = log.title
            colorView.backgroundColor = log.type.color()
            if let url = URL(string: log.iconUrl) {
                iconImageView.af_setImage(withURL: url)
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd MMM"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            dateLabel.text = formatter.string(from: log.date) + "\n" + timeFormatter.string(from: log.date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
