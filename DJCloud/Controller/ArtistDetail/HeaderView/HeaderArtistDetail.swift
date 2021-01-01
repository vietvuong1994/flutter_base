//
//  HeaderListSongView.swift
//  HopAmNhanh
//
//  Created by kien on 8/5/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

class HeaderArtistDetail: CustomNibView {
    
    @IBOutlet weak var imageThumbHeader: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageThumbHeader.roundRectWith(corners: [.bottomLeft, .bottomRight], radius: 20)
        imageThumbHeader.layoutIfNeeded()
    }
}
