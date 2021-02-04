//
//  PoolLogViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 26/07/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit

protocol PoolLogViewControllerDelegate {
    func poolLogItemDidDelete(log:Log)
}

class PoolLogViewController: UIViewController {
    
    var log:Log!
    
    var delegate:PoolLogViewControllerDelegate?
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: FliprLogDidChanged, object: nil, queue: nil) { (notification) in
            self.modalTransitionStyle = .crossDissolve
            self.dismiss(animated: true, completion: nil)
        }
        
        self.titleLabel.text = log.title
        
        colorView.backgroundColor = log.type.color()
        if let url = URL(string: log.iconUrl) {
            iconImageView.af_setImage(withURL: url)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd MMM HH:mm"
        dateLabel.text = formatter.string(from: log.date)
        
        if let systemComment = log.systemComment {
            contentLabel.text = systemComment
        }
        
        if let userComment = log.userComment, let text = contentLabel.text {
            if text.count > 0 {
                contentLabel.text = text + "\n\n" + userComment
            } else {
                contentLabel.text = userComment
            }
        }
        
        editButton.setTitle("Edit".localized(), for: .normal)
        deleteButton.setTitle("Delete".localized(), for: .normal)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.15, animations: {
            self.blurView.alpha = 0
        }) { (success) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.blurView.alpha = 1
        }
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Item deletion".localized, message:"Do you really want to delete this item?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { (action) in
            
            if (Pool.currentPool?.id) != nil {
                self.view.isUserInteractionEnabled = false
                Pool.currentPool?.deleteLog(id: self.log.id) { (error) in
                    self.view.isUserInteractionEnabled = true
                    if error != nil {
                        self.showError(title: "Error".localized, message: error?.localizedDescription)
                    } else {
                        UIView.animate(withDuration: 0.15, animations: {
                            self.blurView.alpha = 0
                        }) { (success) in
                            self.dismiss(animated: true, completion: {
                                self.delegate?.poolLogItemDidDelete(log:self.log)
                            })
                        }
                    }
                }
            }
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navC = segue.destination as? UINavigationController {
            if let vc = navC.viewControllers[0] as? PoolLogEditViewController {
                vc.logType = log.type
                vc.log = log
            }
        }
    }
    
}
