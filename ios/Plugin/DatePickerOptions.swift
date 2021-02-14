//
//  DatePickerOptions.swift
//  Plugin
//
//  Created by Daniel Rosa on 12/02/21.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation
import Capacitor

public class DatePickerOptions: NSObject, NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = DatePickerOptions()
        copy.theme = theme
        copy.mode = mode
        copy.format = format
        copy.timezone = timezone
        copy.locale = locale
        copy.cancelText = cancelText
        copy.doneText = doneText
        copy.is24h = is24h
        copy.date = date
        copy.min = min
        copy.max = max
        copy.title = title
        copy.titleFontColor = titleFontColor
        copy.titleBgColor = titleBgColor
        copy.bgColor = bgColor
        copy.fontColor = fontColor
        copy.buttonBgColor = buttonBgColor
        copy.buttonFontColor = buttonFontColor
        copy.mergedDateAndTime = mergedDateAndTime
        return copy;
    }
    
    public var theme: String = "light"
    public var mode: String = "dateAndTime"
    public var format: String = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    public var timezone: String? = nil
    public var locale: String? = nil
    public var cancelText: String = "Cancel"
    public var doneText: String = "Ok"
    public var is24h: Bool =  false
    public var date: Date? = nil
    public var min: Date? = nil
    public var max: Date? = nil
    public var title: String? = nil
    public var titleFontColor: String? = nil
    public var titleBgColor: String? = nil
    public var bgColor: String? = nil
    public var fontColor: String? = nil
    public var buttonBgColor: String? = nil
    public var buttonFontColor: String? = nil
    public var mergedDateAndTime: Bool = false
    public var style: String? = nil
}
