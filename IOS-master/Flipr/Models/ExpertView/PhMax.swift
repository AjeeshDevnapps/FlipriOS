//
//	PhMax.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PhMax : NSObject, NSCoding{

	var isDefaultValue : Bool!
	var value : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		isDefaultValue = dictionary["IsDefaultValue"] as? Bool
		value = dictionary["Value"] as? Double
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if isDefaultValue != nil{
			dictionary["IsDefaultValue"] = isDefaultValue
		}
		if value != nil{
			dictionary["Value"] = value
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         isDefaultValue = aDecoder.decodeObject(forKey: "IsDefaultValue") as? Bool
         value = aDecoder.decodeObject(forKey: "Value") as? Double

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if isDefaultValue != nil{
			aCoder.encode(isDefaultValue, forKey: "IsDefaultValue")
		}
		if value != nil{
			aCoder.encode(value, forKey: "Value")
		}

	}

}
