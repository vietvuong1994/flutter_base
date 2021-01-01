//
//  MenuSelectCell.swift
//  DJCloud
//
//  Created by kien on 10/26/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class MenuSelectCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgIcon.set(color: UIColor(hex: 0x3E3E3E))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(menu: MenuSelectType) {
        imgIcon.image = menu.image
        lbTitle.text = menu.title
    }
    
}
