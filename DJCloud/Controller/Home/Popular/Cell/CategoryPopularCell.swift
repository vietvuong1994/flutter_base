//
//  CategoryPopularCell.swift
//  DJCloud
//
//  Created by kien on 10/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class CategoryPopularCell: UICollectionViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(item: Genre) {
        imgImage.loadImage(url: URL(string: item.image ?? ""))
        lbTitle.text = item.title
    }
    
}
