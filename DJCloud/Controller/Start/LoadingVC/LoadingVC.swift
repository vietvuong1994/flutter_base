//
//  LoadingVC.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

class LoadingVC: BaseVC {

    @IBOutlet weak var imageLoad: UIImageView!
    
    // MARK: - Constraints
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Closures
    
    // MARK: - Init & deinit
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        changeRootToMain()
    }
    
    private func changeRootToMain() {
        if let _ = SharedData.accessToken {
            GetUserInfoAPI.init().set(silentLoad: true).execute(target: self) { (response) in
                AppDelegate.shared?.user = response.user
                GeneralUtils.sleep(2) {
                    let mainVC = MainTabVC()
                    SystemBoots.instance.changeRoot(rootController: mainVC)
                }
            } failure: { (error) in
                UIAlertController.showSystemAlert(target: self, message: error.message, buttons: ["Thử lại", "Hủy"]) { (index, str) in
                    if index == 0 {
                        self.changeRootToMain()
                    }
                }
            }
        } else {
            LoginUserGuestAPI.init().execute(target: self) { (response) in
                SharedData.firstRunApp = true
                let mainVC = MainTabVC()
                SystemBoots.instance.changeRoot(rootController: mainVC)
            } failure: { (_) in
                
            }
        }
    }
    

    // MARK: - Data management
    
    // MARK: - Action
    
    // MARK: - Update UI
    
    // MARK: - Supporting methods

}
