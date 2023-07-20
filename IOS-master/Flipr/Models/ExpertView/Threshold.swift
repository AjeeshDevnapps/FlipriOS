//
//	Threshold.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Threshold : NSObject, NSCoding{

	var phMax : PhMax!
	var phMin : PhMax!
	var redox : PhMax!
	var temperature : PhMax!
	var temperatureMax : PhMax!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let phMaxData = dictionary["PhMax"] as? [String:Any]{
			phMax = PhMax(fromDictionary: phMaxData)
		}
		if let phMinData = dictionary["PhMin"] as? [String:Any]{
			phMin = PhMax(fromDictionary: phMinData)
		}
		if let redoxData = dictionary["Redox"] as? [String:Any]{
			redox = PhMax(fromDictionary: redoxData)
		}
		if let temperatureData = dictionary["Temperature"] as? [String:Any]{
			temperature = PhMax(fromDictionary: temperatureData)
		}
		if let temperatureMaxData = dictionary["TemperatureMax"] as? [String:Any]{
			temperatureMax = PhMax(fromDictionary: temperatureMaxData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if phMax != nil{
			dictionary["PhMax"] = phMax.toDictionary()
		}
		if phMin != nil{
			dictionary["PhMin"] = phMin.toDictionary()
		}
		if redox != nil{
			dictionary["Redox"] = redox.toDictionary()
		}
		if temperature != nil{
			dictionary["Temperature"] = temperature.toDictionary()
		}
		if temperatureMax != nil{
			dictionary["TemperatureMax"] = temperatureMax.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         phMax = aDecoder.decodeObject(forKey: "PhMax") as? PhMax
         phMin = aDecoder.decodeObject(forKey: "PhMin") as? PhMax
         redox = aDecoder.decodeObject(forKey: "Redox") as? PhMax
         temperature = aDecoder.decodeObject(forKey: "Temperature") as? PhMax
         temperatureMax = aDecoder.decodeObject(forKey: "TemperatureMax") as? PhMax

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if phMax != nil{
			aCoder.encode(phMax, forKey: "PhMax")
		}
		if phMin != nil{
			aCoder.encode(phMin, forKey: "PhMin")
		}
		if redox != nil{
			aCoder.encode(redox, forKey: "Redox")
		}
		if temperature != nil{
			aCoder.encode(temperature, forKey: "Temperature")
		}
		if temperatureMax != nil{
			aCoder.encode(temperatureMax, forKey: "TemperatureMax")
		}

	}

}