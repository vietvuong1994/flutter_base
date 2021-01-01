//
//  CreateNewPassVC.swift
//  DJCloud
//
//  Created by kien on 11/18/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class CreateNewPassVC: UIViewController {

    @IBOutlet weak var viewNewPass: InputTextField!
    @IBOutlet weak var viewConfirmNewPass: InputTextField!
    @IBOutlet weak var viewConfirm: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNewPass.placeHolder = "Mật khẩu mới"
        viewNewPass.leftImage = UIImage(named: "iconKey")
        viewConfirmNewPass.placeHolder = "Nhập lại mật khẩu mới"
        viewConfirmNewPass.leftImage = UIImage(named: "iconKey")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewConfirm.roundRectWith(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        viewConfirm.layoutIfNeeded()
        viewConfirm.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .leftToRight)
    }

    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
