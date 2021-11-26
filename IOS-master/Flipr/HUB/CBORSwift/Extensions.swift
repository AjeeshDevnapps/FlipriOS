//
//  Data.swift
//  CBORSwift
//
//  Created by Hassan Shahbazi on 5/3/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import Foundation

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if let t: String = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

extension Data {
    public var bytes: [UInt8] {
        return [UInt8](self)
    }
    
    public var binary_decimal: Int {
        var str = ""
        for bit in self.bytes {
            str.append("\(bit)")
        }
        return Int(str, radix: 2)!
    }
    
    public var hex: String {
        var str = ""
        for byte in self.bytes {
            str = str.appendingFormat("%02x", UInt(byte))
        }
        return str
    }
    
    public var string: String {
        return String.init(data:self, encoding: .utf8)!
    }
}

extension Int {
    public var decimal_binary: [UInt8] {
        return String(self, radix: 2).bytes
    }
    
    public var hex: String {
        var hexStr = String(self, radix: 16).uppercased()
        if hexStr.count == 1 {
            hexStr = "0\(hexStr)"
        }
        return hexStr
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public var bytes: [UInt8] {
        var bits = [UInt8]()
        for index in 0..<self.count {
            let chr = self[index..<index+1]
            let chrInt = Int(chr)!
            bits.append(UInt8(chrInt))
        }

        if bits.count % 8 == 0 {
            return bits
        }
        
        var bitDiff = (bits.count / 8) + 1
        if bitDiff > 8 {
            bitDiff = 16
        }
        else if bitDiff > 4 {
            bitDiff = 8
        }
        else if bitDiff > 2 {
            bitDiff = 4
        }
        
        var bitsArray =  [UInt8](repeating:0, count: (8 * bitDiff) - bits.count)
        bitsArray.append(contentsOf: bits)
        return bitsArray
    }
    
    public var data: Data? {
        let data = NSMutableData(capacity: self.count)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)
            data?.append(&num, length: 1)
        }
        return data as Data?
    }
    
    public var hex: String {
        return self.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 16, uppercase: true) }
    }
    
    public var hex_ascii: String {
        var chars = [Character]()
        for c in self {
            chars.append(c)
        }
        
        let numbers =  stride(from: 0, to: chars.count, by: 2).map{
            strtoul(String(chars[$0 ..< $0+2]), nil, 16)
        }
        
        var final = ""
        var i = 0
        
        while i < numbers.count {
            final.append(Character(UnicodeScalar(Int(numbers[i]))!))
            i += 1
        }
        return final
    }
    
    public var ascii_bytes: [UInt8] {
        return self.data(using: .ascii)!.bytes
    }
    
    public var hex_decimal: Int {
        return Int(self, radix: 16)!
    }
    
    public var hex_binary: [UInt8] {
        return String(Int(self, radix: 16)!, radix: 2).bytes
    }
}

extension NSString {
    public var hex: String {
        return String(self).utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 16, uppercase: true) }
    }

    public var ascii_bytes: [UInt8] {
        return String(self).ascii_bytes
    }
}



extension Array where Element == UInt8 {
    public var hex_decimal: Int {
        var str = ""
        for bit in self {
            str.append("\(bit)")
        }
        return Int(str, radix: 16)!
    }
    
    public var binary_decimal: Int {
        var str = ""
        for bit in self {
            str.append("\(bit)")
        }
        return Int(str, radix: 2)!
    }
}

extension Dictionary where Value: Comparable, Key: Comparable {
    var valueKeySorted: [(Key, Value)] {
        return sorted {
            if $0.0 != $1.0 {
                return $0.0 < $1.0
            }
            else if $0.1 != $1.1 {
                return $0.1 < $1.1
            }
            return $0.0 == $1.0
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributeString)
    }
}


extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func roundCorner(corner:CGFloat){
        layer.cornerRadius = corner
        clipsToBounds = true
    }
    
    func fullyRoundCorner(){
        layer.cornerRadius = self.frame.size.height /  2
        clipsToBounds = true
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIViewController {

func setupNavigationMultilineTitle() {
    guard let navigationBar = self.navigationController?.navigationBar else { return }
    for sview in navigationBar.subviews {
        for ssview in sview.subviews {
            guard let label = ssview as? UILabel else { break }
            if label.text == self.title {
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.sizeToFit()
                UIView.animate(withDuration: 0.3, animations: {
                    navigationBar.frame.size.height = 57 + label.frame.height
                })
            }
        }
    }
}
}

extension LosslessStringConvertible {
    var toString: String { .init(self) }
}

extension FloatingPoint where Self: CVarArg {
    func fixedFraction(digits: Int) -> String {
        .init(format: "%.*f", digits, self)
    }
}
