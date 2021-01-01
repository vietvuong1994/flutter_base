//
//  AssetsColor.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

enum AssetsColor {
   case ColorTintApp
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .ColorTintApp:
            return UIColor(named: "ColorTintApp")
        }
    }
}
