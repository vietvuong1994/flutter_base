//
//  PersonalVC.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class PersonalVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let header = HeaderPersonal()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInset.top = -ScreenUtils.safeAreaInsetTop
        scrollView.parallaxHeader.view = header
        scrollView.parallaxHeader.height = 350
        scrollView.parallaxHeader.mode = .bottomFill
        setData()
    }
    
    private func setData() {
        if let image = AppDelegate.shared?.user?.imgAvatar {
            header.imgAvatar.image = image
        } else {
            header.imgAvatar.image = UIImage(named: "default_avatar")
        }
        header.lbTitle.text = SharedData.userNameDisplay
        header.lbSubTile.text = SharedData.userName
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.imageThumbHeader.roundRectWith(corners: [.bottomLeft, .bottomRight], radius: 20)
        header.imageThumbHeader.layoutIfNeeded()
        header.layoutIfNeeded()
    }
    
    @IBAction func actionChangeInfoUser(_ sender: Any) {
        ArtistDetailVC.push()
    }
    
    @IBAction func actionOtherSetting(_ sender: Any) {
        SettingVC.push()
    }
    
    @IBAction func actionEditAvatar(_ sender: Any) {
        let vc = InsertImagePopUpVC()
        CameraPhotoService.instance.allowCrop = false
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false) {
            vc.imagePass = {[weak self] image in
                guard let `self` = self else { return }
                self.header.imgAvatar.image = image.image
                AppDelegate.shared?.user?.imgAvatar = image.image
                NotificationCenter.default.post(name: NSNotification.Name.init("UpdateAvatar"), object: nil, userInfo: nil)
//                self.imageInfo = image
//                self.imgThum.image = image.image
            }
        }
    }
    
    @IBAction func actionEditThumbnail(_ sender: Any) {
        let vc = InsertImagePopUpVC()
        CameraPhotoService.instance.allowCrop = false
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false) {
            vc.imagePass = {[weak self] image in
                guard let `self` = self else { return }
                self.header.imageThumbHeader.image = image.image
            }
        }
    }
    
    
    
    @IBAction func actionLogout(_ sender: Any) {
        let alert = UIAlertController(title: "Xác nhận!", message: "Bạn có chắc chắn muốn đăng xuất không?", preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionOk = UIAlertAction(title: "OK", style: .default) { (_) in
            LogoutAPI.init().execute(target: self) { (response) in
                self.changeMainToLogin()
            } failure: { (error) in
                
            }
        }
        alert.addAction(actionCancel)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changeMainToLogin() {
        let mainVC = BaseNavigationVC(rootViewController: LoginVC())
        SystemBoots.instance.changeRoot(rootController: mainVC)
    }
}
