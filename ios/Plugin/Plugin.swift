import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 * Created by Stewan Silva on 07/07/2019
 */

@objc(DatePickerPlugin)
public class DatePickerPlugin: CAPPlugin {
    public let CONFIG_KEY_PREFIX = "plugins.DatePickerPlugin.ios-"
    
    private var defaultPickerTheme: String = "light"
    private var defaultPickerMode: String = "dateAndTime"
    private var defaultPickerFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    private var defaultPickerTimezone: String? = nil
    private var defaultPickerLocale: String? = nil
    private var defaultPickerCancelText: String = "Cancel"
    private var defaultPickerDoneText: String = "Ok"
    private var defaultPicker24h: Bool =  false
    private var defaultPickerDate: String? = nil
    private var defaultPickerMinDate: String? = nil
    private var defaultPickerMaxDate: String? = nil
    private var defaultPickerTitle: String? = nil
    private var defaultPickerTitleFontColor: String = "#000000"
    private var defaultPickerTitleBgColor: String = "#ffffff"
    private var defaultPickerBgColor: String = "#ffffff"
    private var defaultPickerFontColor: String = "#000000"
    private var defaultPickerButtonBgColor: String = "#ffffff"
    private var defaultPickerButtonFontColor: String = "#000000"
    private var defaultPickerMergedDateAndTime: Bool = false;
    
    private var pickerTheme: String = "light"
    private var pickerMode: String = "dateAndTime"
    private var pickerFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    private var pickerTimezone: String? = nil
    private var pickerLocale: String? = nil
    private var pickerCancelText: String = "Cancel"
    private var pickerDoneText: String = "Ok"
    private var picker24h: Bool =  false
    private var pickerDate: String? = nil
    private var pickerMinDate: String? = nil
    private var pickerMaxDate: String? = nil
    private var pickerTitle: String? = nil
    private var pickerMergedDateAndTime: Bool = false;
    
    private var call: CAPPluginCall?
    private var picker: UIDatePicker?
    private var titleView: UILabel?
    private var alertView: UIView?
    private var backgroundView: UIView?
    private var doneButton: UIButton?
    private var cancelButton: UIButton?
    
    //
    // sizes
    private var defaultButtonHeight: CGFloat = 50
    private var defaultTitleHeight: CGFloat = 50
    private var defaultSpacerHeight: CGFloat = 1
    
    private var alertSize = CGSize(width: 300 , height: 300)
    
