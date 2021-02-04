//
//  SubscriptionTableViewController.swift
//  PassTime
//
//  Created by Benjamin McMurrich on 20/02/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import Foundation
import StoreKit

private var formatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .currency
  formatter.formatterBehavior = .behavior10_4
  
  return formatter
}()

struct Subscription {
    let product: SKProduct
    let formattedPrice: String
    let formattedMonthPrice: String
    let labelPrice: String
    let monthPrice: NSDecimalNumber
    let label: String
  
  init(product: SKProduct) {
    self.product = product
    
    if formatter.locale != self.product.priceLocale {
      formatter.locale = self.product.priceLocale
    }
    
    if product.productIdentifier == "com.goflipr.flipr.sub.infinitequartely" {
        let mPrice = NSDecimalNumber(floatLiteral:trunc((Double(truncating: product.price) / 3)*100)/100)
        monthPrice = mPrice
        formattedMonthPrice = formatter.string(from: mPrice) ?? "\(mPrice)"
        labelPrice = formatter.string(from: product.price)! + "/quarter after the trial period".localized
        label = "3"
    } else if product.productIdentifier == "com.goflipr.flipr.sub.infiniteannually" {
        //let mPrice = NSDecimalNumber(floatLiteral: Double(truncating: product.price) / 12)
        let mPrice = NSDecimalNumber(floatLiteral:trunc((Double(truncating: product.price) / 12)*100)/100)
        print("truncatingPrice = \(Double(truncating: product.price)) - mPrice = \(trunc((Double(truncating: product.price) / 12)*100)/100)")
        monthPrice = mPrice
        formattedMonthPrice = formatter.string(from: mPrice) ?? "\(mPrice)"
        label = "12"
        labelPrice = formatter.string(from: product.price)! + "/year after the trial period".localized
    } else {
        label = "1"
        formattedMonthPrice = formatter.string(from: product.price) ?? "\(product.price)"
        monthPrice = product.price
        labelPrice = formatter.string(from: product.price)! + "/month after the trial period".localized
    }
    formattedPrice = formatter.string(from: product.price) ?? "\(product.price)"
    

  }
}
