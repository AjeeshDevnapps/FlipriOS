//
//  WaveTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 17/06/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import BAFluidView

class WaveTableViewCell: UITableViewCell {
    @IBOutlet weak var orpView: UIView!
    @IBOutlet weak var orpLabel: UILabel!
    @IBOutlet weak var orpIndicatorImageView: UIImageView!
    @IBOutlet weak var orpStateView: UIView!
    @IBOutlet weak var orpStateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
////        addWave()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addWave(){
        let startElevation = 0.67
        //        let frame = self.view.frame
        var fluidView1 = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral:  startElevation))
        fluidView1.strokeColor = .clear
        fluidView1.fillColor = UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
        fluidView1.fill(to: NSNumber(floatLiteral: startElevation))
        fluidView1.startAnimation()
        self.contentView.addSubview(fluidView1)
        //            fluidView1.clipsToBounds = true
        
        var fluidColor =  UIColor.init(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)

        var fluidView = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral: startElevation))
        fluidView.strokeColor = .clear
        fluidView.fillColor = fluidColor
        fluidView.fill(to: NSNumber(floatLiteral: startElevation))
        fluidView.startAnimation()
        self.contentView.addSubview(fluidView)
       
    }

}
