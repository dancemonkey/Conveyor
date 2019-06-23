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
  @IBOutlet weak var priorityIcon: UIImageView!
  @IBOutlet weak var repeatIcon: UIImageView!
  
  var delegate: ItemCompleter?
  var complete: (()->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    priorityIcon.isHidden = true
    repeatIcon.isHidden = true
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
      completeBtn.setImage(#imageLiteral(resourceName: "allDone"), for: .normal)
      completeBtn.alpha = 0.7
      if itemState == .none {
//        completeBtn.setImage(#imageLiteral(resourceName: "allDone"), for: .normal)
//        completeBtn.alpha = 0.7
        title.textColor = ColorStyles.extensionTextColor
      } else if itemState == .overdue {
//        completeBtn.setImage(#imageLiteral(resourceName: "allDone"), for: .normal)
//        completeBtn.alpha = 0.7
        title.textColor = ColorStyles.accent
      }
    }
    repeatIcon.isHidden = !item.repeating
    priorityIcon.isHidden = !item.priority
    self.complete = {
      delegate.complete(item: item)
    }
    completeBtn.layer.cornerRadius = 4.0
    completeBtn.layer.masksToBounds = true
  }
  
  override func prepareForReuse() {
    title.alpha = 1.0
    title.attributedText = nil
    priorityIcon.isHidden = true
    repeatIcon.isHidden = true
    super.prepareForReuse()
  }
  
}
