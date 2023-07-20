//
//	LSI.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class LSI : NSObject, NSCoding{

	var lSICoeff : Float!
	var lSIStr : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		lSICoeff = dictionary["LSI_Coeff"] as? Float
		lSIStr = dictionary["LSI_Str"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if lSICoeff != nil{
			dictionary["LSI_Coeff"] = lSICoeff
		}
		if lSIStr != nil{
			dictionary["LSI_Str"] = lSIStr
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         lSICoeff = aDecoder.decodeObject(forKey: "LSI_Coeff") as? Float
         lSIStr = aDecoder.decodeObject(forKey: "LSI_Str") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if lSICoeff != nil{
			aCoder.encode(lSICoeff, forKey: "LSI_Coeff")
		}
		if lSIStr != nil{
			aCoder.encode(lSIStr, forKey: "LSI_Str")
		}

	}

}