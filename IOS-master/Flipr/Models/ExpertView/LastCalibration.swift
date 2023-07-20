//
//	LastCalibration.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class LastCalibration : NSObject, NSCoding{

	var conductivity : Float!
	var data : String!
	var dataType : Int!
	var dateTime : String!
	var deviceId : String!
	var isInactivated : Bool!
	var mesureId : Int!
	var oxydoReducPotentiel : Float!
	var rawBatteryLevel : Int!
	var rawBestOrp : Int!
	var rawConductivity : Int!
	var rawOxydoReducPotentiel : Int!
	var rawPH : Float!
	var rawPhSensorVoltage : Int!
	var rawTemperature : Int!
	var source : String!
	var temperature : Float!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		conductivity = dictionary["Conductivity"] as? Float
		data = dictionary["Data"] as? String
		dataType = dictionary["DataType"] as? Int
		dateTime = dictionary["DateTime"] as? String
		deviceId = dictionary["DeviceId"] as? String
		isInactivated = dictionary["IsInactivated"] as? Bool
		mesureId = dictionary["MesureId"] as? Int
		oxydoReducPotentiel = dictionary["OxydoReducPotentiel"] as? Float
		rawBatteryLevel = dictionary["RawBatteryLevel"] as? Int
		rawBestOrp = dictionary["RawBestOrp"] as? Int
		rawConductivity = dictionary["RawConductivity"] as? Int
		rawOxydoReducPotentiel = dictionary["RawOxydoReducPotentiel"] as? Int
		rawPH = dictionary["RawPH"] as? Float
		rawPhSensorVoltage = dictionary["RawPhSensorVoltage"] as? Int
		rawTemperature = dictionary["RawTemperature"] as? Int
		source = dictionary["Source"] as? String
		temperature = dictionary["Temperature"] as? Float
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if conductivity != nil{
			dictionary["Conductivity"] = conductivity
		}
		if data != nil{
			dictionary["Data"] = data
		}
		if dataType != nil{
			dictionary["DataType"] = dataType
		}
		if dateTime != nil{
			dictionary["DateTime"] = dateTime
		}
		if deviceId != nil{
			dictionary["DeviceId"] = deviceId
		}
		if isInactivated != nil{
			dictionary["IsInactivated"] = isInactivated
		}
		if mesureId != nil{
			dictionary["MesureId"] = mesureId
		}
		if oxydoReducPotentiel != nil{
			dictionary["OxydoReducPotentiel"] = oxydoReducPotentiel
		}
		if rawBatteryLevel != nil{
			dictionary["RawBatteryLevel"] = rawBatteryLevel
		}
		if rawBestOrp != nil{
			dictionary["RawBestOrp"] = rawBestOrp
		}
		if rawConductivity != nil{
			dictionary["RawConductivity"] = rawConductivity
		}
		if rawOxydoReducPotentiel != nil{
			dictionary["RawOxydoReducPotentiel"] = rawOxydoReducPotentiel
		}
		if rawPH != nil{
			dictionary["RawPH"] = rawPH
		}
		if rawPhSensorVoltage != nil{
			dictionary["RawPhSensorVoltage"] = rawPhSensorVoltage
		}
		if rawTemperature != nil{
			dictionary["RawTemperature"] = rawTemperature
		}
		if source != nil{
			dictionary["Source"] = source
		}
		if temperature != nil{
			dictionary["Temperature"] = temperature
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         conductivity = aDecoder.decodeObject(forKey: "Conductivity") as? Float
         data = aDecoder.decodeObject(forKey: "Data") as? String
         dataType = aDecoder.decodeObject(forKey: "DataType") as? Int
         dateTime = aDecoder.decodeObject(forKey: "DateTime") as? String
         deviceId = aDecoder.decodeObject(forKey: "DeviceId") as? String
         isInactivated = aDecoder.decodeObject(forKey: "IsInactivated") as? Bool
         mesureId = aDecoder.decodeObject(forKey: "MesureId") as? Int
         oxydoReducPotentiel = aDecoder.decodeObject(forKey: "OxydoReducPotentiel") as? Float
         rawBatteryLevel = aDecoder.decodeObject(forKey: "RawBatteryLevel") as? Int
         rawBestOrp = aDecoder.decodeObject(forKey: "RawBestOrp") as? Int
         rawConductivity = aDecoder.decodeObject(forKey: "RawConductivity") as? Int
         rawOxydoReducPotentiel = aDecoder.decodeObject(forKey: "RawOxydoReducPotentiel") as? Int
         rawPH = aDecoder.decodeObject(forKey: "RawPH") as? Float
         rawPhSensorVoltage = aDecoder.decodeObject(forKey: "RawPhSensorVoltage") as? Int
         rawTemperature = aDecoder.decodeObject(forKey: "RawTemperature") as? Int
         source = aDecoder.decodeObject(forKey: "Source") as? String
         temperature = aDecoder.decodeObject(forKey: "Temperature") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if conductivity != nil{
			aCoder.encode(conductivity, forKey: "Conductivity")
		}
		if data != nil{
			aCoder.encode(data, forKey: "Data")
		}
		if dataType != nil{
			aCoder.encode(dataType, forKey: "DataType")
		}
		if dateTime != nil{
			aCoder.encode(dateTime, forKey: "DateTime")
		}
		if deviceId != nil{
			aCoder.encode(deviceId, forKey: "DeviceId")
		}
		if isInactivated != nil{
			aCoder.encode(isInactivated, forKey: "IsInactivated")
		}
		if mesureId != nil{
			aCoder.encode(mesureId, forKey: "MesureId")
		}
		if oxydoReducPotentiel != nil{
			aCoder.encode(oxydoReducPotentiel, forKey: "OxydoReducPotentiel")
		}
		if rawBatteryLevel != nil{
			aCoder.encode(rawBatteryLevel, forKey: "RawBatteryLevel")
		}
		if rawBestOrp != nil{
			aCoder.encode(rawBestOrp, forKey: "RawBestOrp")
		}
		if rawConductivity != nil{
			aCoder.encode(rawConductivity, forKey: "RawConductivity")
		}
		if rawOxydoReducPotentiel != nil{
			aCoder.encode(rawOxydoReducPotentiel, forKey: "RawOxydoReducPotentiel")
		}
		if rawPH != nil{
			aCoder.encode(rawPH, forKey: "RawPH")
		}
		if rawPhSensorVoltage != nil{
			aCoder.encode(rawPhSensorVoltage, forKey: "RawPhSensorVoltage")
		}
		if rawTemperature != nil{
			aCoder.encode(rawTemperature, forKey: "RawTemperature")
		}
		if source != nil{
			aCoder.encode(source, forKey: "Source")
		}
		if temperature != nil{
			aCoder.encode(temperature, forKey: "Temperature")
		}

	}

}