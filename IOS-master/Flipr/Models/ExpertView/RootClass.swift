//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ExpertViewData : NSObject, NSCoding{

	var lSI : LSI!
	var lastCalibrations : [LastCalibration]!
	var lastMeasure : LastCalibration!
	var lastStripValues : LastStripValue!
	var sliderStrip : SliderStrip!
	var thresholds : Threshold!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let lSIData = dictionary["LSI"] as? [String:Any]{
			lSI = LSI(fromDictionary: lSIData)
		}
		lastCalibrations = [LastCalibration]()
		if let lastCalibrationsArray = dictionary["LastCalibrations"] as? [[String:Any]]{
			for dic in lastCalibrationsArray{
				let value = LastCalibration(fromDictionary: dic)
				lastCalibrations.append(value)
			}
		}
		if let lastMeasureData = dictionary["LastMeasure"] as? [String:Any]{
			lastMeasure = LastCalibration(fromDictionary: lastMeasureData)
		}
		if let lastStripValuesData = dictionary["LastStripValues"] as? [String:Any]{
			lastStripValues = LastStripValue(fromDictionary: lastStripValuesData)
		}
		if let sliderStripData = dictionary["SliderStrip"] as? [String:Any]{
			sliderStrip = SliderStrip(fromDictionary: sliderStripData)
		}
		if let thresholdsData = dictionary["Thresholds"] as? [String:Any]{
			thresholds = Threshold(fromDictionary: thresholdsData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if lSI != nil{
			dictionary["LSI"] = lSI.toDictionary()
		}
		if lastCalibrations != nil{
			var dictionaryElements = [[String:Any]]()
			for lastCalibrationsElement in lastCalibrations {
				dictionaryElements.append(lastCalibrationsElement.toDictionary())
			}
			dictionary["LastCalibrations"] = dictionaryElements
		}
		if lastMeasure != nil{
			dictionary["LastMeasure"] = lastMeasure.toDictionary()
		}
		if lastStripValues != nil{
			dictionary["LastStripValues"] = lastStripValues.toDictionary()
		}
		if sliderStrip != nil{
			dictionary["SliderStrip"] = sliderStrip.toDictionary()
		}
		if thresholds != nil{
			dictionary["Thresholds"] = thresholds.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         lSI = aDecoder.decodeObject(forKey: "LSI") as? LSI
         lastCalibrations = aDecoder.decodeObject(forKey :"LastCalibrations") as? [LastCalibration]
         lastMeasure = aDecoder.decodeObject(forKey: "LastMeasure") as? LastCalibration
         lastStripValues = aDecoder.decodeObject(forKey: "LastStripValues") as? LastStripValue
         sliderStrip = aDecoder.decodeObject(forKey: "SliderStrip") as? SliderStrip
         thresholds = aDecoder.decodeObject(forKey: "Thresholds") as? Threshold

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if lSI != nil{
			aCoder.encode(lSI, forKey: "LSI")
		}
		if lastCalibrations != nil{
			aCoder.encode(lastCalibrations, forKey: "LastCalibrations")
		}
		if lastMeasure != nil{
			aCoder.encode(lastMeasure, forKey: "LastMeasure")
		}
		if lastStripValues != nil{
			aCoder.encode(lastStripValues, forKey: "LastStripValues")
		}
		if sliderStrip != nil{
			aCoder.encode(sliderStrip, forKey: "SliderStrip")
		}
		if thresholds != nil{
			aCoder.encode(thresholds, forKey: "Thresholds")
		}

	}

}
