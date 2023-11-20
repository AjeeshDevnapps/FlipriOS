//
//  PaletteCollectionViewCell.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 11/11/23.
//

import UIKit

class PaletteCollectionViewCell: UICollectionViewCell {

    let circleDiameter: CGFloat = 10.0
    let circleColor: UIColor = UIColor.white
    var selectedCell = false {
        didSet {
            setNeedsDisplay()
        }
    }
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if selectedCell {
            drawCircle()
        }
    }

    func drawCircle() {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let circleRect = CGRect(
            x: (bounds.width - circleDiameter) / 2,
            y: (bounds.height - circleDiameter) / 2,
            width: circleDiameter,
            height: circleDiameter
        )

        context.setFillColor(circleColor.cgColor)
        context.fillEllipse(in: circleRect)
    }

    override var isSelected: Bool {
        didSet {
//            setNeedsDisplay()
        }
    }
}
