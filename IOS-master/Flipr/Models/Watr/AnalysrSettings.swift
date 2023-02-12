//
//	AnalysrSettings.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AnalysrSettings{

	var lastMeasureDateTime : String!
	var model : String!
	var percentageBattery : Double!
	var placeName : String!
	var serial : String!
	var tensionBattery : Double!
	var userName : String!
	var version : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		lastMeasureDateTime = dictionary["LastMeasureDateTime"] as? String
		model = dictionary["Model"] as? String
		percentageBattery = dictionary["PercentageBattery"] as? Double
		placeName = dictionary["PlaceName"] as? String
		serial = dictionary["Serial"] as? String
		tensionBattery = dictionary["TensionBattery"] as? Double
		userName = dictionary["UserName"] as? String
		version = dictionary["Version"] as? Int
	}

}
