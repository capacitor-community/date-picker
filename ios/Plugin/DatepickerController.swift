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

class DatepickerController: UIViewController {
  private var instance:UIDatePicker?
  
  public var dateMode:UIDatePicker.Mode?
  public var dateTheme:UIDatePicker.Theme?
  
  public var dateResponse:String?
  public var dateCurrent:String?
  public var dateFormat:String?
  public var dateLocale:String?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    CAPLog.print("remove observer")
    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
  }
  
  @objc func deviceRotated(){
    if UIDevice.current.orientation.isLandscape {
      CAPLog.print("Landscape")
      setPosition()
    } else {
      CAPLog.print("Portrait")
      setPosition()
    }
  }
  
  func load(_ theme:String,_ format:String,_ locale:String,_ mode:String,_ current:String?) {
    //
    // set options
    setOptions(theme, format, locale, mode, current)
    
    //
    // Create a DatePicker
    instance = UIDatePicker()
    instance?.setValue(false, forKey: "highlightsToday")
    
    //
    // Set picker mode
    setMode()
    
    //
    // Set theme
    setTheme()
    
    //
    // Set locale
    setLocale()
    
    //
    // Set date
    setDate()
    
    //
    // Does picker position
    setPosition()
    
    //
    // Timezone
    instance?.timeZone = NSTimeZone.local
    
    //
    // Required event to call onDidChangeDate function when value is changed
    instance?.addTarget(self, action: #selector(DatepickerController.instanceValueChanged(_:)), for: .valueChanged)
    
    //
    // Push picker to the view
    view.addSubview(instance!)
  }
  
  @objc func instanceValueChanged(_ sender: UIDatePicker){
    //
    // Apply date format
    dateResponse = parseDateFromObject(sender.date)
    CAPLog.print("Selected value \(String(describing: dateCurrent))")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    //
    // Dispose of any resources that can be recreated.
  }
  
  func parseDateFromObject(_ date:Date) -> String {
    //
    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()
    
    //
    // Set date format
    dateFormatter.dateFormat = dateFormat
    
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
  
  func reset(currentDate:Date = Date()) {
    instance?.setDate(currentDate, animated: false)
    dateResponse = nil
  }
  
  func setPosition() {
    instance?.frame = CGRect(x: 0, y: view.frame.size.height-200, width: view.frame.width, height: 200)
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
  
  func setLocale() {
    instance?.locale = Locale(identifier: dateLocale!)
  }
  
  func setDate() {
    if (dateCurrent != nil) {
      instance?.setDate(parseDateFromString(dateCurrent!), animated: false)
    }
  }
  
  func setMode() {
    instance?.datePickerMode = dateMode!
  }
  
  func setTheme() {
    if (dateTheme == UIDatePicker.Theme.light) {
      lightMode()
    }
    if (dateTheme == UIDatePicker.Theme.dark) {
      darkMode()
    }
  }
  
  func setOptions(_ format:String, _ locale:String, _ mode:String, _ theme:String, _ current:String?) {
    dateFormat = format
    dateLocale = locale
    dateMode = translateMode(mode)
    dateTheme = translateTheme(theme)
    dateCurrent = current != nil ? current : parseDateFromObject(Date())
  }
}
