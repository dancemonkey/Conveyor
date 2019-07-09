//
//  ItemListCell.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ItemListCell: UITableViewCell {
  
  @IBOutlet weak var itemLabel: UILabel!
  @IBOutlet weak var priorityIcon: UIImageView?
  @IBOutlet weak var tagColorView: UIView?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
    selectionStyle = .none
    priorityIcon?.image = UIImage(named: "priority")
    priorityIcon?.isHidden = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(item: Item, in state: ItemState?) {
    itemLabel.textColor = ColorStyles.textColor
    itemLabel.text = item.title ?? "no title"
    itemLabel.font = FontStyles.itemCellFont
    itemLabel.adjustsFontSizeToFitWidth = true
    itemLabel.adjustsFontForContentSizeCategory = true
    itemLabel.minimumScaleFactor = 0.80
    self.accessoryView = nil
    self.tagColorView?.backgroundColor = item.getColorTag()
    let itemState: ItemState
    if state == nil {
      itemState = .none
    } else {
      itemState = state!
    }
    if item.repeating && itemState != .held {
      self.accessoryView = Settings.darkModeActive == true ? UIImageView(image: UIImage(named: "repeatDark")) : UIImageView(image: UIImage(named: "repeat"))
    }
    if item.priority {
      priorityIcon?.isHidden = false
    }
    switch itemState {
    case .done:
      let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: itemLabel.text ?? "")
      attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
      itemLabel.attributedText = attributeString
      itemLabel.textColor = ColorStyles.textColor
      self.itemLabel.alpha = 0.3
      if let pr = priorityIcon, pr.isHidden == false {
        priorityIcon?.alpha = 0.5
      }
    case .held:
      itemLabel.textColor = ColorStyles.textColor.withAlphaComponent(0.5)
      if !item.holdForever {
        setLockView(for: Int(item.holdDays))
      } else {
        setLockView(for: nil)
      }
    case .overdue:
      itemLabel.textColor = ColorStyles.accent
    case .none:
      itemLabel.textColor = ColorStyles.textColor
    }
  }
  
  private func setLockView(for days: Int?) {
    var lock = UIImageView(image: UIImage(named: "heldItem"))
    if let holdDays = days, holdDays > 0 {
      lock = drawOnLock(days: holdDays)
    } else if days == nil {
      lock = drawInfinity()
    }
    self.accessoryView = lock
  }
  
  private func drawInfinity() -> UIImageView {
    let fileName: String = Settings.darkModeActive ? "heldItemDark" : "heldItem"
    let lock = UIImageView(image: UIImage(named: fileName))
    let renderer = UIGraphicsImageRenderer(size: lock.frame.size)
    let img = renderer.image { ctx in
      let lockImage = UIImage(named: "heldItem")
      lockImage?.draw(at: CGPoint.zero)
      let paraStyle = NSMutableParagraphStyle()
      paraStyle.alignment = .center
      let string: NSString = "∞" as NSString
      let attributes = [NSAttributedString.Key.paragraphStyle: paraStyle, NSAttributedString.Key.foregroundColor: ColorStyles.background, NSAttributedString.Key.font: FontStyles.itemCellFont]
      string.draw(with: lock.frame.offsetBy(dx: 0.0, dy: 14.0), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    }
    return UIImageView(image: img)
  }
  
  private func drawOnLock(days: Int) -> UIImageView {
    let fileName: String = Settings.darkModeActive ? "heldItemDark" : "heldItem"
    let lock = UIImageView(image: UIImage(named: fileName))
    let renderer = UIGraphicsImageRenderer(size: lock.frame.size)
    let img = renderer.image { ctx in
      let lockImage = UIImage(named: fileName)
      lockImage?.draw(at: CGPoint.zero)
      let paraStyle = NSMutableParagraphStyle()
      paraStyle.alignment = .center
      let string: NSString = "\(days)" as NSString
      let attributes = [NSAttributedString.Key.paragraphStyle: paraStyle, NSAttributedString.Key.foregroundColor: ColorStyles.background]
      string.draw(with: lock.frame.offsetBy(dx: 0.0, dy: 18.0), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    }
    return UIImageView(image: img)
  }
  
  override func prepareForReuse() {
    itemLabel.alpha = 1.0
    itemLabel.attributedText = nil
    priorityIcon?.isHidden = true
    accessoryType = .none
    super.prepareForReuse()
  }
  
}
