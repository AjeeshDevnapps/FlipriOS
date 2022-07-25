//
//  HUBProgramViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 28/05/2020.
//  Copyright © 2020 I See U. All rights reserved.
//

import UIKit
import Charts
import JGProgressHUD

let FliprHUBPlanningsDidChange = Notification.Name("FliprHUBPlanningsDidChange")

class HUBProgramViewController: UIViewController, ChartViewDelegate {

    var planning:Planning?
    
    var timeSlots:[Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var dayString = "0000000"
    
    @IBOutlet weak var slotsLabel: UILabel!
    @IBOutlet weak var slotsLabelValue: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var selectionChartView: PieChartView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var weenesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var space1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var space2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeSloteTopConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight < 737{
            space1HeightConstraint.constant = 30
            space2HeightConstraint.constant = 30
        }
        
        if screenHeight < 668 {
            self.textFieldTopConstraint.constant = 60
            space1HeightConstraint.constant = 20
            space2HeightConstraint.constant = 20
            timeSloteTopConstraint.constant = 10
        }
        
        selectionChartView.transparentCircleColor = UIColor.init(hexString: "111729")
        selectionChartView.holeColor = .black
        
        if (planning != nil) {
            cancelButton.setTitle("Delete".localized(), for: .normal)
            saveButton.setTitle("Save".localized(), for: .normal)
        }else{
            cancelButton.setTitle("Cancel".localized(), for: .normal)
            saveButton.setTitle("Save".localized(), for: .normal)
        }
        cancelButton.roundCorner(corner: 12)
        saveButton.roundCorner(corner: 12)
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(hexString: "97A3B6").cgColor

        slotsLabel.text = "Selected time slots".localized()
            textField.attributedPlaceholder = NSAttributedString(string: "Program's name".localized(),
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "97A3B6")])
        
        repeatLabel.text = "Repeat".localized()
        
        monday.setTitle("DAY_1".localized(), for: .normal)
        tuesday.setTitle("DAY_2".localized(), for: .normal)
        weenesday.setTitle("DAY_3".localized(), for: .normal)
        thursday.setTitle("DAY_4".localized(), for: .normal)
        friday.setTitle("DAY_5".localized(), for: .normal)
        saturday.setTitle("DAY_6".localized(), for: .normal)
        sunday.setTitle("DAY_7".localized(), for: .normal)
        
        
        if let planning = planning {
            textField.text = planning.name
            dayString = planning.days
            refresh(planning: planning, button: monday, atIndex: 0)
            refresh(planning: planning, button: tuesday, atIndex: 1)
            refresh(planning: planning, button: weenesday, atIndex: 2)
            refresh(planning: planning, button: thursday, atIndex: 3)
            refresh(planning: planning, button: friday, atIndex: 4)
            refresh(planning: planning, button: saturday, atIndex: 5)
            refresh(planning: planning, button: sunday, atIndex: 6)
            timeSlots = planning.timeSlot
            
        } else {
            self.planning = Planning(withJSON: ["id":0, "name":"", "isActivated":false, "order":0, "days":"0000000"])
        }
        
        selectionChartView.delegate = self
        var selectionEntries:[PieChartDataEntry] = []
        var selectionColors:[NSUIColor] = []
        for index in 0...23 {
            selectionEntries.append(PieChartDataEntry(value: 1, data: index))
            selectionColors.append(.clear)
        }
        selectionChartView.holeRadiusPercent = 0.60
        selectionChartView.holeColor = .clear
        selectionChartView.legend.enabled = false
        selectionChartView.rotationEnabled = false
        
        
        let sset = PieChartDataSet(entries: selectionEntries, label: "")
        sset.drawIconsEnabled = false
        sset.sliceSpace = 6
        sset.drawValuesEnabled = false
        sset.colors = selectionColors
        
        let sdata = PieChartData(dataSet: sset)
        
        selectionChartView.data = sdata
        
        //-------------------------------
        
        var entries:[PieChartDataEntry] = []
        var colors:[NSUIColor] = []
        var valColors:[NSUIColor] = []

