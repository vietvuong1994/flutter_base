//
//  String+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit
import CommonCrypto

// General enum list
enum RandomStringType: String {
    case numericDigits = "0123456789"
    case uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    case allKindLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numericDigitsAndLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var text: String { return rawValue }
}

extension String {
    // MARK: - Subscript
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    // MARK: - Variables
    var int: Int? {
        return Int(self)
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    var percentEncoding: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var trimWhiteSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var trimNewLines: String {
        return self.trimmingCharacters(in: .newlines)
    }
    
    var trimWhiteSpacesAndNewLines: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var md5: String? {
        guard let messageData = self.data(using:.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
//    var encryptAES: String? {
//        let key = "mwLZH3hyy6jKR0AP"
//        let iv = "FWmn6Yu5KXPUKZrp"
//        do {
//            if let data = self.data(using: .utf8) {
//                let encrypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).encrypt([UInt8](data))
//                let encryptedString = Data(encrypted).base64EncodedString()
//                return encryptedString
//            }
//        } catch { }
//        return nil
//    }

//    var decryptAES: String? {
//        let key = "mwLZH3hyy6jKR0AP"
//        let iv = "FWmn6Yu5KXPUKZrp"
//        do {
//            if let data = Data(base64Encoded: self) {
//                let decrypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).decrypt([UInt8](data))
//                let decryptedString = String(bytes: Data(decrypted).bytes, encoding: .utf8)
//                return decryptedString
//            }
//        } catch { }
//        return nil
//    }
    
    var hasSpecialCharacters: Bool {
        let regex = "(?=.*[A-Za-z0-9]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isEmail: Bool {
        let regex = "^(([\\w+-]+\\.)+[\\w+-]+|([a-zA-Z+]{1}|[\\w+-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        if self.contains("-") || self.contains("*") || self.contains("+") {
            let precidate = NSPredicate(format: "SELF MATCHES %@", "^((\\+)|(00))[0-9]{6,14}$")
            return precidate.evaluate(with: self)
        }
        let precidate = NSPredicate(format: "SELF MATCHES %@", "([0-9]){10,11}$")
        return precidate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        if self.getBytesBy(encoding: SystemUtils.shiftJISEncoding) != self.count { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Za-z0-9]).{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    var isFullSizeCharacter: Bool {
        return getBytesBy(encoding: SystemUtils.shiftJISEncoding) == 2
    }

    // MARK: - Static functions
    static func randomStringWith(type: RandomStringType, length: Int) -> String {
        let letters: NSString = type.text as NSString
        let len = UInt32(letters.length)
        var randomString = ""
        (0..<length).forEach { _ in
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static func add(separator text: String = ",", to number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = text
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    // MARK: - Local functions
    func first(_ length: Int) -> String {
        return String(self.prefix(length))
    }
    
    func last(_ length: Int) -> String {
        return String(self.suffix(length))
    }
    
    func startIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func endIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString, options: .backwards) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func getBytesBy(encoding: String.Encoding) -> Int? {
        return data(using: encoding)?.count
    }
    
    func replace(string: String, with newString: String) -> String {
        return self.replacingOccurrences(of: string, with: newString)
    }
    
    func nsrangeOf(subString: String) -> NSRange? {
        if let range = self.range(of: subString) {
            return NSRange(range, in: self)
        }
        return nil
    }
    
    func numberBy(removing separator: String) -> Int {
        let seperatedArr = components(separatedBy: separator)
        var finalNumber = 0
        for (i, numStr) in seperatedArr.reversed().enumerated() {
            if let dNum = Int(numStr) {
                finalNumber += dNum * Int(pow(10, Double(i)))
            }
        }
        return finalNumber
    }
    
    func dateBy(format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }

    func textBoundsWith(width: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func textBoundsWith(height: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: CGFloat(CGFloat.greatestFiniteMagnitude), height: height),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func heightWith(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func widthWith(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
extension String {
   func maxLength(length: Int) -> String {
       var str = self
       let nsString = str as NSString
       if nsString.length >= length {
           str = nsString.substring(with:
               NSRange(
                location: 0,
                length: nsString.length > length ? length : nsString.length)
           ) + "..."
       }
       return  str
   }
}
