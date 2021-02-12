import Foundation
import Capacitor

public class DatePicker: NSObject {
    
    private var options = DatePickerOptions()
    
    init(options: DatePickerOptions) {
        self.options = options
    }
    
    public func titleView() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 10))
        title.textAlignment = .center
        title.text = self.titleChange(self.parseDateFromString(date: self.pickerDate!))
        title.textColor = UIColor(hexString: self.pickerTitleFontColor)
        title.backgroundColor = UIColor(hexString: self.pickerTitleBgColor)
    }
    
    public func open(options: DatePickerOptions, completion: @escaping (_ value: String) -> Void) {
        completion(options.title!)
    }
}
