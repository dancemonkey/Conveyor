//
//  ItemListVC.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import Intents

class ItemListVC: UIViewController, ItemAdder, ItemDisplayer, Toastable {
  
  var fadedView: UIView?
  var addingItem: Bool = false
  var editingExistingItem: Item? = nil
  var bucketSelectButtons: [UIBarButtonItem] = []
  var frc: NSFetchedResultsController<Item>!
  var stopEditingTap: UITapGestureRecognizer?
  var watermarkImage: UIImageView?
  var titleLabel: UILabel?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var entryField: ItemEntryField!
  @IBOutlet weak var entryFieldBottomConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    applyGlobalStyles()
    setupKeyboardObserver()
    tableView.delegate = self
    tableView.dataSource = self
    
    frc = initializeFRC()
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      print("stop trying to make fetch happen")
    }
    if INPreferences.siriAuthorizationStatus() == .notDetermined {
      INPreferences.requestSiriAuthorization { (status) in
        if status == .authorized {
          print("siri authorized")
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateHeading()
  }
  
  func applyGlobalStyles() {
    self.view.backgroundColor = ColorStyles.backgroundWhite
    tableView.backgroundColor = .clear
    entryField.styleView()
    entryField.delegate = self
  }
  
  private func updateHeading() {
    if let label = titleLabel {
      guard let bucketTitle = self.title else { return }
      label.text = getHeading(for: bucketTitle)
    } else {
      addHeading()
    }
  }
  
  private func getHeading(for title: String) -> String {
    switch self.title {
    case "Today":
      return DateStyles.headingDate.string(from: Date())
    case "Tomorrow":
      return DateStyles.headingDate.string(from: DateStyles.getTomorrow(from: Date()))
    case "Later":
      return DateStyles.headingDate.string(from: DateStyles.getLater()) + " and beyond"
    default:
      return "where are we?"
    }
  }
  
  private func addHeading() {
    titleLabel = UILabel()
    switch self.title {
    case "Today":
      titleLabel?.text = DateStyles.headingDate.string(from: Date())
    case "Tomorrow":
      titleLabel?.text = DateStyles.headingDate.string(from: DateStyles.getTomorrow(from: Date()))
    case "Later":
      titleLabel?.text = DateStyles.headingDate.string(from: DateStyles.getLater()) + " and beyond"
    default:
      titleLabel?.text = "where are we?"
    }
    titleLabel?.textColor = ColorStyles.blackText
    titleLabel?.font = FontStyles.mainTitleFont
    titleLabel?.textAlignment = .right
    titleLabel?.adjustsFontSizeToFitWidth = true
    self.view.addSubview(titleLabel!)
    
    titleLabel?.translatesAutoresizingMaskIntoConstraints = false
    let views: [String: Any] = ["label": titleLabel!]
    let hFormat = "[label]-16-|"
    let vFormat = "V:|-55-[label(30@1000)]"
    let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: nil, views: views)
    let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: nil, views: views)
    var allConstraints: [NSLayoutConstraint] = []
    allConstraints = allConstraints + hConstraints
    allConstraints = allConstraints + vConstraints
    NSLayoutConstraint.activate(allConstraints)
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    let userInfo = notification.userInfo!
    let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      UIView.animate(withDuration: 0.5) {
        self.entryFieldBottomConstraint.constant = 0.0
        self.watermarkImage?.isHidden = false
        self.view.layoutIfNeeded()
      }
    } else {
      if entryField.isFirstResponder {
        UIView.animate(withDuration: 0.5) {
          self.entryFieldBottomConstraint.constant = keyboardViewEndFrame.height
          self.watermarkImage?.isHidden = true
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  @IBAction func settingsTapped(sender: UIButton) {
    performSegue(withIdentifier: "showSettings", sender: self)
  }
}

extension ItemListVC: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .move:
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.insertRows(at: [newIndexPath], with: .fade)
      }
    @unknown default:
      fatalError()
    }
  }
}

