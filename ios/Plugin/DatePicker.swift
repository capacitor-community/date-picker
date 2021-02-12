import Foundation
import Capacitor

public class DatePicker {
    
    public var options: DatePickerOptions!
    private var viewCtrl: UIViewController!
    
    private var buttonHeight: CGFloat = 50
    private var paddingHeight: CGFloat = 0
    private var titleHeight: CGFloat = 50
    private var spacerHeight: CGFloat = 1
    private var pickerHeight: CGFloat = 250
    
    private var alertSize: CGSize!
    
    public var background: UIView!
    public var alert: UIView!
    public var picker: UIDatePicker!
    public var doneButton: UIButton!
    public var cancelButton: UIButton!
    public var title: UILabel!
    public var buttonDivider: UIView!
    
    init(options: DatePickerOptions, viewCtrl: UIViewController) {
        self.options = options
        self.viewCtrl = viewCtrl
    }
    
    public func createElements() {
        
        NSLog(self.options.theme)
        
        if (self.options.theme == "dark") {
            self.options.titleFontColor = "#fafafa"
            self.options.titleBgColor = "#121212"
            self.options.bgColor = "#121212"
            self.options.fontColor = "#fafafa"
            self.options.buttonBgColor = "#121212"
            self.options.buttonFontColor =  "#fafafa"
        }
        
        self.paddingHeight = UIDevice.current.hasNotch ? 35 : 0
        self.createBackground()
        self.createAlert()
        self.createPicker()
        self.createDoneButton()
        self.createCancelButton()
        self.createButtonDivider()
        self.createTitle()
    }
    
