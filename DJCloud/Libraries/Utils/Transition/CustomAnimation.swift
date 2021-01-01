//
//  CustomAnimation.swift
//  HopAmNhanh
//
//  Created by kien on 6/29/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class CustomAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: TimeInterval
    private var isPresenting: Bool
    
    init(duration: TimeInterval, isPresenting: Bool) {
        self.duration = duration
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let targetView = isPresenting ? toView : fromView
        
        toView.frame = isPresenting ? CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        toView.layoutIfNeeded()
        
        if isPresenting {
            UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                targetView.frame = fromView.frame
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                targetView.frame = CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
