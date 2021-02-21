//
//  NotificationsAlertViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 26/01/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit




enum AlertType {
    case Notification
    case Threshold
}

protocol AlertPresentViewDelegate: class {
    func settingsButtonClicked(type:AlertType)
}



class NotificationsAlertViewController: UIViewController {
    var delegate : AlertPresentViewDelegate?
    @IBOutlet var iconImageHeight: NSLayoutConstraint!
    @IBOutlet var iconImageWidth: NSLayoutConstraint!

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tapView: UIView!
    var alertType = AlertType.Notification

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.tapView.addGestureRecognizer(tap)
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.tapView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }, completion: nil)

    }
    
    

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        print("Hello World")
    }

    
    @IBAction func settingsButtonAction(_ sender: Any) {
        self.tapView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
        self.delegate?.settingsButtonClicked(type:self.alertType)
//        ExpertModeViewController
        if self.alertType == .Threshold{
        
        }else{
            
        }
    }
    
    func setupView(){
        if self.alertType == .Threshold{
            self.iconImageHeight.constant = 30
            self.iconImageWidth.constant = 30
            
            self.iconImageView.image = #imageLiteral(resourceName: "filterIcon")
            self.iconImageView.frame =  CGRect(x:  self.iconImageView.frame.origin.x, y:  self.iconImageView.frame.origin.y, width: 45, height:45)
            headingLabel.text = "🚨     You customized alert thresholds."
            contentLabel.text = "Alerts and notifications will be displayed following these new thresholds. You can change the thresholds at any time in Expert Mode."
            settingsTitleLabel.text = "Threshold settings"
            settingsTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        }else{
            self.iconImageView.image = #imageLiteral(resourceName: "notificationAlert")
            headingLabel.text = "🚨     Alerts and notifications are turned off."
            contentLabel.text = "Alerts and notifications are disabled. You can reactivate them at any time."
            settingsTitleLabel.text = "Activate alerts and notifications"
        }
    }
    
}
