//
//  TintColorButton.swift
//  HopAmNhanh
//
//  Created by kien on 7/12/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class TintColorButton: UIButton {
    // MARK: - IBInspectable
    @IBInspectable var tintImageColor: UIColor? {
        didSet {
            if let color = tintImageColor {
                self.imageView?.set(color: color)
                self.setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        if let color = tintImageColor {
            self.imageView?.set(color: color)
            self.setNeedsDisplay()
        }
    }
}
