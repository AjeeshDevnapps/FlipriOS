//
//	Message.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Message{

	var content : String!
	var date : String!
	var finishReason : String!
	var isAiResponse : Bool!
	var role : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		content = dictionary["content"] as? String
		date = dictionary["date"] as? String
		finishReason = dictionary["finish_reason"] as? String
		isAiResponse = dictionary["isAiResponse"] as? Bool
		role = dictionary["role"] as? String
	}

}