//
//  IAPProducts.swift
//  iOS Structure MVC
//
//  Created by kien on 2/25/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit

class IAPProducts {
    // Variables
    // Generate In-App Purchase item list
    static let items: [IAPItem] = [
        IAPItem(id: "", price: 120, point: 85, bonusPoint: 0),
        IAPItem(id: "", price: 500, point: 325, bonusPoint: 0),
        IAPItem(id: "", price: 1500, point: 975, bonusPoint: 0),
        IAPItem(id: "", price: 3000, point: 1950, bonusPoint: 0),
        IAPItem(id: "", price: 5000, point: 3250, bonusPoint: 0),
        IAPItem(id: "", price: 10000, point: 6500, bonusPoint: 0),
        IAPItem(id: "", price: 20000, point: 12870, bonusPoint: 0)
    ]
    
    static var idList: [String] {
        return IAPProducts.items.map({ $0.id })
    }
    
    static var priceList: [Int] {
        return IAPProducts.items.map({ $0.price })
    }
}
