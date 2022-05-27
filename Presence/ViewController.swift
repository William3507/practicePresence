//
//  ViewController.swift
//  Presence
//
//  Created by William Bailey on 5/19/22.
//

import UIKit
import FlyBuy
import FlyBuyPresence
import CoreBluetooth


@objc public protocol PresenceLocDel {
  @objc optional func locatorDidStart(_ locator: PresenceLocator)
    @objc optional func locatorDidStop(_ locator: PresenceLocator)
  @objc optional func locatorDidFail(_ locator: PresenceLocator, error: Error)
  @objc optional func locator(_ locator: PresenceLocator, didReceiveEvent type: UInt8)
}

var counter = 0

class ViewController: UIViewController, UITextFieldDelegate, PresenceLocatorDelegate {
    @IBOutlet weak var presenceActivation: UIButton!
    @IBOutlet weak var presenceDeActivation: UIButton!
    @IBOutlet weak var displayField: UITextField!
    var activeField: UITextField?

    @IBOutlet weak var field: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.hideKeyboardWhenTappedAround()
    }
    
    var customerLocator:PresenceLocator?
    
    func setLocator(_ locator:PresenceLocator) {
        self.customerLocator = locator
    }
    
    
    @IBAction func displayField(_ sender: Any) {
        
    }
    
    
    // Button that should start the locator
    
    @IBAction func enterTapped(_ sender: Any) {

        var someString:String = field.text ?? "12345678"
        
        if someString.count < 8 {
            let difference = 8 - someString.count
            
            for i in 1...difference {
                someString = someString + " "
            }
        }
        else if someString.count > 8 {
            let difference = someString.count - 8
            
            for i in 1...difference {
                someString.removeLast()
            }
        }
                    
            
        let presenceId = Data(someString.utf8)
        let payload = "{'key':'value'}"
        FlyBuyPresence.Manager.shared.createLocatorWithIdentifier(presenceId, payload: payload) { (locator, error) -> (Void) in
          if let error = error {
            // Handle error
              print("Uh oh! Something went wrong! \(error)")
          }
          else {
            // Set locator delegate
              locator?.delegate = self
            
            if let locator = locator {
                FlyBuyPresence.Manager.shared.start(locator)
                
                counter = 1
                
                displayField.backgroundColor = UIColor.green;
                displayField.text = "On"

                
            }
          }
        }
    }
    
    
// Button that should stop the locator
    
    @IBAction func locatorOffButton(_ sender: Any) {
                
        if let error = FlyBuyPresence.Manager.shared.stop() as? PresenceError {
          print("Error Description: \(error)")
          let errorType = error.type
          print("Error Type: \(errorType)")
        }
        
        counter = 0
        
        displayField.backgroundColor = UIColor.red;
        displayField.text = "Off"

    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
