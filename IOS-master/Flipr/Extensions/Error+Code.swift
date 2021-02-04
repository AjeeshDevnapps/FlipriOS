//
//  Error+Code.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 28/04/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
