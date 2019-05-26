//
//  IAPStore.swift
//  Conveyor
//
//  Created by Drew Lanning on 5/25/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation
import StoreKit

enum IAPHandlerAlertType {
  case disabled
  case restored
  case purchased
  
  func message() -> String {
    switch self {
    case .disabled: return "Purchases are disabled in your device!"
    case .restored: return "You've successfully restored your purchase!"
    case .purchased: return "Thank you for your support!"
    }
  }
}

class IAPStore: NSObject {
  static let shared = IAPStore()
  
  let smallTip = "com.DrewLanning.Conveyor.small"
  let mediumTip = "com.DrewLanning.Conveyor.medium"
  let largeTip = "com.DrewLanning.Conveyor.large"
  let proUpgrade = "com.DrewLanning.Conveyor.proUpgrade"
  
  fileprivate var productID = ""
  fileprivate var productsRequest = SKProductsRequest()
//  fileprivate
  var iapProducts = [SKProduct]()

  var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
  var productRequestComplete: (() -> ())?
  
  // MARK: - MAKE PURCHASE OF A PRODUCT
  func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
  
  func purchaseMyProduct(index: Int) {
    if iapProducts.count == 0 { return }
    
    if self.canMakePurchases() {
      let product = iapProducts[index]
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(self)
      SKPaymentQueue.default().add(payment)
      
      print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
      productID = product.productIdentifier
    } else {
      purchaseStatusBlock?(.disabled)
    }
  }
  
  // MARK: - RESTORE PURCHASE
  func restorePurchase() {
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  // MARK: - Check if Purchased Pro upgrade
  func isProUser() -> Bool {
    
    return true
  }
  
  
  // MARK: - FETCH AVAILABLE IAP PRODUCTS
  func fetchAvailableProducts(completion: (() -> ())?) {
    
    // Put here your IAP Products ID's
    let productIdentifiers = NSSet(objects:
      smallTip,
      mediumTip,
      largeTip,
      proUpgrade
    )
    
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
    productsRequest.delegate = self
    productsRequest.start()
    if let handle = completion {
      self.productRequestComplete = handle
    }
  }
}

extension IAPStore: SKProductsRequestDelegate, SKPaymentTransactionObserver {
  // MARK: - REQUEST IAP PRODUCTS
  func productsRequest(_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
    if (response.products.count > 0) {
      iapProducts = response.products
      for product in iapProducts {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        let price1Str = numberFormatter.string(from: product.price)
        print(product.localizedDescription + "\nfor just \(price1Str!)")
      }
    }
    if let handleRequest = self.productRequestComplete {
      handleRequest()
    }
  }
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    purchaseStatusBlock?(.restored)
  }
  
  // MARK:- IAP PAYMENT QUEUE
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction:AnyObject in transactions {
      if let trans = transaction as? SKPaymentTransaction {
        switch trans.transactionState {
        case .purchased:
          print("purchased")
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          purchaseStatusBlock?(.purchased)
          break
          
        case .failed:
          print("failed")
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          break
        case .restored:
          print("restored")
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          break
          
        default: break
        }}}
  }
}
