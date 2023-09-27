//
//	TaylorBalance.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class TaylorBalance{

	var pheTextId : Int!
	var pheValue : Double!
	var tacThTextId : Int!
	var tacThValue : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		pheTextId = dictionary["PheTextId"] as? Int
		pheValue = dictionary["PheValue"] as? Double
		tacThTextId = dictionary["TacThTextId"] as? Int
		tacThValue = dictionary["TacThValue"] as? Double
	}

}
