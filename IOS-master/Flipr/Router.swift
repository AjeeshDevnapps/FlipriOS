//
//  Router.swift
//  UGGO
//
//  Created by Benjamin McMurrich on 20/02/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case updateUserProfile(firstName: String, lastName: String, password: String)
    case createNewUser(email: String)
    case deleteUser

    case authentifyUser(email: String, password: String)
    case createUser(email: String, password: String, lastName: String, firstName: String, phone: String)
    case readAccountActivation(email: String)
    case resetPassword(email: String)
    case changePassword(oldPassword: String, newPassword: String)
    case readUser
    case readUserNotifications
    case updateDeviceToken(token:String)

    case updateUserNotifications(activate: Bool)
    case updateLanguage
    case updateUserInfo(lastName: String, firstName: String)
    
    case sendSubscriptionReceipt(data:Data)
    
    case addMobileDevice(token: String)
    
    case addModule(serial: String, activationKey: String, delete: Bool)
    case addModuleEquipment(serial: String, code: String)
    case forgetModuleEquipment(serial: String, code: String)

    case getModules
    case createPlace(typeId:String)
    case updatePlace(placeId:String)
    case getPlaces
    case getPlaceModules(placeId: String)

    
    //case addStripTest(poolId:Int,params:[String:Any])
    case addStripTest(params:[String:Any])
    
    case readModuleLastMetrics(serialId: String)
    case readModuleLastSurvey(serialId: String)
    case readModuleResume(serialId: String)
    case sendModuleMetrics(serialId: String, data: String, type:String)
    case readModuleHourlyMetrics(serialId: String)
    case readModuleDailyMetrics(serialId: String)
    case removeModule(serialId: String)
    
    case readModuleThresholds(serialId: String)
    case resetModuleThresholds(serialId: String)
    case resetModuleThreshold(serialId: String, name:String)
    case updateModuleThreshold(serialId: String, name:String, value:Double)
    
    case getFormValues(apiPath: String)
    
    case createPool(serialId: String, attributes:[String:Any])
    case updatePool(attributes:[String:Any])
    case getPools
    case getAlerts(serial: String)
    case postponeAlerts(serial: String, value:Int)
    case closeAlert(serial: String, alertId:String)
    
    case getProduct(EAN: Int64)
    case getProductTypes
    case getProductAttributes(type:ProductAttributeType)
    case getProductUnits(type:ProductAttributeType, conditioning:ProductAttribute)
    case addProductAttribute(type:ProductAttributeType, named:String)
    case getEquipments
    case getPoolEquipments(poolId:Int)
    case updatePoolEquipments(poolId:Int, equipmentIds:[Int])
    
    case getStock(poolId:Int)
    case addProduct(product:Product)
    case updateProduct(product:Product)
    case addStock(poolId:Int, product:Product, quantity: Double)
    case deleteStock(poolId:Int, stockId:Int)
    case updateStock(poolId:Int, stockId:Int, quantity: Double)
    
    case getWaterLevels(poolId:Int)
    case addWaterLevel(poolId:Int, date:Date, quantity: Double)
    case deleteWaterLevel(poolId:Int, waterLevelId:Int)
    
    case getShopUrl(poolId:Int)
    case getLog(poolId:Int, nbItems:Int, page:Int)
    case deleteLog(poolId:Int, logId:Int)
    case getLogTypes
    case addLog(poolId:Int, attributes:[String:Any])
    case updateLog(poolId:Int, logId:Int, attributes:[String:Any])
    
    case getHUBS(poolId: Int)
    case getHUBState(serial: String)
    case updateHUBState(serial: String, value:String)
    case updateHUBBehavior(serial: String, value:String)
    case updateHUBName(serial: String, value:String)
    case getHUBPlannings(serial: String)
    case deleteHUBPlanning(serial: String, id:Int)
    case updateHUBPlannings(serial: String, attributes:[String:Any])
    case reactivateAlert(serial: String,status:Bool)
    case updatedFirmwere(serial: String,version:String)

    case startedUpdatedFirmwere(serial: String)
    case getPlaceTypes

    
    //Shares
    case viewShares(poolId: String)
    case addShare(poolId: String, email: String, permissionLevel: FliprRole)
    case updateShare(poolId: String, email: String, permissionLevel: FliprRole)
    case deleteShare(poolId: String, email: String)
    case acceptShare(poolId: String)

    //Place
    case deletePlace(placeId: String)


    //PoolSettings
    case getPoolSettings(poolId: String)
   
    
    //Legacy
    //static let baseURLString = K.Server.BaseUrl + K.Server.ApiPath
    

    
    //Prod
    static let baseURLString = "https://apis.goflipr.com/"
    
    
    //Recette
    static let baseDevURLString = "https://flipr-api-prod-recette.azurewebsites.net/"
    
    var method: HTTPMethod {
        switch self {
        case .createPlace:
            return .post
        case .updatePlace:
            return .put
        case .reactivateAlert:
            return .put
        case .authentifyUser:
            return .post
        case .createUser:
            return .post
        case .deleteUser:
            return .delete
        case .readAccountActivation:
            return .get
        case .resetPassword:
            return .post
        case .changePassword:
            return .put
        case .readUser:
            return .get
        case .readUserNotifications:
            return .get
        case .updateDeviceToken:
            return .put
        case .updateUserNotifications:
            return .put
        case .updateLanguage:
            return .put
        case .updateUserInfo:
            return .put
        case .sendSubscriptionReceipt:
            return .post
        case .addMobileDevice:
            return .post
        case .addModule:
            return .post
        case .addModuleEquipment:
            return .post
        case .forgetModuleEquipment:
            return .delete
        case .getModules:
            return .get
        case .getPlaces:
            return .get

        case .addStripTest:
            return .post
        case .readModuleLastMetrics:
            return .get
        case .readModuleLastSurvey:
            return .get
        case .readModuleResume:
            return .get
        case .readModuleThresholds:
            return .get
        case .resetModuleThresholds:
            return .put
        case .resetModuleThreshold:
            return .put
        case .updateModuleThreshold:
            return .put
        case .sendModuleMetrics:
            return .post
        case .readModuleHourlyMetrics:
            return .get
        case .readModuleDailyMetrics:
            return .get
        case .removeModule:
            return .delete
        case .getFormValues:
            return .get
        case .getPlaceModules:
            return .get

        case .createPool:
            return .post
        case .updatePool:
            return .put
        case .getPools:
            return .get
        case .getAlerts:
            return .get
        case .postponeAlerts:
            return .post
        case .closeAlert:
            return .put
        case .getProduct:
            return .get
        case .getProductTypes:
            return .get
        case .getProductAttributes:
            return .get
        case .getProductUnits:
            return .get
        case .addProductAttribute:
            return .post
        case .getEquipments:
            return .get
        case .getPoolEquipments:
            return .get
        case .updatePoolEquipments:
            return .put
        case .getStock:
            return .get
        case .addProduct:
            return .post
        case .updateProduct:
            return .put
        case .addStock:
            return .post
        case .deleteStock:
            return .delete
        case .updateStock:
            return .put
        case .getWaterLevels:
            return .get
        case .addWaterLevel:
            return .post
        case .deleteWaterLevel:
            return .delete
        case .getShopUrl:
            return .get
        case .getLog:
            return .get
        case .deleteLog:
            return .delete
        case .getLogTypes:
            return .get
        case .addLog:
            return .post
        case .updateLog:
            return .put
        case .getHUBS:
            return .get
        case .getHUBState:
            return .get
        case .updateHUBState:
            return .post
        case .updateHUBBehavior:
            return .put
        case .updateHUBName:
            return .put
        case .getHUBPlannings:
            return .get
        case .updateHUBPlannings:
            return .post
        case .deleteHUBPlanning:
            return .delete
        case .createNewUser:
            return .post
        case .updateUserProfile:
            return .put
        case .updatedFirmwere:
            return .put
        case .startedUpdatedFirmwere:
            return .put
            
        case .viewShares:
            return .get
        case .addShare:
            return .post
        case .updateShare:
            return .put
        case .deleteShare:
            return .delete
            
        case .deletePlace:
            return .delete
        case .getPoolSettings:
            return .get
           
        case .getPlaceTypes:
            return .get
            
        case .acceptShare:
            return .post
            
        }
    }
    
    var path: String {
        switch self {
        case .createPlace(let typeId):
            return "place"
        case .updatePlace(let placeId):
            return "place/\(placeId)"

        case .authentifyUser:
            return "oauth2/token"
        case .createUser:
            return "accounts"
        case .deleteUser:
            return "Account"
        case .readAccountActivation:
            return "accounts/isActivated"
        case .resetPassword:
            return "pwd"
        case .changePassword:
            return "pwd"
        case .readUser:
            return "accounts"
        case .readUserNotifications:
            return "accounts/notifications"
        case .updateUserNotifications:
            return "accounts/notifications"
        case .updateDeviceToken(_):
            return "accounts/UpdateTokenDevice"
        case .updateLanguage:
            return "accounts"
        case .updateUserInfo:
            return "accounts"
        case .sendSubscriptionReceipt:
            return "accounts/subscription/iTunes"
            
        case .reactivateAlert(_):
            return "accounts/"
        case .addMobileDevice:
            return "mobiles"
            
        case .addModule:
            return "modules/activate"
        case .addModuleEquipment(let serial, let code):
            return "hub/\(serial)/Equipment/Add/\(code)"
        case .forgetModuleEquipment(let serial, let code):
            return "modules/\(serial)"
            
        case .getModules:
            return "modules"
            
        case .getPlaces:
            return "place"
        
        case .getPlaceModules(_):
            return "modules/ListPlaceModules"
        
        //case .addStripTest(let poolId,_):
        //    return "pools/\(poolId)/strip"
        case .addStripTest:
            return "data/strip"

        case .readModuleLastMetrics(let serialId):
            return "data/\(serialId)/report/last"
        case .readModuleLastSurvey(let serialId):
            return "modules/\(serialId)/survey/last"
        case .readModuleResume(let serialId):
            return "modules/\(serialId)/NewResume"
        case .removeModule(let serialId):
            return "modules/\(serialId)"
            
        case .readModuleThresholds(let serialId):
            return "modules/\(serialId)/thresholds"
        case .resetModuleThresholds(let serialId):
            return "modules/\(serialId)/thresholds"
        case .resetModuleThreshold(let serialId,_):
            return "modules/\(serialId)/thresholds"
        case .updateModuleThreshold(let serialId,_,_):
            return "modules/\(serialId)/thresholds"
        case .sendModuleMetrics:
            return "callback/bluetooth"
            
        case .readModuleHourlyMetrics(let serialId):
            return "modules/\(serialId)/survey/lastHours/" + "72".remotable("HISTORIC_LAST_HOURS")
        case .readModuleDailyMetrics(let serialId):
            return "modules/\(serialId)/survey/statsPerDays/" + "31".remotable("HISTORIC_STATS_PER_DAYS")
            
        case .getFormValues(let path):
            return "pools/\(path)"
            
        case .createPool(let serialId, _):
            return "pools/\(serialId)"
        case .updatePool(let attributes):
            if let id = attributes["Id"] as? Int {
                return "pools/\(id)"
            }
            return "pools"
        case .getPools:
            return "pools"
        case .getAlerts(let serial):
            return "modules/\(serial)/alerts"
        case .postponeAlerts(let serial, _):
            return "modules/\(serial)/alerts/postpone"
        case .closeAlert(let serial, let id):
            return "modules/\(serial)/alerts/\(id)/close"
        case .getProduct:
            return "maintenance/chemical"
        case .getProductTypes:
            return "maintenance/type"
        case .getProductAttributes(let type):
            return "maintenance/\(type.rawValue)"
        case .getProductUnits(let type,let conditioning):
            return "maintenance/conditioning/\(conditioning.id)/\(type.rawValue)"
        case .addProductAttribute(let type, _):
            return "maintenance/\(type.rawValue)"
        case .getEquipments:
            return "pools/equipments"
        case .getPoolEquipments(let poolId):
            return "pools/\(poolId)/equipments"
        case .updatePoolEquipments(let poolId, _):
            return "pools/\(poolId)/equipments"
        case .getStock(let poolId):
            return "pools/\(poolId)/stock"
        case .addProduct:
            return "maintenance/chemical"
        case .updateProduct(let product):
            return "maintenance/chemical/\(product.id!)"
        case .addStock(let poolId,_,_):
            return "pools/\(poolId)/stock"
        case .deleteStock(let poolId, let id):
            return "pools/\(poolId)/stock/\(id)"
        case .updateStock(let poolId, let id, _):
            return "pools/\(poolId)/stock/\(id)"
        case .getWaterLevels(let poolId):
            return "pools/\(poolId)/waterLevel"
        case .addWaterLevel(let poolId,_,_):
            return "pools/\(poolId)/waterLevel"
        case .deleteWaterLevel(let poolId, let id):
            return "pools/\(poolId)/waterLevel/\(id)"
        case .getShopUrl(let poolId):
            return "pools/\(poolId)/Shop"
        case .getLog(let poolId,_, _):
            return "pools/\(poolId)/Log"
        case .deleteLog(let poolId, let logId):
            return "pools/\(poolId)/Log/\(logId)"
        case .getLogTypes:
            return "pools/Log/Types"
        case .addLog(let poolId, _):
            return "pools/\(poolId)/Log"
        case .updateLog(let poolId, let logId, _):
            return "pools/\(poolId)/Log/\(logId)"
            
            //flipr
//        case .getHUBS(let poolId):
//            return "hub/Pool/\(poolId)/AllHubs"
            
                //water
        case .getHUBS(let poolId):
            return "hub/Place/\(poolId)/AllHubs"

        case .getHUBState(let serial):
            return "hub/\(serial)/state"
        case .updateHUBState(let serial, let value):
            return "hub/\(serial)/Manual/\(value)"
        case .updateHUBBehavior(let serial, let value):
            return "hub/\(serial)/mode/\(value)"
        case .updateHUBName(let serial, _):
            return "hub/\(serial)/Equipment/Name"
        case .getHUBPlannings(let serial):
            return "hub/\(serial)/GetPlannings"
        case .deleteHUBPlanning(let serial, _):
            return "hub/\(serial)/DeleteSinglePlanning"
        case .updateHUBPlannings(let serial, _):
            return "hub/\(serial)/AddPlannings"
        case .createNewUser:
            return "accounts/new"
        case .updateUserProfile(_ ,_ ,_):
            return "accounts/all"
        case .updatedFirmwere(let serial,let version):
            return "modules/"
        case .startedUpdatedFirmwere(let serial):
            return "modules/"
        case .viewShares(let poolId):
            return "place/\(poolId)/shares"
        case .addShare(poolId: let poolId, email: let email, permissionLevel: let permissionLevel):
            return "place/\(poolId)/shares"
        case .updateShare(poolId: let poolId, email: let email, permissionLevel: let permissionLevel):
            return "place/\(poolId)/shares"
        case .deleteShare(poolId: let poolId, email: let email):
            return "place/\(poolId)/shares"
            
        case .deletePlace(placeId: let placeId):
            return "place/\(placeId)"
        case .getPoolSettings(poolId: let poolId):
            return "place/\(poolId)"
        case .getPlaceTypes:
            return "place/types"
            
        case .acceptShare(let poolId):
            return "place/\(poolId)/shares/accept"

            
            
        }

    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        var url = try Router.baseURLString.asURL()
        let severType = UserDefaults.standard.bool(forKey: K.AppConstant.CurrentServerIsDev)
        if severType == true {
            url = try Router.baseDevURLString.asURL()
        }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        if let userToken = User.currentUser?.token {
            urlRequest.addValue("bearer " + userToken, forHTTPHeaderField: "Authorization")
            if let preferredLanguage = Locale.current.languageCode {
                urlRequest.addValue(preferredLanguage, forHTTPHeaderField: "Accept-Language")
            }
            debugPrint("bearer " + userToken)
        }
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .createNewUser(let email):
            var lang = "en"
            if let preferredLanguage = Locale.current.languageCode {
                lang = preferredLanguage
            }
            let parameters: [String : Any] = [
                "email": email,
                "lang": lang
            ]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            
            
            
        case .updateUserProfile(let firstName, let lastName, let password):
            let parameters: [String: Any] = [
                "firstname": firstName,
                "lastname": lastName
            ]
            if let url = urlRequest.url?.absoluteString {
                urlRequest.url = URL(string: url + "?NewPass=\(password)")
            }
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
          
        case .getPlaceModules(let placeId):
            if let url = urlRequest.url?.absoluteString {
                urlRequest.url = URL(string: url + "?idPlace=\(placeId)")
            }
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)

            
        case .authentifyUser(let email, let password):
            let parameters: [String : Any] = [
                "username": email,
                "password": password,
                "grant_type": "password"
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .createUser(let email, let password, let lastName, let firstName, let phone):
            var lang = "en"
            if let preferredLanguage = Locale.current.languageCode {
                lang = preferredLanguage
            }
            let parameters: [String : Any] = [
                "Email": email,
                "Password": password,
                "Lastname": lastName,
                "Firstname": firstName,
                "Phone": phone,
                "Lang": lang,
                "Birthday":"1900-01-01T00:00:00.0000000+00:00",
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .updateUserInfo( let lastName, let firstName):
            var lang = "en"
            if let preferredLanguage = Locale.current.languageCode {
                lang = preferredLanguage
            }
            let parameters: [String : Any] = [
                "Lastname": lastName,
                "Firstname": firstName,
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .readAccountActivation(let email):
            let parameters: [String : Any] = [
                "email": email,
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .updateLanguage:
            var lang = "en"
            if let preferredLanguage = Locale.current.languageCode {
                lang = preferredLanguage
            }
            let parameters: [String : Any] = [
                "Lang": lang
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .sendSubscriptionReceipt(let data):

            let parameters: [String : Any] = [
                "receipt": data.base64EncodedString(),
                "isTest": false
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .resetPassword(let email):
            let parameters: [String : Any] = [
                "email": email
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .changePassword(let oldPassword, let newPassword):
            let parameters: [String : Any] = [
                "OldPassword": oldPassword,
                "NewPassword": newPassword
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        
        case .updateUserNotifications(let activate):
            let parameters: [String : Any] = [
                "Value": !activate
            ]
            print("updateUserNotifications: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .updateDeviceToken(let token):
            let parm: [String : Any] = [
                "Token": token
            ]
            print("update Device fcm token: \(parm)")
            
            if let url = urlRequest.url?.absoluteString {
                urlRequest.url = URL(string: url + "?Token=\(token)")
            }
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parm)
            
        case .addMobileDevice(let token):
            let parameters: [String : Any] = [
                "MobileUID": token,
                "DeviceType": "iOS"
            ]
            print("Posting measures with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .addModule(let serial, let activationKey, let delete):
            let parameters: [String : Any] = [
                "Serial": serial,
//                "ActivationKey": activationKey,
//                "Delete": delete,
                "placeId" : AppSharedData.sharedInstance.addedPlaceId,
//                "NickName": "Flipr " + serial
            ]
            print(parameters)
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        //case .addStripTest(_,let params):
        case .addStripTest(let params):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            
        case .sendModuleMetrics(let serialId, let data, let type):
            let parameters: [String : Any] = [
                "data": data,
                "device": serialId,
                "time": String(format: "%.0f", NSDate().timeIntervalSince1970),
                "callbackType": type
            ]
            print("Posting measures with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .resetModuleThresholds(_):
            let parameters: [String : Any] = [
                "Conductivity": ["IsDefaultValue":true],
                "PhMax": ["IsDefaultValue":true],
                "PhMin": ["IsDefaultValue":true],
                "Redox": ["IsDefaultValue":true],
                "Temperature": ["IsDefaultValue":true],"TemperatureMax": ["IsDefaultValue":true]
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .resetModuleThreshold(_, let name):
            let parameters: [String : Any] = [
                name: ["IsDefaultValue":true],
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .updateModuleThreshold(_, let name, let value):
            let parameters: [String : Any] = [
                name: ["IsDefaultValue":false,
                    "Value":value],
                ]
            print("updateModuleThreshold parameters \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .createPool(_, let attributes):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: attributes)
        case .updatePool(let attributes):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: attributes)
        
        case .getPools:
            
            if let serial = Module.currentModule?.serial {
                let parameters: [String : Any] = [
                    "serial":serial
                ]
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            }
            
        case .postponeAlerts(_, let value):
            let parameters: [String : Any] = [
                "Value": value
            ]
            print("Postpone Alerts with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .getProduct(let EAN):
            let parameters: [String : Any] = [
                "EAN": EAN
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .addProduct(let product):
            let parameters: [String : Any] = product.serialized
            print("Add product with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .updateProduct(let product):
            let parameters: [String : Any] = product.serialized
            print("Update product with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .addProductAttribute(_, let named):
            let parameters: [String : Any] = [
                "name": named
            ]
            print("Add productAttributes with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .addStock(_ , let product, let quantity):
            let parameters: [String : Any] = [
                "EAN":product.EAN,
                "Quantity": quantity
            ]
            print("Add stock with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .updateStock(_ , _, let quantity):
            let parameters: [String : Any] = [
                "Quantity": quantity
            ]
            print("Update stock with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .addWaterLevel(_ , let date, let quantity):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let parameters: [String : Any] = [
                "Date":formatter.string(from: date),
                "FillPercentage": quantity
            ]
            print("Add water level with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .updatePoolEquipments( _, let equipments):
            let parameters: [String : Any] = [
                "Ids": equipments
            ]
            print("Update pool equipments with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .getFormValues(_):
            var poolType = 0
            if let module = Module.currentModule {
                if module.isForSpa {
                    poolType = 1
                }
            }
            let parameters: [String : Any] = [
                "poolType": poolType
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .getEquipments:
            var poolType = 0
            if let module = Module.currentModule {
                if module.isForSpa {
                    poolType = 1
                }
            }
            let parameters: [String : Any] = [
                "poolType": poolType
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        case .getLog(_,let nbItems, let page):
            let parameters: [String : Any] = [
                "page": page,
                "nbItems":nbItems
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .addLog(_, let attributes):
            print("Add log with ttributes: \(attributes)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: attributes)
        
        case .updateLog(_,_,let attributes):
            print("Update log with ttributes: \(attributes)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: attributes)
            
        case .updateHUBState(_,_):
            let parameters: [String : Any] = [:]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        
        case .updateHUBName(_, let value):
            print("update HUB name: \(value)")
            let parameters: [String : Any] = ["NameEquipment":value]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .deleteHUBPlanning(_,let id):
            let parameters: [String : Any] = ["idPlanning":id]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)

        case .updateHUBPlannings(_, let attributes):
            print("update Plannings attributes: \(attributes)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: attributes)
            
        case .forgetModuleEquipment(_, _):
            let parameters: [String : Any] = [
                "Status": 20,
                "Comments": "Changed made by the User"
            ]
            print("Add productAttributes with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .reactivateAlert(let serial, let status):
            if let url = urlRequest.url?.absoluteString {
                urlRequest.url = URL(string: url + "\(serial)/ReactivationNotification?notification=\(status)")
            }
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
            
        case .updatedFirmwere(let serial, let version):
            if let url = urlRequest.url?.absoluteString {
                urlRequest.url = URL(string: url + "\(serial)/UpdateSoftwareVersion?Version=\(version)")
            }
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
            
        case .startedUpdatedFirmwere(let serial):
            if let url = urlRequest.url?.absoluteString {
                urlRequest.url = URL(string: url + "\(serial)/UpdateStartFirmwareUpgrade")
            }
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
            
        case .viewShares(poolId: let poolId):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [:])
            
        case .addShare(poolId: let poolId, email: let email, permissionLevel: let permissionLevel):
            var permission: String = ""
            switch permissionLevel {
            case .guest:
                permission = "View"
            case .boy:
                permission = "Manage"
            case .man:
                permission = "Admin"
            }
            let parameters: [String : Any] = [
                "GuestUser": email,
                "PermissionLevel": permission
            ]
            print("Posting measures with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .updateShare(poolId: let poolId, email: let email, permissionLevel: let permissionLevel):
            var permission: String = ""
            switch permissionLevel {
            case .guest:
                permission = "View"
            case .boy:
                permission = "Manage"
            case .man:
                permission = "Admin"
            }
            let parameters: [String : Any] = [
                "GuestUser": email,
                "PermissionLevel": permission
            ]
            print("Posting measures with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .deleteShare(poolId: let poolId, email: let email):
            let parameters: [String : Any] = [
                "email": email,
            ]
            print("Posting measures with params: \(parameters)")
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
         
        case .deletePlace(placeId: let poolId):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [:])

        case .getPoolSettings(poolId: _):
            var lang = "en"
            if let preferredLanguage = Locale.current.languageCode {
                lang = preferredLanguage
            }
            let parameters: [String: Any] = [
                "l": lang,
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
       
            
        case .createPlace(typeId: _):
            
            let placeInfo = AppSharedData.sharedInstance.addPlaceInfo
            let placeLoc = AppSharedData.sharedInstance.addPlaceLocationInfo
            
            let parameters: [String : Any] = ["PrivateName": AppSharedData.sharedInstance.addPlaceName,"BuiltYear": 2022,"ElectrolyzerThreshold": 0.0,"Id" : placeLoc.palceId, "IsPublic" : false, "Latitude" : placeInfo.latitude ?? 123.9, "Longitude" : placeInfo.longitude ?? 123.9, "NumberOfUsers" : placeInfo.numberOfUsers ?? 0, "NumberOfPlaces" : 0, "Surface" : 17.25, "Volume" : placeInfo.volume ?? 0.0, "City" : ["Latitude" : placeInfo.latitude ?? 123.9 , "Longitude" : placeInfo.longitude ?? 23.0, "Name" : placeInfo.city?.name ?? "",  "ZipCode" : placeInfo.city?.zipCode ?? ""], "Coating" : ["Id" : placeInfo.coating?.id ?? 0, "Name" : placeInfo.coating?.label ?? "" ], "Filtration" : ["Id" : placeInfo.filtration?.id ?? 0, "Name" : placeInfo.filtration?.label ?? "" ], "Integration" : ["Id" : placeInfo.integration?.id ?? 0, "Name" : placeInfo.integration?.label ?? "" ], "Mode" : ["Id" : placeInfo.mode?.id ?? 0, "Name" : placeInfo.mode?.label ?? "" ], "Shape" : ["Id" : placeInfo.shape?.id ?? 0, "Name" : placeInfo.shape?.label ?? "" ],  "Treatment" : ["Id" : placeInfo.treatment?.id ?? 0, "Name" : placeInfo.treatment?.label ?? "" ], "Type" : ["id" : placeLoc.palceId ]]
            
            print("Posting create place with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .updatePlace:
            
            let placeInfo = AppSharedData.sharedInstance.updatePlaceInfo
            
            let parameters: [String : Any] = ["PrivateName": AppSharedData.sharedInstance.addPlaceName,"BuiltYear": 2022,"ElectrolyzerThreshold": 0.0,"Id" : placeInfo.id ?? 0, "IsPublic" : false, "Latitude" : placeInfo.latitude ?? 123.9, "Longitude" : placeInfo.longitude ?? 123.9, "NumberOfUsers" : placeInfo.numberOfUsers ?? 0, "NumberOfPlaces" : 0, "Surface" : 17.25, "Volume" : placeInfo.volume ?? 0.0, "City" : ["Latitude" : placeInfo.latitude ?? 123.9 , "Longitude" : placeInfo.longitude ?? 23.0, "Name" : placeInfo.city?.name ?? "",  "ZipCode" : placeInfo.city?.zipCode ?? ""], "Coating" : ["Id" : placeInfo.coating?.id ?? 0, "Name" : placeInfo.coating?.name ?? "" ], "Filtration" : ["Id" : placeInfo.filtration?.id ?? 0, "Name" : placeInfo.filtration?.name ?? "" ], "Integration" : ["Id" : placeInfo.integration?.id ?? 0, "Name" : placeInfo.integration?.name ?? "" ], "Mode" : ["Id" : placeInfo.mode?.id ?? 0, "Name" : placeInfo.mode?.name ?? "" ], "Shape" : ["Id" : placeInfo.shape?.id ?? 0, "Name" : placeInfo.shape?.name ?? "" ],  "Treatment" : ["Id" : placeInfo.treatment?.id ?? 0, "Name" : placeInfo.treatment?.name ?? "" ], "Type" : ["id" : placeInfo.type?.id ?? 0, "IsAvailableAsPlace" : placeInfo.type?.isAvailableAsPlace ?? true ]]
            
            print("Posting create place with params: \(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)

            
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)

        default:
            break
        }

        print("Request URL: \(urlRequest.url?.absoluteString)")
        print("Body: \(urlRequest.httpBodyStream)")
        
        return urlRequest
    }
}

