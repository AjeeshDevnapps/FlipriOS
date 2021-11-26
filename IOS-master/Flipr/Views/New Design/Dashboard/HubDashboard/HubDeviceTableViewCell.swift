//
//  HubDeviceTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 16/07/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

protocol HubDeviceDelegate {
    func didSelectSettingsButton(hub:HUB)
    func didSelectPowerButton(hub:HUB)
    func didSelectSmartControllButton(hub:HUB)
    func didSelectProgramButton(hub:HUB)
    func didSelectProgramEditButton(hub:HUB)

}

class HubDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var innerContainerViewView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var modeNameLbl: UILabel!
    @IBOutlet weak var powerBtn: UIButton!
    @IBOutlet weak var smartContrlBtn: UIButton!
    @IBOutlet weak var programBtn: UIButton!
    @IBOutlet weak var editProgramLbl: UILabel!
    @IBOutlet weak var editProgramIcon: UIImageView!

    var hub: HUB?


    var delegate:HubDeviceDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.innerContainerViewView.roundCorner(corner: 12)
        innerContainerViewView.addShadow(offset: CGSize.init(width: 0, height: 3), color:UIColor(red: 0.621, green: 0.633, blue: 0.677, alpha: 0.13), radius: 14, opacity:1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func manageIcons(){
        editProgramLbl.isHidden = true
        editProgramIcon.isHidden = true

        if let hub = hub {
            let hubState = hub.equipementState
            powerBtn.setImage(UIImage(named: "OFF"), for: .normal)
            smartContrlBtn.setImage(UIImage(named: "smartContrlOff"), for: .normal)
            programBtn.setImage(UIImage(named: "pumbPrgmOff"), for: .normal)
            if hub.behavior == "manual" {
                let imageName = hubState ? "ON" : "OFF-pause"
                powerBtn.setImage(UIImage(named: imageName), for: .normal)
            } else{
                powerBtn.setImage(UIImage(named: "OFF"), for: .normal)
            }
            if hub.behavior == "planning" {
                editProgramLbl.isHidden = false
                editProgramIcon.isHidden = false
                setupEditButton()
                let imageName = hubState ? "pumbPgmOn" : "pumbPgmInactive"
                programBtn.setImage(UIImage(named: imageName), for: .normal)
            } else{
                programBtn.setImage(UIImage(named: "pumbPrgmOff"), for: .normal)
            }
            if hub.behavior == "auto" {
                let imageName = hubState ? "smartContrlOn" : "smartContrlActivated"
                smartContrlBtn.setImage(UIImage(named: imageName), for: .normal)

            }else{
                smartContrlBtn.setImage(UIImage(named: "smartContrlOff"), for: .normal)
            }
            
            if hub.equipementCode == 84{
                let icon  = hubState ? "lightOn" : "lightEnabled"
                self.iconImageView.image =  UIImage(named: icon)
            }
            else if hub.equipementCode == 86{
                let icon  = hubState ? "pumbactive" : "pumbactive"
                self.iconImageView.image =  UIImage(named: icon)
            }
            else{
                let icon  = hubState ? "heatpump" : "heatpump"

                self.iconImageView.image =  UIImage(named: icon)
            }
         
        }
    }
    
    func setupEditButton(){
        editProgramLbl.textColor = UIColor(red: 0.592, green: 0.639, blue: 0.714, alpha: 1)
        editProgramLbl.font = UIFont(name: "SFProDisplay-Regular", size: 15)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        // Line height: 22 pt
        // (identical to box height)

        editProgramLbl.attributedText = NSMutableAttributedString(string: "Mes programmes", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
    }

    @IBAction func tapSettingsButton(){
        self.delegate?.didSelectSettingsButton(hub: self.hub!)
    }
    
    @IBAction func tapPowerButton(){
        self.delegate?.didSelectPowerButton(hub: self.hub!)
    }
    
    @IBAction func tapSmartControllButton(){
        self.delegate?.didSelectSmartControllButton(hub:self.hub!)
    }
    
    @IBAction func tapProgrameButton(){
        self.delegate?.didSelectProgramButton(hub:self.hub!)
    }
    
    @IBAction func tapProgrameEditButton(){
        self.delegate?.didSelectProgramEditButton(hub:self.hub!)
    }
}
