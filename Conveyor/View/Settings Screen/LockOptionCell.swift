//
//  LockOptionCell.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/18/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class LockOptionCell: UITableViewCell {

  @IBOutlet weak var titleLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 0.25
    self.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func configure(with option: LockOption) {
    var text = ""
    switch option {
    case .ask:
      text = "Always ask"
    case .five, .four, .three, .two, .one:
      text = "Lock item for \(option.rawValue + 1) days"
    case .forever:
      text = "Lock item until I unlock it"
    }
    self.titleLbl.text = text
    self.titleLbl.font = FontStyles.settingsCellFont
    if Settings.lockOption() == option {
      self.accessoryType = .checkmark
    } else {
      self.accessoryType = .none
    }
  }

}
