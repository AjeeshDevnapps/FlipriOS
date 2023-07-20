//
//	SliderStrip.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SliderStrip : NSObject, NSCoding{

	var analyze : String!
	var datetime : String!
	var freeChlorine : Int!
	var lSI : Int!
	var pH : Int!
	var stabilizer : Int!
	var totalAlk : Int!
	var totalClBr : Int!
	var totalHardness : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		analyze = dictionary["Analyze"] as? String
		datetime = dictionary["Datetime"] as? String
		freeChlorine = dictionary["FreeChlorine"] as? Int
		lSI = dictionary["LSI"] as? Int
		pH = dictionary["PH"] as? Int
		stabilizer = dictionary["Stabilizer"] as? Int
		totalAlk = dictionary["TotalAlk"] as? Int
		totalClBr = dictionary["TotalClBr"] as? Int
		totalHardness = dictionary["TotalHardness"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if analyze != nil{
			dictionary["Analyze"] = analyze
		}
		if datetime != nil{
			dictionary["Datetime"] = datetime
		}
		if freeChlorine != nil{
			dictionary["FreeChlorine"] = freeChlorine
		}
		if lSI != nil{
			dictionary["LSI"] = lSI
		}
		if pH != nil{
			dictionary["PH"] = pH
		}
		if stabilizer != nil{
			dictionary["Stabilizer"] = stabilizer
		}
		if totalAlk != nil{
			dictionary["TotalAlk"] = totalAlk
		}
		if totalClBr != nil{
			dictionary["TotalClBr"] = totalClBr
		}
		if totalHardness != nil{
			dictionary["TotalHardness"] = totalHardness
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         analyze = aDecoder.decodeObject(forKey: "Analyze") as? String
         datetime = aDecoder.decodeObject(forKey: "Datetime") as? String
         freeChlorine = aDecoder.decodeObject(forKey: "FreeChlorine") as? Int
         lSI = aDecoder.decodeObject(forKey: "LSI") as? Int
         pH = aDecoder.decodeObject(forKey: "PH") as? Int
         stabilizer = aDecoder.decodeObject(forKey: "Stabilizer") as? Int
         totalAlk = aDecoder.decodeObject(forKey: "TotalAlk") as? Int
         totalClBr = aDecoder.decodeObject(forKey: "TotalClBr") as? Int
         totalHardness = aDecoder.decodeObject(forKey: "TotalHardness") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if analyze != nil{
			aCoder.encode(analyze, forKey: "Analyze")
		}
		if datetime != nil{
			aCoder.encode(datetime, forKey: "Datetime")
		}
		if freeChlorine != nil{
			aCoder.encode(freeChlorine, forKey: "FreeChlorine")
		}
		if lSI != nil{
			aCoder.encode(lSI, forKey: "LSI")
		}
		if pH != nil{
			aCoder.encode(pH, forKey: "PH")
		}
		if stabilizer != nil{
			aCoder.encode(stabilizer, forKey: "Stabilizer")
		}
		if totalAlk != nil{
			aCoder.encode(totalAlk, forKey: "TotalAlk")
		}
		if totalClBr != nil{
			aCoder.encode(totalClBr, forKey: "TotalClBr")
		}
		if totalHardness != nil{
			aCoder.encode(totalHardness, forKey: "TotalHardness")
		}

	}

}