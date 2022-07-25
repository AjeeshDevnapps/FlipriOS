//
//  LoginEducationViewOneController.swift
//  Flipr
//
//  Created by Ajeesh T S on 02/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class LoginEducationOneViewController: BaseViewController {
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var contentImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        headingLbl.text = "Forget about water analysis".localized
        subHeadingLbl.text = "Don't worry about the quality of your pond water Create an account".localized
//        nextButton.setTitle("Create an account".localized, for: .normal)
//        loginButton.setTitle("Login".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func loginButtonClicked(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    @IBAction func signupButtonClicked(){
        
        let signupView = UIStoryboard.init(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SignUpEmailController") as! SignUpEmailController
        self.navigationController?.pushViewController(signupView)
    }

}



class LoginEducationSecondViewController: UIViewController {
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}


class LoginEducationThirdViewController: UIViewController {
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}