    //
    // colors
    private var pickerTitleFontColor: String = "#000000"
    private var pickerTitleBgColor: String = "#ffffff"
    private var pickerBgColor: String = "#ffffff"
    private var pickerFontColor: String = "#000000"
    private var pickerButtonBgColor: String = "#ffffff"
    private var pickerButtonFontColor: String =  "#000000"
    
    
    private func loadOptions() {
        self.defaultPickerTheme = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "theme") ?? self.defaultPickerTheme
        self.defaultPickerMode = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "mode") ?? self.defaultPickerMode
        self.defaultPickerFormat = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "format") ?? self.defaultPickerFormat
        self.defaultPickerTimezone = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "timezone") ?? self.defaultPickerTimezone
        self.defaultPickerLocale = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "locale") ?? self.defaultPickerLocale
        self.defaultPickerCancelText = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "cancelText") ?? self.defaultPickerCancelText
        self.defaultPickerDoneText = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "doneText") ?? self.defaultPickerDoneText
        self.defaultPicker24h = self.bridge.config.getValue(self.CONFIG_KEY_PREFIX + "is24h") as? Bool ?? self.defaultPicker24h
        self.defaultPickerTitle = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "title") ?? self.defaultPickerTitle
        self.defaultPickerTitleFontColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "titleFontColor") ?? self.defaultPickerTitleFontColor
        self.defaultPickerTitleBgColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "titleBgColor") ?? self.defaultPickerTitleBgColor
        self.defaultPickerBgColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "bgColor") ?? self.defaultPickerBgColor
        self.defaultPickerFontColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "fontColor") ?? self.defaultPickerFontColor
        self.defaultPickerButtonBgColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "buttonBgColor") ?? self.defaultPickerButtonBgColor
        self.defaultPickerButtonFontColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "buttonFontColor") ?? self.defaultPickerButtonFontColor
        self.defaultPickerMergedDateAndTime = self.bridge.config.getValue(self.CONFIG_KEY_PREFIX + "mergedDateAndTime") as? Bool ?? self.defaultPickerMergedDateAndTime
    }
    
    private func loadCallOptions() {
        self.pickerLocale = self.call?.getString("locale") ?? self.defaultPickerLocale
        self.pickerFormat = self.call?.getString("format") ?? self.defaultPickerFormat
        self.pickerTheme = self.call?.getString("theme") ?? self.defaultPickerTheme
        self.pickerMode = self.call?.getString("mode") ?? self.defaultPickerMode
        self.pickerTimezone = self.call?.getString("timezone") ?? self.defaultPickerTimezone
        self.pickerDate = self.call?.getString("date") ?? self.parseDateFromObject(date: Date())
        self.pickerMinDate = self.call?.getString("min") ?? nil
        self.pickerMaxDate = self.call?.getString("max") ?? nil
        self.pickerTitle = self.call?.getString("title") ?? self.defaultPickerTitle
        self.pickerCancelText = self.call?.getString("cancelText") ?? self.defaultPickerCancelText
        self.pickerDoneText = self.call?.getString("doneText") ?? self.defaultPickerDoneText
        self.picker24h = self.call?.getBool("is24h") ?? self.defaultPicker24h
        self.pickerTitleFontColor = self.call?.getString("titleFontColor") ?? self.defaultPickerTitleFontColor
        self.pickerTitleBgColor = self.call?.getString("titleBgColor") ?? self.defaultPickerTitleBgColor
        self.pickerBgColor = self.call?.getString("bgColor") ?? self.defaultPickerBgColor
        self.pickerFontColor = self.call?.getString("fontColor") ?? self.defaultPickerFontColor
        self.pickerButtonBgColor = self.call?.getString("buttonBgColor") ?? self.defaultPickerButtonBgColor
        self.pickerButtonFontColor = self.call?.getString("buttonFontColor") ?? self.defaultPickerButtonFontColor
        self.pickerMergedDateAndTime = self.call?.getBool("mergedDateAndTime") ?? self.defaultPickerMergedDateAndTime
        
        
        self.alertSize = CGSize(width: self.bridge.viewController.view.bounds.size.width, height: 250 + self.defaultButtonHeight)
        
        if (self.pickerTheme == "dark" || self.pickerTheme == "legacyDark") {
            self.defaultDark()
        } else {
            self.defaultLight()
        }
    }
    
    public override func load() {
        loadOptions()
    }
    
    private func parseDateFromObject(date: Date, format: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        if (format != nil) {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateFormat = pickerFormat
        }
        if (pickerTimezone != nil) {
            let tz = TimeZone(identifier: pickerTimezone ?? "UTC")
            dateFormatter.timeZone = tz;
        }
        return dateFormatter.string(from: date)
    }
    
    private func parseDateFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pickerFormat
        if (pickerTimezone != nil) {
            let tz = TimeZone(identifier: pickerTimezone ?? "UTC")
            dateFormatter.timeZone = tz;
        }
        return dateFormatter.date(from: date)!
    }
    
    private func createTitleView() -> UILabel {
        if (self.titleView == nil) {
            self.titleView = UILabel(frame: CGRect(x: 0, y: 0, width: self.alertSize.width, height: self.defaultTitleHeight))
        }
        self.titleView!.textAlignment = .center
        self.titleView!.text = self.titleChange(self.parseDateFromString(date: self.pickerDate!))
        self.titleView!.textColor = UIColor(hexString: self.pickerTitleFontColor)
        self.titleView!.backgroundColor = UIColor(hexString: self.pickerTitleBgColor)
        
        return self.titleView!
    }
    
    private func createOkButton() -> UIButton {
        let buttonWidth =  self.alertSize.width / 2
        if (self.doneButton == nil) {
            self.doneButton = UIButton(type: .custom)
        }
        self.doneButton?.frame = CGRect(x: buttonWidth, y: self.alertSize.height - self.defaultButtonHeight, width: buttonWidth, height: self.defaultButtonHeight)
        self.doneButton?.setTitle(self.pickerDoneText, for: .normal)
        self.doneButton?.setTitleColor(UIColor(hexString: self.pickerButtonFontColor), for: .normal)
        self.doneButton?.backgroundColor = UIColor(hexString: self.pickerButtonBgColor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.ok))
        self.doneButton?.addGestureRecognizer(tap)
        
        return self.doneButton!
    }
    
    private func createCancelButton() -> UIButton {
        let buttonWidth =  self.alertSize.width / 2
        if (self.cancelButton == nil) {
            self.cancelButton = UIButton(frame: CGRect(x: 0, y: self.alertSize.height - self.defaultButtonHeight, width: buttonWidth, height: self.defaultButtonHeight))
        }
        self.cancelButton?.setTitle(self.pickerCancelText, for: .normal)
        self.cancelButton?.setTitleColor(UIColor(hexString: self.pickerButtonFontColor), for: .normal)
        self.cancelButton?.backgroundColor = UIColor(hexString: self.pickerButtonBgColor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancel))
        self.cancelButton?.addGestureRecognizer(tap)
        
        return self.cancelButton!
    }
    
    private func createDatePicker() -> UIDatePicker {
        if (self.picker == nil) {
            self.picker = UIDatePicker(frame: CGRect(x: 0, y: self.defaultTitleHeight, width: 0, height: 0))
        }
        
        let xPosition = (self.alertSize.width - (self.picker?.frame.width)!) / 2
        self.picker?.frame.origin.x = xPosition
        
        self.picker?.setValue(UIColor(hexString: self.pickerFontColor), forKey: "textColor")
        self.picker?.setValue(false, forKey: "highlightsToday")
        self.picker?.addTarget(self, action: #selector(self.datePickerChanged(picker:)), for: .valueChanged)
        self.picker?.setDate(self.parseDateFromString(date: self.pickerDate!), animated: false)
        if (self.pickerDate != nil) {
            self.picker?.date = self.parseDateFromString(date: self.pickerDate!)
        }
        if (self.pickerMaxDate != nil) {
            self.picker?.maximumDate = self.parseDateFromString(date: self.pickerMaxDate!)
        } else {
            self.picker?.maximumDate = nil
        }
        if (self.pickerMinDate != nil) {
            self.picker?.minimumDate = self.parseDateFromString(date: self.pickerMinDate!)
        } else {
            self.picker?.minimumDate = nil
        }
        if (self.pickerLocale != nil) {
            self.picker?.locale = Locale(identifier: self.pickerLocale!)
        } else {
            self.picker?.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")
        }
        
        if (self.pickerMode == "time") {
            self.setTimeMode()
        } else if (self.pickerMergedDateAndTime) {
            self.picker?.datePickerMode = UIDatePicker.Mode.dateAndTime
            let xPosition = (self.alertSize.width - (self.picker?.frame.width)!) / 2
            self.picker?.frame.origin.x = xPosition
        } else {
            self.picker?.datePickerMode = UIDatePicker.Mode.date
            let xPosition = (self.alertSize.width - (self.picker?.frame.width)!) / 2
            self.picker?.frame.origin.x = xPosition
        }
        
        return self.picker!
    }
    
    private func setTimeMode() {
        DispatchQueue.main.async {
            let date = self.picker?.date
            if (self.picker24h) {
                self.picker?.datePickerMode = UIDatePicker.Mode.countDownTimer
            } else {
                self.picker?.datePickerMode = UIDatePicker.Mode.time
            }
            let xPosition = (self.alertSize.width - (self.picker?.frame.width)!) / 2
            self.picker?.frame.origin.x = xPosition
            
            self.picker?.setDate(date!, animated: true)
        }
    }
    
    private func createPickerView() -> UIView {
        self.createOkButton()
        self.createCancelButton()
        
        let width = self.bridge.viewController.view.bounds.size.width
        let height = self.bridge.viewController.view.bounds.size.height
        
        if (self.alertView == nil) {
            self.alertView = UIView()
        }
        
        self.alertView?.frame = CGRect(x: 0, y: 0, width: self.alertSize.width, height: self.alertSize.height)
        
        let yPosition = (self.alertView?.bounds.size.height)! - self.defaultButtonHeight - self.defaultSpacerHeight
        let lineView = UIView(frame: CGRect(x: 0, y: yPosition, width: alertView!.bounds.size.width, height: self.defaultSpacerHeight))
        
        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        
        self.alertView?.frame.origin.y = height - 300
        self.alertView?.frame.size.width = width
        self.alertView?.frame.size.height = 300
        self.alertView?.backgroundColor = UIColor(hexString: self.pickerBgColor)
        
        self.alertView?.addSubview(self.doneButton!)
        self.alertView?.addSubview(self.cancelButton!)
        self.alertView?.addSubview(lineView)
        
        return self.alertView!
    }
    
    @objc func titleChange(_ date: Date) -> String{
        if (self.pickerTitle == nil) {
            var format: String = "E, MMM d, yyyy HH:mm"
            if (self.pickerMode == "time") {
                format = "HH:mm a"
            } else if (self.pickerMode == "date") {
                format = "E, MMM d, yyyy"
            }
            return self.parseDateFromObject(date: date, format: format)
        }
        return self.pickerTitle!
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        DispatchQueue.main.async {
            self.titleView?.text = self.titleChange(picker.date)
        }
    }
    
    private func dismiss() {
        DispatchQueue.main.async {
            let height = self.alertView!.frame.size.height
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.alertView!.center.y += height
            }, completion: nil)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView!.backgroundColor = UIColor(hexString: "#00000000")
            }, completion: { (finished: Bool) in
                self.backgroundView!.removeFromSuperview()
            })
            UIView.transition(with: self.bridge.viewController.view, duration: 0.25, options: [.curveEaseIn], animations: {
            }, completion: nil)
        }
    }
    
    @objc func cancel(sender: UIButton) {
        if (self.pickerMode == "dateAndTime") {
            if (!self.pickerMergedDateAndTime) {
                DispatchQueue.main.async {
                    self.picker?.datePickerMode = UIDatePicker.Mode.time
                }
            }
        }
        if (self.call != nil) {
            var obj:[String:Any] = [:]
            obj["value"] = nil
            self.call?.resolve(obj)
            self.call = nil
        }
        self.dismiss()
    }
    
    @objc func ok(sender: UIButton) {
        if (self.pickerMode == "dateAndTime" && self.picker?.datePickerMode == UIDatePicker.Mode.date) {
            self.setTimeMode()
            return
        }
        if (self.call != nil) {
            var obj:[String:Any] = [:]
            obj["value"] = parseDateFromObject(date: (picker?.date)!)
            self.call?.resolve(obj)
            self.call = nil
        }
        self.dismiss()
    }
    
    private func defaultLight() {
        self.pickerTitleFontColor = "#000000"
        self.pickerTitleBgColor = "#ffffff"
        self.pickerBgColor = "#ffffff"
        self.pickerFontColor = "#000000"
        self.pickerButtonBgColor = "#ffffff"
        self.pickerButtonFontColor =  "#000000"
    }
    
    
    private func defaultDark() {
        self.pickerTitleFontColor = "#fafafa"
        self.pickerTitleBgColor = "#121212"
        self.pickerBgColor = "#121212"
        self.pickerFontColor = "#fafafa"
        self.pickerButtonBgColor = "#121212"
        self.pickerButtonFontColor =  "#fafafa"
    }
    
    
    @objc func darkMode(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let black = UIColor(hexString: "#121212")
            let white = UIColor(hexString: "#fafafa")
            self.alertView?.backgroundColor = black
            self.picker?.setValue(white, forKey: "textColor")
            self.doneButton?.setTitleColor(white, for: .normal)
            self.doneButton?.backgroundColor = black
            self.cancelButton?.setTitleColor(white, for: .normal)
            self.cancelButton?.backgroundColor = black
            self.titleView?.backgroundColor = black
            self.titleView?.textColor = white
        }
    }
    
    @objc func lightMode(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let black = UIColor(hexString: "#ffffff")
            let white = UIColor(hexString: "#000000")
            self.alertView?.backgroundColor = black
            self.picker?.setValue(white, forKey: "textColor")
            self.doneButton?.setTitleColor(white, for: .normal)
            self.doneButton?.backgroundColor = black
            self.cancelButton?.setTitleColor(white, for: .normal)
            self.cancelButton?.backgroundColor = black
            self.titleView?.backgroundColor = black
            self.titleView?.textColor = white
        }
    }
    
    @objc func present(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.call = call
            self.loadCallOptions()
            
            self.createTitleView()
            self.createDatePicker()
            
            self.createPickerView()
            

            self.backgroundView = UIView()
            self.backgroundView!.backgroundColor = UIColor(hexString: "#00000000")

            let x = self.bridge.viewController.view.bounds.size.width
            let y = self.bridge.viewController.view.bounds.size.height
            
            self.backgroundView!.frame.size.width = x
            self.backgroundView!.frame.size.height = y
            self.backgroundView!.addSubview(self.alertView!)
            
            self.alertView?.addSubview(self.titleView!);
            self.alertView?.addSubview(self.picker!)
            let height = self.alertView!.frame.size.height
            self.alertView!.center.y += height
            
            self.bridge.viewController.view.addSubview(self.backgroundView!)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.backgroundView!.backgroundColor = UIColor(hexString: "#00000088")
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.alertView!.center.y -= height
            }, completion: nil)
        }
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            var hexColor = String(hexString[start...])
            if (hexColor.count == 6) {
                hexColor = "\(hexColor)ff"
            }
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
}
