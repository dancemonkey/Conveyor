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
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configure(with title: String, segueID: String) {
    self.optionLbl.text = title
    self.segueID = segueID
  }
  
}
