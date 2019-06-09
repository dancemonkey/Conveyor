//
//  IAPCell.swift
//  Conveyor
//
//  Created by Drew Lanning on 5/26/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import StoreKit

class IAPCell: SettingsCell {
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var descLbl: UILabel!
  @IBOutlet weak var priceLbl: UILabel!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  var proUpgradeCell: Bool = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLbl.font = FontStyles.iapTitleFont
    titleLbl.textColor = ColorStyles.textColor
    descLbl.font = FontStyles.iapDescFont
    descLbl.textColor = ColorStyles.textColor
    priceLbl.font = FontStyles.iapPriceFont
    priceLbl.textColor = ColorStyles.primary
    backgroundColor = ColorStyles.background
    spinner.hidesWhenStopped = true
    spinner.stopAnimating()
  }
  
  func startPurchase() {
    spinner.isHidden = false
    spinner.startAnimating()
    priceLbl.isHidden = spinner.isAnimating
  }
  
  func purchaseComplete() {
    spinner.stopAnimating()
    priceLbl.isHidden = spinner.isAnimating
  }
  
  func configure(with product: SKProduct) {
    self.titleLbl.text = product.localizedTitle
    self.descLbl.text = product.localizedDescription
    selectionStyle = .none
    if product.productIdentifier == Constants.IAPProductIds.proUpgrade.rawValue {
      proUpgradeCell = true
      if IAPStore.shared.isProUser() {
        self.priceLbl.text = "Pro User"
        self.priceLbl.textColor = ColorStyles.textColor
      } else {
        self.priceLbl.text = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          formatter.locale = product.priceLocale
          return formatter.string(from: product.price) ?? "Unknown Price"
        }()
      }
    } else {
      self.priceLbl.text = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "Unknown Price"
      }()
    }
  }
}
