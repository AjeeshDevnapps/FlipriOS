//
//	ControlRSettings.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ControlRSettings{

	var mode : String!
	var moduleName : String!
	var placeName : String!
	var serial : String!
	var state : Int!
	var statut : Bool!
	var userName : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mode = dictionary["Mode"] as? String
		moduleName = dictionary["ModuleName"] as? String
		placeName = dictionary["PlaceName"] as? String
		serial = dictionary["Serial"] as? String
		state = dictionary["State"] as? Int
		statut = dictionary["Statut"] as? Bool
		userName = dictionary["UserName"] as? String
	}

}