//
//  TapActionView.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

class TapActionView: UIView {

    // MARK: - Closures
    var didTap: (() -> Void)?
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    // MARK: - Action
    @objc private func tapGestureAction(sender: UITapGestureRecognizer) {
        didTap?()
    }

}
