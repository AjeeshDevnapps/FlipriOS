//
//	GatewayActivate.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class GatewayActivate{

	var activationKey : String!
	var bEflipr : Bool!
	var batteryPlugDate : String!
	var comments : String!
	var commercialType : AnyObject!
	var ecoMode : Int!
	var enableFliprFirmwareUpgrade : Int!
	var fliprFirmwareUpgradeAttempt : Int!
	var fliprFirmwareUpgradeEnd : AnyObject!
	var fliprFirmwareUpgradeStart : AnyObject!
	var isForSpa : Bool!
	var isSubscriptionValid : Bool!
	var isSuspended : Bool!
	var lastMeasureDateTime : AnyObject!
	var moduleTypeId : Int!
	var noAlertUnil : String!
	var offsetConductivite : Int!
	var offsetOrp : Float!
	var offsetPh : Float!
	var offsetTemperature : Float!
	var pAC : AnyObject!
	var resetsCounter : Int!
	var serial : String!
	var sigfoxStatus : String!
	var status : AnyObject!
	var subscribtionValidUntil : Int!
	var version : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		activationKey = dictionary["ActivationKey"] as? String
		bEflipr = dictionary["BEflipr"] as? Bool
		batteryPlugDate = dictionary["BatteryPlugDate"] as? String
		comments = dictionary["Comments"] as? String
		commercialType = dictionary["CommercialType"] as? AnyObject
		ecoMode = dictionary["Eco_Mode"] as? Int
		enableFliprFirmwareUpgrade = dictionary["EnableFliprFirmwareUpgrade"] as? Int
		fliprFirmwareUpgradeAttempt = dictionary["FliprFirmwareUpgradeAttempt"] as? Int
		fliprFirmwareUpgradeEnd = dictionary["FliprFirmwareUpgradeEnd"] as? AnyObject
		fliprFirmwareUpgradeStart = dictionary["FliprFirmwareUpgradeStart"] as? AnyObject
		isForSpa = dictionary["IsForSpa"] as? Bool
		isSubscriptionValid = dictionary["IsSubscriptionValid"] as? Bool
		isSuspended = dictionary["IsSuspended"] as? Bool
		lastMeasureDateTime = dictionary["LastMeasureDateTime"] as? AnyObject
		moduleTypeId = dictionary["ModuleType_Id"] as? Int
		noAlertUnil = dictionary["NoAlertUnil"] as? String
		offsetConductivite = dictionary["OffsetConductivite"] as? Int
		offsetOrp = dictionary["OffsetOrp"] as? Float
		offsetPh = dictionary["OffsetPh"] as? Float
		offsetTemperature = dictionary["OffsetTemperature"] as? Float
		pAC = dictionary["PAC"] as? AnyObject
		resetsCounter = dictionary["ResetsCounter"] as? Int
		serial = dictionary["Serial"] as? String
		sigfoxStatus = dictionary["SigfoxStatus"] as? String
		status = dictionary["Status"] as? AnyObject
		subscribtionValidUntil = dictionary["SubscribtionValidUntil"] as? Int
		version = dictionary["Version"] as? Int
	}

}




class UserGateway{

    var moduleType : Int!
    var serial : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        moduleType = dictionary["ModuleType"] as? Int
        serial = dictionary["Serial"] as? String
    }

}
