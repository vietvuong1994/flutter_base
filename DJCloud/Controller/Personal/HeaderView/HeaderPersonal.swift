//
//  HeaderListSongView.swift
//  HopAmNhanh
//
//  Created by kien on 8/5/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

class HeaderPersonal: CustomNibView {
    
    @IBOutlet weak var imageThumbHeader: UIImageView!
    @IBOutlet weak var imgAvatar: CircularImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTile: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageThumbHeader.roundRectWith(corners: [.bottomLeft, .bottomRight], radius: 20)
        imageThumbHeader.layoutIfNeeded()
    }
}
