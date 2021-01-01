//
//  UIView+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

protocol XibView {
    static var name: String { get }
    static func createFromXib() -> Self
}

extension XibView where Self: UIView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func createFromXib() -> Self {
        return Self.init()
    }
}

extension UIView: XibView { }

// MARK: - Extension for Inspectable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            clipsToBounds = true
            layer.cornerRadius = value
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }@objc 
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(value) {
            layer.shadowColor = value.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set(value) {
            layer.masksToBounds = value
        }
    }
}

// MARK: - Extension for all
extension UIView {
    // MARK: - Variables
    var name: String {
        return type(of: self).name
    }
    
    var subviewsRecursive: [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive }
    }
    
    var parentViewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.parentViewController
        } else {
            return nil
        }
    }
    
    var globalPointWithEntireScreen: CGPoint? {
        return superview?.convert(frame.origin, to: nil)
    }
    
    var globalFrameWithEntireScreen: CGRect? {
        return superview?.convert(frame, to: nil)
    }

    // MARK: - Local functions
    func set(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func set(borderWidth: CGFloat, withColor color: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    func set(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        set(cornerRadius: cornerRadius)
        set(borderWidth: borderWidth, withColor: borderColor)
    }
    
    func setShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, gradientDirection: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = gradientDirection.draw().x
        gradientLayer.endPoint = gradientDirection.draw().y
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundRectWith(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
}

// Extension for cutting & masking layers
extension UIView {
    func cut(rect: CGRect) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addRect(rect)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = s
    }
    
    func cut(path: CGPath) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addPath(path)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        layer.mask = s
    }
}

// Extension for autolayout
extension UIView {
    static let maxPriority: UILayoutPriority = UILayoutPriority(999)
    static let minPriority: UILayoutPriority = UILayoutPriority(1)
    
    @discardableResult
    func centerTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .centerX),
            getEqualConstraintTo(superView: superView, attribute: .centerY)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func fitTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .top),
            getEqualConstraintTo(superView: superView, attribute: .left),
            getEqualConstraintTo(superView: superView, attribute: .right),
            getEqualConstraintTo(superView: superView, attribute: .bottom)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func sameSizeTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .width),
            getEqualConstraintTo(superView: superView, attribute: .height)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func sameWidthTo(superView: UIView) -> NSLayoutConstraint {
        let constraint = getEqualConstraintTo(superView:superView, attribute: .width)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func sameHeightTo(superView: UIView) -> NSLayoutConstraint {
        let constraint = getEqualConstraintTo(superView:superView, attribute: .height)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func setRatioWith(multiplier: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = getRatioConstraintWith(multiplier: multiplier)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    func getEqualConstraintTo(superView: UIView,
                              attribute: NSLayoutConstraint.Attribute,
                              constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        return constraint
    }
    
    func getFixedConstraintWith(attribute: NSLayoutConstraint.Attribute,
                                value: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: value)
        return constraint
    }
    
    func getRelatedConstraintTo(superView: UIView,
                                attribute: NSLayoutConstraint.Attribute,
                                relatedBy: NSLayoutConstraint.Relation,
                                constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: relatedBy,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        return constraint
    }
    
    func getRatioConstraintWith(multiplier: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: 0)
        return constraint
    }
    
    var isViewEnable: Bool {
        get {
            return isUserInteractionEnabled
        } set(value) {
            if value {
                self.alpha = 1
            } else {
                self.alpha = 0.4
            }
            isUserInteractionEnabled = value
        }
    }
    
    @IBInspectable var halfRadius: Bool {
        get {
            setNeedsDisplay()
            return layer.cornerRadius == frame.size.height/2
        }
        
        set {
            if newValue {
                clipsToBounds = true
                layer.cornerRadius = frame.size.height/2
                setNeedsDisplay()
            } else {
                layer.cornerRadius = cornerRadius
                setNeedsDisplay()
            }
        }
    }
    
    func addBlurView() {
        self.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
