//
//  EPExtensions.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 17/01/16.
//
//

import Foundation

//MARK: - UIViewController Extensions

extension UIViewController {
    
    func showAlert(message: String) {
        showAlert(message, andTitle: "")
    }
    
    func showAlert(message: String, andTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: - UIColor Extensions

extension UIColor {
    class func defaultTintColor() -> UIColor {
        return UIColor(red: (233/255), green: (159/255), blue: (94/255), alpha: 1.0)
    }
}