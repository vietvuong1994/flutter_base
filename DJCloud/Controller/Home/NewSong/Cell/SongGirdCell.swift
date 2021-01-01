//
//  SongGirdCell.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class SongGirdCell: UICollectionViewCell {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(item: PlayableItem) {
        lbTitle.text = item.title
        lbSubTitle.text = item.artist
        imgImage.loadImage(url: URL(string: item.imageUrl ?? ""))
    }

}
