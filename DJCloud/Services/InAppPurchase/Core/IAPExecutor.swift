//
//  InAppPurchaseService.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 10/27/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit
import StoreKit

public typealias RequestProductsHandler = (_ products: [SKProduct]?) -> ()
public typealias BuyProductHandler = (_ success: Bool, _ productId: String?) -> ()

class IAPExecutor: NSObject {
    // Singleton
    static var instance = IAPExecutor()
    
    // Variables
    fileprivate var items = Set<String>()
    fileprivate var productRequest: SKProductsRequest?
    
    // MARK: - Closures
    fileprivate var requestProductsHandler: RequestProductsHandler?
    fileprivate var buyProductHandler: BuyProductHandler?
    
    override init() {
        super.init()
        items = Set(IAPProducts.idList)
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - Handle StoreKit functions
extension IAPExecutor {
    func requestProducts(completion: @escaping RequestProductsHandler) {
        requestProductsHandler = completion
        
        // Cancel current request
        productRequest?.cancel()
        productRequest = nil
        
        // Create new request
        productRequest = SKProductsRequest(productIdentifiers: items)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func buy(product: SKProduct, completion: @escaping BuyProductHandler) {
        buyProductHandler = completion
        
        // Add payment
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension IAPExecutor: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        requestProductsHandler?(response.products)
        clearProductRequest()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        requestProductsHandler?(nil)
        clearProductRequest()
    }
    
    private func clearProductRequest() {
        productRequest = nil
        requestProductsHandler = nil
    }
}

extension IAPExecutor: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchased, .restored:
                purchased(transaction: $0)
            case .failed:
                failed(transaction: $0)
            default: break
            }
        }
    }
    
    private func purchased(transaction: SKPaymentTransaction) {
        buyProductHandler?(true, transaction.payment.productIdentifier)
        clear(transaction: transaction)
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        buyProductHandler?(false, transaction.payment.productIdentifier)
        clear(transaction: transaction)
    }
    
    private func clear(transaction: SKPaymentTransaction) {
        buyProductHandler = nil
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