extension ItemListVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let items = frc.fetchedObjects else { return 0 }
    if items.count == 0 {
      showWatermark()
    } else {
      removeWatermark()
    }
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let items = frc.fetchedObjects else { return UITableViewCell() }
    let cell = tableView.dequeueReusableCell(withIdentifier: "\(self.title!.lowercased())Cell") as? ItemListCell
    let item = items[indexPath.row]
    cell?.configure(item: item, in: ItemState(rawValue: item.state ?? "none"))
    return cell!
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard let items = self.frc.fetchedObjects else { return nil }
    let item = items[indexPath.row]
    let itemState = ItemState(rawValue: item.state!)!
    let bucket = Bucket(rawValue: item.bucket ?? "")!
    var actions: [UIContextualAction] = []
    let delete = UIContextualAction(style: .destructive, title: nil) { (action, view, success: (Bool) -> Void) in
      let store = Store(testing: false)
      store.delete(item: item)
      store.save()
      success(true)
    }
    let move = UIContextualAction(style: .normal, title: nil) { (_, _, success: @escaping (Bool) -> Void) in
      guard let alert = AlertFactory.move(item: item, completion: { [weak self] in
        let store = Store(testing: false)
        store.save()
        if item.bucket!.lowercased() != self?.title!.lowercased() {
          self?.showToast(from: .bottom, with: "Moved to \(item.bucket!.capitalized)")
        }
        success(true)
      }) else { return }
      self.present(alert, animated: true, completion: nil)
    }
    delete.image = ItemActions.delete.getImage()
    delete.backgroundColor = ColorStyles.accent
    move.image = ItemActions.move.getImage()
    move.backgroundColor = ColorStyles.secondary
    actions.append(delete)
    actions.append(move)
    if bucket == .later {
      let hold = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, success: @escaping (Bool) -> Void) in
        let store = Store(testing: false)
        let holdSetting = Settings.lockOption()
        if itemState == .held {
          item.unHold()
          success(true)
        } else {
          switch holdSetting {
          case .ask:
            let holdSelect = AlertFactory.hold(item: item, textfieldDelegate: self, completion: {
              store.save()
              success(true)
            })
            self?.present(holdSelect, animated: true, completion: nil)
          case .one, .two, .three, .four, .five:
            item.hold(forever: false, or: holdSetting.rawValue + 1)
            success(true)
          case .forever:
            item.hold(forever: true, or: nil)
            success(true)
          }
        }
      }
      if itemState == .held {
        hold.image = ItemActions.hold.getUnholdImage()
      } else {
        hold.image = ItemActions.hold.getImage()
      }
      hold.backgroundColor = ColorStyles.primary
      actions.append(hold)
    }
    return UISwipeActionsConfiguration(actions: actions)
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    guard let items = self.frc.fetchedObjects else { return nil }
    let item = items[indexPath.row]
    let itemState = ItemState(rawValue: item.state!)!
    let complete = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, success: (Bool) -> Void) in
      let store = Store(testing: false)
      let doneSetting = Settings.doneOption()
      if itemState == .done {
        item.unComplete()
      } else {
        if doneSetting == .strikethrough {
          item.complete()
        } else if doneSetting == .delete {
          store.delete(item: item)
        }
        self?.showToast(from: .bottom, with: ToastMessages.getPositiveMessage())
      }
      store.save()
      success(true)
    }
    if itemState == .done {
      complete.image = ItemActions.complete.getUnCompleteImage()
    } else {
      complete.image = ItemActions.complete.getImage()
    }
    complete.backgroundColor = ColorStyles.primary
    return UISwipeActionsConfiguration(actions: [complete])
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let items = self.frc.fetchedObjects else { return }
    let item = items[indexPath.row]
    editExisting(item: item)
  }
}

extension ItemListVC: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view!.isDescendant(of: self.tableView) {
      return false
    }
    return true
  }
}

extension ItemListVC {
  
  @objc func newItem() {
    if self.addingItem == false {
      addBlurEffect()
      self.addBucketButtons(to: entryField)
      let _ = entryField.becomeFirstResponder()
      tableView.isUserInteractionEnabled = false
      self.addingItem = true
      stopEditingTap = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
      self.view.addGestureRecognizer(stopEditingTap!)
    }
  }
  
  func editExisting(item: Item) {
    if self.addingItem == false {
      let _ = entryField.becomeFirstResponder()
      editingExistingItem = item
      entryField.text = item.title ?? ""
      entryField.selectAll(nil)
    }
  }

  @objc func stopEditing() {
    view.endEditing(true)
    removeBlurEffect()
    tableView.isUserInteractionEnabled = true
    self.entryField.text = ""
    self.addingItem = false
    self.editingExistingItem = nil
    self.view.removeGestureRecognizer(stopEditingTap!)
  }
  
  @objc func bucketSelectTapped(sender: UIBarButtonItem) {
    self.bucketSelectButtons.forEach { (button) in
      if button === sender {
        button.tintColor = ColorStyles.primary
      } else {
        button.tintColor = ColorStyles.primaryFaded
      }
    }
    let store = Store(testing: false)
    guard let text = self.entryField.text else {
      stopEditing()
      return
    }
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      stopEditing()
      return
    }
    guard let bucket = Bucket(rawValue: sender.title!.lowercased()) else { return }
    if let item = editingExistingItem {
      store.updateExisting(item: item, withTitle: text, in: bucket)
    } else {
      store.addNewItem(text: text, in: bucket)
    }
    store.save()
    stopEditing()
    
    // show toast if adding item to different bucket
    let currentBucket = Bucket(rawValue: self.title!.lowercased())
    if currentBucket != bucket {
      showToast(from: .bottom, with: "Added to \(bucket.rawValue.capitalized)")
    }
  }
}

extension ItemListVC: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if let id = textField.fieldId {
      if id == .newItem {
        self.newItem()
      } else if id == .numberOfDays {
        textField.addTarget(textField, action: #selector(UITextField.textFieldDidChange), for: .editingChanged)
      }
    }
  }
}
