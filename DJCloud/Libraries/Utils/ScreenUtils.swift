//
//  ScreenUtils.swift
//  iOS Structure MVC
//
//  Created by kien on 2/28/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit

class ScreenUtils {
    static let screenBounds = UIScreen.main.bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenNativeBounds = UIScreen.main.nativeBounds
    static let screenNativeWidth = UIScreen.main.nativeBounds.width
    static let screenNativeHeight = UIScreen.main.nativeBounds.height
    
    static let iphone3point5InchesHeight: CGFloat = 480 // iphone 4s and below
    static let iphone4InchesHeight: CGFloat = 568 // iphone 4s -> iphone 5s || iphone SE
    static let iphone4point7InchesHeight: CGFloat = 667 // iphone 6 & 7 & 8
    static let iphone5point5InchesHeight: CGFloat = 736 // iphone 6+ & 7+ & 8+
    static let iphone5point8InchesHeight: CGFloat = 812 // iphone X
    static let iphone6point5InchesHeight: CGFloat = 896 // iphone XS Max
    
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    static var safeAreaInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return .zero }
            return window.safeAreaInsets
        }
        return .zero
    }
    
    static var safeAreaInsetTop: CGFloat {
        return ScreenUtils.safeAreaInset.top
    }
    
    static var safeAreaInsetBottom: CGFloat {
        return ScreenUtils.safeAreaInset.bottom
    }
}
