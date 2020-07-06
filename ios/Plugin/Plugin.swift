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
    
    private var pickerTheme: String?
    private var pickerMode: String?
    private var pickerFormat: String?
    private var pickerTimezone: String?
    private var pickerLocale: String?
    private var pickerCancelText: String?
    private var pickerDoneText: String?
    private var picker24h: Bool?
    private var pickerDate: String?
    private var pickerMinDate: String?
    private var pickerMaxDate: String?
    private var pickerTitle: String?
    
    private var call: CAPPluginCall?
    private var picker: UIDatePicker?
    private var titleView: UILabel?
    private var alertView: UIView?
    
    
    //
    // sizes
    private var defaultButtonHeight: CGFloat = 50
    private var defaultTitleHeight: CGFloat = 50
    private var defaultSpacerHeight: CGFloat = 1
    
    private var alertSize = CGSize(width: 300 , height: 300)
    
    //
    // colors
    private var pickerTitleFontColor: String = "#ffffff"
    private var pickerTitleBgColor: String = "#2861ff"
    private var pickerBgColor: String = "#ffffff"
    private var pickerFontColor: String = "#000000"
    private var pickerButtonBgColor: String = "#ffffff"
    private var pickerButtonFontColor: String =  "#2861ff"
    
    
    private func loadOptions() {
        self.pickerTheme = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerLocale") ?? "light"
        self.pickerMode = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerFormat") ?? "dateAndTime"
        self.pickerFormat = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerTheme") ?? "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        self.pickerTimezone = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerMode") ?? nil
        self.pickerLocale = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerTimezone") ?? nil
        self.pickerCancelText = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerDate") ?? "Cancel"
        self.pickerDoneText = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerMinDate") ?? "Ok"
        self.picker24h = self.bridge.config.getValue(self.CONFIG_KEY_PREFIX + "pickerMaxDate") as? Bool ?? false
        self.pickerDate = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerTitle") ?? self.parseDateFromObject(date: Date())
        self.pickerMinDate = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerCancelText") ?? nil
        self.pickerMaxDate = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "pickerDoneText") ?? nil
        self.pickerTitle = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "title") ?? nil
        self.pickerTitleFontColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "titleFontColor") ?? self.pickerTitleFontColor
        self.pickerTitleBgColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "titleBgColor") ?? self.pickerTitleBgColor
        self.pickerBgColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "bgColor") ?? self.pickerBgColor
        self.pickerFontColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "fontColor") ?? self.pickerFontColor
        self.pickerButtonBgColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "buttonBgColor") ?? self.pickerButtonBgColor
        self.pickerButtonFontColor = self.bridge.config.getString(self.CONFIG_KEY_PREFIX + "buttonFontColor") ?? self.pickerButtonFontColor
        
        if (self.call != nil) {
            self.pickerLocale = self.call?.getString("locale") ?? self.pickerLocale
            self.pickerFormat = self.call?.getString("format") ?? self.pickerFormat
            self.pickerTheme = self.call?.getString("theme") ?? self.pickerTheme
            self.pickerMode = self.call?.getString("mode") ?? self.pickerMode
            self.pickerTimezone = self.call?.getString("timezone") ?? self.pickerTimezone
            self.pickerDate = self.call?.getString("date") ?? self.pickerDate
            self.pickerMinDate = self.call?.getString("min") ?? self.pickerMinDate
            self.pickerMaxDate = self.call?.getString("max") ?? self.pickerMaxDate
            self.pickerTitle = self.call?.getString("title") ?? self.pickerTitle
            self.pickerCancelText = self.call?.getString("cancelText") ?? self.pickerCancelText
            self.pickerDoneText = self.call?.getString("doneText") ?? self.pickerDoneText
            self.picker24h = self.call?.getBool("is24h") ?? self.picker24h
            self.pickerTitleFontColor = self.call?.getString("titleFontColor") ?? self.pickerTitleFontColor
            self.pickerTitleBgColor = self.call?.getString("titleBgColor") ?? self.pickerTitleBgColor
            self.pickerBgColor = self.call?.getString("bgColor") ?? self.pickerBgColor
            self.pickerFontColor = self.call?.getString("fontColor") ?? self.pickerFontColor
            self.pickerButtonBgColor = self.call?.getString("buttonBgColor") ?? self.pickerButtonBgColor
            self.pickerButtonFontColor = self.call?.getString("buttonFontColor") ?? self.pickerButtonFontColor
        }
        
        self.alertSize = CGSize(width: self.bridge.viewController.view.bounds.size.width, height: 250 + self.defaultButtonHeight)
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
    
    private func getMode() -> UIDatePicker.Mode {
        let result: UIDatePicker.Mode
        switch self.pickerMode {
        case "time":
            result = UIDatePicker.Mode.time
            break
        case "date":
            result = UIDatePicker.Mode.date
            break;
        default:
            result = UIDatePicker.Mode.dateAndTime
            break
        }
        
        return result
    }
    
    private func createTitleView() -> UILabel {
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: self.alertSize.width, height: self.defaultTitleHeight))
        titleView.textAlignment = .center
        titleView.text = self.titleChange(self.parseDateFromString(date: self.pickerDate!))
        titleView.textColor = UIColor(hexString: self.pickerTitleFontColor)
        titleView.backgroundColor = UIColor(hexString: self.pickerTitleBgColor)
        
        return titleView
    }
    
    private func createOkButton() -> UIButton {
        let buttonWidth =  self.alertSize.width / 2
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: buttonWidth, y: self.alertSize.height - self.defaultButtonHeight, width: buttonWidth, height: self.defaultButtonHeight)
        button.setTitle(self.pickerDoneText != nil ? self.pickerDoneText! : "Ok", for: .normal)
        button.setTitleColor(UIColor(hexString: self.pickerButtonFontColor), for: .normal)
        button.backgroundColor = UIColor(hexString: self.pickerButtonBgColor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.ok))
        button.addGestureRecognizer(tap)
        
        return button
    }
    
    private func createCancelButton() -> UIButton {
        let buttonWidth =  self.alertSize.width / 2
        let button = UIButton(frame: CGRect(x: 0, y: self.alertSize.height - self.defaultButtonHeight, width: buttonWidth, height: self.defaultButtonHeight))
        button.setTitle(self.pickerCancelText != nil ? self.pickerCancelText! : "Cancel", for: .normal)
        button.setTitleColor(UIColor(hexString: self.pickerButtonFontColor), for: .normal)
        button.backgroundColor = UIColor(hexString: self.pickerButtonBgColor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancel))
        button.addGestureRecognizer(tap)
        
        return button
    }
    
    private func createDatePicker() -> UIDatePicker {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: self.defaultTitleHeight, width: 0, height: 0))
        
        picker.setValue(UIColor(hexString: self.pickerFontColor), forKey: "textColor")
        picker.addTarget(self, action: #selector(self.datePickerChanged(picker:)), for: .valueChanged)
        picker.setDate(self.parseDateFromString(date: self.pickerDate!), animated: false)
        if (self.pickerDate != nil) {
            picker.date = self.parseDateFromString(date: self.pickerDate!)
        }
        if (self.pickerMaxDate != nil) {
            picker.maximumDate = self.parseDateFromString(date: self.pickerMaxDate!)
        }
        if (self.pickerMinDate != nil) {
            picker.minimumDate = self.parseDateFromString(date: self.pickerMinDate!)
        }
        picker.datePickerMode = self.getMode()
        
        return picker
    }
    
    private func createPickerView() -> UIView {
        let okButton = self.createOkButton()
        let cancelButton = self.createCancelButton()
        
        let width = self.bridge.viewController.view.bounds.size.width
        let height = self.bridge.viewController.view.bounds.size.height
        
        let alertView = UIView(frame: CGRect(x: 0, y: 0, width: self.alertSize.width, height: self.alertSize.height))
        let yPosition = alertView.bounds.size.height - self.defaultButtonHeight - self.defaultSpacerHeight
        let lineView = UIView(frame: CGRect(x: 0, y: yPosition, width: alertView.bounds.size.width, height: self.defaultSpacerHeight))
        
        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        
        alertView.frame.origin.y = height - 300
        alertView.frame.size.width = width
        alertView.frame.size.height = 300
        alertView.backgroundColor = UIColor(hexString: self.pickerBgColor)
        
        alertView.addSubview(okButton)
        alertView.addSubview(cancelButton)
        alertView.addSubview(lineView)
        
        return alertView
    }
    
    @objc func titleChange(_ date: Date) -> String{
        if (self.pickerTitle == nil) {
            var format: String = "E, MMM d, yyyy HH:MM"
            if (self.pickerMode == "time") {
                format = "HH:MM a"
            } else if (self.pickerMode == "date") {
                format = "E, MMM d, yyyy"
            }
            return self.parseDateFromObject(date: date, format: format)
        }
        return self.pickerTitle!
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        self.titleView?.text = self.titleChange(picker.date)
    }
    
    private func dismiss() {
        DispatchQueue.main.async {
            self.alertView?.removeFromSuperview()
        }
    }
    
    @objc func cancel(sender: UIButton) {
        if (self.call != nil) {
            var obj:[String:Any] = [:]
            obj["value"] = nil
            self.call?.resolve(obj)
            self.call = nil
        }
        self.dismiss()
    }
    
    @objc func ok(sender: UIButton) {
        if (self.call != nil) {
            var obj:[String:Any] = [:]
            obj["value"] = parseDateFromObject(date: (picker?.date)!)
            self.call?.resolve(obj)
            self.call = nil
        }
        self.dismiss()
    }
    
    @objc func present(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.call = call
            self.loadOptions()
            
            if (self.alertView != nil) {
                self.alertView?.removeFromSuperview()
            }
            
            self.titleView = self.createTitleView()
            self.picker = self.createDatePicker()
            
            self.alertView = self.createPickerView()
            
            self.alertView?.addSubview(self.titleView!);
            self.alertView?.addSubview(self.picker!)
            
            self.bridge.viewController.view.addSubview(self.alertView!)
        }
    }
    
    func setPosition() {
        let view = self.bridge.viewController.view
        CAPLog.print("view dimension", view!.frame.width, view!.frame.height)
        
        self.picker!.frame.origin.y = view!.frame.size.height-200
        self.picker!.frame.size.width = view!.frame.width
        
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
