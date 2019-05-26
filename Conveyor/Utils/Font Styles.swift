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
      return UIFont(name: "SFUIDisplay-Bold", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0, weight: .bold)
    }
  }
  
  static var mainTitleFont: UIFont {
    get {
      return UIFont(name: "SFProText-Semibold", size: 24.0) ?? UIFont.systemFont(ofSize: 24.0, weight: .medium)
    }
  }
  
  static var dataEntryFont: UIFont {
    get {
      return UIFont.preferredFont(forTextStyle: .body)
    }
  }
  
  static var settingsCellFont: UIFont {
    get {
      return UIFont(name: "SFProText-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }
  }
  
  static var iapTitleFont: UIFont {
    get {
      return UIFont(name: "SFProText-Semibold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    }
  }
  
  static var iapDescFont: UIFont {
    get {
      return UIFont(name: "SFProText-Medium", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0, weight: .medium)
    }
  }
  
  static var iapPriceFont: UIFont {
    get {
      return UIFont(name: "SFProText-Semibold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    }
  }
  
  static var toastFont: UIFont {
    return UIFont(name: "SFProText-Medium", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0, weight: .regular)
  }
  
  static var itemCellFont: UIFont {
    get {
      let font = UIFont.preferredFont(forTextStyle: .body)
      return font
    }
  }
  
  static var widgetItemCellFont: UIFont {
    get {
      return UIFont.preferredFont(forTextStyle: .body)
    }
  }
  
  static var onboardingTitleFont: UIFont {
    get {
      let size: CGFloat = 18.0
      return UIFont(name: "SFProText-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
  }
  
  static var onboardingSubTitleFont: UIFont {
    get {
      let size: CGFloat = 14.0
      return UIFont(name: "SFProText-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
  }
  
}
