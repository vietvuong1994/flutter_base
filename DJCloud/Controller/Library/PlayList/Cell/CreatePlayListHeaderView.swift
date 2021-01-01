//
//  ChatBotHeaderView.swift
//  TetViet
//
//  Created by vinhdd on 12/26/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit

class CreatePlayListHeaderView: UITableViewHeaderFooterView {
    
    var didSelectCreate: (()->Void)?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    @IBAction func actionCreate(_ sender: Any) {
        didSelectCreate?()
    }
    
}
