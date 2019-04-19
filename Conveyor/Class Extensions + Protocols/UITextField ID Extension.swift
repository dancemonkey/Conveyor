//
//  UITextField ID Extension.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/29/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

enum TextFieldId: Int {
  case newItem = 0, numberOfDays
}

extension UITextField {
  var fieldId: TextFieldId? {
    get {
      switch self.tag {
      case 0: return .newItem
      case 1: return .numberOfDays
      default: return nil
      }
    }
  }
  
  private static var _textUpdateTarget: UIAlertAction? = nil
  var textUpdateTarget: UIAlertAction? {
    get {
      return UITextField._textUpdateTarget
    }
    set {
      UITextField._textUpdateTarget = newValue
    }
  }
  
  @objc func textFieldDidChange() {
    // Can make UIAlertAction conform to target editing protocol
    // For now this is all I need though
    if let target = self.textUpdateTarget {
      if let text = self.text, text != "" {
        target.setValue("Lock \(text) days", forKey: "title")
      } else if let text = self.text, text.isEmpty {
        target.setValue("[Enter # of days to lock]", forKey: "title")
      }
    }
  }
}
