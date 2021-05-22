//
//  FliprSplashViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 31/03/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

extension UIView {


    func rotate(degrees: CGFloat) {

        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))

        // If you like to use layer you can uncomment the following line
        //layer.transform = CATransform3DMakeRotation(degreesToRadians(degrees), 0.0, 0.0, 1.0)
    }
}

class FliprSplashViewController: UIViewController {
    @IBOutlet weak var rightAnimationImageView: UIImageView!
    @IBOutlet weak var leftAnimationImageView: UIImageView!
    @IBOutlet weak var waveAnimationImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var rightAnimationContainerView: UIView!
    
    @IBOutlet weak var waveAnimationImageViewYpost: NSLayoutConstraint!
    @IBOutlet weak var logoImageViewYpost: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        perform(#selector(showWaveAnimation), with: nil, afterDelay: 0.5)

        addRightImage()
    }
    
    
    @objc func showEducationScreen(){
        
    }
    
    
    func addRightImage(){
        self.rightAnimationImageView.transform = CGAffineTransform(translationX: 110.0, y: 0.0)
        self.leftAnimationImageView.transform = CGAffineTransform(translationX: -58.0, y: 0.0)

        UIView.animate(withDuration: 1, animations: {
            let rightRotationMatrix = CGAffineTransform(rotationAngle: -0.01)
            let rightTranslationMatrix = CGAffineTransform(translationX: 0.0, y: 0.0)
            self.rightAnimationImageView.transform = rightRotationMatrix.concatenating(rightTranslationMatrix)
            let leftRotationMatrix = CGAffineTransform(rotationAngle: 0.01)
            let leftTranslationMatrix = CGAffineTransform(translationX: 0.0, y: 0.0)
            self.leftAnimationImageView.transform = leftRotationMatrix.concatenating(leftTranslationMatrix)
        })
        
    }
    
    
    @objc func showWaveAnimation(){
        waveAnimationImageView.isHidden = false
        self.waveAnimationImageViewYpost.constant = 0
        self.logoImageViewYpost.constant =  self.logoImageViewYpost.constant - 100
        UIView.animate(withDuration: 0.5) {
            self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: 0.8, y: 0.8)
            self.view.layoutIfNeeded()
        }
    }
}
