//
//  FilterCell.swift
//  HopAmNhanh
//
//  Created by kien on 6/29/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var separateView: UIView!
    
    func setupCell(image: String, title: String) {
        titleLabel.text = title

    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkImage.isHidden = true
    }
}
