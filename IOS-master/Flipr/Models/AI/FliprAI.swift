//
//	FliprAI.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class FliprAI{

	var creditAllowed : Int!
	var creditUsed : Int!
	var dialogDatetime : AnyObject!
	var hasAccept : Bool!
	var id : Int!
	var lastDialog : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		creditAllowed = dictionary["CreditAllowed"] as? Int
		creditUsed = dictionary["CreditUsed"] as? Int
		dialogDatetime = dictionary["DialogDatetime"] as? AnyObject
		hasAccept = dictionary["HasAccept"] as? Bool
		id = dictionary["Id"] as? Int
		lastDialog = dictionary["LastDialog"] as? String
	}

}