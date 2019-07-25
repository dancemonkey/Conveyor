//
//  ActionSheetFactory.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class AlertFactory {
  
  static func siriAuthNotification(completion: @escaping () -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Siri Authorization", message: "We're requesting Siri access so you will be able to add to your lists using Siri. You can change your mind later from iOS Settings.", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
      completion()
    }
    controller.addAction(ok)
    return controller
  }
  
  static func badgeAuthNotification(completion: @escaping () -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Badge Authorization", message: "We're asking for Notifications acccess so you can have badge on the app icon showing incomplete Today list items. You can change your mind later from iOS Settings.", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
      completion()
    }
    controller.addAction(ok)
    return controller
  }
  
  static func confirmColorReset(completion: @escaping () -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Reset Colors?", message: "You are about to reset all custom color tags to their original values, are you sure?", preferredStyle: .alert)
    let yes = UIAlertAction(title: "YES!", style: .destructive) { (action) in
      completion()
    }
    let no = UIAlertAction(title: "Nope", style: .cancel, handler: nil)
    controller.addAction(yes)
    controller.addAction(no)
    return controller
  }
  
  static func whatsNewLatestVersion(delegate: UIPopoverPresentationControllerDelegate, completion: @escaping () -> ()) -> UIViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "WhatsNewLatestVersion", bundle: nil)
    let vc = storyboard.instantiateInitialViewController() as! WhatsNewVC
    vc.modalPresentationStyle = .popover
    vc.completion = completion
    let popover = vc.popoverPresentationController!
    popover.delegate = delegate
    popover.permittedArrowDirections = .any
    popover.sourceView = vc.view
    popover.sourceRect = vc.view.bounds
    return vc
  }
  
  static func purchasesRestored() -> UIAlertController {
    let controller = UIAlertController(title: "Purchases Restored", message: IAPHandlerAlertType.restored.message(), preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    controller.addAction(ok)
    return controller
  }
  
  static func askForOnboarding(completion: @escaping () -> (), cancellation: @escaping () -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Overview?", message: "Would you like to see a brief (6 slide) overview of the app?", preferredStyle: .alert)
    let ok = UIAlertAction(title: "Okay", style: .default) { (action) in
      completion()
    }
    let cancel = UIAlertAction(title: "No thanks", style: .cancel) { (action) in
      cancellation()
    }
    controller.addAction(ok)
    controller.addAction(cancel)
    return controller
  }
  
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
    let controller = UIAlertController(title: "Lock item", message: "For how long should the item be locked?", preferredStyle: .alert)
    let daySelect = UIAlertAction(title: "[Enter # of days to lock]", style: .default, handler: { (_) in
      if let holdDays = Int(controller.textFields![0].text!), holdDays != 0 {
        item.hold(forever: false, or: holdDays)
      }
      completion()
    })
    controller.addTextField { (field) in
      field.placeholder = "Number of days to lock"
      field.keyboardType = .numberPad
      field.font = FontStyles.dataEntryFont
      field.tag = TextFieldId.numberOfDays.rawValue
      field.delegate = delegate
      field.textUpdateTarget = daySelect
      let heightConstraint = NSLayoutConstraint(item: field, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
      field.addConstraint(heightConstraint)
    }
    daySelect.setValue(ColorStyles.lockAlertTextColor, forKey: "titleTextColor")
    controller.addAction(daySelect)
    let foreverAction = UIAlertAction(title: "Lock Forever", style: .default, handler: { (_) in
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
