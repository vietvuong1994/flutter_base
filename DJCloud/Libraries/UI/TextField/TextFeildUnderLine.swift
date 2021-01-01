//
//  TextFeildUnderLine.swift
//  MonNgon
//
//  Created by kien on 4/12/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TextFeildUnderLine: UITextField {
    // MARK: - Inspectable
    @IBInspectable var lineColor: UIColor = UIColor.clear
    @IBInspectable var lineHeight: CGFloat = 0.5
    @IBInspectable var colorBorder: UIColor = UIColor.clear
    @IBInspectable var insetTop: CGFloat = 0
    @IBInspectable var insetLeft: CGFloat = 10
    @IBInspectable var insetBottom: CGFloat = 0
    @IBInspectable var insetRight: CGFloat = 10
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            if let image = rightImage {
                modifyClearButton(with: image)
            }
        }
    }
    
    override func didMoveToSuperview() {
        
    }
    
    func modifyClearButton(with image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(TextFeildUnderLine.clear(_:)), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .always
    }
    
    @objc func clear(_ sender : AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }

    override func draw(_ rect: CGRect) {
        let border = CALayer()
        let width = lineHeight
        border.borderColor = lineColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        
    }
    
    
    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight)
    }
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
