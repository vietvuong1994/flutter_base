//
//  ResetPassVC.swift
//  DJCloud
//
//  Created by kien on 11/18/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class ResetPassVC: UIViewController {
    
    @IBOutlet weak var viewEmail: InputTextField!
    @IBOutlet weak var viewResetPass: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEmail.placeHolder = "Địa chỉ email"
        viewEmail.leftImage = UIImage(named: "iconEmail")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewResetPass.roundRectWith(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        viewResetPass.layoutIfNeeded()
        viewResetPass.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .leftToRight)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }

    @IBAction func actionCreateNewPass(_ sender: Any) {
        CreateNewPassVC.push()
    }
}
