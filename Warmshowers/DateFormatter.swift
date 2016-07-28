//
//  DateFormatter.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 29/07/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

class DateFormatter {
    
    static let sharedDateFormatter = DateFormatter()
    
    let formatter = NSDateFormatter()
    
    init() {
        formatter.locale = NSLocale(localeIdentifier: "en_US")
    }
    
    // Trys to parse a data using all the possible date formats. */
    func dateFromString(string: String) -> NSDate? {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.dateFromString(string) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.dateFromString(string) {
            return date
        }
        return nil
    }
    
}