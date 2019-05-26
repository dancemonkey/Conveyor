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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLbl.font = FontStyles.iapTitleFont
    titleLbl.textColor = ColorStyles.blackText
    descLbl.font = FontStyles.iapDescFont
    descLbl.textColor = ColorStyles.blackText
    priceLbl.font = FontStyles.iapPriceFont
    priceLbl.textColor = ColorStyles.primary
    backgroundColor = ColorStyles.backgroundWhite
  }
  
  func configure(with product: SKProduct) {
    self.titleLbl.text = product.localizedTitle
    self.descLbl.text = product.localizedDescription
    self.priceLbl.text = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.locale = product.priceLocale
      return formatter.string(from: product.price) ?? "Unknown Price"
    }()
  }
}
