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
  case proPurchase
  
  func message() -> String {
    switch self {
    case .disabled: return "Purchases are disabled in your device!"
    case .restored: return "You've successfully restored your purchases!"
    case .purchased: return "Thank you for your support!"
    case .proPurchase: return "Thank you for upgrading to Pro!"
    }
  }
}

class IAPStore: NSObject {
  static let shared = IAPStore()
  
  let smallTip = Constants.IAPProductIds.smallTip.rawValue
  let mediumTip = Constants.IAPProductIds.mediumTip.rawValue
  let largeTip = Constants.IAPProductIds.largeTip.rawValue
  let proUpgrade = Constants.IAPProductIds.proUpgrade.rawValue
  
  fileprivate var productID = ""
  fileprivate var productsRequest = SKProductsRequest()
  var iapProducts = [SKProduct]()
  var proIndex: Int = 0

  var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)? = { (purchaseStatus) in
    if purchaseStatus == .proPurchase || purchaseStatus == .restored {
      do {
        try shared.setProUser()
      } catch {
        print("did not set pro user")
      }
    }
    shared.purchaseCompleteBlock?()
  }
  private var purchaseCompleteBlock: (() -> ())?
  private var productRequestComplete: (() -> ())?
  
  // MARK: - MAKE PURCHASE OF A PRODUCT
  func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
  
  func purchaseMyProduct(index: Int, completion: @escaping () -> ()) {
    if iapProducts.count == 0 { return }
    purchaseCompleteBlock = completion
    if self.canMakePurchases() {
      let product = iapProducts[index]
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(self)
      SKPaymentQueue.default().add(payment)      
      productID = product.productIdentifier
    } else {
      purchaseStatusBlock?(.disabled)
    }
  }
  
  func purchasePro(completion: @escaping () -> ()) {
    purchaseCompleteBlock = completion
    if self.canMakePurchases() {
      let product = iapProducts[proIndex]
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(self)
      SKPaymentQueue.default().add(payment)
      productID = product.productIdentifier
    } else {
      purchaseStatusBlock?(.disabled)
    }
  }
  
  // MARK: - RESTORE PURCHASE
  func restorePurchase(completion: (()->())?) {
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
    completion?()
  }
  
  // MARK: - FETCH AVAILABLE IAP PRODUCTS
  func fetchAvailableProducts(completion: (() -> ())?) {
    
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
  
  // MARK: FILE ISPRO STORAGE AND RETRIEVAL
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func isProUser() -> Bool {
    guard let filename = UserDefaults.standard.value(forKey: Constants.DefaultKeys.filename.rawValue) as? String else { return false }
    let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
    do {
      let nsData = try NSData(contentsOf: fullPath, options: [])
      let data = Data(referencing: nsData)
      let possibleValue = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? String
      if let value = possibleValue {
        return value == "isProUser"
      }
    } catch {
      print("no isUserPro data found")
    }
//    return true
    return false
  }
  
  func clearProUser() {
    guard let filename = UserDefaults.standard.value(forKey: Constants.DefaultKeys.filename.rawValue) as? String else { return }
    var filePath = ""
    let dirs: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
    if dirs.count > 0 {
      let dir = dirs[0]
      filePath = dir.appendingFormat("/", filename)
    } else {
      print("could not find directory")
    }
    do {
      let manager = FileManager.default
      if manager.fileExists(atPath: filePath) {
        try manager.removeItem(atPath: filePath)
      } else {
        print("file not found")
      }
    } catch {
      print("error deleting file")
    }
  }
  
  func setProUser() throws {
    print("setting pro user")
    enum WriteError: Error {
      case failed
      case alreadyProUser
    }
    
    if isProUser() == true {
      throw WriteError.alreadyProUser
    }
    
    let value = "isProUser"
    let filename = UUID().uuidString
    UserDefaults.standard.set(filename, forKey: Constants.DefaultKeys.filename.rawValue)
    let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
      try data.write(to: fullPath, options: [.completeFileProtection])
    } catch {
      throw WriteError.failed
    }
  }
}

extension IAPStore: SKProductsRequestDelegate, SKPaymentTransactionObserver {
  // MARK: - REQUEST IAP PRODUCTS
  func productsRequest(_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
    if (response.products.count > 0) {
      iapProducts = response.products
      for (index, product) in iapProducts.enumerated() {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
//        let priceStr = numberFormatter.string(from: product.price)
        if product.productIdentifier == proUpgrade {
          self.proIndex = index
        }
      }
    }
    if let handleRequest = self.productRequestComplete {
      handleRequest()
    }
  }
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    purchaseStatusBlock?(.restored)
  }
  
  // MARK: - IAP PAYMENT QUEUE
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction:AnyObject in transactions {
      if let trans = transaction as? SKPaymentTransaction {
        switch trans.transactionState {
        case .purchased:
          print("purchased")
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          if trans.payment.productIdentifier == smallTip {
            purchaseStatusBlock?(.purchased)
          } else {
            purchaseStatusBlock?(.proPurchase)
          }
          break
        case .failed:
          print("failed")
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          purchaseCompleteBlock?()
          break
        case .restored:
          print("restored")
          SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
          break
        default: break
        }}}
  }
}
