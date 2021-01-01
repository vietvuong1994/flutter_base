//
//  UIApplication+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

extension UIApplication {

    var statusBar: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
    
    static func setStatusBar(backgroundColor: UIColor, tintColor: UIColor) {
        guard let statusBar = UIApplication.shared.statusBar else { return }
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = backgroundColor
            statusBar.tintColor = tintColor
        }
    }
    
    static func setStatusBar(backgroundImage: UIImage?, tintColor: UIColor) {
        guard let statusBar = UIApplication.shared.statusBar else { return }
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            let imageView = UIImageView(image: backgroundImage)
            statusBar.tintColor = tintColor
            statusBar.addSubview(imageView)
            imageView.layer.zPosition = -10000
            imageView.fitTo(superView: statusBar)
        }
    }
}

