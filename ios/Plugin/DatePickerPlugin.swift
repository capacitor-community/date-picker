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
        if self.instance != nil {
            return
        }
        self.call = call
        let options = self.datePickerOptions(from: self.call, original: self.options.copy() as! DatePickerOptions)
        guard let viewController = self.bridge?.viewController else {
            call.reject("Unable to access viewController!")
            return
        }
        DispatchQueue.main.async {
            self.instance = DatePicker(options: options, view: viewController.view)

            self.instance.done.addTarget(
                self,
                action: #selector(self.done(sender:)),
                for: .touchUpInside
            )
            self.instance.cancel.addTarget(
                self,
                action: #selector(self.cancel(sender:)),
                for: .touchUpInside
            )
            if self.instance.options.style != "inline" {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancel(sender:)))
                self.instance.background.addGestureRecognizer(tap)
            }
            viewController.view.addSubview(self.instance.background)
        }
    }

    @objc func done(sender: UIButton) {
        if self.instance.options.mode == "dateAndTime" &&
                self.instance.picker.datePickerMode == UIDatePicker.Mode.date {
            self.instance.setTimeMode()
            return
        }
        var obj: [String: Any] = [:]
        obj["value"] = Parse.dateToString(date: self.instance.picker.date, format: self.instance.options.format)
        self.call.resolve(obj)
        self.dismissInstance()
    }
    @objc func cancel(sender: UIButton) {
        if self.instance.options.mode == "dateAndTime" {
            if self.instance.options.style != "inline" &&
                    !self.instance.options.mergedDateAndTime &&
                    self.instance.picker.datePickerMode == UIDatePicker.Mode.time {
                DispatchQueue.main.async {
                    self.instance.picker.datePickerMode = UIDatePicker.Mode.date
                }
                return
            }
        }
        var obj: [String: Any] = [:]
        obj["value"] = nil
        self.call.resolve(obj)
        self.dismissInstance()
    }

    private func dismissInstance() {
        self.instance.dismiss()
        self.instance = nil
    }

    private func datePickerOptions() -> DatePickerOptions {
        let options = DatePickerOptions()
        if #available(iOS 14.0, *) {
            options.style = "inline"
            if let style = getConfigValue("ios.style") as? String {
                options.style = style
            }
        }

        if #available(iOS 13.0, *), UITraitCollection.current.userInterfaceStyle == .dark {
            options.theme = "dark"
        }

        if let theme = getConfigValue("ios.theme") as? String ?? getConfigValue("theme") as? String {
            options.theme = theme
        }
        if let mode = getConfigValue("ios.mode") as? String ?? getConfigValue("mode") as? String {
            options.mode = mode
        }
        if let format = getConfigValue("ios.format") as? String ?? getConfigValue("format") as? String {
            options.format = format
        }
        if let timezone = getConfigValue("ios.timezone") as? String ?? getConfigValue("timezone") as? String {
            options.timezone = timezone
        }
        if let locale = getConfigValue("ios.locale") as? String ?? getConfigValue("locale") as? String {
            options.locale = locale
        }
        if let cancelText = getConfigValue("ios.cancelText") as? String ?? getConfigValue("cancelText") as? String {
            options.cancelText = cancelText
        }
        if let doneText = getConfigValue("ios.doneText") as? String ?? getConfigValue("doneText") as? String {
            options.doneText = doneText
        }
        if let is24h = getConfigValue("ios.is24h") as? Bool ?? getConfigValue("is24h") as? Bool {
            options.is24h = is24h
        }
        if let title = getConfigValue("ios.title") as? String ?? getConfigValue("title") as? String {
            options.title = title
        }
        if let titleFontColor = getConfigValue("ios.titleFontColor") as? String {
            options.titleFontColor = titleFontColor
        }
        if let titleBgColor = getConfigValue("ios.titleBgColor") as? String {
            options.titleBgColor = titleBgColor
        }
        if let bgColor = getConfigValue("ios.bgColor") as? String {
            options.bgColor = bgColor
        }
        if let fontColor = getConfigValue("ios.fontColor") as? String {
            options.fontColor = fontColor
        }
        if let buttonBgColor = getConfigValue("ios.buttonBgColor") as? String {
            options.buttonBgColor = buttonBgColor
        }
        if let buttonFontColor = getConfigValue("ios.buttonFontColor") as? String {
            options.buttonFontColor = buttonFontColor
        }
        if let mergedDateAndTime = getConfigValue("ios.mergedDateAndTime") as? Bool {
            options.mergedDateAndTime = mergedDateAndTime
        }

        return options
    }

    private func datePickerOptions(from call: CAPPluginCall, original options: DatePickerOptions) -> DatePickerOptions {
        if #available(iOS 14.0, *) {
            if let style = call.getObject("ios")?["style"] as? String {
                options.style = style
            }
        }
        if let theme = call.getObject("ios")?["theme"] as? String ?? call.getString("theme") {
            options.theme = theme
        }
        if let mode = call.getObject("ios")?["mode"] as? String ?? call.getString("mode") {
            options.mode = mode
        }
        if let format = call.getObject("ios")?["format"] as? String ?? call.getString("format") {
            options.format = format
        }
        if let timezone = call.getObject("ios")?["timezone"] as? String ?? call.getString("timezone") {
            options.timezone = timezone
        }
        if let locale = call.getObject("ios")?["locale"] as? String ?? call.getString("locale") {
            options.locale = locale
        }
        if let cancelText = call.getObject("ios")?["cancelText"] as? String ?? call.getString("cancelText") {
            options.cancelText = cancelText
        }
        if let doneText = call.getObject("ios")?["doneText"] as? String ?? call.getString("doneText") {
            options.doneText = doneText
        }
        if let is24h = call.getObject("ios")?["is24h"] as? Bool ?? call.getBool("is24h") {
            options.is24h = is24h
        }
        if let title = call.getObject("ios")?["title"] as? String ?? call.getString("title") {
            options.title = title
        }
        if let titleFontColor = call.getObject("ios")?["titleFontColor"] as? String {
            options.titleFontColor = titleFontColor
        }
        if let titleBgColor = call.getObject("ios")?["titleBgColor"] as? String {
            options.titleBgColor = titleBgColor
        }
        if let bgColor = call.getObject("ios")?["bgColor"] as? String {
            options.bgColor = bgColor
        }
        if let fontColor = call.getObject("ios")?["fontColor"] as? String {
            options.fontColor = fontColor
        }
        if let buttonBgColor = call.getObject("ios")?["buttonBgColor"] as? String {
            options.buttonBgColor = buttonBgColor
        }
        if let buttonFontColor = call.getObject("ios")?["buttonFontColor"] as? String {
            options.buttonFontColor = buttonFontColor
        }
        if let mergedDateAndTime = call.getObject("ios")?["mergedDateAndTime"] as? Bool {
            options.mergedDateAndTime = mergedDateAndTime
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

        return options
    }
}
