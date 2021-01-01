//
//  LinkAccountVC.swift
//  DJCloud
//
//  Created by kien on 11/25/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class LinkAccountVC: UIViewController {

    @IBOutlet weak var viewUserName: InputTextField!
    @IBOutlet weak var viewPassword: InputTextField!
    @IBOutlet weak var viewEmail: InputTextField!
    @IBOutlet weak var viewLinkBottom: UIView!
    
    var didCreateAccount: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUserName.placeHolder = "Tên tài khoản"
        viewUserName.leftImage = UIImage(named: "iconUserName")
        viewPassword.placeHolder = "Mật khẩu"
        viewPassword.leftImage = UIImage(named: "iconKey")
        viewEmail.placeHolder = "Địa chỉ email"
        viewEmail.leftImage = UIImage(named: "iconEmail")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewLinkBottom.roundRectWith(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        viewLinkBottom.layoutIfNeeded()
        viewLinkBottom.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .leftToRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.white.alpha(0.2)
    }


    @IBAction func actionLinkAccountNormal(_ sender: Any) {
        guard let userName = viewUserName.text?.trimWhiteSpaces, !userName.isEmpty else {
            UIAlertController.showSystemAlert(target: self, title: "Tên tài khoản", message: "Tên tài khoản không được để trống", buttons: ["Đóng"], handler: nil)
            viewUserName.isError = true
            return
        }
        guard let email = viewEmail.text, email.isEmail else {
            UIAlertController.showSystemAlert(target: self, title: "Email", message: "Email không hợp lệ", buttons: ["Đóng"], handler: nil)
            viewEmail.isError = true
            return
        }
        guard let password = viewPassword.text, !password.isEmpty, password.count >= 8 else {
            viewPassword.isError = true
            UIAlertController.showSystemAlert(target: self, title: "Mật khẩu", message: "Yêu cầu nhập mật khẩu trên 8 kí tự", buttons: ["Đóng"], handler: nil)
            return
        }
        ConnectGuestToUserAPI.init(userName: userName, password: password, email: email).execute(target: self) {[weak self] (response) in
            DispatchQueue.main.async {
                self?.didCreateAccount?()
                self?.dismiss(animated: true, completion: nil)
            }
        } failure: { (error) in
            
        }
    }
    
    @IBAction func actionClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
