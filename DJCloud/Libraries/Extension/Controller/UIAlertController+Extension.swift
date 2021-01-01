//
//  UIAlertController+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import Foundation
import UIKit

typealias SystemAlertButtonData = (title: String, style: UIAlertAction.Style, handler: (() -> Void)?)

// Extension for system alert view
extension UIAlertController {
    static func showQuickSystemAlert(target: UIViewController? = UIViewController.top(),
                                     title: String? = nil,
                                     message: String? = nil,
                                     cancelButtonTitle: String = "Ok",
                                     handler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            handler?()
        }))
        target?.present(alertVC, animated: true)
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.top(),
                                title: String? = nil,
                                message: String? = nil,
                                buttons: [String],
                                handler: ((_ index: Int, _ title: String) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                handler?(button.offset, button.element)
            })
            alert.addAction(action)
        }
        target?.present(alert, animated: true)
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.top(),
                                title: String? = nil,
                                message: String? = nil,
                                buttons: [SystemAlertButtonData]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach { button in
            let action = UIAlertAction(title: button.title, style: button.style, handler: { _ in
                button.handler?()
            })
            alert.addAction(action)
        }
        target?.present(alert, animated: true)
    }
    
    static func showSystemActionSheet(target: UIViewController? = UIViewController.top(),
                                      title: String? = nil,
                                      message: String? = nil,
                                      optionButtons: [SystemAlertButtonData],
                                      cancelButton: SystemAlertButtonData) {
        let viewBG = UIView(frame: UIScreen.main.bounds)
        let backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        optionButtons.forEach { (button) in
            alert.addAction(UIAlertAction(title: button.title, style: button.style, handler: { (_) in
                viewBG.removeFromSuperview()
                button.handler?()
            }))
        }
        let cancelAction = UIAlertAction(title: cancelButton.title, style: UIAlertAction.Style.cancel, handler: { (_) in
            viewBG.removeFromSuperview()
            cancelButton.handler?()
        })
        alert.addAction(cancelAction)
        viewBG.backgroundColor = backgroundColor
        target?.view.addSubview(viewBG)
        target?.present(alert, animated: true)
    }
}
extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
