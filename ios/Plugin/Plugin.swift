import Foundation
import Capacitor
import UIKit


/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 * Created by Stewan Silva on 07/07/2019
 */

@objc(DatepickPlugin)
public class DatepickPlugin: CAPPlugin {
  
  private var instance = DatepickerController()
  
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
    let current = getConfigValue("current") as? String ?? nil
   
    view = self.bridge.viewController.view
    viewHeight = instance.view.frame.size.height
    viewWidth = instance.view.frame.size.width
    
    cancelButton = UIButton(frame: CGRect(x: viewWidth/2, y: viewHeight - 200 - 50, width: viewWidth/2, height: 50))
    cancelButton?.contentHorizontalAlignment = .right
    cancelButton?.contentEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 15)
    cancelButton?.setTitle("Cancel", for: .normal)
    cancelButton?.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
    
    doneButton = UIButton(frame: CGRect(x: 0, y: viewHeight - 200 - 50, width: viewWidth/2, height: 50))
    doneButton?.contentHorizontalAlignment = .left
    doneButton?.contentEdgeInsets = UIEdgeInsets(top: 0,left: 15,bottom: 0,right: 0)
    doneButton?.setTitle("Done", for: .normal)
    doneButton?.addTarget(self, action: #selector(self.done), for: .touchUpInside)
    
    instance.load(theme, format, locale, mode, current)
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
      let current = call.getString("current")
      
      //
      // apply options
      if (format != nil) {
        self.instance.dateFormat = format
      }
      
      if (locale != nil) {
        self.instance.dateLocale = locale
        self.instance.setLocale()
      }
      
      if (theme != nil) {
        let themeChanged = self.instance.translateTheme(theme!)
        self.instance.dateTheme = themeChanged
        self.instance.setTheme()
        if (themeChanged == UIDatePicker.Theme.light) {
          self.lightMode()
        }
        if (themeChanged == UIDatePicker.Theme.dark) {
          self.darkMode()
        }
      }
      
      if (mode != nil) {
        self.instance.dateMode = self.instance.translateMode(mode!)
        self.instance.setMode()
      }
      
      if (current != nil) {
        self.instance.dateCurrent = current
        self.instance.setDate()
      }
      
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
  
}
