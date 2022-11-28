//
//  InvitationTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 28/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit


protocol InvitationTableViewCellDelegate {
    func didSelectAccept(place:PlaceDropdown?)
    func didSelectDecline(place:PlaceDropdown?)

}

class InvitationTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonContentView: UIView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var badgeButton: UIButton!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!

    
    var delegate:InvitationTableViewCellDelegate?
    var place:PlaceDropdown?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    
    @IBAction func acceptButtonClicked(){
        self.delegate?.didSelectAccept(place: self.place)
    }
    
    @IBAction func declineButtonClicked(){
        self.delegate?.didSelectDecline(place: self.place)
    }

}
