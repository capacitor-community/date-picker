import Capacitor

/**
 * Created by Stewan Silva on 07/07/2019
 */

enum DatepickerTheme: String {
  case light = "LIGHT"
  case dark = "DARK"
}


class DatepickerController: UIViewController {
  
  private var datePicker:UIDatePicker?
  private var dateCurrent:String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.load();
  }
  
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
      self.position()
    } else {
      CAPLog.print("Portrait")
      self.position()
    }
  }
  
  func load(_ theme:DatepickerTheme = DatepickerTheme.light) {
    
    // Create a DatePicker
    self.datePicker = UIDatePicker()
    self.datePicker?.setValue(false, forKey: "highlightsToday")
    self.datePicker?.datePickerMode = .dateAndTime
    
    // self.datePicker?.locale = Locale(identifier: "pt_BR")
    
    
    // Positioning date picket within a view
    self.position()
    
    // Set some of UIDatePicker properties
    self.datePicker?.timeZone = NSTimeZone.local
    
    // Add an event to call onDidChangeDate function when value is changed.
    self.datePicker?.addTarget(self, action: #selector(DatepickerController.datePickerValueChanged(_:)), for: .valueChanged)
    
    // Add DataPicker to the view
    self.view.addSubview(self.datePicker!)
  }
  
  @objc func datePickerValueChanged(_ sender: UIDatePicker){
    // Apply date format
    let selectedDate: String = self.format(date: sender.date)
    
    CAPLog.print("Selected value \(selectedDate)")
    
    self.dateCurrent = selectedDate
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func format(date:Date) -> String {
    
    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()
    
    // Set date format
    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
    
    // Apply date format
    return dateFormatter.string(from:date)
  }
  
  func darkMode() {
    self.datePicker!.setValue(UIColor.white, forKey: "textColor")
  }
  
  func lightMode() {
    self.datePicker!.setValue(UIColor.black, forKey: "textColor")
  }
  
  func value() -> String {
    return self.dateCurrent != nil ? self.dateCurrent! : self.format(date: self.datePicker!.date)
  }
  
  func reset(currentDate:Date = Date()) {
    self.datePicker?.setDate(currentDate, animated: false)
  }
  
  func position() {
    self.datePicker?.frame = CGRect(x: 0, y: view.frame.size.height-200, width: self.view.frame.width, height: 200)
  }
  
}
