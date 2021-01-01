//
//  UIFont+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

extension UIFont {
    // Name of font will be defined according to project
    static func normal(size: CGFloat) -> UIFont {
        return UIFont(name: "YuGothic-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    // Name of font will be defined according to project
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "YuGothic-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
