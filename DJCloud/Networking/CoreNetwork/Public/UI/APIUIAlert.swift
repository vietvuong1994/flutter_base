//
//  APIUIAlert.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

// MARK: - Init list of dialogs
class APIUIAlert {
    static func apiErrorDialog(error: APIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
    
    static func requestErrorDialog(error: APIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
    
    static func offlineErrorDialog(completion: @escaping ((_ index: Int, _ tapRetry: Bool) -> Void)) -> UIAlertController {
        let title = "error_connect".localized
        let message = "no_internet".localized
        let buttons = ["retry".localized, "close".localized]
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                completion(button.offset, button.offset == 0)
            })
            alertVC.addAction(action)
        }
        return alertVC
    }
    
    static func apiErrorUserDialog(errorMess: String?, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: "tittle_mess".localized, message: errorMess, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
}

// MARK: - Presenting functions
extension APIUIAlert {
    static func showApiErrorDialogWith(error: APIError, completion: @escaping (() -> Void)) {
        let alert = APIUIAlert.apiErrorDialog(error: error, completion: completion)
        UIViewController.top()?.present(alert, animated: true)
    }
    
    static func showRequestErrorDialogWith(error: APIError, completion: @escaping (() -> Void)) {
        let alert = APIUIAlert.requestErrorDialog(error: error, completion: completion)
        UIViewController.top()?.present(alert, animated: true)
    }
    
    static func showOfflineErrorDialog(completion: @escaping ((_ index: Int, _ tapRetry: Bool) -> Void)) {
        let alert = APIUIAlert.offlineErrorDialog(completion: completion)
        UIViewController.top()?.present(alert, animated: true)
    }
    
    static func showErrorUserDialog(errorMes: String?, completion: @escaping (() -> Void)) {
           let alert = APIUIAlert.apiErrorUserDialog(errorMess: errorMes, completion: completion)
           UIViewController.top()?.present(alert, animated: true)
    }
}
