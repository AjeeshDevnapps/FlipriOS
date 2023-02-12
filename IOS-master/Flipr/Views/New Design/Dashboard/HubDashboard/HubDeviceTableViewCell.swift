//
//  HubDeviceTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 16/07/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import Alamofire

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
    @IBOutlet weak var filtrationTimeLbl: UILabel!

    @IBOutlet weak var modeNameLbl: UILabel!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var powerBtn: UIButton!
    @IBOutlet weak var smartContrlBtn: UIButton!
    @IBOutlet weak var programBtn: UIButton!
    @IBOutlet weak var editProgramLbl: UILabel!
    @IBOutlet weak var editProgramIcon: UIImageView!

    var hub: HUB?
    var isOwner = true


    var delegate:HubDeviceDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.innerContainerViewView.clipsToBounds = true
       // innerContainerViewView.addShadow(offset: CGSize.init(width: 0, height: 3), color:UIColor(red: 0.621, green: 0.633, blue: 0.677, alpha: 0.13), radius: 14, opacity:1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func manageIcons(){
//                self.innerContainerViewView.clipsToBounds = true
//        self.innerContainerViewView.layer.cornerRadius = 30
        self.innerContainerViewView.roundCorner(corner: 12)
        filtrationTimeLbl.isHidden = true
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
                powerBtn.isHidden = false
            } else{
                if !isOwner {
                    powerBtn.isHidden = true
                }

                powerBtn.setImage(UIImage(named: "OFF"), for: .normal)
            }
            if hub.behavior == "planning" {
                getFiltrationTime()
                editProgramLbl.isHidden = false
//                editProgramIcon.isHidden = false
                setupEditButton()
                let imageName = hubState ? "pumbPgmOn" : "pumbPgmInactive"
                programBtn.setImage(UIImage(named: imageName), for: .normal)
                if hubState{
                    self.getFiltrationTime()
                }
            } else{
                if !isOwner {
//                    if hub.behavior != "manual"{
                        programBtn.isHidden = true
//                    }
                }
                programBtn.setImage(UIImage(named: "pumbPrgmOff"), for: .normal)
            }
            self.smartContrlBtn.isUserInteractionEnabled = true
            if hub.behavior == "auto" {
                self.getFiltrationTime()
                self.smartContrlBtn.isUserInteractionEnabled =  hubState ? false : true
                let imageName = hubState ? "smartContrlOn" : "smartContrlActivated"
                smartContrlBtn.setImage(UIImage(named: imageName), for: .normal)
            }else{
                if !isOwner {
                    smartContrlBtn.isHidden = true
                }
                smartContrlBtn.setImage(UIImage(named: "smartContrlOff"), for: .normal)
            }
            
            if hub.equipementCode == 84{
                self.smartContrlBtn.isHidden = true
                let icon  = hubState ? "lightOn" : "lightEnabled"
                self.iconImageView.image =  UIImage(named: icon)
            }
            else if hub.equipementCode == 86{
                if hub.behavior == "auto" {
                    self.getFiltrationTime()
                }
                if let module = Module.currentModule {
                    if module.isSubscriptionValid {
                        self.smartContrlBtn.isHidden = false
                        if hub.behavior != "auto" {
                            if !isOwner {
                                smartContrlBtn.isHidden = true
                            }
                        }
                    }else{
                        self.smartContrlBtn.isHidden = true
                    }
                }else{
                    self.smartContrlBtn.isHidden = true
                }
                let icon  = hubState ? "pumbactive" : "pumbactive"
                self.iconImageView.image =  UIImage(named: icon)
//                if !isOwner {
//                    iconImageView.isHidden = !hubState
//                }
            }
            else{
                self.smartContrlBtn.isHidden = true
                let icon  = hubState ? "heatpump" : "heatpump"
                self.iconImageView.image =  UIImage(named: icon)
            }
         
        }
    }
    
    func setupEditButton(){
        editProgramLbl.textColor = UIColor(red: 0.592, green: 0.639, blue: 0.714, alpha: 1)
        editProgramLbl.textColor = .black
        editProgramLbl.font = UIFont(name: "SFProDisplay-Regular", size: 15)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.23
        editProgramLbl.text = self.hub?.planningName
        // Line height: 22 pt
        // (identical to box height)

//        editProgramLbl.attributedText = NSMutableAttributedString(string: "Mes programmes", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
    }
    
    func clearFiltrationTimeLabel(){
        self.filtrationTimeLbl.text = ""
    }
    
    func getFiltrationTime(){
        
        Alamofire.request(Router.getHUBState(serial: hub?.serial ?? "0")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                      
                      switch response.result {
                          
                      case .success(let value):
                       
                       if let JSON = value as? [String:Any] {
                           print("HUB get State: \(JSON)")
                           if let value = JSON["messageModeAutoFiltration"] as? String {
                               if self.filtrationTimeLbl != nil{
                                   if let tmpHub = self.hub {
                                       if tmpHub.equipementCode == 86{
                                           if tmpHub.behavior == "auto" {
                                               self.filtrationTimeLbl.isHidden = false
                                               self.filtrationTimeLbl.text = value
                                           }else{
                                               self.clearFiltrationTimeLabel()
                                           }
                                       }else{
                                           self.clearFiltrationTimeLabel()
                                       }
                                   }
                                   else{
                                       self.clearFiltrationTimeLabel()
                                   }
                               }
                           } else {
                               
                           }
                       } else {
                           print("response.result.value: \(value)")
                       }
                       
                          
                          
                      case .failure(let error):
                          
                          if let serverError = User.serverError(response: response) {
                          } else {
                          }
                      }
                      
           })


    }

    @IBAction func tapSettingsButton(){
        if !isOwner {return}
        self.delegate?.didSelectSettingsButton(hub: self.hub!)
    }
    
    @IBAction func tapPowerButton(){
        if !isOwner {return}
        if let hub = hub {
            if hub.behavior == "manual" {
                let hubState = hub.equipementState
                let imageName = hubState ?  "OFF-pause" : "ON"
                powerBtn.setImage(UIImage(named: imageName), for: .normal)
                powerBtn.isHidden = false
            }else{
                let imageName =  "OFF-pause" //: "ON"
                powerBtn.setImage(UIImage(named: imageName), for: .normal)
            }
        }
        self.delegate?.didSelectPowerButton(hub: self.hub!)
    }
    
    @IBAction func tapSmartControllButton(){
        if !isOwner {return}
        if let hub = hub {
            
            if hub.behavior == "auto" {
                let hubState = hub.equipementState
                if !hubState{
                    smartContrlBtn.setImage(UIImage(named: "smartContrlActivated"), for: .normal)
                }
            }else{
                let imageName = "smartContrlActivated" // : "smartContrlActivated"
                smartContrlBtn.setImage(UIImage(named: imageName), for: .normal)
            }
            self.delegate?.didSelectSmartControllButton(hub:self.hub!)
        }
        
    }
        
    @IBAction func tapProgrameButton(){
        if !isOwner {return}
        self.delegate?.didSelectProgramButton(hub:self.hub!)
    }
    
    @IBAction func tapProgrameEditButton(){
        if !isOwner {return}
        self.delegate?.didSelectProgramEditButton(hub:self.hub!)
    }
}
