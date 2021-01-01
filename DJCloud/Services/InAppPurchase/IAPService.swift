//
//  IAPBuyTask.swift
//  iOS Structure MVC
//
//  Created by kien on 2/25/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit
import StoreKit

public typealias VerifyPurcharseHandler = (_ buySuccess: Bool,_ verifySuccess: Bool,_ point: Int?) -> ()

class IAPService: NSObject {
    var buyId: String?
    var item: IAPItem
    
    var verifyPurchaseHandler: VerifyPurcharseHandler?
    
    init(item: IAPItem) {
        self.item = item
    }
    
    func execute(completion: @escaping VerifyPurcharseHandler) {
        self.verifyPurchaseHandler = completion
        IndicatorViewer.show()
        IAPExecutor.instance.requestProducts(completion: { list in
            if let list = list, let product = list.filter({ $0.productIdentifier == self.item.id }).first {
                self.createPurchase(product: product)
            } else {
                self.showFailedAlert()
            }
        })
    }
    
    private func createPurchase(product: SKProduct) {
        // Call api from server to create new purchase, then:
        // Succeed: Continue calling function buy(product: SKProduct, buyId: String?) { ... }
        // Failed: Call showFailedAlert() { ... }
    }
    
    private func buy(product: SKProduct, buyId: String?) {
        IAPExecutor.instance.buy(product: product, completion: { success, productId  in
            if success {
                self.verifyPurchase(buyId: buyId)
            } else {
                self.showFailedAlert()
            }
        })
    }
    
    private func verifyPurchase(buyId: String?) {
        guard let _ = buyId, let _ = getPaymentReceipt() else {
            showFailedAlert()
            return
        }
        // Call api to verify purchase, then:
        // Succeed: Call showSucceededAlert(point: Int?) { ... }
        // Failed: Call showCannotCompleteAlert() { ... }
    }
}

// MARK: - In-App Purchase supporting functions
extension IAPService {
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func getPaymentReceipt() -> String? {
        if let url = Bundle.main.appStoreReceiptURL, let data = try? Data(contentsOf: url) {
            return data.base64EncodedString()
        }
        return nil
    }
}

// Show alerts
extension IAPService {
    private func showSucceededAlert(point: Int?) {
        DispatchQueue.main.async {
            IndicatorViewer.hide()
            // Write code to show your own alert
            self.verifyPurchaseHandler?(true, true, point)
        }
    }
    
    private func showCannotCompleteAlert() {
        DispatchQueue.main.async {
            IndicatorViewer.hide()
            // Write code to show your own alert
            self.verifyPurchaseHandler?(true, false, nil)
        }
    }
    
    private func showFailedAlert() {
        DispatchQueue.main.async {
            IndicatorViewer.hide()
            // Write code to show your own alert
            self.verifyPurchaseHandler?(false, false, nil)
        }
    }
}

