//
//	ContactsWatr.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ContactsWatr{

	var email : String!
	var firstName : String!
	var id : Int!
	var isPending : Bool!
    var isInvited : Bool!
    var isKnow : Bool!

	var language : String!
	var lastName : String!
	var sharedHisPlace : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		email = dictionary["Email"] as? String
		firstName = dictionary["FirstName"] as? String
		id = dictionary["Id"] as? Int
		isPending = dictionary["IsPending"] as? Bool
        isInvited = dictionary["IsInvited"] as? Bool
        isKnow = dictionary["Isknow"] as? Bool

		language = dictionary["Language"] as? String
		lastName = dictionary["LastName"] as? String
		sharedHisPlace = dictionary["SharedHisPlace"] as? Bool
	}

}
