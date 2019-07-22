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
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configure(with option: ColorOption) {
    self.textLabel?.text = option.getTextValue().capitalized
    guard let color = Settings.getUserColors?[option.getTextValue()] else {
      self.detailTextLabel?.text = "@\(option.getTextValue())"
      return
    }
    self.detailTextLabel?.text = "@\(color)"
    self.textLabel?.font = FontStyles.settingsCellFont
    self.detailTextLabel?.font = FontStyles.settingsCellFont
    backgroundColor = ColorStyles.background
  }
  
}
