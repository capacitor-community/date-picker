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
  
  private var datePicker = DatepickerController()
  
  private var view:UIView?
  private var viewHeight:CGFloat = 0.0
  private var viewWidth:CGFloat = 0.0
  
  private var doneButton:UIButton?
  private var cancelButton:UIButton?
  
  private var call:CAPPluginCall?
  
  public override func load() {
    view = self.bridge.viewController.view
    viewHeight = datePicker.view.frame.size.height
    viewWidth = datePicker.view.frame.size.width
    
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
    

    
    self.lightMode()
  }
  
  @objc func present(_ call: CAPPluginCall) {
    self.call = call;
    DispatchQueue.main.async {
      self.view?.addSubview(self.datePicker.view)
      self.view?.addSubview(self.doneButton!)
      self.view?.addSubview(self.cancelButton!)
    }
  }
  
  @objc func dismiss() {
    DispatchQueue.main.async {
      self.datePicker.view.removeFromSuperview()
      self.cancelButton?.removeFromSuperview()
      self.doneButton?.removeFromSuperview()
    }
  }
  
  @objc func done() {
    self.dismiss()
    self.call?.resolve([
      "value": self.datePicker.value()
    ])
    self.datePicker.reset()
  }
  
  @objc func darkMode(_ call: CAPPluginCall? = nil) {
    DispatchQueue.main.async {
      self.doneButton?.setTitleColor(UIColor.white, for: .normal)
      self.doneButton?.setTitleColor(UIColor.white, for: .highlighted)
      
      self.cancelButton?.setTitleColor(UIColor.white, for: .normal)
      self.cancelButton?.setTitleColor(UIColor.white, for: .highlighted)
      
      self.datePicker.darkMode()
    }
  }
  
  @objc func lightMode(_ call: CAPPluginCall? = nil) {
    DispatchQueue.main.async {
      self.doneButton?.setTitleColor(UIColor.black, for: .normal)
      self.doneButton?.setTitleColor(UIColor.black, for: .highlighted)
      
      self.cancelButton?.setTitleColor(UIColor.black, for: .normal)
      self.cancelButton?.setTitleColor(UIColor.black, for: .highlighted)
      
      self.datePicker.lightMode()
    }
  }
  
}
