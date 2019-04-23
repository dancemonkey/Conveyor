//
//  SettingsCell.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/17/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
  
  @IBOutlet weak var optionLbl: UILabel!
  var segueID: String?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 0.25
    self.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func configure(with title: String, segueID: String) {
    self.optionLbl.text = title
    self.segueID = segueID
    optionLbl.font = FontStyles.settingsCellFont
    optionLbl.textColor = ColorStyles.blackText
    backgroundColor = ColorStyles.backgroundWhite
    selectionStyle = .none
  }
  
}
