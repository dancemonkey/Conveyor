//
//  ToastView.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ToastView: UIView {
  var label: UILabel?
  
  convenience init(text: String, frame: CGRect) {
    self.init()
    label = UILabel()
    label?.text = text
    label?.textColor = ColorStyles.background
    label?.textAlignment = .center
    label?.font = FontStyles.toastFont
    label?.adjustsFontSizeToFitWidth = true
    label?.minimumScaleFactor = 0.80
    self.addSubview(label!)
    label?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    self.backgroundColor = ColorStyles.primary
    layer.cornerRadius = 4.0
    setFrame(frame: frame)
  }
  
  private func setFrame(frame: CGRect) {
    self.frame = frame
  }
}
