//
//  HeaderListSongView.swift
//  HopAmNhanh
//
//  Created by kien on 8/5/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

class HeaderSongDisplaySongView: CustomNibView {
    
    @IBOutlet weak var imgImageHeader: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewBlure: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var viewPlay: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewPlay.roundRectWith(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        viewPlay.layoutIfNeeded()
        viewPlay.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .leftToRight)
    }
}
