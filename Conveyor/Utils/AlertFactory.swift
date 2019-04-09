//
//  ActionSheetFactory.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class AlertFactory {
  
  static func move(item: Item, completion: @escaping () -> ()) -> UIAlertController? {
    guard let currentBucket = Bucket(rawValue: item.bucket!) else { return nil }
    let controller = UIAlertController(title: "Move item to...", message: nil, preferredStyle: .actionSheet)
    let today = UIAlertAction(title: "Today", style: .default) { (_) in
      item.change(to: .today)
      completion()
    }
    let tomorrow = UIAlertAction(title: "Tomorrow", style: .default) { (_) in
      item.change(to: .tomorrow)
      completion()
    }
    let later = UIAlertAction(title: "Later", style: .default) { (_) in
      item.change(to: .later)
      completion()
    }
    [today, tomorrow, later].forEach { (action) in
      if currentBucket.rawValue.lowercased() != action.title?.lowercased() {
        controller.addAction(action)
      }
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
      completion()
    })
    controller.addAction(cancel)
    return controller
  }
  
  static func hold(item: Item, textfieldDelegate delegate: UITextFieldDelegate?, completion: @escaping () -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Hold item", message: "For how long should the item be held?", preferredStyle: .alert)
    let daySelect = UIAlertAction(title: "[Enter # of days to hold]", style: .default, handler: { (_) in
      if let holdDays = Int(controller.textFields![0].text!), holdDays != 0 {
        item.hold(forever: false, or: holdDays)
      }
      completion()
    })
    controller.addTextField { (field) in
      field.placeholder = "Number of days to hold"
      field.keyboardType = .numberPad
      field.font = FontStyles.dataEntryFont
      field.tag = TextFieldId.numberOfDays.rawValue
      field.delegate = delegate
      field.textUpdateTarget = daySelect
      let heightConstraint = NSLayoutConstraint(item: field, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
      field.addConstraint(heightConstraint)
    }
    daySelect.setValue(ColorStyles.blackText, forKey: "titleTextColor")
    controller.addAction(daySelect)
    let foreverAction = UIAlertAction(title: "Hold Forever", style: .default, handler: { (_) in
      item.hold(forever: true, or: nil)
      completion()
    })
    foreverAction.setValue(ColorStyles.primary, forKey: "titleTextColor")
    controller.addAction(foreverAction)
    controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
      completion()
    }))
    return controller
  }
}
