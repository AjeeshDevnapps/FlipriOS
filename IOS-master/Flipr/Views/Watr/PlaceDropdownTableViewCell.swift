//
//  PlaceDropdownTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 03/10/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

protocol PlaceDropdownCellDelegate {
    func didSelectSettings(place:PlaceDropdown?)
}
class PlaceDropdownTableViewCell: UITableViewCell {
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var badgeButton: UIButton!
    var delegate:PlaceDropdownCellDelegate?
    var place:PlaceDropdown?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func settingsButtonClicked(){
        self.delegate?.didSelectSettings(place: self.place)
    }
    

}
