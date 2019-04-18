//
//  DoneOptionCell.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/18/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class DoneOptionCell: UITableViewCell {

  @IBOutlet weak var titleLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 0.25
    self.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func configure(with option: DoneOption) {
    var text = ""
    switch option {
    case .delete:
      text = "Delete completed items immediately"
    case .strikethrough:
      text = "Strikethrough completed items"
    }
    self.titleLbl.text = text
    self.titleLbl.font = FontStyles.settingsCellFont
    if Settings.doneOption() == option {
      self.accessoryType = .checkmark
    } else {
      self.accessoryType = .none
    }
  }
}
