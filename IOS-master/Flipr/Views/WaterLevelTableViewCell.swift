//
//  WaterLevelTableViewCell.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 18/04/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit

class WaterLevelButton: UIButton {
    var waterLevel:WaterLevel?
}

class WaterLevelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityProgressView: UIProgressView!
    @IBOutlet weak var deleteButton: WaterLevelButton!
    
    var waterLevel:WaterLevel? {
        didSet {
            self.dateLabel.text = "Draining date:".localized + " " + (waterLevel?.date.dateString())!
            self.quantityLabel.text = "Fill percentage:".localized + " \(String(format:"%.0f",(1 - (waterLevel?.fillPercentage)!) * 100)) %"
            self.quantityProgressView.setProgress(Float((1 - (waterLevel?.fillPercentage)!)), animated: true)
            self.deleteButton.waterLevel = waterLevel
            quantityProgressView.layer.cornerRadius = 4
            quantityProgressView.clipsToBounds = true
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
