//
//  MainTabVC.swift
//  HopAmNhanh
//
//  Created by kien on 6/29/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController {
    
    fileprivate var homeVC = HomeVC()
    fileprivate var librayVC = LibraryVC()
    fileprivate var notificationVC = NotificationVC()
    fileprivate var personalVC = PersonalVC()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.white
            tabBar.standardAppearance = appearance
        } else {
            UITabBar.appearance().backgroundColor = UIColor.white
            tabBar.backgroundImage = UIImage()   //Clear background
        }
        NotificationCenter.default.addObserver(self, selector: #selector(openPersonalTab), name: NSNotification.Name.init("OpenPersonalTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLinkAccount), name: NotifiNameCenter.ShowLinkAccount, object: nil)
       let navigationHomeVC = BaseNavigationVC(rootViewController: homeVC)
        navigationHomeVC.tabBarItem = UITabBarItem(title: "Trang chủ", image: UIImage(named: "iconHome"), selectedImage: UIImage(named: "iconHome"))
        
           let navigationLibrayVC = BaseNavigationVC(rootViewController: librayVC)
       navigationLibrayVC.tabBarItem = UITabBarItem(title: "Theo dõi", image: UIImage(named: "iconFavorite"), selectedImage: UIImage(named: "iconFavorite"))
        
        let navigationNotificationVC = BaseNavigationVC(rootViewController: notificationVC)
        navigationNotificationVC.tabBarItem = UITabBarItem(title: "Thông báo", image: UIImage(named: "iconNotification"), selectedImage: UIImage(named: "iconNotification"))
        
       let navigationPersonalVC = BaseNavigationVC(rootViewController: personalVC)
       navigationPersonalVC.tabBarItem = UITabBarItem(title: "Cá nhân", image: UIImage(named: "iconUser"), selectedImage: UIImage(named: "iconUser"))
        
       self.viewControllers = [navigationHomeVC, navigationPersonalVC]
    }
    
    @objc private func showLinkAccount() {
//        self.selectedIndex = 3
        self.selectedIndex = 1
        GeneralUtils.sleep(1) {
            self.personalVC.navigationController?.pushViewController(SettingVC.create(), animated: true)
        }
    }
    
    @objc private func openPersonalTab() {
        self.selectedIndex = 1
    }
    
}
