//
//  CustomCheckView.swift
//  DJCloud
//
//  Created by kien on 9/14/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomCheckView: RoundedView {
    
    var didTouchInSide: (()->Void)?
        
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction(sender:)))
        self.addGestureRecognizer(gesture)

    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.alpha = 1
        didTouchInSide?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.alpha = 0.6
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.alpha = 1
    }
    
    func setIsEnable(isEnable: Bool) {
        self.isUserInteractionEnabled = isEnable
        self.alpha = isEnable ? 1 : 0.5
    }
}

