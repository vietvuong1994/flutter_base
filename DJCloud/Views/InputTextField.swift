//
//  InputTextField.swift
//  DJCloud
//
//  Created by kien on 11/17/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

class InputTextField: CustomNibView {
    
    @IBOutlet weak var lbPlaceHolder: UILabel!
    @IBOutlet weak var tfContent: DesignableUITextField!
    
    @IBOutlet weak var constraintLeadingNoEdit: NSLayoutConstraint!
    @IBOutlet weak var constraintCenterNoEdit: NSLayoutConstraint!
    @IBOutlet weak var constraintTopEdit: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingEdit: NSLayoutConstraint!
    
    var isError: Bool = false {
        didSet {
            if (isError) {
                tfContent.borderColor = UIColor.red
            }
        }
    }
    
    var leftImage: UIImage? {
        didSet {
            tfContent.leftImage = leftImage
        }
    }
    
    var text: String? {
        return tfContent.text
    }
    
    var placeHolder: String? {
        didSet {
            self.lbPlaceHolder.text = placeHolder
        }
    }
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        tfContent.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
        tfContent.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
    }
    
    @objc private func textFieldDidBegin() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.constraintLeadingNoEdit.priority = .defaultLow
            self.constraintCenterNoEdit.priority = .defaultLow
            self.constraintTopEdit.priority = .defaultHigh
            self.constraintLeadingEdit.priority = .defaultHigh
        }, completion: { _ in
            
        })
    }
    
    @objc private func textFieldDidEnd() {
        if let text = tfContent.text, !text.isEmpty {
            return
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.constraintLeadingNoEdit.priority = .defaultHigh
                self.constraintCenterNoEdit.priority = .defaultHigh
                self.constraintTopEdit.priority = .defaultLow
                self.constraintLeadingEdit.priority = .defaultLow
            }, completion: { _ in
                
            })
        }
    }
}
