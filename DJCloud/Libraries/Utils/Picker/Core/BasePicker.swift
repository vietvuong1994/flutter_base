//
//  BasePicker.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

class BasePicker: UIViewController {
    
    // MARK: - Closures
    var configBeforeShow: (() -> Void)?
    var configBeforeHide: (() -> Void)?
    var configWhenShow: (() -> Void)?
    var configWhenHide: (() -> Void)?
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action
    func showWithAnimation(completion: (() -> Void)? = nil) {
        view.layoutIfNeeded()
        configBeforeShow?()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.configWhenShow?()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    func hideWithAnimation(completion: (() -> Void)? = nil) {
        view.layoutIfNeeded()
        configBeforeHide?()
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.configWhenHide?()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
}
