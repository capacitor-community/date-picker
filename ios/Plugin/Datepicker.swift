import Capacitor

/**
 * Created by Stewan Silva on 07/07/2019
 */

extension UIDatePicker {
  public enum Theme : Int {
    case light = 1
    case dark = 0
  }
}

class Datepicker: UIViewController {
  private var instance:UIDatePicker?
  
  public var dateMode:UIDatePicker.Mode?
  public var dateTheme:UIDatePicker.Theme?
  
  public var dateResponse:String?
  public var dateCurrent:String?
  public var dateFormat:String?
  public var dateLocale:String?
  public var dateBg:String?
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    //
    // Dispose of any resources that can be recreated.
  }
  
  func load(_ mode:String, _ locale:String, _ theme:String, _ format:String, _ date:String?, _ bg:String?) {
    //
    // Create a DatePicker
    instance = UIDatePicker()
    instance?.setValue(false, forKey: "highlightsToday")
    
    //
    // picker mode
    setMode(mode)
    
    //
    // theme
    setTheme(theme)
    
    //
    // background
    setBg(bg)
    
    //
    // locale
    setLocale(locale)
    
    //
    // date date
    setDate(date)
    
    //
    // timezone
    instance?.timeZone = NSTimeZone.local
    
    //
    // required event to call onDidChangeDate function when value is changed
    instance?.addTarget(self, action: #selector(Datepicker.instanceValueChanged(_:)), for: .valueChanged)
    
    //
    // push picker to the view
    view.addSubview(instance!)
  }
  
  @objc func instanceValueChanged(_ sender: UIDatePicker){
    //
    // Apply date format
    dateResponse = parseDateFromObject(sender.date)
    CAPLog.print("Selected value \(String(describing: dateCurrent))")
  }
  
  func darkMode() {
    instance!.setValue(UIColor.white, forKey: "textColor")
  }
  
  func lightMode() {
    instance!.setValue(UIColor.black, forKey: "textColor")
  }
  
  func value() -> String {
    let response:String = dateResponse ?? dateCurrent!
    reset()
    return response
  }
  
  func reset(dateDate:Date = Date()) {
    instance?.setDate(dateDate, animated: false)
    dateResponse = nil
  }
  
  func setLocale(_ locale:String) {
    instance?.locale = Locale(identifier: locale)
  }
  
  func setDate(_ date:String?) {
    if (date != nil) {
      dateCurrent = date
      instance?.setDate(parseDateFromString(date!), animated: false)
    }
  }
  
  func setMode(_ mode: String) {
    instance?.datePickerMode = translateMode(mode)
  }
  
  func setTheme(_ theme:String) {
    let themeChanged = translateTheme(theme)
    if (themeChanged == UIDatePicker.Theme.light) {
      lightMode()
    }
    if (themeChanged == UIDatePicker.Theme.dark) {
      darkMode()
    }
  }
  
  func setBg(_ dateBg:String?) {
    if (dateBg != nil) {
      instance?.backgroundColor = UIColor(fromHex: dateBg!)
    }
  }
  
  func picker() -> UIDatePicker? {
    if (instance != nil) {
      return instance!
    }
    return nil
  }
  
  func parseDateFromObject(_ date:Date) -> String {
    //
    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()
    
    //
    // Set date format
    if (dateFormat != nil) {
      CAPLog.print("date format", date, dateFormat as Any)
      dateFormatter.dateFormat = dateFormat
    }
    
    //
    // Apply date format
    return dateFormatter.string(from:date)
  }
  
  func parseDateFromString(_ date:String) -> Date {
    //
    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()
    
    //
    // Set date format
    if (dateFormat != nil) {
      CAPLog.print("date format", date, dateFormat as Any)
      dateFormatter.dateFormat = dateFormat
    }
    
    //
    // Apply date format
    return dateFormatter.date(from:date) ?? Date()
  }
  
  func translateMode(_ value:String) -> UIDatePicker.Mode {
    if (value == "time") {
      return UIDatePicker.Mode(rawValue: 0)!;
    }
    
    if (value == "date") {
      return UIDatePicker.Mode(rawValue: 1)!;
    }
    
    if (value == "dateAndTime") {
      return UIDatePicker.Mode(rawValue: 2)!;
    }
    
    if (value == "countDownTimer") {
      return UIDatePicker.Mode(rawValue: 3)!;
    }
    
    return UIDatePicker.Mode(rawValue: 0)!;
  }
  
  func translateTheme(_ value:String) -> UIDatePicker.Theme {
    if (value == "light") {
      return UIDatePicker.Theme(rawValue: 1)!;
    }
    
    if (value == "dark") {
      return UIDatePicker.Theme(rawValue: 0)!;
    }
    
    return UIDatePicker.Theme(rawValue: 1)!;
  }
  
}
