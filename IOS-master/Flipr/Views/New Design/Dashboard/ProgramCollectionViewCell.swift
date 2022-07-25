//
//  ProgramCollectionViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 24/06/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit



class ProgramCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var shadowView: UIView!

    @IBOutlet weak var buttonShadowView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!

    func addShadow(){
        buttonShadowView.roundCorner(corner: buttonShadowView.frame.height / 2)
        buttonShadowView.addShadow(offset: CGSize.init(width: 0, height: 3), color:UIColor(red: 0.621, green: 0.633, blue: 0.677, alpha: 0.13), radius: 14, opacity:1)

    }

}
