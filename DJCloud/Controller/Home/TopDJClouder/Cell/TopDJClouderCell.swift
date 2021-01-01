//
//  TopDJClouderCell.swift
//  DJCloud
//
//  Created by kien on 10/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class TopDJClouderCell: UICollectionViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func  setData(item: Artist) {
        imgImage.loadImage(url: URL(string: item.thumbImage ?? ""))
        lbTitle.text = item.name
        lbSubTitle.text = "\(item.followersCount) followers"
    }

}
