//
//  Parse.swift
//  Plugin
//
//  Created by Daniel Rosa on 12/02/21.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation
public class Parse {
    public static func dateFromString(date: String, format: String? = nil, timezone: String? = nil) -> Date? {
        let formatter = DateFormatter()
        if (format != nil) {
            formatter.dateFormat = format;
        }
        if (timezone != nil) {
            let tz = TimeZone(identifier: timezone ?? "UTC")
            formatter.timeZone = tz;
        }
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let dt = formatter.date(from: date) else {
            return nil
        }
        return dt
    }
    public static func dateToString(date: Date, format: String? = nil, locale: Locale? = nil) -> String {
        let formatter = DateFormatter()
        if (format != nil) {
            formatter.dateFormat = format
        }
        if (locale != nil) {
            formatter.locale = locale
        } else {
            formatter.locale = Locale(identifier: "en_US_POSIX")
        }
        return formatter.string(from: date)
    }
}
