//
//	PhMax.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class FliprThreshold{

	var isDefaultValue : Bool!
	var value : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		isDefaultValue = dictionary["IsDefaultValue"] as? Bool
		value = dictionary["Value"] as? Double
	}

}
