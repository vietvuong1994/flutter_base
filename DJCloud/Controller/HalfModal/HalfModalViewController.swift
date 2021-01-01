//
//  HalfModalViewController.swift
//  DJCloud
//
//  Created by kien on 10/25/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import Foundation
import UIKit

class HalfModalViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onHalfModalDimmedViewTappedOrPushed), name: NSNotification.Name(rawValue: Constants.halfModalDimmedViewTappedBroadcastNotificationKey), object: nil);
    }
    
    @objc
    func onHalfModalDimmedViewTappedOrPushed() {
        self.dismiss(animated: false);
    }
    
}
