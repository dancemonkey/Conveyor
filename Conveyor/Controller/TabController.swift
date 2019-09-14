//
//  TabController.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(setTabColor), name: .onDarkModeSelected, object: nil)
    setTabStyling()
  }
  
  // MARK: Styling
  func setTabStyling() {
    UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -15.0)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : FontStyles.tabBarFont], for: .normal)
    setTabColor()
  }
  
  @objc func setTabColor() {
    // is iOS 13, use named color with dark mode option
    if #available(iOS 13, *) {
      UITabBar.appearance().barTintColor = UIColor(named: "tabBarColor")!
    } else {
      UITabBar.appearance().barTintColor = Settings.darkModeActive ? UIColor.black : ColorStyles.textColor
    }
  }
  
}
