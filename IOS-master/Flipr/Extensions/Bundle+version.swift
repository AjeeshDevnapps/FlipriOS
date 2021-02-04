//
//  Bundle+version.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 11/05/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
