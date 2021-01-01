//
//  DJNavigationCustomView.swift
//  DJCloud
//
//  Created by kien on 10/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DJNavigationCustomView: UIView {
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        self.setNeedsDisplay()
        self.roundRectWith(corners: [.bottomLeft, .bottomRight], radius: 20)
        self.layoutIfNeeded()
        self.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .topToBottom)
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

