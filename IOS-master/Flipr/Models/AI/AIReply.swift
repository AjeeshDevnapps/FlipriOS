//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AIReply{

	var dialog : [Dialog]!
	var fliprAI : FliprAI!
	var limitCharact : Int!
	var message : Dialog!
	var totalTokens : Int!
    
    
    
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		dialog = [Dialog]()
		if let dialogArray = dictionary["Dialog"] as? [[String:Any]]{
			for dic in dialogArray{
				let value = Dialog(fromDictionary: dic)
				dialog.append(value)
			}
		}
		if let fliprAIData = dictionary["FliprAI"] as? [String:Any]{
			fliprAI = FliprAI(fromDictionary: fliprAIData)
		}
		limitCharact = dictionary["LimitCharact"] as? Int
		if let messageData = dictionary["Message"] as? [String:Any]{
			message = Dialog(fromDictionary: messageData)
		}
		totalTokens = dictionary["TotalTokens"] as? Int
	}

}

class AIQustnNreply{
    var qustion: String?
    var message : Dialog?
}
