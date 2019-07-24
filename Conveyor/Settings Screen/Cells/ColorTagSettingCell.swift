//
//  ColorTagSettingCell.swift
//  Conveyor
//
//  Created by Drew Lanning on 7/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ColorTagSettingCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 0.25
    self.layer.borderColor = UIColor.lightGray.cgColor
    backgroundColor = ColorStyles.background
    contentView.backgroundColor = ColorStyles.background
    self.textLabel?.font = FontStyles.settingsCellFont
    self.detailTextLabel?.font = FontStyles.settingsCellFont
    self.textLabel?.textColor = ColorStyles.textColor
    self.detailTextLabel?.textColor = ColorStyles.textColor
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configure(with option: ColorOption) {
    self.textLabel?.text = option.getTextValue().capitalized
    guard let color = Settings.getUserColors?[option.getTextValue()] else {
      self.detailTextLabel?.text = "@\(option.getTextValue())"
      return
    }
    self.detailTextLabel?.text = "@\(color)"
  }
  
}
