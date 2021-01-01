//
//  CustomInteractor.swift
//  HopAmNhanh
//
//  Created by kien on 6/29/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class CustomInteractor: UIPercentDrivenInteractiveTransition {

    weak var navigationController : UINavigationController?
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    init?(attachTo viewController: UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            setupBackPanGestureFor(view: viewController.view)
        } else { return nil }
    }
    
    private func setupBackPanGestureFor(view: UIView) {
        for gesture in (view.gestureRecognizers ?? []).map({ $0 as? UIPanGestureRecognizer }).filter({ $0?.maximumNumberOfTouches == 100 }) {
            if let panGesture = gesture {
                view.removeGestureRecognizer(panGesture)
            }
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(backPanGestureAction(gesture:)))
        panGesture.maximumNumberOfTouches = 100
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func backPanGestureAction(gesture: UIPanGestureRecognizer) {
        guard let navigationController = self.navigationController else { return }
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.x / navigationController.view.frame.width
        
        switch gesture.state {
        case .began:
            transitionInProgress = true
            navigationController.topViewController?.view.endEditing(true)
            navigationController.popViewController(animated: true)
            break
        case .changed:
            shouldCompleteTransition = progress > 0.3
            update(progress)
            break
        case .cancelled:
            transitionInProgress = false
            cancel()
            break
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
        default:
            return
        }
    }
}