//        for index in 0...(timeSlots.count - 1) {
//            entries.append(PieChartDataEntry(value: 1, data: index))
//            if timeSlots[index] == 0 {
//                colors.append(UIColor(white: 1, alpha: 0.20))
//            } else {
//                colors.append(.white)
//            }
//        }
        for index in 0...(timeSlots.count - 1) {
            entries.append(PieChartDataEntry(value: 1, data: index))
            valColors.append(.black)
            if timeSlots[index] == 0 {
                colors.append(UIColor(hexString: "D0D1D4"))
//                colors.append(UIColor(white: .black, alpha: 0.20))
            } else {
                colors.append(.black)
            }
        }
        chartView.holeRadiusPercent = 0.90
        chartView.holeColor = .clear
        chartView.legend.enabled = false
        chartView.rotationEnabled = false
        chartView.entryLabelColor = .black
        chartView.transparentCircleColor = .black
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 6
        set.drawValuesEnabled = false
        
        set.colors = colors
        set.valueColors = valColors
        
        let data = PieChartData(dataSet: set)
        
        chartView.data = data
        
        updateSlotsLabelValue()
    }
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func updateSlotsLabelValue() {
        var index = 0
        var count = 0
        var time = ""
        var timeTuples:[String:String] = [:]
//        for slot in timeSlots {
//            count = count + slot
//            print("slot: \(slot)")
//            if slot == 1 {
//
//                var loopIndex = index
//                if index == 0 {
//                    loopIndex = 23
//                }
//                if timeSlots[loopIndex - 1] == 0 {
//                    var count = 0
//                    for i in index...50 {
//                        if i >= 24 {
//                            loopIndex = i - 24
//                        } else {
//                            loopIndex = i
//                        }
//                        if timeSlots[loopIndex] == 0 {
//                            break
//                        } else {
//                            count = count + 1
//                        }
//                        loopIndex = loopIndex + 1
//                    }
//                    print("index: \(index), count: \(count)")
//                    let start = index * 60
//                    let duration = count * 60
//                    print("start minute: \(start), duration: \(duration)")
//                    timeTuples[String(start)] = String(duration)
//                }
//            }
//
//            index = index + 1
//        }
        
        
                while index <= 23 {
                    if timeSlots[index] == 1 {
                        var startHour = index;
                        while index <= 23 && timeSlots[index] == 1  {
                            index += 1
                        }
                        
                        let start = startHour * 60
                        let duration = (index - startHour) * 60
                        count += 1
                        timeTuples[String(start)] = String(duration)
                       
                    }else
                    {
                        index += 1
                    }
                }
        
        
        
        print("timeTuples: \(timeTuples)")
        planning?.listStartingMinuteduration = timeTuples
        
        var slots:[String] = []
        for key in timeTuples.keys {
            let startH = Int(key)!/60
            var endH = startH + Int(timeTuples[key]!)!/60
            if endH >= 24 {
                endH = endH - 24
            }
            slots.append("\(startH)h - \(endH)h")
        }
        
        if count == 0 {
            slotsLabelValue.text = "None".localized()
        } else {
            slotsLabelValue.text = slots.joined(separator: ", ")
            print(slotsLabelValue.text)
        }
        
    }
    
    func refreshChartView() {
        var entries:[PieChartDataEntry] = []
        var colors:[NSUIColor] = []
        var valColors:[NSUIColor] = []

        for index in 0...(timeSlots.count - 1) {
            entries.append(PieChartDataEntry(value: 1, data: index))
            if timeSlots[index] == 0 {
//                colors.append(UIColor(white: 1, alpha: 0.20))
                colors.append(UIColor(hexString: "D0D1D4"))

            } else {
                colors.append(.black)
            }
            valColors.append(UIColor(hexString: "D0D1D4"))

        }
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 6
        set.drawValuesEnabled = false
        set.valueColors = valColors
        set.colors = colors
        
        let data = PieChartData(dataSet: set)
        
        chartView.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let index = entry.data as? Int {
            print("index: \(index)")
            if timeSlots[index] == 1 {
                timeSlots[index] = 0
            } else {
                timeSlots[index] = 1
            }
            refreshChartView()
            updateSlotsLabelValue()
        }
        
    }
    
    func refresh(planning:Planning,button:UIButton, atIndex:Int) {
        if planning.days[atIndex] == "1" {
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        if self.planning != nil{
            let hud = JGProgressHUD(style:.dark)
            hud?.show(in: self.view)
            let planning = self.planning
            HUB.currentHUB!.deletePlanning(planningId: planning?.id ?? 0) { (error) in
                if error == nil {
//                    HUB.currentHUB!.plannings.remove(at: indexPath.row)
                    hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud?.dismiss(afterDelay: 1)
                    NotificationCenter.default.post(name: K.Notifications.ReloadProgrameList, object: nil, userInfo: nil)
                    self.dismiss(animated: true, completion: nil)
//                    if HUB.currentHUB!.plannings.count == 0 {
//                        self.programView.showEmptyStateView(image: nil, title: nil, message: "No program".localized(), buttonTitle: "Add a new program".localized()) {
//                            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HUBProgramViewControllerID") as? HUBProgramViewController {
//                                self.present(vc, animated: true, completion: nil)
//                            }
//                        }
//                    }
                } else {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                }
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if let name =  textField.text {
            if name == "" {
                self.showError(title: "Error".localized, message: "Name is mandatory".localized)
                return
            }
            planning?.name = name
            textField.resignFirstResponder()
        }
        
        var slotsOk = false
        for slot in timeSlots {
            if slot == 1 {
                slotsOk = true
            }
        }
        if !slotsOk {
            self.showError(title: "Error".localized, message: "Select at least one time slot".localized)
            return
        }
        
        dayString = ""
        if monday.backgroundColor == .black {
            dayString = "1"
        } else {
            dayString = "0"
        }
        if tuesday.backgroundColor == .black {
            dayString = dayString + "1"
        } else {
            dayString = dayString + "0"
        }
        if weenesday.backgroundColor == .black {
            dayString = dayString + "1"
        } else {
            dayString = dayString + "0"
        }
        if thursday.backgroundColor == .black {
            dayString = dayString + "1"
        } else {
            dayString = dayString + "0"
        }
        if friday.backgroundColor == .black {
            dayString = dayString + "1"
        } else {
            dayString = dayString + "0"
        }
        if saturday.backgroundColor == .black {
            dayString = dayString + "1"
        } else {
            dayString = dayString + "0"
        }
        if sunday.backgroundColor == .black {
            dayString = dayString + "1"
        } else {
            dayString = dayString + "0"
        }
        
        if dayString == "0000000" {
            self.showError(title: "Error".localized, message: "Select at least one day of the week".localized)
            return
        } else {
            planning?.days = dayString
        }
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        
        if planning!.id == 0 {
            HUB.currentHUB?.plannings.append(planning!)
        }
        HUB.currentHUB?.syncPlannings(completion: { (error) in
            if (error != nil) {
                hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                hud?.textLabel.text = error?.localizedDescription
                hud?.dismiss(afterDelay: 3)
            } else {
                NotificationCenter.default.post(name: FliprHUBPlanningsDidChange, object: nil)
                hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud?.dismiss(afterDelay: 1)
                NotificationCenter.default.post(name: K.Notifications.ReloadProgrameList, object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    @IBAction func dayButtonAction(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.backgroundColor == .black {
                button.backgroundColor = .clear
                button.setTitleColor(.black, for: .normal)
            } else {
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIScreen {

    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
    }

    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}