    public func open() {
        self.alert.addSubview(self.doneButton)
        self.alert.addSubview(self.cancelButton)
        self.alert.addSubview(self.buttonDivider)
        self.alert.addSubview(self.picker)
        self.alert.addSubview(self.title)
        
        self.background.addSubview(self.alert)
        
        self.viewCtrl.view.addSubview(self.background)
        
        let height = self.alert.frame.size.height
        self.alert.center.y += height
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.background.backgroundColor = UIColor(fromHex: "#00000088")
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.alert.center.y -= height
        }, completion: nil)
    }
    
    private func createBackground() -> Void {
        self.background = UIView()
        self.background.backgroundColor = UIColor(fromHex: "#00000000")
        
        let x = viewCtrl.view.bounds.size.width
        let y = viewCtrl.view.bounds.size.height
        
        self.background.frame.size.width = x
        self.background.frame.size.height = y
    }
    
    private func createAlert() -> Void {
        self.alertSize = CGSize(width: self.viewCtrl.view.bounds.size.width, height: self.pickerHeight + self.buttonHeight + self.paddingHeight)
        let width = self.viewCtrl.view.bounds.size.width
        let height = self.viewCtrl.view.bounds.size.height
        self.alert = UIView()
        self.alert.frame = CGRect(x: 0, y: 0, width: self.alertSize.width, height: self.alertSize.height)
        self.alert.frame.origin.y = height - self.alertSize.height
        self.alert.frame.size.width = width
        self.alert.frame.size.height = self.alertSize.height
        self.alert.backgroundColor = UIColor(fromHex: self.options.bgColor)
    }
    
    private func createTitle() -> Void {
        self.title = UILabel()
        self.title.frame = CGRect(
            x: 0,
            y: 0,
            width: self.alertSize.width,
            height: self.titleHeight
        )
        self.title.textAlignment = .center
        self.title.text = self.titleChange(self.picker.date)
        self.title.textColor = UIColor(fromHex: self.options.titleFontColor)
        self.title.backgroundColor = UIColor(fromHex: self.options.titleBgColor)
    }
    
    private func createPicker() -> Void {
        self.picker = UIDatePicker(frame: CGRect(x: 0, y: titleHeight, width: 0, height: 0))
        if #available(iOS 14.0, *) {
            self.picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            self.picker.setValue(false, forKey: "highlightsToday")
        }
        
        let xPosition = (alertSize.width - self.picker.frame.width) / 2
        self.picker.frame.origin.x = xPosition
        self.picker.addTarget(self, action: #selector(self.datePickerChanged(picker:)), for: .valueChanged)
        self.picker.setValue(UIColor(fromHex: options.fontColor), forKey: "textColor")
        
        if (options.date != nil) {
            self.picker.setDate(options.date!, animated: false)
        }
        if (options.max != nil) {
            self.picker.maximumDate = options.max!
        }
        if (options.min != nil) {
            self.picker.minimumDate = options.min!
        }
        if (options.locale != nil) {
            self.picker.locale = Locale(identifier: options.locale!)
        } else {
            self.picker.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")
        }
        
        if (options.mode == "time") {
            self.setTimeMode()
        } else if (options.mergedDateAndTime) {
            self.picker.datePickerMode = UIDatePicker.Mode.dateAndTime
            let xPosition = (alertSize.width - self.picker.frame.width) / 2
            self.picker.frame.origin.x = xPosition
        } else {
            self.picker.datePickerMode = UIDatePicker.Mode.date
            let xPosition = (alertSize.width - self.picker.frame.width) / 2
            self.picker.frame.origin.x = xPosition
        }
    }
    
    private func createDoneButton() -> Void {
        self.doneButton = UIButton(type: .custom)
        
        self.doneButton.frame = CGRect(
            x: self.alertSize.width / 2,
            y: self.alertSize.height - self.buttonHeight - self.paddingHeight,
            width: self.alertSize.width / 2,
            height: self.buttonHeight
        )
        self.doneButton.setTitle(options.doneText, for: .normal)
        self.doneButton.setTitleColor(UIColor(fromHex: options.buttonFontColor), for: .normal)
        self.doneButton.backgroundColor = UIColor(fromHex: options.buttonBgColor)
    }
    
    private func createCancelButton() -> Void {
        self.cancelButton = UIButton()
        self.cancelButton.frame = CGRect(
            x: 0,
            y: alertSize.height - buttonHeight - paddingHeight,
            width: self.alertSize.width / 2,
            height: buttonHeight
        )
        self.cancelButton.setTitle(self.options.cancelText, for: .normal)
        self.cancelButton.setTitleColor(UIColor(fromHex: self.options.buttonFontColor), for: .normal)
        self.cancelButton.backgroundColor = UIColor(fromHex: self.options.buttonBgColor)
    }
    
    private func createButtonDivider() -> Void {
        self.buttonDivider = UIView()
        self.buttonDivider.frame = CGRect(
            x: 0,
            y: self.alertSize.height - self.buttonHeight - self.spacerHeight - self.paddingHeight,
            width: self.viewCtrl.view.bounds.size.width,
            height: self.spacerHeight
        )
        self.buttonDivider.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
    }
    
    public func setTimeMode() {
        let date = self.picker.date
        if (options.is24h) {
            self.picker.datePickerMode = UIDatePicker.Mode.countDownTimer
        } else {
            self.picker.datePickerMode = UIDatePicker.Mode.time
        }
        let xPosition = (alertSize.width - self.picker.frame.width) / 2
        self.picker.frame.origin.x = xPosition
        self.picker.setDate(date, animated: true)
    }
    
    @objc public func dismiss() {
        let height = self.alert.frame.size.height
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.alert.center.y += height
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.background.backgroundColor = UIColor(fromHex: "#00000000")
        }, completion: { (finished: Bool) in
            self.background.removeFromSuperview()
        })
        UIView.transition(with: self.viewCtrl.view, duration: 0.25, options: [.curveEaseIn], animations: {
        }, completion: nil)
    }
    
    @objc func titleChange(_ date: Date) -> String {
        if (self.options.title == nil) {
            var format: String = self.options.is24h ? "E, MMM d, yyyy HH:mm" : "E, MMM d, yyyy hh:mm a"
            if (self.options.mode == "time") {
                format = self.options.is24h ? "HH:mm" : "hh:mm a"
            } else if (self.options.mode == "date") {
                format = "E, MMM d, yyyy"
            }
            return Parse.dateToString(date: date, format: format)
        }
        return self.options.title!
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        DispatchQueue.main.async {
            self.title.text = self.titleChange(picker.date)
        }
    }
}
