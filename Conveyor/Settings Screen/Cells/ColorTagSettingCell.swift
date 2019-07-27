//
//  ColorTagSettingCell.swift
//  Conveyor
//
//  Created by Drew Lanning on 7/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ColorTagSettingCell: UITableViewCell {
  
  @IBOutlet weak var colorTagView: UIView!
  @IBOutlet weak var colorLbl: UILabel!
  @IBOutlet weak var tagLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 0.25
    self.layer.borderColor = UIColor.lightGray.cgColor
    backgroundColor = ColorStyles.background
    contentView.backgroundColor = ColorStyles.background
    self.colorLbl.font = FontStyles.settingsCellFont
    self.tagLbl.font = FontStyles.settingsCellFont
    self.colorLbl.textColor = ColorStyles.textColor
    self.tagLbl.textColor = ColorStyles.textColor
    self.selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configure(with option: ColorOption) {
    self.colorLbl.text = option.getTextValue().capitalized
    guard let color = Settings.getUserColors?[option.getTextValue()] else {
      self.tagLbl.text = "@\(option.getTextValue())"
      return
    }
    self.tagLbl.text = "@\(color)"
    self.colorTagView.backgroundColor = option.getColor()
  }
  
}
