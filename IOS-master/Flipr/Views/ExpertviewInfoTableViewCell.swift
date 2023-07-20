//
//  ExpertviewInfoTableViewCell.swift
//  Flipr
//
//  Created by Ajish on 12/07/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class ExpertviewInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var phValLbl: UILabel!
    @IBOutlet weak var phLbl: UILabel!
    
    @IBOutlet weak var redoxValLbl: UILabel!
    @IBOutlet weak var redoxLbl: UILabel!

    
    @IBOutlet weak var airTempValLbl: UILabel!
    @IBOutlet weak var airTempLbl: UILabel!

    @IBOutlet weak var waterTempValLbl: UILabel!
    @IBOutlet weak var waterTempLbl: UILabel!
    
    @IBOutlet weak var lastMeasureDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    var lastMeasureInfo : LastCalibration?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(){
        self.titleLabel.text = "Données brutes".latinized

        phLbl.text = "pH".localized
        redoxLbl.text = "Redox".localized
        airTempLbl.text = "Air".localized
        waterTempLbl.text = "Water".localized

        
        phValLbl.text = Module.currentModule?.rawPH
        redoxValLbl.text = Module.currentModule?.rawRedox
        
        
        airTempValLbl.text = Module.currentModule?.airTemperature
        waterTempValLbl.text = Module.currentModule?.rawWaterTemperature

        
        if let dateString = lastMeasureInfo?.dateTime as? String {
            if let lastDate = dateString.fliprDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE dd/MM HH:mm"
                let title = "Last Measurement".localized
                self.lastMeasureDateLabel.text = "\(title) : \(dateFormatter.string(from: lastDate))"
            }
        }
    }

}




class ExpertviewCalibrationInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calibrationTilteLbl: UILabel!

    @IBOutlet weak var ph4ValLbl: UILabel!
    @IBOutlet weak var ph4Lbl: UILabel!
    @IBOutlet weak var ph4DateLbl: UILabel!

    
    @IBOutlet weak var ph7ValLbl: UILabel!
    @IBOutlet weak var ph7Lbl: UILabel!
    @IBOutlet weak var ph7DateLbl: UILabel!

    
    @IBOutlet weak var newCalibrationBtn: UIButton!
    
    var lastCalibrations:[LastCalibration]?

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(){
        calibrationTilteLbl.text = "Calibration".localized
        ph7Lbl.text = "pH7".localized
        ph4Lbl.text = "pH4".localized
        
        
        newCalibrationBtn.setTitle("New Calibration".localized, for: .normal)

        if let list = lastCalibrations {
            for item in list.enumerated(){
                if let obj = item as? LastCalibration{
                    if obj.dataType == 2{
                        ph7ValLbl.text = "\(obj.rawPH)"
                        if let dateString = obj.dateTime as? String {
                            if let lastDate = dateString.fliprDate {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "EEE dd/MM HH:mm"
                                self.ph7DateLbl.text = "\(dateFormatter.string(from: lastDate))"
                            }
                        }
                    }else{
                           ph4ValLbl.text = "\(obj.rawPH)"
                           if let dateString = obj.dateTime as? String {
                               if let lastDate = dateString.fliprDate {
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "EEE dd/MM HH:mm"
                                   self.ph4DateLbl.text = "\(dateFormatter.string(from: lastDate))"
                               }
                           }
                    }
                }
                
            }
        }

    }

}



class ExpertviewStripTestInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stripTestTilteLbl: UILabel!

    @IBOutlet weak var phValLbl: UILabel!
    @IBOutlet weak var phLbl: UILabel!
    @IBOutlet weak var phInfoLbl: UILabel!
    @IBOutlet weak var phSlider: UIImageView!

    @IBOutlet weak var clBrValLbl: UILabel!
    @IBOutlet weak var clBrLbl: UILabel!
    @IBOutlet weak var clBrInfoLbl: UILabel!
    @IBOutlet weak var clBrSlider: UIImageView!


    @IBOutlet weak var freeClValLbl: UILabel!
    @IBOutlet weak var freeClLbl: UILabel!
    @IBOutlet weak var freeClInfoLbl: UILabel!
    @IBOutlet weak var freeClSlider: UIImageView!
    @IBOutlet weak var newStripTestBtn: UIButton!
    
    
    @IBOutlet weak var thLbl: UILabel!
    @IBOutlet weak var thInfoLbl: UILabel!
    @IBOutlet weak var thSlider: UIImageView!


    @IBOutlet weak var alklnLbl: UILabel!
    @IBOutlet weak var alklnInfoLbl: UILabel!
    @IBOutlet weak var alklnSlider: UIImageView!

    
    @IBOutlet weak var stabilizerLbl: UILabel!
    @IBOutlet weak var stabilizerInfoLbl: UILabel!
    @IBOutlet weak var stabilizerSlider: UIImageView!

    
    var sliderInfo:SliderStrip?
    var stripValues:LastStripValue?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func loadData(){
        newStripTestBtn.setTitle("New strip test".localized, for: .normal)
        stripTestTilteLbl.text = "Strip test".localized
        self.phInfoLbl.text = "Control data not processed by Flipr algorithms".localized
        phLbl.text = "pH".localized
        if let dateString = sliderInfo?.datetime as? String {
            if let lastDate = dateString.fliprDate1 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/mm/yyyy HH:mm"
                var titleStr = "Strip test".localized
                titleStr = titleStr.appending(":  ")
                titleStr = titleStr.appending("\(dateFormatter.string(from: lastDate))")
                self.stripTestTilteLbl.text = titleStr
            }
        }
        if let ph  = sliderInfo?.pH{
            phSlider.image = UIImage(named: "hSlider\(ph)")
        }
        if let ph  = stripValues?.pH{
            var valInfo = "pH".localized
            valInfo = valInfo.appending(" = ")
            valInfo = valInfo.appending(ph.string)
            phValLbl.text = valInfo
        }
        
        self.clBrInfoLbl.text = "Control data not processed by Flipr algorithms".localized
        clBrLbl.text = "Cl-Br T".localized
        if let totalCr  = sliderInfo?.totalClBr{
            clBrSlider.image = UIImage(named: "hSlider\(totalCr)")
        }
        if let clBr  = stripValues?.totalClBr{
            var valInfo = "Total Chlorine/Bromine".localized
            valInfo = valInfo.appending(" = ")
            valInfo = valInfo.appending(clBr.string)
            valInfo = valInfo.appending(" ppm")
            clBrValLbl.text = valInfo
        }
        
        
        self.freeClInfoLbl.text = "Control data not processed by Flipr algorithms".localized
        freeClLbl.text = "Free Cl".localized
        if let freeCl  = sliderInfo?.freeChlorine{
            freeClSlider.image = UIImage(named: "hSlider\(freeCl)")
        }
        if let freeCl  = stripValues?.freeChlorine{
            var valInfo = "Free Chlorine".localized
            valInfo = valInfo.appending(" = ")
            valInfo = valInfo.appending(freeCl.string)
            valInfo = valInfo.appending(" ppm")
            freeClValLbl.text = valInfo
        }
        
        
        var valInfo = "TH (Total Hardness)".localized
        valInfo = valInfo.appending(": ")

        if let th  = sliderInfo?.totalHardness{
            if th == 1{
                valInfo = valInfo.appending("Very Low".localized)
                thInfoLbl.text = "A very low TH (Total Hardness) in a swimming pool, resulting from an extremely low mineral concentration, can lead to issues such as corrosion, staining, unstable water balance, and discomfort for swimmers, which can be addressed by adjusting the calcium hardness, monitoring and balancing water chemistry, and using metal sequestrants if needed.".localized
            }
            else if th == 2{
                valInfo = valInfo.appending("Low".localized)
                thInfoLbl.text = "A low TH (Total Hardness) in a swimming pool, resulting from a lower mineral concentration, can lead to issues such as corrosion, metal stains, and unstable water balance, which can be addressed by adjusting the calcium hardness, monitoring and balancing water chemistry, and using metal sequestrants if needed.".localized

            }
            else if th == 3{
                valInfo = valInfo.appending("Correct".localized)
                thInfoLbl.text = "A correct TH (Total Hardness) in a swimming pool ensures balanced water chemistry, prevents scaling, and promotes clear water for an enjoyable swimming experience." .localized

            }
            else if th == 4{
                valInfo = valInfo.appending("Hight".localized)
                thInfoLbl.text = "A high TH (Total Hardness) in a swimming pool, caused by elevated mineral concentrations, can lead to issues such as scaling, cloudy water, reduced sanitizer efficiency, skin irritation, and difficulty in maintaining water balance.".localized

            }
            else if th == 5{
                valInfo = valInfo.appending("Very Hight".localized)
                thInfoLbl.text = "A very high TH (Total Hardness) in a swimming pool, caused by an excessive concentration of minerals like calcium and magnesium, can lead to issues such as scaling, cloudy water, and poor water balance, which can be addressed through dilution, the use of water softeners or sequestering agents, filtration and backwashing, and regular monitoring and balancing of the pool water.".localized

            }
            else{
                
            }
            
            if let thVal  = stripValues?.totalHardness{
                valInfo = valInfo.appending(" ")
                valInfo = valInfo.appending(thVal.string)
                valInfo = valInfo.appending(" : ")
            }

            valInfo = valInfo.appending("°f")
            thLbl.text = valInfo
        }
        if let thVal  = sliderInfo?.totalHardness{
            thSlider.image = UIImage(named: "vSlider\(thVal)")
        }

        
        // Alkaline
        
        var alklnInfo = "Alkalinity".localized
        alklnInfo = alklnInfo.appending(": ")

        if let alkalineStage  = sliderInfo?.totalAlk{
            alklnSlider.image = UIImage(named: "vSlider\(alkalineStage)")
            if alkalineStage == 1{
                alklnInfo = alklnInfo.appending("Very Low".localized)
                alklnInfoLbl.text = "When alkalinity in a pool is very low, it can have several negative effects. It may result in pH imbalance, leading to acidic water that causes discomfort for swimmers and damages pool equipment. It can also contribute to staining on pool surfaces and reduce the efficiency of sanitizers like chlorine.".localized             }
            else if alkalineStage == 2{
                alklnInfo = alklnInfo.appending("Low".localized)
                alklnInfoLbl.text = "A slightly low alkalinity in a swimming pool, characterized by moderately decreased levels of alkaline substances, can result in pH instability, acidic water, staining and etching, and potential discomfort for swimmers, which can be addressed through alkalinity adjustment and regular monitoring and balancing of water chemistry.".localized
            }
            else if alkalineStage == 3{
                alklnInfo = alklnInfo.appending("Correct".localized)
                alklnInfoLbl.text = "A correct alkalinity in a swimming pool, within the recommended range of 80 to 120 ppm, provides pH stability, prevents scale formation, ensures water clarity, and creates a comfortable swimming environment.".localized
            }
            else if alkalineStage == 4{
                alklnInfo = alklnInfo.appending("Hight".localized)
                alklnInfoLbl.text = "A slightly high alkalinity in a swimming pool, characterized by moderately elevated levels of alkaline substances, can result in pH imbalance, scale formation, water clarity issues, and potential discomfort, which can be addressed through acid treatment and regular monitoring and balancing of water chemistry.".localized
            }
            else if alkalineStage == 5{
                alklnInfo = alklnInfo.appending("Very Hight".localized)
                alklnInfoLbl.text = "A very high alkalinity in a swimming pool, characterized by elevated levels of alkaline substances, can lead to pH imbalance, scale formation, poor water clarity, and discomfort for swimmers, which can be addressed through acid treatment, dilution, and regular monitoring and balancing of the water chemistry.".localized
                
            }
            else{
                
            }
            
            if let thVal  = stripValues?.totalAlk{
                alklnInfo = alklnInfo.appending(": ")
                alklnInfo = alklnInfo.appending(thVal.string)
                alklnInfo = alklnInfo.appending(" ppm")
            }
            alklnLbl.text = alklnInfo
        }
        
       
        
        var stabilixerInfo = "Stabilizer".localized
        stabilixerInfo = stabilixerInfo.appending(": ")

        if let stabilizerStage  = sliderInfo?.stabilizer{
            stabilizerSlider.image = UIImage(named: "vSlider\(stabilizerStage)")
            if stabilizerStage == 1{
                stabilixerInfo = stabilixerInfo.appending("Very Low".localized)
                stabilizerInfoLbl.text = "A very low stabilizer (C3N3(OH)3) in a swimming pool, indicating an extremely decreased concentration, can result in insufficient chlorine protection, increased chlorine demand, frequent chlorine addition, and potential risks of waterborne contaminants, necessitating stabilizer addition and regular monitoring to maintain proper water quality.".localized
            }
            else if stabilizerStage == 2{
                stabilixerInfo = stabilixerInfo.appending("Low".localized)
                stabilizerInfoLbl.text = "A slightly low stabilizer (C3N3(OH)3) in a swimming pool, indicating a moderately decreased concentration, can result in reduced chlorine protection, faster chlorine dissipation, potential sanitizer demand, and may require stabilizer adjustment and regular monitoring to maintain proper water quality." .localized            }
            else if stabilizerStage == 3{
                stabilixerInfo = stabilixerInfo.appending("Correct".localized)
                stabilizerInfoLbl.text = "A correct stabilizer (C3N3(OH)3) in a swimming pool, indicating an appropriate concentration, provides chlorine protection, consistent sanitizer effectiveness, cost efficiency, and helps maintain water balance for an optimal swimming environment.".localized            }
            else if stabilizerStage == 4{
                stabilixerInfo = stabilixerInfo.appending("Hight".localized)
                stabilizerInfoLbl.text = "A slightly high stabilizer (C3N3(OH)3) in a swimming pool, indicating a moderately elevated concentration, can provide adequate chlorine protection while requiring regular monitoring and potential dilution or partial water replacement to prevent excessive accumulation and maintain optimal water quality." .localized            }
            else if stabilizerStage == 5{
                stabilixerInfo = stabilixerInfo.appending("Very Hight".localized)
                stabilizerInfoLbl.text = "A very high stabilizer (C3N3(OH)3) in a swimming pool, indicating an excessively elevated concentration, can reduce sanitizer effectiveness, cause chlorine lock, lead to pH imbalance, and may require partial water replacement or specialized treatment methods for resolution.".localized
            }
            else{
                
            }
            
            if let stabVal  = stripValues?.stabilizer{
                stabilixerInfo = stabilixerInfo.appending(": ")
                stabilixerInfo = stabilixerInfo.appending(stabVal.string)
                stabilixerInfo = stabilixerInfo.appending(" ppm")
            }
            stabilizerLbl.text = stabilixerInfo
        }
        

    }
}


class ExpertviewTrendInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calibrationTilteLbl: UILabel!

    @IBOutlet weak var ph4ValLbl: UILabel!
    @IBOutlet weak var ph4Lbl: UILabel!
    @IBOutlet weak var ph4DateLbl: UILabel!

    
    @IBOutlet weak var ph7ValLbl: UILabel!
    @IBOutlet weak var ph7Lbl: UILabel!
    @IBOutlet weak var ph7DateLbl: UILabel!

    
    @IBOutlet weak var newCalibrationBtn: UIButton!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class ExpertviewthresholdInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calibrationTilteLbl: UILabel!

    @IBOutlet weak var ph4ValLbl: UILabel!
    @IBOutlet weak var ph4Lbl: UILabel!
    @IBOutlet weak var ph4DateLbl: UILabel!

    
    @IBOutlet weak var ph7ValLbl: UILabel!
    @IBOutlet weak var ph7Lbl: UILabel!
    @IBOutlet weak var ph7DateLbl: UILabel!

    
    @IBOutlet weak var newCalibrationBtn: UIButton!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
