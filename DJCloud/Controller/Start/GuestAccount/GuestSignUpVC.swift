//
//  ResetPassVC.swift
//  DJCloud
//
//  Created by kien on 11/18/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class GuestSignUpVC: UIViewController {
    
    @IBOutlet weak var viewNameDisplay: InputTextField!
    @IBOutlet weak var viewSigupGuest: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNameDisplay.placeHolder = "Tên hiển thị"
        viewNameDisplay.leftImage = UIImage(named: "iconUserName")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewSigupGuest.roundRectWith(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        viewSigupGuest.layoutIfNeeded()
        viewSigupGuest.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .leftToRight)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }

    @IBAction func actionCreateNewPass(_ sender: Any) {
        guard let name = viewNameDisplay.text else {
            UIAlertController.showSystemAlert(target: self, message: "Cần nhập tên hiển thị", buttons: ["Ok"], handler: nil)
            return
        }
    }
}
