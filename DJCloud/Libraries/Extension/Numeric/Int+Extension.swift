//
//  Int+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//
import Foundation

extension Int {
    func string() -> String {
        return "\(self)"
    }
    
    func addCommaWith(separator: String = ",") -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = separator
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))
    }
    
    func formatPoints() -> String {
        let thousandNum = self / 1000
        if self >= 1000 {
            return("\(Int(thousandNum))k")
        } else if self > 0 {
            return ("\(Int(self))")
        }
        return ("\(Int(self))k")
    }
}
