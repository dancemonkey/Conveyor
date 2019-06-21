//
//  Color Style.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

struct ColorStyles {
  
  static var textColor: UIColor {
    return Settings.darkModeActive ? UIColor.white : UIColor(named: "black")!
    // original dark mode color UIColor(named: "white")!.withAlphaComponent(0.5)
  }
  
  static var extensionTextColor: UIColor {
    return UIColor(named: "black")!
  }
  
  static var lockAlertTextColor: UIColor {
    return UIColor(named: "black")!
  }
  
  static var primaryFaded: UIColor {
    return primary.withAlphaComponent(0.3)
  }
  
  static var background: UIColor {
    return Settings.darkModeActive ? UIColor.black : UIColor(named: "white")!
    // original dark mode color UIColor(named: "black")!
  }
  
  static var primary: UIColor {
    return UIColor(named: "primary")!
  }
  
  static var accent: UIColor {
    return UIColor(named: "accent")!
  }
  
  static var secondary: UIColor {
    return UIColor(named: "secondary")!
  }
}

extension UIColor {
  var toHex: String? {
    return toHex()
  }
  
  func toHex(alpha: Bool = false) -> String? {
    guard let components = cgColor.components, components.count >= 3 else {
      return nil
    }
    
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    var a = Float(1.0)
    
    if components.count >= 4 {
      a = Float(components[3])
    }
    
    if alpha {
      return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
      return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
  }
}
