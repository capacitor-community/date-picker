import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(DatePickerPlugin)
public class DatePickerPlugin: CAPPlugin {
    private var options: DatePickerOptions!
    private var instance: DatePicker!
    private var call: CAPPluginCall!
    
    override public func load() {
        options = datePickerOptions()
    }
    
    @objc func present(_ call: CAPPluginCall) {
        if (self.instance != nil) {
            return
        }
        self.call = call
        let options = self.datePickerOptions(from: self.call, original: self.options.copy() as! DatePickerOptions)
        guard let viewController = self.bridge?.viewController else {
            call.reject("Unable to access viewController!")
            return
        }
        self.instance = DatePicker(options: options, viewCtrl: viewController)
        DispatchQueue.main.async {
            self.instance.createElements()
            self.instance.doneButton.addTarget(
                self,
                action: #selector(self.done(sender:)),
                for: .touchUpInside
            )
            self.instance.cancelButton.addTarget(
                self,
                action: #selector(self.cancel(sender:)),
                for: .touchUpInside
            )
            self.instance.open()
        }
    }
    
    @objc func done(sender: UIButton) {
        if (
            self.instance.options.mode == "dateAndTime" &&
            self.instance.picker.datePickerMode == UIDatePicker.Mode.date
        ) {
            self.instance.setTimeMode()
            return
        }
        var obj:[String:Any] = [:]
        obj["value"] = Parse.dateToString(date: self.instance.picker.date, format: self.instance.options.format)
        self.call.resolve(obj)
        self.dismissInstance()
    }
    @objc func cancel(sender: UIButton) {
        if (self.instance.options.mode == "dateAndTime") {
            if (
                !self.instance.options.mergedDateAndTime &&
                self.instance.picker.datePickerMode == UIDatePicker.Mode.time
            ) {
                DispatchQueue.main.async {
                    self.instance.picker.datePickerMode = UIDatePicker.Mode.date
                }
                return
            }
        }
        var obj:[String:Any] = [:]
        obj["value"] = nil
        self.call.resolve(obj)
        self.dismissInstance()
    }
    
    private func dismissInstance() -> Void {
        self.instance.dismiss()
        self.instance = nil
    }
    
    private func datePickerOptions() -> DatePickerOptions {
        let options = DatePickerOptions()
        
        if let theme = getConfigValue("theme") as? String {
            NSLog(theme)
            options.theme = theme
        }
        if let mode = getConfigValue("mode") as? String {
            options.mode = mode
        }
        if let format = getConfigValue("format") as? String {
            options.format = format
        }
        if let timezone = getConfigValue("timezone") as? String {
            options.timezone = timezone
        }
        if let locale = getConfigValue("locale") as? String {
            options.locale = locale
        }
        if let cancelText = getConfigValue("cancelText") as? String {
            options.cancelText = cancelText
        }
        if let doneText = getConfigValue("doneText") as? String {
            options.doneText = doneText
        }
        if let is24h = getConfigValue("is24h") as? Bool {
            options.is24h = is24h
        }
        if let date = getConfigValue("date") as? String {
            options.date = Parse.dateFromString(date: date, format: options.format)
        }
        if let min = getConfigValue("min") as? String {
            options.min = Parse.dateFromString(date: min, format: options.format)
        }
        if let max = getConfigValue("max") as? String {
            options.max = Parse.dateFromString(date: max, format: options.format)
        }
        if let title = getConfigValue("title") as? String {
            options.title = title
        }
        if let titleFontColor = getConfigValue("titleFontColor") as? String {
            options.titleFontColor = titleFontColor
        }
        if let titleBgColor = getConfigValue("titleBgColor") as? String {
            options.titleBgColor = titleBgColor
        }
        if let bgColor = getConfigValue("bgColor") as? String {
            options.bgColor = bgColor
        }
        if let fontColor = getConfigValue("fontColor") as? String {
            options.fontColor = fontColor
        }
        if let buttonBgColor = getConfigValue("buttonBgColor") as? String {
            options.buttonBgColor = buttonBgColor
        }
        if let buttonFontColor = getConfigValue("buttonFontColor") as? String {
            options.buttonFontColor = buttonFontColor
        }
        if let mergedDateAndTime = getConfigValue("mergedDateAndTime") as? Bool {
            options.mergedDateAndTime = mergedDateAndTime
        }
        
        return options
    }
    
    private func datePickerOptions(from call: CAPPluginCall, original options: DatePickerOptions) -> DatePickerOptions {
        
        if let theme = call.getString("theme") {
            options.theme = theme
        }
        if let mode = call.getString("mode") {
            options.mode = mode
        }
        if let format = call.getString("format") {
            options.format = format
        }
        if let timezone = call.getString("timezone") {
            options.timezone = timezone
        }
        if let locale = call.getString("locale") {
            options.locale = locale
        }
        if let cancelText = call.getString("cancelText") {
            options.cancelText = cancelText
        }
        if let doneText = call.getString("doneText") {
            options.doneText = doneText
        }
        if let is24h = call.getBool("is24h") {
            options.is24h = is24h
        }
        if let date = call.getString("date") {
            options.date = Parse.dateFromString(date: date, format: options.format)
        }
        if let min = call.getString("min") {
            options.min = Parse.dateFromString(date: min, format: options.format)
        }
        if let max = call.getString("max") {
            options.max = Parse.dateFromString(date: max, format: options.format)
        }
        if let title = call.getString("title") {
            options.title = title
        }
        if let titleFontColor = call.getString("titleFontColor") {
            options.titleFontColor = titleFontColor
        }
        if let titleBgColor = call.getString("titleBgColor") {
            options.titleBgColor = titleBgColor
        }
        if let bgColor = call.getString("bgColor") {
            options.bgColor = bgColor
        }
        if let fontColor = call.getString("fontColor") {
            options.fontColor = fontColor
        }
        if let buttonBgColor = call.getString("buttonBgColor") {
            options.buttonBgColor = buttonBgColor
        }
        if let buttonFontColor = call.getString("buttonFontColor") {
            options.buttonFontColor = buttonFontColor
        }
        if let mergedDateAndTime = call.getBool("mergedDateAndTime") {
            options.mergedDateAndTime = mergedDateAndTime
        }
        
        return options
    }
}
