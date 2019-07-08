import Foundation
import Capacitor
import UIKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 * Created by Stewan Silva on 07/07/2019
 */

class DatepickerController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create a DatePicker
    let datePicker: UIDatePicker = UIDatePicker()
    
    // Grabs the height of your view
    let viewHeight = view.frame.size.height
    
    // Positioning date picket within a view
    datePicker.frame = CGRect(x: 0, y: viewHeight-200, width: self.view.frame.width, height: 200)
    
    // Set some of UIDatePicker properties
    datePicker.timeZone = NSTimeZone.local
    datePicker.backgroundColor = UIColor.white
    
    // Add an event to call onDidChangeDate function when value is changed.
    datePicker.addTarget(self, action: #selector(DatepickerController.datePickerValueChanged(_:)), for: .valueChanged)
    
    // Add DataPicker to the view
    self.view.addSubview(datePicker)
    
  }
  
  
  @objc func datePickerValueChanged(_ sender: UIDatePicker){
    
    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()
    
    // Set date format
    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
    
    // Apply date format
    let selectedDate: String = dateFormatter.string(from: sender.date)
    
    print("Selected value \(selectedDate)")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
@objc(DatetimePlugin)
public class DatetimePlugin: CAPPlugin {
  
  @objc func echo(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      let datepicker = DatepickerController()

//      self.bridge.viewController.present(datepicker, animated: true, completion: nil)
//
      
      let view = self.bridge.viewController.view
      view?.addSubview(datepicker.view)
      

    }
  }
  

}
