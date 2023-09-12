//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class DefaultThreshold{

	var phMax : FliprThreshold!
	var phMin : FliprThreshold!
	var redox : FliprThreshold!
	var temperature : FliprThreshold!
	var temperatureMax : FliprThreshold!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let phMaxData = dictionary["PhMax"] as? [String:Any]{
			phMax = FliprThreshold(fromDictionary: phMaxData)
		}
		if let phMinData = dictionary["PhMin"] as? [String:Any]{
			phMin = FliprThreshold(fromDictionary: phMinData)
		}
		if let redoxData = dictionary["Redox"] as? [String:Any]{
			redox = FliprThreshold(fromDictionary: redoxData)
		}
		if let temperatureData = dictionary["Temperature"] as? [String:Any]{
			temperature = FliprThreshold(fromDictionary: temperatureData)
		}
		if let temperatureMaxData = dictionary["TemperatureMax"] as? [String:Any]{
			temperatureMax = FliprThreshold(fromDictionary: temperatureMaxData)
		}
	}

}
