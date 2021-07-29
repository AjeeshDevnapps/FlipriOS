//
//  HistoricViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 03/07/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import NVActivityIndicatorView
import BAFluidView
import Device
import CoreMotion

enum GraphDataGranularity {
    case hourly
    case daily
}

enum GraphDataType {
    case temperature
    case pH
    case orp
}

class HistoricViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter {
    
    var motionManager = CMMotionManager()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var selectedDateTimeLabel: UILabel!
    @IBOutlet weak var SelectedValueLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var temperatureButton: UIButton!
    @IBOutlet weak var pHButton: UIButton!
    @IBOutlet weak var orpButton: UIButton!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var helpLabel: UILabel!
    
    @IBOutlet weak var helpView: UIVisualEffectView!
    
    @IBOutlet weak var orpInfoButton: UIButton!
    
    var graphDataGranularity:GraphDataGranularity = .daily
    var graphDataType:GraphDataType = .temperature
    var hourlyData = [[String:Any]]()
    var dailyData = [[String:Any]]()
    var days = [String]()
    var firstLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let module = Module.currentModule {
            if module.isForSpa {
                backgroundImageView.image = UIImage(named:"BG_spa")
            }
        }
        
        self.title = "History".localized
        helpLabel.text = "Scroll to view the entire history.".localized
        temperatureButton.setTitle("Temperature".localized, for: .normal)
        pHButton.setTitle("pH".localized, for: .normal)
        orpButton.setTitle("Redox".localized, for: .normal)
        
        segmentedControl.setTitle("Hour".localized, forSegmentAt: 0)
        segmentedControl.setTitle("Day".localized, forSegmentAt: 1)
        segmentedControl.setTitle("Season".localized, forSegmentAt: 2)

        
        helpView.alpha = 0
        
        activityIndicatorView.backgroundColor = .clear
        activityIndicatorView.type = .lineScaleParty
        activityIndicatorView.tintColor = .white
        
        segmentedControl.selectedSegmentIndex = 1
        selectorView.frame = CGRect(x: 0, y: temperatureButton.bounds.size.height, width: temperatureButton.bounds.size.width, height: 2)

        lineChartView.delegate = self
        lineChartView.chartDescription?.enabled = false
        lineChartView.drawBordersEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.scaleYEnabled = false
        
        let yAxis = lineChartView.leftAxis
        yAxis.drawGridLinesEnabled = false
        //yAxis.axisMinimum = 10
        //yAxis.axisMaximum = 30
        
        //lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelTextColor = UIColor(red: 29/255.0, green: 88/255.0, blue: 114/255.0, alpha: 1)
        lineChartView.xAxis.labelFont = UIFont(name: "Lato-Regular", size: 15)!
        
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = true
        lineChartView.xAxis.valueFormatter = self
        lineChartView.xAxis.granularity = 1
        
        lineChartView.rightAxis.enabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        
        lineChartView.legend.form = .empty
        lineChartView.legend.enabled = false
        lineChartView.noDataTextColor = .white
        lineChartView.noDataText = "No data".localized
        lineChartView.animate(yAxisDuration: 1.5)
        
        lineChartView.setNeedsDisplay()
        
        getDailyMetrics()
        
        // Do any additional setup after loading the view.
        
        var fluidColor =  UIColor.init(red: 40/255.0, green: 154/255.0, blue: 194/255.0, alpha: 1)
        
