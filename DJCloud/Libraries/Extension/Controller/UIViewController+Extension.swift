//
//  UIViewController+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import Foundation
import UIKit

protocol XibViewController {
    static var name: String { get }
    static func create() -> Self
}

extension XibViewController where Self: UIViewController {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func create() -> Self {
        return self.init(nibName: Self.name, bundle: nil)
    }
    
    static func present(from: UIViewController? = top(),
                        animated: Bool = true,
                        prepare: ((_ vc: Self) -> Void)? = nil,
                        completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        parentVC.present(targetVC, animated: animated, completion: completion)
    }
    
    static func present(from: UIViewController? = top(),
                        isFullScreen: Bool = false,
                           animated: Bool = true,
                           prepare: ((_ vc: Self) -> Void)? = nil,
                           completion: (() -> Void)? = nil) {
           guard let parentVC = from else { return }
           let targetVC = create()
            if( isFullScreen) {
                targetVC.modalPresentationStyle = .fullScreen
            }
           prepare?(targetVC)
           parentVC.present(targetVC, animated: animated, completion: completion)
       }
    
    static func push(from: UIViewController? = top(),
                     animated: Bool = true,
                     prepare: ((_ vc: Self) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        parentVC.navigationController?.pushViewController(targetVC, animated: animated)
        CATransaction.commit()
    }
}

extension UIViewController: XibViewController { }

extension UIViewController {
    
    var name: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    var isModal: Bool {
        if let navController = self.navigationController, navController.viewControllers.first != self {
            return false
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    var isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }

    class func top(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return top(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return top(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return top(controller: presented)
        }
        return controller
    }
    
    func dismissToRoot(controller: UIViewController? = UIViewController.top(),
                       animated: Bool = true,
                       completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        guard let getController = controller else {
            completion?(nil)
            return
        }
        if let prevVC = getController.presentingViewController {
            if prevVC.isModal && prevVC.presentingViewController != nil {
                dismissToRoot(controller: prevVC, animated: animated, completion: completion)
            } else {
                getController.dismiss(animated: animated, completion: {
                    completion?(prevVC)
                })
            }
        } else {
            completion?(getController)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func changeThemeToDrakMode(isDark: Bool) {
       if #available(iOS 13.0, *) {
            if isDark {
                overrideUserInterfaceStyle = .dark
            } else {
                overrideUserInterfaceStyle = .light
            }
        }
    }
    
    func showDialog(size: CGSize? = nil, ratio: CGFloat = 0.8, animated: Bool = false, completion: (() -> Void)? = nil) {
           guard let parentVC = UIViewController.top() else { return }
           var sizeFrame: CGSize
           if let size = size {
               sizeFrame = size
           } else {
               let sizeVC = self.view.bounds.size
               sizeFrame = CGSize(width: sizeVC.width * ratio, height: sizeVC.height * ratio)
           }
           let transitioningDelegate = ModalTransitioningDelegate(from: parentVC, to: self, sizeFrame, animated: animated)
           self.modalPresentationStyle = .custom
           self.transitioningDelegate = transitioningDelegate
           parentVC.present(self, animated: animated, completion: completion)
       }
}

class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    let size: CGSize
    let animated: Bool
    init(from presented: UIViewController, to presenting: UIViewController, _ size: CGSize, animated: Bool) {
        self.size = size
        self.animated = animated
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}

extension UIViewController {
    
    /// A Boolean value indicating whether the view controller is presented
    /// using Deck.
    var isPresentedWithDeck: Bool {
        return transitioningDelegate is DeckTransitioningDelegate
            && modalPresentationStyle == .custom
            && presentingViewController != nil
    }
    
}
