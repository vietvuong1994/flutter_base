//
//  CircularImageView.swift
//  DJCloud
//
//  Created by kien on 10/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}
