//
//  DataEntryProtocol.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

protocol Toastable: AnyObject {
  func showToast(from direction: Direction, with text: String)
}

extension Toastable where Self: UIViewController {
  func showToast(from direction: Direction, with text: String) {
    ToastFactory.newToast(from: direction, withText: text, parent: self)
  }
}

protocol ItemDisplayer: AnyObject {
  func initializeFRC() -> NSFetchedResultsController<Item>
}

extension ItemDisplayer where Self: ItemListVC {
  func initializeFRC() -> NSFetchedResultsController<Item> {
    let store = Store(testing: false)
    let context = store.context
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    let predicate = NSPredicate(format: "bucket == %@", "\(self.title!.lowercased())")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "state", ascending: false), NSSortDescriptor(key: "holdDays", ascending: true), NSSortDescriptor(key: "creation", ascending: true)]
    fetchRequest.predicate = predicate
    let fetchedResultsController: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  func showWatermark() {
    guard watermarkImage == nil else { return }
    let image = UIImage(named: "watermark")!
    watermarkImage = UIImageView(image: image)
    watermarkImage?.alpha = 0.4
    watermarkImage?.center = view.center
    self.view.addSubview(watermarkImage!)
  }
  
  func removeWatermark() {
    if let wm = self.watermarkImage {
      wm.removeFromSuperview()
      watermarkImage = nil
    }
  }
}

protocol ItemAdder: AnyObject {
  var addingItem: Bool { get  set }
  var bucketSelectButtons: [UIBarButtonItem] { get set }
  var fadedView: UIView? { get set }
  func setupKeyboardObserver()
  func adjustForKeyboard(notification: Notification)
  func addBucketButtons(to field: UITextField)
  func addBlurEffect()
  func removeBlurEffect()
}

extension ItemAdder where Self: ItemListVC {

  func addBlurEffect() {
    fadedView = UIView()
    fadedView?.alpha = 0.0
    fadedView?.frame = self.view.bounds
    fadedView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    fadedView?.isUserInteractionEnabled = false
    view.insertSubview(fadedView!, belowSubview: entryField)
    UIView.animate(withDuration: 0.5) { [weak self] in
      self?.fadedView?.alpha = 1.0
    }
  }
  
  func removeBlurEffect() {
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      self?.fadedView?.alpha = 0.0
    }) { [weak self] (_) in
      self?.fadedView?.removeFromSuperview()
      self?.fadedView = nil
    }
  }
  
  func setupKeyboardObserver() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  func addBucketButtons(to field: UITextField) {
    let toolbar: UIToolbar = UIToolbar()
    toolbar.sizeToFit()
    toolbar.backgroundColor = ColorStyles.background
    
    let currentTab = Bucket(rawValue: self.title!.lowercased())
    var todayTitle = "today"
    var tomorrowTitle = "tomorrow"
    var laterTitle = "later"
    switch currentTab! {
    case .today:
      todayTitle = todayTitle.uppercased()
    case .tomorrow:
      tomorrowTitle = tomorrowTitle.uppercased()
    case .later:
      laterTitle = laterTitle.uppercased()
    }
    
    let today = UIBarButtonItem(title: todayTitle, style: .done, target: self, action: #selector(bucketSelectTapped(sender:)))
    today.tag = 0
    let tomorrow = UIBarButtonItem(title: tomorrowTitle, style: .done, target: self, action: #selector(bucketSelectTapped(sender:)))
    tomorrow.tag = 1
    let later = UIBarButtonItem(title: laterTitle, style: .done, target: self, action: #selector(bucketSelectTapped(sender:)))
    later.tag = 2
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    [today, tomorrow, later].forEach { (button) in
      button.tintColor = ColorStyles.primary
      button.style = UIBarButtonItem.Style.done
    }
    bucketSelectButtons.removeAll()
    bucketSelectButtons.append(contentsOf: [today, spacer, tomorrow, spacer, later])
    toolbar.setItems(bucketSelectButtons, animated: false)
    field.inputAccessoryView = toolbar
    field.returnKeyType = .done
  }
  
}
