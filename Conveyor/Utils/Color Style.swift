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
    return Settings.darkModeActive ? UIColor(named: "white")!.withAlphaComponent(0.5) : UIColor(named: "black")!
  }
  
  static var primaryFaded: UIColor {
    return primary.withAlphaComponent(0.3)
  }
  
  static var background: UIColor {
    return Settings.darkModeActive ? UIColor(named: "black")! : UIColor(named: "white")!
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
