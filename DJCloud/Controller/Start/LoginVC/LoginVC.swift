//
//  LoginVC.swift
//  DJCloud
//
//  Created by kien on 11/17/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import AuthenticationServices
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var viewUserName: InputTextField!
    @IBOutlet weak var viewPassword: InputTextField!
    @IBOutlet weak var viewLogin: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        viewUserName.placeHolder = "Tên tài khoản"
        viewUserName.leftImage = UIImage(named: "iconUserName")
        viewPassword.placeHolder = "Mật khẩu"
        viewPassword.leftImage = UIImage(named: "iconKey")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewLogin.roundRectWith(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        viewLogin.layoutIfNeeded()
        viewLogin.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .leftToRight)
    }
    
    private func changeRootToMain() {
        let mainVC = MainTabVC()
        SystemBoots.instance.changeRoot(rootController: mainVC)
    }
    
    private func callLoginSocial(type: SocialType, token: String) {
        LoginWithSocialAPI.init(socialType: type, token: token).execute(target: self) { (response) in
            if let user = response.user {
                AppDelegate.shared?.user = user
                SharedData.userName = user.userName
                SharedData.userNameDisplay = user.name
                SharedData.avatarUser = user.avatar
                self.changeRootToMain()
            }
        } failure: { (error) in
            
        }
    }

    
    @IBAction func actionLogIn(_ sender: Any) {
        guard let userName = viewUserName.text?.trimWhiteSpaces, !userName.isEmpty else {
            UIAlertController.showSystemAlert(target: self, title: "Tên tài khoản", message: "Tên tài khoản không được để trống", buttons: ["Đóng"], handler: nil)
            viewUserName.isError = true
            return
        }
        guard let password = viewPassword.text, !password.isEmpty, password.count >= 8 else {
            viewPassword.isError = true
            UIAlertController.showSystemAlert(target: self, title: "Mật khẩu", message: "Yêu cầu nhập mật khẩu trên 8 kí tự", buttons: ["Đóng"], handler: nil)
            return
        }
        SigInAPI.init(userName: userName, password: password).execute(target: self) { (response) in
            self.changeRootToMain()
        } failure: { (error) in
            
        }
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        RegisterVC.push()
    }
    
    @IBAction func actionResetPass(_ sender: Any) {
        ResetPassVC.push()
    }
    
    @IBAction func actionLoginWithAppleId(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func actionLoginWithFacebook(_ sender: Any) {
        loginFacebook()
    }
    
    @IBAction func actionLoginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func actionLoginWithGuest(_ sender: Any) {
        GuestSignUpVC.push()
    }
    
}
extension LoginVC: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
//        let userIdentifier = appleIDCredential.user
            if let dataToken = appleIDCredential.identityToken, let token =  String(data: dataToken, encoding: .utf8) {
                self.callLoginSocial(type: .apple, token: token)
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
}
// Login With Facebook
extension LoginVC {
    
    private func loginFacebook() {
        if let _ = AccessToken.current {
            getDataFB()
            return
        }
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if let _ = error {
                // Do nothing
            } else if let result = result {
                let _: LoginManagerLoginResult = result
                self.getDataFB()
            }
        }
    }
    
    private func getDataFB() {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,first_name, last_name,birthday"]).start(completionHandler: { (connect, result, erro) in
                if let _ = erro {
                    // TO DO Nothing
                } else if let token = AccessToken.current?.tokenString {
                    self.callLoginSocial(type: .facebook, token: token)
                }
            })
        } else {
            UIAlertController.showSystemAlert(target: self, message: "Đã có lỗi xảy ra, vui lòng thử lại sau!", buttons: ["Ok"], handler: nil)
        }
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if let token = user.authentication.accessToken {
            self.callLoginSocial(type: .google, token: token)
        }
    }
    // Start Google OAuth2 Authentication
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        
        // Showing OAuth2 authentication window
        if let aController = viewController {
            present(aController, animated: true) {() -> Void in }
        }
    }
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        // Close OAuth2 authentication window
        print("Close OAuth2 authentication window")
        dismiss(animated: true) {() -> Void in }
    }
}
