//
//  StripViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 27/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit


class StripViewController: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "bkWaves.pdf"))

    var recalibration = false
    var isPresentView = false

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var sunInfoLabel: UILabel!
        
    
    @IBOutlet weak var chloreBromeButton: UIButton!
    @IBOutlet weak var totalChloreButton: UIButton!
    @IBOutlet weak var alcalinityButton: UIButton!
    @IBOutlet weak var pHButton: UIButton!
    @IBOutlet weak var hydrotimetricTitleButton: UIButton!
    @IBOutlet weak var cyanudricAcidButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!

    var strip = Strip()
    
    let version2Colors2 = ["255eae","305dad","3b5cad","465aac","5259ab","5d58aa","6856a9","7455a8","7f53a6","8a51a5","fbf3c2","e8efc3","d5eac4","c4e5c5","b1e1c6","9fdcc7","8dd8c8","7bd4ca","69d0ca","57cccb","eaeebe","dedcbd","d2cbbb","c7b9b8","bca7b6","b096b3","a684b0","9c73ac","9362a9","8a51a5","e1b33a","e3a73f","e69c43","e99049","eb844c","ee7650","f26954","f45c57","f84e59","f83e5b","c5d56c","b8c665","abb85d","9eab56","7da65f","5ba067","3d9b70","2b7c6a","1d6163","114858","dbc251","e6a054","f07955","f85055","f84d6a","f84b7e","f64893","cd4092","a53891","7d3190"]
    
    let version2Colors = ["305DAA","3F5EA6","465DA4","5159A4","5B5AA5","5A59A4","6658A2","6E59A4","7955A6","8155A0","F9F1C6","E9ECC6","D8E7C7","C9E2C5","B8DDC8","AAD8C8","9CD4C9","8DD0C8","81CDC8","72C9C7","E8EBC0","E8EBC0","CECBC0","C4B8B7","B7A7B3","AA96B0","A184AC","9178A6","8D62A6","83559D","DBB154","DBA855","DA9E4F","E09253","DE8854","E17C5A","E4705C","DE685D","E85960","E54F5F","C6D376","BBC372","ADB569","9FA961","85A365","6A9D6B","55986F","407A69","2F605F","204655","D8C160","DCA05E","E07E5C","E75C5A","E75A6B","E6597E","E5578F","BD4D8F","99408D","73378B"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))
        doneButton.roundCorner(corner: 12)
//        addBackground()
        /*
        if recalibration == true {
            useNewStripVersion()
        } else if let moduleVersion = Module.currentModule?.version {
            if moduleVersion > 2 {
                useNewStripVersion()
            }
        }
        */
        useNewStripVersion()

        if isPresentView {
            self.closeButton.isHidden = false
        }
        
        
        titleLabel.text = "Contrôle bandelette".localized
//        messageLabel.text = "Grab the strip provided in the package, then dip it in mid-arm in your pool for 2 seconds. Then report the colors obtained below.".localized
        messageLabel.text = "Ce test permet de vérifier que les premières mesures de Flipr sont en adéquation avec la qualité de votre eau. Saisissez la languette fournie sans toucher les carrés colorés, puis plongez-la dans l’eau de votre bassin à mi-bras pendant 2 secondes. Reportez ensuite les couleurs obtenues, ligne par ligne.".localized
        if sunInfoLabel != nil{
            sunInfoLabel.text  = "Nous vous conseillons de régler la luminosité de votre écran au maximum.".localized
        }
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
    
    func addBackground(){
        self.view.backgroundColor =  UIColor.init(hexString: "#F2F9FE")
        imageView.frame = CGRect(x: 0, y: self.view.height - 316, width: self.view.frame.width, height: 316)
        view.addSubview(imageView)
    }
    
    func useNewStripVersion() {
        strip.version = 2
        let allSubviews = self.view.subviewsRecursive()
        for v in allSubviews {
            if let b = v as? UIButton {
             //   print("eeeee: \(b.tag)")
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

//        doneButtonWidthConstraint.constant = 44
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
                        self.showGWInfoView()
//                        self.showFliprSuccessScreen()
//                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewControllerID") {
//                            self.navigationController?.pushViewController(viewController, animated: true)
//                        }
                    }
                    
                }
                
                self.doneButton.hideActivityIndicator()
//                self.doneButtonWidthConstraint.constant = 200
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            })
            
        }
        
    }
    
    
    
    func showFliprSuccessScreen(){
        let sb =  UIStoryboard(name: "Calibration", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: "CalibrationSuccessViewController") as! CalibrationSuccessViewController
        viewController.recalibration = self.recalibration
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showGWInfoView(){
        if AppSharedData.sharedInstance.isFlipr3{
            showGatewaySetup()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
            dashboard.modalTransitionStyle = .flipHorizontal
            dashboard.modalPresentationStyle = .fullScreen
            self.present(dashboard, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: false)
            })
        }
    }
    
    
    func showGatewaySetup(){
        let storyboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddGatewayIntroViewController") as! AddGatewayIntroViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

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
