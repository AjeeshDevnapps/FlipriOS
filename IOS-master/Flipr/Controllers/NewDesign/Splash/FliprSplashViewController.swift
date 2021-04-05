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
    @IBOutlet weak var rightAnimationView: UIImageView!
    @IBOutlet weak var rightAnimationContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        let view1 = UILabel()
        view1.frame = CGRect(x: 0, y: 0, width: 152.78, height: 401.99)
        view1.backgroundColor = .white

        let image0 = UIImage(named: "illustration right.png")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 2.63, b: 0, c: 0, d: 1, tx: -0.82, ty: 0))
        layer0.compositingFilter = "overlayBlendMode"
        layer0.bounds = view.bounds
        layer0.position = view.center
        view1.layer.addSublayer(layer0)


    //    var parent = self.view!
        self.view.addSubview(view1)
        view1.translatesAutoresizingMaskIntoConstraints = false
        
     ///   UIView.animate(withDuration: 1.0, animations: {
         //   self.rightAnimationContainerView.transform = .identity
//            self.rightAnimationView.transform.rotated(by: CGFloat(Double.pi / 2))
     //   })
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
