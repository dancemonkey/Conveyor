//
//  BadgeOptionCell.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/18/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class BadgeOptionCell: UITableViewCell {
  
  @IBOutlet weak var titleLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 0.25
    self.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func configure(with option: BadgeOption) {
    var text = ""
    switch option {
    case .all:
      text = "Everything in Today"
    case .overdue:
      text = "Only overdue items in Today"
    case .none:
      text = "No badge"
    }
    self.titleLbl.text = text
    self.titleLbl.font = FontStyles.settingsCellFont
    if Settings.badgeOption() == option {
      self.accessoryType = .checkmark
    } else {
      self.accessoryType = .none
    }
    backgroundColor = ColorStyles.background
    titleLbl.textColor = ColorStyles.textColor
  }
  
}
