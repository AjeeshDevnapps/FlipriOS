//
//  SubscriptionTableViewController.swift
//  PassTime
//
//  Created by Benjamin McMurrich on 20/02/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import Foundation
import StoreKit

class SubscriptionService: NSObject {
  
  static let sessionIdSetNotification = Notification.Name("SubscriptionServiceSessionIdSetNotification")
  static let optionsLoadedNotification = Notification.Name("SubscriptionServiceOptionsLoadedNotification")
  static let restoreSuccessfulNotification = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")
    static let restoreFAiledNotification = Notification.Name("SubscriptionServiceRestoreFailedNotification")
  static let purchaseSuccessfulNotification = Notification.Name("SubscriptionServicePurchaseSuccessfulNotification")
    static let purchaseFailedNotification = Notification.Name("SubscriptionServicePurchaseFailedNotification")
static let purchaseCanceledNotification = Notification.Name("SubscriptionServicePurchaseCanceledNotification")
  
  
  static let shared = SubscriptionService()
  
  var hasReceiptData: Bool {
    return loadReceipt() != nil
  }
  
  var currentSessionId: String? {
    didSet {
      NotificationCenter.default.post(name: SubscriptionService.sessionIdSetNotification, object: currentSessionId)
    }
  }
  
  var currentSubscription: PaidSubscription?
  
  var options: [Subscription]? {
    didSet {
      NotificationCenter.default.post(name: SubscriptionService.optionsLoadedNotification, object: options)
    }
  }
  
  func loadSubscriptionOptions() {
    
    let infiniteMonthly = "com.goflipr.flipr.sub.infinitemonthly"
    let infiniteQuarterly = "com.goflipr.flipr.sub.infinitequartely"
    let infiniteAnnually = "com.goflipr.flipr.sub.infiniteannually"
    let forLifeMonthly = "com.goflipr.flipr.sub.4lifemonthly"
    
    let productIDs = Set([infiniteMonthly, infiniteQuarterly, infiniteAnnually, forLifeMonthly])
    
    let request = SKProductsRequest(productIdentifiers: productIDs)
    request.delegate = self
    request.start()
  }
  
  func purchase(subscription: Subscription) {
    let payment = SKPayment(product: subscription.product)
    SKPaymentQueue.default().add(payment)
  }
  
  func restorePurchases() {
    // TODO: Initiate restore
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  func uploadReceipt(completion: ((_ error:Error?) -> Void)?) {
    if let receiptData = loadReceipt() {
        
    print("receipt-data: \(receiptData.base64EncodedString())")
    
        User.subscribe(receiptData: receiptData) { (error) in
            if  error != nil {
                completion?(error)
            } else {
                completion?(error)
            }
        }
    /*
      SelfieService.shared.upload(receipt: receiptData) { [weak self] (result) in
        guard let strongSelf = self else { return }
        switch result {
        case .success(let result):
          strongSelf.currentSessionId = result.sessionId
          strongSelf.currentSubscription = result.currentSubscription
          completion?(true)
        case .failure(let error):
          print("🚫 Receipt Upload Failed: \(error)")
          completion?(false)
        }
      }*/
    }
  }
  
  private func loadReceipt() -> Data? {
    guard let url = Bundle.main.appStoreReceiptURL else {
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        return data
    } catch {
        print("Error loading receipt data: \(error.localizedDescription)")
        return nil
    }
  }
}

extension SubscriptionService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Subscription Options Loaded: \(response.products)")
        print("Invalid product: \(response.invalidProductIdentifiers)")
        options = response.products.map { Subscription(product: $0) }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            print("Subscription Options Failed Loading: \(error.localizedDescription)")
        }
    }
}
