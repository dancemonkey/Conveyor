//
//  BucketSelectBtn.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/11/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class BucketSelectBtn: UIBarButtonItem {
  
  func configure() {
    let button = UIButton()
    button.setTitle(self.title ?? "", for: .normal)
    button.setTitleColor(ColorStyles.primary, for: .normal)
    button.addTarget(self.target, action: self.action!, for: .touchUpInside)
    self.customView = button
  }
  
}
