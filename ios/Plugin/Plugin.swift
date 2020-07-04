import Foundation
import Capacitor
import UIKit


/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 * Created by Stewan Silva on 07/07/2019
 */

@objc(DatePickerPlugin)
public class DatePickerPlugin: CAPPlugin {

  private var instance = DatePicker()
  
  private var view:UIView?
  private var viewHeight:CGFloat = 0.0
  private var viewWidth:CGFloat = 0.0
  
  private var doneButton:UIButton?
  private var cancelButton:UIButton?
  
  private var call:CAPPluginCall?
  
  private var defaultTheme:String = "light"
  private var defaultMode:String = "dateAndTime"
  private var defaultFormat:String = "MM/dd/yyyy hh:mm a"
  private var defaultLocale:String = "en_US"
  
  public override func load() {
    let format = getConfigValue("format") as? String ?? defaultFormat
    let locale = getConfigValue("locale") as? String ?? defaultLocale
    let theme = getConfigValue("theme") as? String ?? defaultTheme
    let mode = getConfigValue("mode") as? String ?? defaultMode
    let date = getConfigValue("date") as? String ?? nil
    let bg = getConfigValue("background") as? String ?? nil
    
    view = self.bridge.viewController.view
    viewHeight = instance.view.bounds.size.height
    viewWidth = instance.view.bounds.size.width
    
    doneButton = UIButton(frame: CGRect(x: 0, y: viewHeight - 200 - 50, width: viewWidth/2, height: 50))
    doneButton?.contentHorizontalAlignment = .left
    doneButton?.contentEdgeInsets = UIEdgeInsets(top: 0,left: 15,bottom: 0,right: 0)
    doneButton?.setTitle("Done", for: .normal)
    doneButton?.addTarget(self, action: #selector(self.done), for: .touchUpInside)
    
    cancelButton = UIButton(frame: CGRect(x: viewWidth/2, y: viewHeight - 200 - 50, width: viewWidth/2, height: 50))
    cancelButton?.contentHorizontalAlignment = .right
    cancelButton?.contentEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 15)
    cancelButton?.setTitle("Cancel", for: .normal)
    cancelButton?.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
    
    
    if (bg != nil) {
        doneButton?.backgroundColor = UIColor(named: bg!)
        cancelButton?.backgroundColor = UIColor(named: bg!)
    }
    
    instance.load(mode, locale, format,theme,date, bg)
    
    NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
  }
  
  @objc func deviceRotated(){
    if UIDevice.current.orientation.isLandscape {
      CAPLog.print("Landscape")
      
      self.doneButton!.frame.origin.y = viewHeight - 460 - 50
      self.cancelButton!.frame.origin.y = viewHeight - 460 - 50
      
      setPosition()
      
      self.cancelButton!.frame.size = CGSize(width: view!.frame.width/2+view!.frame.width/4.6, height: 50)
      
    } else {
      CAPLog.print("Portrait")
      
      self.doneButton!.frame.origin.y = viewHeight - 200 - 50
      self.cancelButton!.frame.origin.y = viewHeight - 200 - 50
      
      setPosition()
      
      self.cancelButton!.frame.size = CGSize(width: view!.frame.width/2, height: 50)
    }
  }
  
  @objc func present(_ call: CAPPluginCall) {
    self.call = call;
    DispatchQueue.main.async {
      //
      // get options
      let format = call.getString("format")
      let locale = call.getString("locale")
      let theme = call.getString("theme")
      let mode = call.getString("mode")
      let date = call.getString("date")
      let bg = call.getString("background")
      
      //
      // apply options
      if (format != nil) {
        self.instance.dateFormat = format
      }
      
      if (locale != nil) {
        self.instance.setLocale(locale!)
      }
      
      if (theme != nil) {
        let themeChanged = self.instance.translateTheme(theme!)
        if (themeChanged == UIDatePicker.Theme.light) {
          self.lightMode()
        }
        if (themeChanged == UIDatePicker.Theme.dark) {
          self.darkMode()
        }
      }
      
      if (bg != nil) {
        self.instance.setBg(bg)
        self.doneButton?.backgroundColor = UIColor(named: bg!)
        self.cancelButton?.backgroundColor = UIColor(named: bg!)
      }
      
      if (mode != nil) {
        self.instance.setMode(mode!)
      }
      
      if (date != nil) {
        self.instance.setDate(date)
      }
      
      //
      // positioning
      self.setPosition()
      
      //
      // mount view
      self.view?.addSubview(self.instance.view)
      self.view?.addSubview(self.doneButton!)
      self.view?.addSubview(self.cancelButton!)
    }
  }
  
  @objc func dismiss() {
    DispatchQueue.main.async {
      self.instance.view.removeFromSuperview()
      self.cancelButton?.removeFromSuperview()
      self.doneButton?.removeFromSuperview()
    }
  }
  
  @objc func done() {
    call?.resolve([
      "value": self.instance.value()
      ])
    dismiss()
    instance.reset()
  }
  
  @objc func darkMode(_ call: CAPPluginCall? = nil) {
    DispatchQueue.main.async {
      self.doneButton?.setTitleColor(UIColor.white, for: .normal)
      self.doneButton?.setTitleColor(UIColor.white, for: .highlighted)
      
      self.cancelButton?.setTitleColor(UIColor.white, for: .normal)
      self.cancelButton?.setTitleColor(UIColor.white, for: .highlighted)
      
      self.instance.darkMode()
    }
  }
  
  @objc func lightMode(_ call: CAPPluginCall? = nil) {
    DispatchQueue.main.async {
      self.doneButton?.setTitleColor(UIColor.black, for: .normal)
      self.doneButton?.setTitleColor(UIColor.black, for: .highlighted)
      
      self.cancelButton?.setTitleColor(UIColor.black, for: .normal)
      self.cancelButton?.setTitleColor(UIColor.black, for: .highlighted)
      
      self.instance.lightMode()
    }
  }
  
  func setPosition() {
    let picker:UIDatePicker? = instance.picker()
    
    CAPLog.print("view dimension", view!.frame.width, view!.frame.height)
    
    picker!.frame.origin.y = view!.frame.size.height-200
    picker!.frame.size.width = view!.frame.width
    
  }
}
