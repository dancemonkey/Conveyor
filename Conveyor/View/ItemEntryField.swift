//
//  ItemEntryField.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/10/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//222

import UIKit

class ItemEntryField: UITextField {

  let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func styleView() {
    self.tag = TextFieldId.newItem.rawValue
    adjustsFontSizeToFitWidth = true
    minimumFontSize = 11.0
    self.font = FontStyles.dataEntryFont
    self.textColor = ColorStyles.blackText
    self.borderStyle = .line
    self.layer.borderWidth = 1.0
    self.layer.borderColor = ColorStyles.primaryFaded.cgColor
    self.attributedPlaceholder = NSAttributedString(string: "add new item", attributes: [NSAttributedString.Key.foregroundColor: ColorStyles.blackText])
    UIView.animate(withDuration: 0.5) {
      self.backgroundColor = ColorStyles.blackText.withAlphaComponent(0.7)
    }
  }
  
  func styleForEntry() {
    UIView.animate(withDuration: 0.5) {
      self.backgroundColor = ColorStyles.backgroundWhite.withAlphaComponent(1.0)
      self.placeholder = ""
    }
  }
  
  override func becomeFirstResponder() -> Bool {
    styleForEntry()
    return super.becomeFirstResponder()
  }
  
  override func resignFirstResponder() -> Bool {
    styleView()
    return super.resignFirstResponder()
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
}
