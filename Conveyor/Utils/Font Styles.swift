//
//  Font Styles.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

struct FontStyles {
  
  static var tabBarFont: UIFont {
    get {
      return UIFont(name: "SF-UI-Display-Bold", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0, weight: .bold)
    }
  }
  
  static var mainTitleFont: UIFont {
    get {
      return UIFont(name: "SF-Pro-Text-Semibold", size: 24.0) ?? UIFont.systemFont(ofSize: 24.0, weight: .medium)
    }
  }
  
  static var dataEntryFont: UIFont {
    get {
      return UIFont.preferredFont(forTextStyle: .body)
    }
  }
  
  static var settingsCellFont: UIFont {
    get {
      return UIFont(name: "SF-Pro-Text-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }
  }
  
  static var toastFont: UIFont {
    return UIFont(name: "SF-Pro-Text-Medium", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .regular)
  }
  
  static var itemCellFont: UIFont {
    get {
      return UIFont.systemFont(ofSize: 18.0, weight: .thin)
    }
  }
  
  static var widgetItemCellFont: UIFont {
    get {
      return UIFont.preferredFont(forTextStyle: .body)
    }
  }
  
}
