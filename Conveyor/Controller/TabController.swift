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
    setTabStyling()
  }
  
  // MARK: Styling
  func setTabStyling() {
    UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -15.0)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : FontStyles.tabBarFont], for: .normal)
  }
  
//  @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
//    if sender.direction == .left {
//      self.selectedIndex += 1
//    }
//    if sender.direction == .right {
//      self.selectedIndex -= 1
//    }
//  }
}
