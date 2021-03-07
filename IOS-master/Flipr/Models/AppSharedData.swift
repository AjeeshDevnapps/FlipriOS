//
//  AppSharedData.swift
//  Flipr
//
//  Created by Ajeesh T S on 07/03/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import Foundation

class AppSharedData: NSObject {
    static let sharedInstance = AppSharedData()
    
    var isNeedtoCallHubDetailsApi : Bool = false
    var isNeedtoCallModulesApiForSideMenu : Bool = false
    var serialKey = ""
    var deviceName = ""

    private override init() {
        
    }
}
