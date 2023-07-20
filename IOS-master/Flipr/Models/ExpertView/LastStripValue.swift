//
//	LastStripValue.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class LastStripValue : NSObject, NSCoding{

	var analyze : String!
	var datetime : String!
	var freeChlorine : Double!
	var pH : Double!
	var stabilizer : Double!
	var totalAlk : Double!
	var totalClBr : Double!
	var totalHardness : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		analyze = dictionary["Analyze"] as? String
		datetime = dictionary["Datetime"] as? String
		freeChlorine = dictionary["FreeChlorine"] as? Double
		pH = dictionary["PH"] as? Double
		stabilizer = dictionary["Stabilizer"] as? Double
		totalAlk = dictionary["TotalAlk"] as? Double
		totalClBr = dictionary["TotalClBr"] as? Double
		totalHardness = dictionary["TotalHardness"] as? Double
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
         freeChlorine = aDecoder.decodeObject(forKey: "FreeChlorine") as? Double
         pH = aDecoder.decodeObject(forKey: "PH") as? Double
         stabilizer = aDecoder.decodeObject(forKey: "Stabilizer") as? Double
         totalAlk = aDecoder.decodeObject(forKey: "TotalAlk") as? Double
         totalClBr = aDecoder.decodeObject(forKey: "TotalClBr") as? Double
         totalHardness = aDecoder.decodeObject(forKey: "TotalHardness") as? Double

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