        // iPhone 6,7
        var startElevation = 0.67
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            print("Top noch: \(UIApplication.shared.delegate?.window??.safeAreaInsets.top)")
            if (UIApplication.shared.delegate?.window??.safeAreaInsets.top)! > CGFloat(20) { // hasTopNotch
                startElevation = Double((self.view.frame.height - CGFloat(235)) / self.view.frame.height)
            } else {
                startElevation = Double((self.view.frame.height - CGFloat(215)) / self.view.frame.height)
            }
        }
        
        let frame = CGRect(x: -(self.view.frame.height - self.view.frame.width)/2, y: 0, width: sqrt(self.view.frame.height * self.view.frame.height + self.view.frame.width * self.view.frame.width), height: self.view.frame.height + 100)
        
        var fluidView1 = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral: startElevation))
            fluidView1.strokeColor = .clear
            fluidView1.fillColor = UIColor.init(red: 93/255.0, green: 193/255.0, blue: 226/255.0, alpha: 1)
            fluidView1.fill(to: NSNumber(floatLiteral: startElevation))
            fluidView1.startAnimation()
            self.view.insertSubview(fluidView1, aboveSubview: backgroundImageView)
            
        var fluidView = BAFluidView.init(frame: frame, startElevation: NSNumber(floatLiteral: startElevation))
                fluidView.strokeColor = .clear
                fluidView.fillColor = fluidColor
                fluidView.fill(to: NSNumber(floatLiteral: startElevation))
                fluidView.startAnimation()
                self.view.insertSubview(fluidView, aboveSubview: fluidView1)

                
                motionManager.deviceMotionUpdateInterval = 0.01
                motionManager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data, error) in
                 
                guard let data = data, error == nil else {
                return
                 }
                 
                    if data.gravity.y > -0.05 {
                        fluidView.transform = CGAffineTransform(rotationAngle: 0)
                        fluidView1.transform = CGAffineTransform(rotationAngle: 0)
                    } else {
                        let rotation = atan2(data.gravity.x,data.gravity.y) - .pi
                        fluidView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                        fluidView1.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                    }
                 
                 }
                
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func temperatureButtonAction(_ sender: Any) {
        
        orpInfoButton.isHidden = true
        
        self.temperatureButton.tintColor = K.Color.DarkBlue
        self.pHButton.tintColor = K.Color.DarkBlue
        self.orpButton.tintColor = K.Color.DarkBlue
        
        UIView.animate(withDuration: 0.25) { 
            self.selectorView.frame = CGRect(x: 0, y: self.temperatureButton.bounds.size.height, width: self.temperatureButton.bounds.size.width, height: 2)
        }
        
        graphDataType = .temperature
        loadGraph()
    }
    @IBAction func pHButtonAction(_ sender: Any) {
        
        orpInfoButton.isHidden = true
        
        self.temperatureButton.tintColor = K.Color.DarkBlue
        self.pHButton.tintColor = K.Color.DarkBlue
        self.orpButton.tintColor = K.Color.DarkBlue
        
        UIView.animate(withDuration: 0.25) {
            self.selectorView.frame = CGRect(x: self.pHButton.frame.origin.x, y: self.pHButton.bounds.size.height, width: self.pHButton.bounds.size.width, height: 2)
        }
        
        graphDataType = .pH
        loadGraph()
    }
    @IBAction func orpButtonAction(_ sender: Any) {
        
        orpInfoButton.isHidden = false
        
        self.temperatureButton.titleLabel?.textColor = K.Color.DarkBlue
        self.pHButton.tintColor = K.Color.DarkBlue
        self.orpButton.tintColor = K.Color.DarkBlue
        
        UIView.animate(withDuration: 0.25) {
            self.selectorView.frame = CGRect(x: self.orpButton.frame.origin.x, y: self.orpButton.bounds.size.height, width: self.orpButton.bounds.size.width, height: 2)
        }
        
        graphDataType = .orp
        loadGraph()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            graphDataGranularity = .hourly
            loadGraph()
        case 1, 2:
            graphDataGranularity = .daily
            loadGraph()
        default:
            break
        }
    }
    
    @IBAction func orpInfoButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Redox".localized, message:"REDOX_INFO".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadGraph() {
        
        self.lineChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        self.lineChartView.data = nil
        self.lineChartView.data?.notifyDataChanged()
        self.lineChartView.notifyDataSetChanged()
        self.lineChartView.highlightValue(nil)
        
        if graphDataGranularity == .hourly {
            lineChartView.xAxis.granularity = 3600
            if self.hourlyData.count == 0 {
                getHourlyMetrics()
                return
            }
        } else {
            lineChartView.xAxis.granularity = 1
            if self.dailyData.count == 0 {
                getDailyMetrics()
                return
            }
        }
        
        
        var entries = [ChartDataEntry]()
        var lastDateTimeStamp = 0.0
        var forecasteLastDateTimeStamp = 0.0
        
        let axisFormatter = DateFormatter()
        axisFormatter.dateFormat = "dd/MM/yyyy"
        
        var forecastEntries = [ChartDataEntry]()
        
        switch graphDataType {
        case .temperature:
            if graphDataGranularity == .hourly {
                for metrics in hourlyData {
                    if let time = metrics["DateTime"] as? String, let temperature = metrics["Temperature"] as? Double{
                        if let date = time.fliprDate {
                            entries.append(ChartDataEntry(x: date.timeIntervalSince1970, y: temperature))
                            lastDateTimeStamp = date.timeIntervalSince1970
                        }
                    }
                    
                }
                
                if let forecast = Pool.currentPool?.hourlyForecast {
                    
                    forecastEntries.append(entries.last!)
                    
                    for metrics in forecast {
                        print("Mertrics: \(metrics)")
                        
                        if let time = metrics["DateTime"] as? String, let temperature = metrics["Temperature"] as? Double{
                            if let date = time.fliprDate {
                                forecastEntries.append(ChartDataEntry(x: date.timeIntervalSince1970, y: temperature))
                                forecasteLastDateTimeStamp = date.timeIntervalSince1970
                            }
                            
                        }
                    
                    }
                }
                
            } else if graphDataGranularity == .daily {
                var i = 0.0
                days.removeAll()
                for metrics in dailyData {
                    if let time = metrics["Date"] as? String, let temperature = metrics["Temperature"] as? [String:Any]{
                        if let date = time.fliprDate {
                            if let medValue = temperature["MedValue"] as? Double {
                                entries.append(ChartDataEntry(x: i, y: medValue))
                                days.append(axisFormatter.string(from: date))
                                i = i+1
                                lastDateTimeStamp = date.timeIntervalSince1970
                            }
                        }
                        
                    }
                }
                
                if let forecast = Pool.currentPool?.dailyForecast {
                    
                    forecastEntries.append(entries.last!)
                    
                    for metrics in forecast {
                        print("Daily Forecastr Mertrics: \(metrics)")
                        
                        if let time = metrics["DateTime"] as? String, let temperature = metrics["Temperature"] as? Double {
                        
                            if let date = time.fliprDate {
                                forecastEntries.append(ChartDataEntry(x: i, y: temperature))
                                days.append(axisFormatter.string(from: date))
                                i = i+1
                                forecasteLastDateTimeStamp = date.timeIntervalSince1970
                            }
                            
                        }
                    }
                }
            }  else {
                var i = 0.0
                days.removeAll()
                for metrics in dailyData {
                    if let time = metrics["Date"] as? String, let temperature = metrics["Temperature"] as? [String:Any]{
                        if let date = time.fliprDate {
                            if let medValue = temperature["MedValue"] as? Double {
                                entries.append(ChartDataEntry(x: i, y: medValue))
                                days.append(axisFormatter.string(from: date))
                                i = i+1
                                lastDateTimeStamp = date.timeIntervalSince1970
                            }
                        }
                    }
                }
                
            }
            
        case .pH:
            if graphDataGranularity == .hourly {
                for metrics in hourlyData {
                    if let time = metrics["DateTime"] as? String, let pH = metrics["PH"] as? [String:Any]  {
                        
                        print("DateTime: \(time)")
                        if let date = time.fliprDate {
                            if let pHValue = pH["Value"] as? Double  {
                                entries.append(ChartDataEntry(x: date.timeIntervalSince1970, y: pHValue))
                                lastDateTimeStamp = date.timeIntervalSince1970
                            }
                        }

                    }
                    
                }
            } else {
                var i = 0.0
                days.removeAll()
                for metrics in dailyData {
                    if let time = metrics["Date"] as? String, let pH = metrics["PH"] as? [String:Any]  {
                        if let date = time.fliprDate {
                            print("DateTime: \(time)")
                            if let pHValue = pH["MedValue"] as? Double  {
                                entries.append(ChartDataEntry(x: i, y: pHValue))
                                days.append(axisFormatter.string(from: date))
                                i = i+1
                                lastDateTimeStamp = date.timeIntervalSince1970
                            }
                        }
                        
                    }
                    
                }
            }
        case .orp:
            if graphDataGranularity == .hourly {
                for metrics in hourlyData {
                    if let time = metrics["DateTime"] as? String, let orp = metrics["OxydoReductionPotentiel"] as? [String:Any]  {
                        
                        print("DateTime: \(time)")
                        if let date = time.fliprDate {
                            if let orpValue = orp["Value"] as? Double  {
                                entries.append(ChartDataEntry(x: date.timeIntervalSince1970, y: orpValue))
                                lastDateTimeStamp = date.timeIntervalSince1970
                            }
                        }
                        
                    }
                    
                }
            } else {
                var i = 0.0
                days.removeAll()
                for metrics in dailyData {
                    if let time = metrics["Date"] as? String, let orp = metrics["OxydoRecutionPotential"] as? [String:Any]  {
                        if let date = time.fliprDate {
                            print("DateTime: \(time)")
                            if let orpValue = orp["MedValue"] as? Double  {
                                entries.append(ChartDataEntry(x: i, y: orpValue))
                                days.append(axisFormatter.string(from: date))
                                i = i+1
                                lastDateTimeStamp = date.timeIntervalSince1970
                            }
                        }
                    }
                    
                }
            }
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Temperature")
        
        dataSet.valueFont = UIFont(name: "Lato-Regular", size: 15)!
        dataSet.colors = [.white]
        dataSet.lineWidth = 2
        dataSet.highlightColor = .white
        dataSet.highlightLineDashLengths = [5,2.5]
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.fillColor = K.Color.DarkBlue
        dataSet.fillAlpha = 0.5
        dataSet.drawCirclesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.mode = .cubicBezier
        
        let gradientColors = [ChartColorTemplates.colorFromString("#229BB9").cgColor,ChartColorTemplates.colorFromString("#24617B").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        
        dataSet.fillAlpha = 0.5
        dataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90)
        dataSet.drawFilledEnabled = true
        
        var data = LineChartData(dataSets: [dataSet])
        data.setValueTextColor(.white)
        
        if forecastEntries.count > 1 && graphDataType == .temperature {
            let forecastDataSet = LineChartDataSet(entries: forecastEntries, label: "Temperature")
            
            forecastDataSet.valueFont = UIFont(name: "Lato-Regular", size: 15)!
            forecastDataSet.colors = [.white]
            forecastDataSet.lineWidth = 2
            forecastDataSet.lineDashLengths = [8,8]
            forecastDataSet.highlightColor = .white
            forecastDataSet.highlightLineDashLengths = [5,2.5]
            forecastDataSet.drawHorizontalHighlightIndicatorEnabled = false
            forecastDataSet.fillColor = K.Color.DarkBlue
            forecastDataSet.fillAlpha = 0.5
            forecastDataSet.drawCirclesEnabled = false
            forecastDataSet.drawFilledEnabled = true
            forecastDataSet.mode = .cubicBezier
            
            let gradientColors = [ChartColorTemplates.colorFromString("#229BB9").cgColor,ChartColorTemplates.colorFromString("#24617B").cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
            
            forecastDataSet.fillAlpha = 0.5
            forecastDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90)
            forecastDataSet.drawFilledEnabled = true
            
            data = LineChartData(dataSets: [dataSet, forecastDataSet])
            data.setValueTextColor(.white)
        }
        
        self.lineChartView.data = data
        self.lineChartView.data?.notifyDataChanged()
        self.lineChartView.notifyDataSetChanged()
        self.lineChartView.setNeedsDisplay()
        
        if let last = entries.last {
            self.lineChartView.highlightValue(Highlight(x: last.x, y: last.y, dataSetIndex: 0), callDelegate:true)
        }
        
        if graphDataGranularity == .hourly {
            lineChartView.xAxis.axisMaximum = lastDateTimeStamp + 3600
            if forecastEntries.count > 1 && graphDataType == .temperature {
                lineChartView.xAxis.axisMaximum = forecasteLastDateTimeStamp + 3600
                
                print("Entries count: \(entries.count))")
                print("last date: \(Date(timeIntervalSince1970: (entries.last?.x)!)) = \((entries.last?.x)!)")
                print("first date: \(Date(timeIntervalSince1970: (entries.first?.x)!))")
                
                let step = ((forecastEntries.last?.x)! - (entries.first?.x)!)/3600
                print("steps: \(step)" )
                
                let stpo = ((entries.last?.x)! - (entries.first?.x)!)/3600

                //let scaleRatio = (step + Double(forecastEntries.count))/4
                
                let scaleRatio = step/4
                
                self.lineChartView.zoom(scaleX: CGFloat(scaleRatio), scaleY: 0, x: CGFloat(stpo - 1) * self.view.bounds.size.width / CGFloat(step), y: 0)
                
               // self.lineChartView.zoom(scaleX: CGFloat(scaleRatio), scaleY: 0, xValue: (forecastEntries.first?.x)!, yValue: 0, axis: .left)
                
                //self.lineChartView.zoom(scaleX: CGFloat((entries.count + forecastEntries.count)/4), scaleY: 0, x: CGFloat(lastDateTimeStamp + 3600), y: 0)
                //self.lineChartView.zoom(scaleX: CGFloat(scaleRatio), scaleY: 0, x: 1, y: 0)
                //self.lineChartView.zoom(scaleX: CGFloat(scaleRatio), scaleY: 0, x: CGFloat(2), y: 0)
                
                print("xOffset: \(self.lineChartView.lowestVisibleX)" )
                
            } else {
                self.lineChartView.zoom(scaleX: CGFloat(entries.count/4), scaleY: 0, x: CGFloat(lineChartView.xAxis.axisMaximum), y: 0)
            }
           
        } else if  graphDataGranularity == .daily {
            
            lineChartView.xAxis.axisMaximum = Double(days.count + 1)
            
            if forecastEntries.count > 1 && graphDataType == .temperature {
                
                if segmentedControl.selectedSegmentIndex == 1 {
                    self.lineChartView.zoom(scaleX:  CGFloat((entries.count + forecastEntries.count)/4), scaleY: 0, x: CGFloat(entries.count) * self.view.bounds.size.width / CGFloat(entries.count + forecastEntries.count), y: 0)
                } else {
                    data.setDrawValues(false)
                    self.lineChartView.zoom(scaleX: 0, scaleY: 0, x: CGFloat(lastDateTimeStamp), y: 0)
                }
                
            } else {
                print("Entries count: \(entries.count)")
                if segmentedControl.selectedSegmentIndex == 1 {
                    self.lineChartView.zoom(scaleX: CGFloat((entries.count + forecastEntries.count)/4), scaleY: 0, x: CGFloat(lastDateTimeStamp), y: 0)
                } else {
                    data.setDrawValues(false)
                    self.lineChartView.zoom(scaleX: 0, scaleY: 0, x: CGFloat(lastDateTimeStamp), y: 0)
                }
            }
            
        }

        UIView.animate(withDuration: 0.5, animations: {
            self.lineChartView.alpha = 1
            self.selectedDateTimeLabel.alpha = 1
            self.SelectedValueLabel.alpha = 1
            //TODO if....
            if !UserDefaults.standard.bool(forKey: "graphViewAlreadyShown") && entries.count > 7 {
                self.helpView.alpha = 1
                self.perform(#selector(self.hideHelpView), with: nil, afterDelay: 5.remotable("GRAPH_HELP_VIEW_DURATION"))
            }
        }, completion: { (success) in

        })
    }
    
    @objc func hideHelpView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.helpView.alpha = 0
        }, completion: { (success) in
            UserDefaults.standard.set(true, forKey: "graphViewAlreadyShown")
        })
    }
    
    func getHourlyMetrics() {
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.alpha = 1
        lineChartView.alpha = 0
        selectedDateTimeLabel.alpha = 0
        SelectedValueLabel.alpha = 0
        
        if let serial = Module.currentModule?.serial {
            
            
            Alamofire.request(Router.readModuleHourlyMetrics(serialId: serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.alpha = 0
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("Get readModuleHourlyMetrics response.result.value: \(value)")
                    
                    if let JSON = value as? [[String:Any]] {
                        
                        self.hourlyData = JSON.reversed()
                        
                        self.loadGraph()
                    } else {
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                    
                    
                case .failure(let error):
                    
                    print("Get metrics did fail with error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        self.showError(title: "Error".localized, message: serverError.localizedDescription)
                    } else {
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                }
            })
        } else {
            self.showError(title: "Error".localized, message: "Aucun module flipr")
        }
    }
    
    func getDailyMetrics() {
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.alpha = 1
        lineChartView.alpha = 0
        selectedDateTimeLabel.alpha = 0
        SelectedValueLabel.alpha = 0
        
        if let serial = Module.currentModule?.serial {
            
            
            Alamofire.request(Router.readModuleDailyMetrics(serialId: serial)).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.alpha = 0
                
                switch response.result {
                    
                case .success(let value):
                    
                    print("Get readModuleDailyMetrics response.result.value: \(value)")
                    
                    if let JSON = value as? [[String:Any]] {
                        
                        self.dailyData = JSON.reversed()
                        
                        self.loadGraph()
                        
                        /*
                        var entries = [ChartDataEntry]()
                        var lastDateTimeStamp = 0.0
                        var i:Double = 0
                        for metrics in JSON.reversed() {
                            if let time = metrics["Date"] as? String, let temperature = metrics["Temperature"] as? [String:Any]  {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                if let timeStamp = formatter.date(from: time)?.timeIntervalSince1970, let medValue = temperature["MedValue"] as? Double  {
                                    entries.append(ChartDataEntry(x: timeStamp, y: medValue))
                                    //entries.append(ChartDataEntry(x: i, y: medValue))
                                    if i == 0 {
                                      self.lineChartView.xAxis.axisMinimum = timeStamp
                                    }
                                    lastDateTimeStamp = timeStamp
                                    i = i + 1
                                }
                            }
                            
                        }
                        self.lineChartView.xAxis.axisMaximum = lastDateTimeStamp
                        
                        if entries.count > 0 {
                            
                            let dataSet = LineChartDataSet(values: entries, label: "Temperature")
                            
                            dataSet.colors = [.white]
                            dataSet.lineWidth = 2
                            dataSet.highlightColor = .white
                            dataSet.highlightLineDashLengths = [5,2.5]
                            dataSet.drawHorizontalHighlightIndicatorEnabled = false
                            dataSet.fillColor = K.Color.DarkBlue
                            dataSet.fillAlpha = 0.5
                            dataSet.drawCirclesEnabled = false
                            dataSet.drawFilledEnabled = true
                            dataSet.mode = .cubicBezier
                            
                            let gradientColors = [ChartColorTemplates.colorFromString("#00BEE1").cgColor,ChartColorTemplates.colorFromString("#01759A").cgColor]
                            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
                            
                            dataSet.fillAlpha = 1
                            dataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90)
                            //[ChartFill fillWithLinearGradient:gradient angle:90.f];
                            dataSet.drawFilledEnabled = true
                            
                            let data = LineChartData(dataSets: [dataSet])
                            data.setValueTextColor(.white)
                            
                            self.lineChartView.data = data
                            self.lineChartView.data?.notifyDataChanged()
                            self.lineChartView.notifyDataSetChanged()
                            self.lineChartView.setNeedsDisplay()
                            
                            //self.lineChartView.zoom(scaleX: 20, scaleY: 0, x: CGFloat(lastDate.timeIntervalSince1970), y: 0)
                            //self.lineChartView.zoomOut()
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.lineChartView.alpha = 1
                            }, completion: { (success) in
                                
                            })
                            
                        }*/
                    } else {
                        print("response.result.value: \(value)")
                        let error = NSError(domain: "flipr", code: -1, userInfo: [NSLocalizedDescriptionKey:"Data format returned by the server is not supported.".localized])
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                    
                    
                case .failure(let error):
                    
                    print("Get metrics did fail with error: \(error)")
                    
                    if let serverError = User.serverError(response: response) {
                        self.showError(title: "Error".localized, message: serverError.localizedDescription)
                    } else {
                        self.showError(title: "Error".localized, message: error.localizedDescription)
                    }
                }
            })
        } else {
            self.showError(title: "Error".localized, message: "Aucun module flipr")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ChartView delegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.x + entry.y)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if graphDataGranularity == .hourly {
            if formatter.string(from: Date(timeIntervalSince1970: entry.x)) == formatter.string(from: Date()) {
                formatter.dateFormat = "HH:mm"
                selectedDateTimeLabel.text = "Today".localized + " " + formatter.string(from: Date(timeIntervalSince1970: entry.x))
            } else {
                formatter.dateFormat = "EEE HH:mm"
                selectedDateTimeLabel.text = formatter.string(from: Date(timeIntervalSince1970: entry.x))
            }
            
        } else {
            if days[Int(entry.x)] == formatter.string(from: Date()) {
                selectedDateTimeLabel.text = "Today".localized
            } else {
                print("days[Int(entry.x): \(days[Int(entry.x)])")
                if let date = formatter.date(from: days[Int(entry.x)]) {
                    formatter.dateFormat = "EEE dd MMM"
                    selectedDateTimeLabel.text = formatter.string(from: date)
                } else {
                    selectedDateTimeLabel.text = days[Int(entry.x)]
                }
                
                
            }
            
        }

        switch graphDataType {
        case .temperature:
            SelectedValueLabel.text = String(format: "%.0f", entry.y) + "°"
        case .pH:
            SelectedValueLabel.text = String(format: "%.1f", entry.y)
        case .orp:
            SelectedValueLabel.text = String(format: "%.0f", entry.y) + " mV"
        }
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.helpView.alpha = 0
        }, completion: { (success) in
            UserDefaults.standard.set(true, forKey: "graphViewAlreadyShown")
        })
    }
    
    // MARK: - ChartView xAxis formatter
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if graphDataGranularity == .hourly {
            let dateFomatter = DateFormatter()
            dateFomatter.dateFormat = "HH:mm"
            let date = Date(timeIntervalSince1970: value)
            return dateFomatter.string(from: date)
        }
        if Int(value) >= days.count {
           return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if value < 0{
            if days.count > 0{
                if let date = formatter.date(from: days[0]) {
                    formatter.dateFormat = "dd/MM"
                    return formatter.string(from: date)
                }
                return days[Int(value)]
            }else{
                return ""
            }
          
        }
        if let date = formatter.date(from: days[Int(value)]) {
            formatter.dateFormat = "dd/MM"
            return formatter.string(from: date)
        }
        return days[Int(value)]
    }


}
