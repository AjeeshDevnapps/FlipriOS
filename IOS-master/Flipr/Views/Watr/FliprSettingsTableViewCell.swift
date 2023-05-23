//
//  FliprSettingsTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 18/11/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit

class FliprSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var serialNoLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!

    @IBOutlet weak var lastMesureLbl: UILabel!
    @IBOutlet weak var batteryInfoLbl: UILabel!
    @IBOutlet weak var firmwareVerLbl: UILabel!
    
    
    @IBOutlet weak var ownerLblTitle: UILabel!
    @IBOutlet weak var locationLblTitle: UILabel!
    @IBOutlet weak var serialNoLblTitle: UILabel!
    @IBOutlet weak var typeLblTitle: UILabel!

    @IBOutlet weak var lastMesureLblTitle: UILabel!
    @IBOutlet weak var batteryInfoLblTitle: UILabel!
    @IBOutlet weak var firmwareVerLblTitle: UILabel!
    
    
    @IBOutlet weak var diagnosticTitle: UILabel!
    @IBOutlet weak var firmwareUpdateTitle: UILabel!

    @IBOutlet weak var generalHeaderTitle: UILabel!
    @IBOutlet weak var diagHeaderTitle: UILabel!
    @IBOutlet weak var settingsHeaderTitle: UILabel!
    @IBOutlet weak var modeHeaderTitle: UILabel!
    @IBOutlet weak var modeValueLbl: UILabel!
    @IBOutlet weak var modeIndicator : UIActivityIndicatorView!

    
    @IBOutlet weak var firmwareUpdateView: UIView!



    override func awakeFromNib() {
        super.awakeFromNib()
        ownerLblTitle.text = "Propriétaire".localized
        locationLblTitle.text = "Emplacement".localized
        serialNoLblTitle.text = "Numéro de série".localized
        typeLblTitle.text = "Modèle".localized
        lastMesureLblTitle.text = "Dernière mesure".localized
        batteryInfoLblTitle.text = "Tension batterie".localized
        firmwareVerLblTitle.text = "Version Firmware".localized
        firmwareUpdateTitle.text = "Mise à jour de Flipr AnalysR".localized
        diagnosticTitle.text = "Diagnostic".localized

        generalHeaderTitle.text = "GENERAL".localized
        diagHeaderTitle.text = "DIAG".localized
        settingsHeaderTitle.text = "REGLAGES".localized
        modeHeaderTitle.text = "Mode".localized

        
        container1.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container2.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container3.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class HubMumbSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameLblTitle: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationLblTitle: UILabel!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var ownerLblTitle: UILabel!
    @IBOutlet weak var serialNoLbl: UILabel!
    @IBOutlet weak var serialNoLblTitle: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusLblTitle: UILabel!
    @IBOutlet weak var modeLbl: UILabel!
    @IBOutlet weak var modeLblTitle: UILabel!
    @IBOutlet weak var settingsLbl: UILabel!
    @IBOutlet weak var settingsLblTitle: UILabel!

    @IBOutlet weak var generalHeaderTitle: UILabel!
    @IBOutlet weak var statusHeaderTitle: UILabel!
    @IBOutlet weak var settingsHeaderTitle: UILabel!


    @IBOutlet weak var deleteBtn: UIButton!




    override func awakeFromNib() {
        super.awakeFromNib()
        nameLblTitle.text = "Libellé ".localized
        ownerLblTitle.text = "Propriétaire".localized
        locationLblTitle.text = "Emplacement".localized
        serialNoLblTitle.text = "Numéro de série".localized
        modeLblTitle.text = "Mode".localized
        statusLblTitle.text = "Statut".localized
        settingsLblTitle.text = "Paramètres de connexion".localized
        
        generalHeaderTitle.text = "GENERAL".localized
        statusHeaderTitle.text = "Statut".localized
        settingsHeaderTitle.text = "REGLAGES".localized
        deleteBtn.setTitle("Supprimer".localized, for: .normal)


        container1.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container2.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container3.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class GatewaySettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameLblTitle: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationLblTitle: UILabel!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var ownerLblTitle: UILabel!
    @IBOutlet weak var serialNoLbl: UILabel!
    @IBOutlet weak var serialNoLblTitle: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusLblTitle: UILabel!
    @IBOutlet weak var modeLbl: UILabel!
    @IBOutlet weak var modeLblTitle: UILabel!
    @IBOutlet weak var settingsLbl: UILabel!
    @IBOutlet weak var settingsLblTitle: UILabel!

    @IBOutlet weak var generalHeaderTitle: UILabel!
    @IBOutlet weak var statusHeaderTitle: UILabel!
    @IBOutlet weak var settingsHeaderTitle: UILabel!

    @IBOutlet weak var deleteHeaderTitle: UILabel!
    @IBOutlet weak var changeeWifiTitle: UILabel!


    @IBOutlet weak var deleteBtn: UIButton!




    override func awakeFromNib() {
        super.awakeFromNib()
        nameLblTitle.text = "Type" .localized
        
//        ownerLblTitle.text = "Propriétaire".localized
        locationLblTitle.text = "State".localized
        serialNoLblTitle.text = "Last connection".localized
//        deleteHeaderTitle.text = "Mode".localized
        changeeWifiTitle.text = "Changer le réseau Wifi".localized
//        settingsLblTitle.text = "Paramètres de connexion".localized
//
        generalHeaderTitle.text = "GENERAL".localized
//        statusHeaderTitle.text = "Statut".localized
//        settingsHeaderTitle.text = "REGLAGES".localized
        deleteBtn.setTitle("Supprimer".localized, for: .normal)


        container1.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
//        container2.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)
        container3.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor(hexString: "E3E7F0"), radius: 25.0, opacity: 1.0)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class FliprModeInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var modeTitleLbl: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
