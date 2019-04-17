//
//  WidgetCell.swift
//  TodayWidget
//
//  Created by Drew Lanning on 4/11/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class WidgetCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var completeBtn: UIButton!
  var delegate: ItemCompleter?
  var complete: (()->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func complete(sender: UIButton) {
    complete?()
  }
  
  func configure(with item: Item, and delegate: ItemCompleter) {
    self.title.text = item.title ?? "No item title"
    title.font = FontStyles.widgetItemCellFont
    self.delegate = delegate
    if let state = item.state, let itemState = ItemState(rawValue: state) {
      if itemState == .none {
        completeBtn.setImage(#imageLiteral(resourceName: "widgetComplete"), for: .normal)
        title.textColor = ColorStyles.blackText
      } else if itemState == .overdue {
        completeBtn.setImage(#imageLiteral(resourceName: "widgetComplete"), for: .normal)
        title.textColor = ColorStyles.accent
      }
    }
    self.complete = {
      delegate.complete(item: item)
    }
    completeBtn.layer.cornerRadius = 4.0
    completeBtn.layer.masksToBounds = true
  }
  
  override func prepareForReuse() {
    title.alpha = 1.0
    title.attributedText = nil
    super.prepareForReuse()
  }
  
}
