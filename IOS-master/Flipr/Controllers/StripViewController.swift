//
//  StripViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 27/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit


class StripViewController: UIViewController {

    var recalibration = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    @IBOutlet weak var chloreBromeButton: UIButton!
    @IBOutlet weak var totalChloreButton: UIButton!
    @IBOutlet weak var alcalinityButton: UIButton!
    @IBOutlet weak var pHButton: UIButton!
    @IBOutlet weak var hydrotimetricTitleButton: UIButton!
    @IBOutlet weak var cyanudricAcidButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneButtonWidthConstraint: NSLayoutConstraint!
    
    var strip = Strip()
    
    let version2Colors = ["255eae","305dad","3b5cad","465aac","5259ab","5d58aa","6856a9","7455a8","7f53a6","8a51a5","fbf3c2","e8efc3","d5eac4","c4e5c5","b1e1c6","9fdcc7","8dd8c8","7bd4ca","69d0ca","57cccb","eaeebe","dedcbd","d2cbbb","c7b9b8","bca7b6","b096b3","a684b0","9c73ac","9362a9","8a51a5","e1b33a","e3a73f","e69c43","e99049","eb844c","ee7650","f26954","f45c57","f84e59","f83e5b","c5d56c","b8c665","abb85d","9eab56","7da65f","5ba067","3d9b70","2b7c6a","1d6163","114858","dbc251","e6a054","f07955","f85055","f84d6a","f84b7e","f64893","cd4092","a53891","7d3190"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))

        if recalibration == true {
            useNewStripVersion()
        } else if let moduleVersion = Module.currentModule?.version {
            if moduleVersion > 2 {
                useNewStripVersion()
            }
        }
        
        
        titleLabel.text = "Your last strip".localized
        messageLabel.text = "Grab the strip provided in the package, then dip it in mid-arm in your pool for 2 seconds. Then report the colors obtained below.".localized
        warningLabel.text = "The colorimetry varies according to the smartphone screens. For more precision, refer to the instructions supplied with the strip to determine the colors and refer to them above.".localized
        doneButton.setTitle("Validate!".localized, for: .normal)
        
        if let module = Module.currentModule {
            if module.isForSpa {
                messageLabel.text = "Grab the strip provided in the package, then dip it in mid-arm in your spa for 2 seconds. Then report the colors obtained below.".localized
            }
        }

    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func useNewStripVersion() {
        strip.version = 2
        let allSubviews = self.view.subviewsRecursive()
        for v in allSubviews {
            if let b = v as? UIButton {
                print("eeeee: \(b.tag)")
                if b.tag > 0 {
                    b.backgroundColor = version2Colors[b.tag - 1].hexStringColor()
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func valueButtonAction(_ sender: Any) {
        if let button = sender as? UIButton {
            print("Selected button \(button.tag)")
            
            if strip.version == 2 {
                if button.tag <= 10 {
                    clearButtons(atLine: 1)
                    chloreBromeButton.backgroundColor = button.backgroundColor
                    strip.hydrotimetricTitle = Double(button.tag)
                } else if button.tag <= 20 {
                    clearButtons(atLine: 2)
                    totalChloreButton.backgroundColor = button.backgroundColor
                    strip.totalChlore = Double(button.tag - 10)
                } else if button.tag <= 30 {
                    clearButtons(atLine: 3)
                    alcalinityButton.backgroundColor = button.backgroundColor
                    strip.chloreBrome = Double(button.tag - 20)
                } else if button.tag <= 40 {
                    clearButtons(atLine: 4)
                    pHButton.backgroundColor = button.backgroundColor
                    strip.pH = Double(button.tag - 30)
                } else if button.tag <= 50 {
                    clearButtons(atLine: 5)
                    hydrotimetricTitleButton.backgroundColor = button.backgroundColor
                    strip.alcalinity = Double(button.tag - 40)
                } else if button.tag <= 60 {
                    clearButtons(atLine: 6)
                    cyanudricAcidButton.backgroundColor = button.backgroundColor
                    strip.cyanudricAcid = Double(button.tag - 50)
                }
            } else {
                if button.tag <= 10 {
                    clearButtons(atLine: 1)
                    chloreBromeButton.backgroundColor = button.backgroundColor
                    strip.chloreBrome = Double(button.tag)
                } else if button.tag <= 20 {
                    clearButtons(atLine: 2)
                    totalChloreButton.backgroundColor = button.backgroundColor
                    strip.totalChlore = Double(button.tag - 10)
                } else if button.tag <= 30 {
                    clearButtons(atLine: 3)
                    alcalinityButton.backgroundColor = button.backgroundColor
                    strip.alcalinity = Double(button.tag - 20)
                } else if button.tag <= 40 {
                    clearButtons(atLine: 4)
                    pHButton.backgroundColor = button.backgroundColor
                    strip.pH = Double(button.tag - 30)
                } else if button.tag <= 50 {
                    clearButtons(atLine: 5)
                    hydrotimetricTitleButton.backgroundColor = button.backgroundColor
                    strip.hydrotimetricTitle = Double(button.tag - 40)
                } else if button.tag <= 60 {
                    clearButtons(atLine: 6)
                    cyanudricAcidButton.backgroundColor = button.backgroundColor
                    strip.cyanudricAcid = Double(button.tag - 50)
                }
            }
            
            
            button.borderColor = UIColor.white
            button.borderWidth = 2
        }
    }
    
    func clearButtons(atLine line:Int) {
        let start = (line - 1) * 10
        let end = start + 10
        for index in start ... end {
            if let button = view.viewWithTag(index) as? UIButton {
                button.borderColor = .clear
            }
        }
    }

    @IBAction func doneButtonAction(_ sender: Any) {

        doneButtonWidthConstraint.constant = 44
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            
                
            self.doneButton.showActivityIndicator(type: .ballClipRotatePulse)
        
            self.strip.send(completion: { (error) in
                if error != nil {
                    if error?.code == 401 {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    }
                } else {
                    if self.recalibration {
                        NotificationCenter.default.post(name: FliprLogDidChanged, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewControllerID") {
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                    
                }
                
                self.doneButton.hideActivityIndicator()
                self.doneButtonWidthConstraint.constant = 200
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            })
            
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView {
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
}

extension String {
    
    func hexStringColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
