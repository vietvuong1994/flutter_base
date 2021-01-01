//
//  ChatBotHeaderView.swift
//  TetViet
//
//  Created by vinhdd on 12/26/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

class CreatePlayListInfoHeaderView: UITableViewHeaderFooterView {
    
    var didSelectAddSong: (()->Void)?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    @IBAction func actionAddSong(_ sender: Any) {
        didSelectAddSong?()
    }
    
}
