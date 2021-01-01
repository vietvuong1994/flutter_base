//
//  IAPItem.swift
//  iOS Structure MVC
//
//  Created by kien on 2/25/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit

// Create your own IAP Model based on your project
class IAPItem {
    var id: String
    var price: Int
    var point: Int
    var bonusPoint: Int
    
    init(id: String, price: Int, point: Int, bonusPoint: Int) {
        self.id = id
        self.price = price
        self.point = point
        self.bonusPoint = bonusPoint
    }
}
