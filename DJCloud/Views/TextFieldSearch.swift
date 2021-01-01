//
//  TextFieldSearch.swift
//  DJCloud
//
//  Created by kien on 9/14/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TextFieldSearch: InsetTextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var isShowClear: Bool = false
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            if let image = rightImage, isShowClear {
                modifyClearButton(with: image)
            }
        }
    }
    
    func modifyClearButton(with image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(TextFeildUnderLine.clear(_:)), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .always
    }
    
    @objc func clear(_ sender : AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    var padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 5)
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
