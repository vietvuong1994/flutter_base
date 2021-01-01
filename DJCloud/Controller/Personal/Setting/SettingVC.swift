//
//  SettingVC.swift
//  DJCloud
//
//  Created by kien on 11/18/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import AuthenticationServices
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class SettingVC: UIViewController {
    
    @IBOutlet weak var lbTitleNormalAccount: UILabel!
    @IBOutlet weak var lbLinkedNormalAccount: UILabel!
    @IBOutlet weak var lbUserNameNormalAccount: UILabel!
    @IBOutlet weak var lbLinkedFacebookAccount: UILabel!
    @IBOutlet weak var lbLinkedGoogleAccount: UILabel!
    @IBOutlet weak var lbLinkedAppleAccount: UILabel!
    @IBOutlet weak var btnLinkedFacebook: UIButton!
    @IBOutlet weak var btnLinkedGoogle: UIButton!
    @IBOutlet weak var btnLinkedApple: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        updateDateUI()
    }
    
    private func updateDateUI() {
        if let isGuestAccount = AppDelegate.shared?.user?.isGuest {
            lbLinkedNormalAccount.isHidden = !isGuestAccount
            if let userName = AppDelegate.shared?.user?.userName {
                lbTitleNormalAccount.text = "Tài khoản: \(userName.maxLength(length: 5))"
            }
        }
        if let social = AppDelegate.shared?.user?.social {
            social.forEach { (type) in
                switch type {
                case .facebook:
                    lbLinkedFacebookAccount.isHidden = false
                    btnLinkedFacebook.isEnabled = false
                case .google:
                    lbLinkedGoogleAccount.isHidden = false
                    btnLinkedGoogle.isEnabled = false
                case .apple:
                    lbLinkedAppleAccount.isHidden = false
                    btnLinkedApple.isEnabled = false
                }
            }
        }
    }
    
    private func callConnectSocial(type: SocialType, token: String) {
        ConnectSocialAPI.init(socialType: type, token: token).execute(target: self) { (response) in
            if let user = response.user {
                AppDelegate.shared?.user = user
                SharedData.userName = user.userName
                SharedData.userNameDisplay = user.name
                SharedData.avatarUser = user.avatar
                self.updateDateUI()
            }
        } failure: { (error) in
            
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    
    @IBAction func actionLinkNormalAccount(_ sender: Any) {
        LinkAccountVC.present(from: self, isFullScreen: true, animated: true) { (vc) in
            vc.didCreateAccount = {[weak self] in
                self?.updateDateUI()
            }
        } completion: {
            
        }
        
    }
    
    @IBAction func actionLinkFacebookAccount(_ sender: Any) {
        loginFacebook()
    }
    
    @IBAction func actionLinkGoogleAccount(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func actionLinkAppleAccount(_ sender: Any) {
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
}
extension SettingVC: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
            if let dataToken = appleIDCredential.identityToken, let token =  String(data: dataToken, encoding: .utf8) {
                self.callConnectSocial(type: .apple, token: token)
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
// Login With Facebook
extension SettingVC {
    
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
                    self.callConnectSocial(type: .facebook, token: token)
                }
            })
        } else {
            UIAlertController.showSystemAlert(target: self, message: "Đã có lỗi xảy ra, vui lòng thử lại sau!", buttons: ["Ok"], handler: nil)
        }
    }
}

extension SettingVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        if let token = user.authentication.accessToken {
            self.callConnectSocial(type: .google, token: token)
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
