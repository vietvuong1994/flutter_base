//
//  BaseVC.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    // MARK: - Init & deinit
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("▶︎ [Screen - \(self.name)] deinit !")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        baseConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed || isMovingFromParent {
            // Detect current controller is being dismissed
            handleWhenViewIsBeingDismissedOrPopped()
        }
    }


    // MARK: - Setup
    private func baseConfig() {
        edgesForExtendedLayout = []
    }
    
    // MARK: - Action
    private func handleWhenViewIsBeingDismissedOrPopped() {
        
    }
}
