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
    @IBOutlet weak var disableView: UIView!

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



protocol NoPlaceIntroCellDelegate {
    func didSelectAddPlace()
    func didSelectDeleteUser()
    func didSelectDisconnect()

}

class NoPlaceIntroableViewCell: UITableViewCell {
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    

    var delegate:NoPlaceIntroCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        addPlaceButton.setTitle("Ajouter emplacement".localized, for: .normal)
        deleteUserButton.setTitle("Delete my User".localized, for: .normal)
        disconnectButton.setTitle("Déconnecter".localized, for: .normal)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addButtonClicked(){
        self.delegate?.didSelectAddPlace()
    }
    
    @IBAction func deleteButtonClicked(){
        self.delegate?.didSelectDeleteUser()
    }
    
    @IBAction func disconnectButtonClicked(){
        self.delegate?.didSelectDisconnect()
    }
    

}


class NoPlaceIntroInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var infoLbl: UILabel!
    

    var delegate:NoPlaceIntroCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        infoLbl.text = "Welcome aboard. You must create a Place or be invited in order to enjoy Flipr. ".localized
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
  

}
