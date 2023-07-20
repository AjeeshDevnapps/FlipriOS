//
//  String+FliprDate.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 21/09/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension String {
    
    public var fliprDate: Date? {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = formatter.date(from: self)?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())) {
            return date
        } else {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = formatter.date(from: self)?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())) {
                return date
            } else {
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'".remotable("WTF_DATE_FORMAT")
                if let date = formatter.date(from: self)?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())) {
                    return date
                }
            }
        }
        return nil
    }
    
    public var fliprDate1: Date? {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/mm/yyyy HH:mm"
        if let date = formatter.date(from: self)?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())) {
            return date
        } else {
            formatter.dateFormat = "dd/mm/yyyy HH:mm"
            if let date = formatter.date(from: self)?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())) {
                return date
            } else {
                formatter.dateFormat = "dd/mm/yyyy HH:mm".remotable("WTF_DATE_FORMAT")
                if let date = formatter.date(from: self)?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT())) {
                    return date
                }
            }
        }
        return nil
    }
}

public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    
    var isValidString: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return !trimmed.isEmpty
        }
    }
    
    func trimSpace() -> String? {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed
    }
}

