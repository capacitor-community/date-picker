import Foundation
import Capacitor

public class DatePicker {
    public var title: UILabel
    public var picker: UIDatePicker
    public var done: UIButton
    public var cancel: UIButton
    public var line: UIView
    public var alert: UIView
    public var background: UIView
    public var effect: UIVisualEffectView
    public var options: DatePickerOptions
    
    private var buttonHeight: CGFloat = 40
    private var padding: CGFloat = 0
    
    private var view: UIView
    
    init(options: DatePickerOptions, view: UIView) {
        self.view = view
        self.options = options
        title = UILabel()
        picker = UIDatePicker()
        alert = UIView()
        done = UIButton()
        cancel = UIButton()
        line = UIView()
        background = UIView()
        effect = UIVisualEffectView()
        
        if #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            padding = window.safeAreaInsets.bottom
        }
        
        prepareTitle()
        preparePicker()
        prepareAlert()
        prepareLine()
        prepareButtons()
        prepareBackground()
        
        if (options.style != "inline") {
            alert.addSubview(title)
        }
        alert.addSubview(picker)
        alert.addSubview(line)
        alert.addSubview(cancel)
        alert.addSubview(done)
        background.addSubview(alert)
        setPickerTheme()
        
        if (options.style == "inline") {
            alert.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            self.alert.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.alert.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.alert.alpha = 1
            }, completion: nil)
        } else {
            alert.frame.origin.y = view.frame.height
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.alert.frame.origin.y = view.frame.height - self.alert.frame.height
            }, completion: nil)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.effect.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        }, completion: nil)
    }
    public func dismiss() {
        if (options.style == "inline") {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.alert.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.alert.alpha = 0
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.alert.frame.origin.y = self.view.frame.height
            }, completion: {(finished: Bool) in
                self.alert.removeFromSuperview()
            })
        }
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseInOut], animations: {
            self.effect.alpha = 0
        }, completion: {(finished: Bool) in
            self.background.removeFromSuperview()
        })
    }
    private func prepareTitle() {
        title.frame.size.width = view.frame.width
        title.frame.size.height = 40
        title.textAlignment = .center
        title.text = titleChange(picker.date)
    }
    private func preparePicker() {
        if #available(iOS 14.0, *), (options.style == "inline") {
            picker.preferredDatePickerStyle = UIDatePickerStyle.inline
            picker.frame.origin.x = 10
            picker.frame.origin.y = 10
        } else {
            if #available(iOS 14.0, *) {
                picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            }
            picker.frame.origin.x = (view.frame.width - picker.frame.width) / 2
            picker.frame.origin.y = title.frame.height
        }
        if (options.date != nil) {
            picker.setDate(options.date!, animated: false)
        }
        if (options.max != nil) {
            picker.maximumDate = options.max!
        }
        if (options.min != nil) {
            picker.minimumDate = options.min!
        }
        if (options.timezone != nil) {
            picker.timeZone = TimeZone(identifier: options.timezone!)
        }
        if (options.locale != nil) {
            picker.locale = Locale(identifier: options.locale!)
        } else {
            picker.locale = NSLocale.current
        }
        if ((options.mergedDateAndTime || options.style == "inline") && options.mode == "dateAndTime") {
            picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        } else if (options.mode == "date" || options.mode == "dateAndTime") {
            picker.datePickerMode = UIDatePicker.Mode.date
        } else {
            picker.datePickerMode = UIDatePicker.Mode.time
        }
        
        picker.addTarget(self, action: #selector(self.datePickerChanged(picker:)), for: .valueChanged)
    }
    private func prepareAlert() {
        if (options.style == "inline") {
            alert.frame.size = CGSize(
                width: picker.frame.width + 20,
                height: picker.frame.height + buttonHeight + 21
            )
            alert.frame.origin.x = (view.frame.width - alert.frame.width) / 2
            alert.frame.origin.y = (view.frame.height - alert.frame.height) / 2
            alert.layer.cornerRadius = 10
        } else {
            alert.frame.size = CGSize(
                width: view.frame.width,
                height: picker.frame.height + title.frame.height + buttonHeight + padding
            )
            alert.frame.origin.x = 0
            alert.frame.origin.y = view.frame.height - alert.frame.height
        }
        
    }
    private func prepareBackground() {
        effect = UIVisualEffectView()
        effect.frame.size = view.frame.size
        effect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background.addSubview(effect)
        background.frame.size = view.frame.size
    }
    private func prepareLine() {
        line.frame.size = CGSize(width: alert.frame.width, height: 1)
        line.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        if (options.style == "inline") {
            line.frame.origin.y = picker.frame.height + 10
        } else {
            line.frame.origin.y = picker.frame.height + title.frame.height + 10
        }
    }
    private func prepareButtons() {
        let size = CGSize(width: alert.frame.width / 2, height: buttonHeight)
        done.frame.size = size;
        cancel.frame.size = size;
        done.setTitle(options.doneText, for: .normal)
        cancel.setTitle(options.cancelText, for: .normal)
        done.contentVerticalAlignment = .center
        cancel.contentVerticalAlignment = .center
        
        if (options.style == "inline") {
            done.frame.origin = CGPoint(x: size.width, y: picker.frame.height + 11)
            cancel.frame.origin = CGPoint(x: 0, y: picker.frame.height + 11)
        } else {
            done.frame.origin = CGPoint(x: size.width, y: picker.frame.height + title.frame.height + 11)
            cancel.frame.origin = CGPoint(x: 0, y: picker.frame.height + title.frame.height + 11)
        }
    }
    public func setTimeMode() {
        let date = self.picker.date
        if #available(iOS 14.0, *), options.style == "inline" {
            picker.preferredDatePickerStyle = .wheels
            picker.frame.origin.y = (alert.frame.height - buttonHeight - picker.frame.height) / 2
        }
        if (options.is24h) {
            picker.datePickerMode = UIDatePicker.Mode.countDownTimer
        } else {
            picker.datePickerMode = UIDatePicker.Mode.time
        }
        picker.frame.origin.x = (alert.frame.width - picker.frame.width) / 2
        picker.setDate(date, animated: true)
    }
    public func setPickerTheme() {
        var titleFontColor = "#000000"
        var titleBgColor = "#ffffff"
        var bgColor = "#ffffff"
        var fontColor = "#000000"
        var buttonBgColor = "#ffffff"
        var buttonFontColor = "#000000"
        if self.options.theme == "dark" {
            titleFontColor = "#fafafa"
            titleBgColor = "#121212"
            bgColor = "#121212"
            fontColor = "#fafafa"
            buttonBgColor = "#121212"
            buttonFontColor =  "#fafafa"
        }
        
        let btFontColor = UIColor(fromHex: options.buttonFontColor ?? buttonFontColor)
        let btBgColor = UIColor(fromHex: options.buttonBgColor ?? buttonBgColor)
        let tltFontColor = UIColor(fromHex: options.titleFontColor ?? titleFontColor)
        let tltBgColor = UIColor(fromHex: options.titleBgColor ?? titleBgColor)
        let alertBgColor = UIColor(fromHex: options.bgColor ?? bgColor)
        
        cancel.setTitleColor(btFontColor, for: .normal)
        cancel.backgroundColor = btBgColor
        done.setTitleColor(btFontColor, for: .normal)
        done.backgroundColor = btBgColor
        
        if #available(iOS 13.0, *) {
            picker.overrideUserInterfaceStyle = self.options.theme == "dark" ? .dark : .light
        } else {
            let pickerFontColor = UIColor(fromHex: fontColor)
            picker.setValue(pickerFontColor, forKey: "textColor")
        }
        
        if let color = options.fontColor {
            picker.setValue(UIColor(fromHex: color), forKey: "textColor")
        }
        
        title.textColor = tltFontColor
        title.backgroundColor = tltBgColor
        alert.backgroundColor = alertBgColor
    }
    @objc func datePickerChanged(picker: UIDatePicker) {
        DispatchQueue.main.async {
            self.title.text = self.titleChange(picker.date)
        }
    }
    @objc func titleChange(_ date: Date) -> String {
        if (self.options.title == nil) {
            var locale = Locale.current
            if (options.locale != nil) {
                locale = Locale(identifier: options.locale!)
            }
            let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!

            let is24h = dateFormat.firstIndex(of: "a") == nil
            
            var format: String = options.is24h || is24h ? "E, MMM d, yyyy HH:mm" : "E, MMM d, yyyy hh:mm a"
            if (options.mode == "time") {
                format = options.is24h || is24h ? "HH:mm" : "hh:mm a"
            } else if (self.options.mode == "date") {
                format = "E, MMM d, yyyy"
            }
            return Parse.dateToString(date: date, format: format, locale: locale)
        }
        return self.options.title!
    }
    
}
