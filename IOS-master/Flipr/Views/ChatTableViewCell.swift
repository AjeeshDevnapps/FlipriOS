//
//  ChatTableViewCell.swift
//  Flipr
//
//  Created by Ajish on 15/09/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import JGProgressHUD
import GhostTypewriter

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var chatLabel: TypewriterLabel!
    @IBOutlet weak var chatCellBackGround: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    var hud:JGProgressHUD?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addLoader(){
        loader.startAnimating()
        loader.isHidden = false
//        if hud == nil{
//            let hud = JGProgressHUD(style:.dark)
//            hud?.show(in: self.chatCellBackGround)
//        }
    }
    
    func removeLoader(){
        loader.stopAnimating()
        loader.isHidden = true

//        if hud != nil{
//            hud?.dismiss(afterDelay: 0)
//        }

    }

}
