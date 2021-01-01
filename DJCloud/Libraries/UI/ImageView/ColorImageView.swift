//
//  ColorImageView.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

@IBDesignable class ColorImageView: UIImageView {

    // MARK: - Inspectable
    @IBInspectable var color: UIColor = .white
    
    // MARK: - UI
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        image = image?.template
        tintColor = color
    }
}
