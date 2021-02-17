//
//  AccountViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 17/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit


private var shadowLayer: CAShapeLayer!
private var cornerRadius: CGFloat = 25.0
private var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor

class AccountViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var subscriptionLabel: UILabel!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var subscriptionContainerView: UIView!
    private var shadowLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"

        detailsContainerView.clipsToBounds = true
        detailsContainerView.layer.cornerRadius = 15.0
        detailsContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)
        
        subscriptionContainerView.clipsToBounds = true
        subscriptionContainerView.layer.cornerRadius = 15.0
        subscriptionContainerView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 15.0, opacity: 0.21)

        showDetails()
    }
    
    
    func showDetails(){
        self.emailLabel.text = User.currentUser?.email
        self.firstNameTxtFld.text = User.currentUser?.firstName
        self.lastNameTxtFld.text = User.currentUser?.lastName

    }
    
    
//    func addShadowLayers(){
//        if shadowLayer == nil {
//               shadowLayer = CAShapeLayer()
//
//                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10.0).cgPath
//               shadowLayer.shadowColor = UIColor.black.cgColor
//               shadowLayer.shadowPath = shadowLayer.path
//               shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//               shadowLayer.shadowOpacity = 0.2
//               shadowLayer.shadowRadius = 3
//
//               layer.insertSublayer(shadowLayer, at: 0)
//           }
//    }

   

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
}
