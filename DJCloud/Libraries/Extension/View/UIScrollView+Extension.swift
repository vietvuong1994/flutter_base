//
//  UIScrollView+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToVeryBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.height + contentInset.bottom)
        if bottomOffset.y > contentOffset.y {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    func isCanScroll() -> Bool {
        let totalHeight = self.contentSize.height
        return totalHeight > self.frame.size.height
    }
}
