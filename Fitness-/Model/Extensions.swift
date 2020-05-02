//
//  Helper.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/6/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Adds a vertical gradient layer with two **UIColors** to the **UIView**.
     - Parameter topColor: The top **UIColor**.
     - Parameter bottomColor: The bottom **UIColor**.
     */
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
 
extension UIButton{
    func disable(){
        self.isEnabled = false;
        self.alpha = 0.4
    }
    func enable(){
        self.isEnabled = true;
        self.alpha = 1
    }
}

extension UITextField{
    func addUnderline(color: UIColor){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height-1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    func disableAutoFill() {
        if #available(iOS 11, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}


extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension UIColor{
    static func rgb(_ red:Double, _ green:Double, _ blue:Double) -> UIColor {
        return UIColor.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
    }
}

extension UIViewController {
    public func presentAlertViewController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func isInt() -> Bool {

        if let intValue = Int(self) {
            return true
        }

        return false
    }
    
    func isDouble() -> Bool {

        if let doubleValue = Double(self) {
            return true
        }

        return false
    }
}


