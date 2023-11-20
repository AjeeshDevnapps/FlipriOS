//
//  Color.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 12/11/23.
//

import UIKit

struct Color: Decodable {
    let name: String
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
//    let hexValue: String

    var uiColor: UIColor {
//        return UIColor.init(hexString: hexValue)
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
