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
import UserNotifications
import AVFoundation

class ItemListVC: UIViewController, ItemAdder, ItemDisplayer, Toastable {
  
  var fadedView: UIView?
  var addingItem: Bool = false
  var editingExistingItem: Item? = nil
  var bucketSelectButtons: [UIBarButtonItem] = []
  var frc: NSFetchedResultsController<Item>!
  var stopEditingTap: UITapGestureRecognizer?
  var watermarkImage: UIImageView?
  var titleLabel: UILabel?
  var mocSaveObserver: NSNotification?
  var radio: Radio?
  var sessionManager: WatchSessionManager?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var entryField: ItemEntryField!
  @IBOutlet weak var entryFieldBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var settingsBtn: UIButton?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    applyGlobalStyles()
    setupKeyboardObserver()
    tableView.delegate = self
    tableView.dataSource = self
    
    radio = Radio()
    
    frc = initializeFRC()
    frc.delegate = self
    performFetch()
    
    sessionManager = WatchSessionManager.shared
    sessionManager?.startSession()
    
    NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: .onDarkModeSelected, object: nil)    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateHeading()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: Constants.DefaultKeys.hasLaunchedBefore.rawValue)
    let hasSeenWhatsNew = UserDefaults.standard.bool(forKey: Constants.DefaultKeys.whatsNew130.rawValue)
    if hasLaunchedBefore == false && self.title == "Today" {
      let completion: () -> () = {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() else { return }
        self.present(vc, animated: true, completion: nil)
      }
      let cancellation: () -> () = {
        UserDefaults.standard.set(true, forKey: Constants.DefaultKeys.hasLaunchedBefore.rawValue)
        if INPreferences.siriAuthorizationStatus() == .notDetermined {
          DispatchQueue.main.async {
            let siriPopup = AlertFactory.siriAuthNotification {
              INPreferences.requestSiriAuthorization { (status) in }
            }
            self.present(siriPopup, animated: true, completion: nil)
          }
        }
      }
      let onboardingRequest = AlertFactory.askForOnboarding(completion: completion, cancellation: cancellation)
      self.present(onboardingRequest, animated: true, completion: nil)
    } else if hasSeenWhatsNew == false && self.title == "Today" {
      // launch whats new popup
      let whatsNewAlert = AlertFactory.whatsNewLatestVersion {
        UserDefaults.standard.set(true, forKey: Constants.DefaultKeys.whatsNew130.rawValue)
      }
      self.present(whatsNewAlert, animated: true, completion: nil)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  @objc func updateData() {
    performFetch()
    tableView.reloadData()
  }
  
  @objc func willEnterForeground() {
    updateData()
  }
  
  @objc func refreshUI() {
    applyGlobalStyles()
    tableView.reloadData()
  }
  
  func performFetch() {
    do {
      try frc.performFetch()
    } catch {
      print("stop trying to make fetch happen")
    }
  }
  
  func applyGlobalStyles() {
    self.view.backgroundColor = ColorStyles.background
    tableView.backgroundColor = .clear
    entryField.styleView()
    entryField.delegate = self
    titleLabel?.textColor = ColorStyles.textColor
    let settingsImage: UIImage? = Settings.darkModeActive ? UIImage(named: "settingsDark")! : UIImage(named: "settings")!
    settingsBtn?.setImage(settingsImage, for: .normal)
  }
  
  private func updateHeading() {
    if let label = titleLabel {
      guard let bucketTitle = self.title else { return }
      label.text = getHeading(for: bucketTitle)
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
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
    titleLabel?.textColor = ColorStyles.textColor
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
  
  func requestBadgeAuthorization() {
    // Ask for badge permissions the first time they add something to Today
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { (settings) in
      if settings.authorizationStatus == .notDetermined {
        DispatchQueue.main.async {
          let badgePopup = AlertFactory.badgeAuthNotification(completion: {
            center.requestAuthorization(options: .badge) { (granted, error) in }
          })
          self.present(badgePopup, animated: true, completion: nil)
        }
      }
    }
  }
  
  @IBAction func settingsTapped(sender: UIButton) {
    let storyboard = UIStoryboard(name: "Settings", bundle: nil)
    guard let vc = storyboard.instantiateInitialViewController() else { return }
    self.present(vc, animated: true, completion: nil)
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
    let items = frc.fetchedObjects?.count ?? 0
    if items == 0 {
      showWatermark()
    } else {
      removeWatermark()
    }
    return items
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
    delete.image = Constants.ItemActions.delete.getImage()
    delete.backgroundColor = ColorStyles.accent
    move.image = Constants.ItemActions.move.getImage()
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
        hold.image = Constants.ItemActions.hold.getUnholdImage()
      } else {
        hold.image = Constants.ItemActions.hold.getImage()
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
          store.complete(task: item)
        } else if doneSetting == .delete {
          store.delete(item: item)
        }
        self?.radio?.playItemComplete()
      }
      store.save()
      success(true)
      self?.showToast(from: .bottom, with: ToastMessages.getPositiveMessage())
    }
    if itemState == .done {
      complete.image = Constants.ItemActions.complete.getUnCompleteImage()
    } else {
      complete.image = Constants.ItemActions.complete.getImage()
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
      let text = (item.title ?? "") +
        (item.repeating == true ? " \(Constants.TextParseKeywords.repeatTask.rawValue)" : "") +
        (item.priority == true ? " \(Constants.TextParseKeywords.priority.rawValue)" : "") +
        (item.colorTag != nil ? " \(item.colorTag!)" : "")
      entryField.text = text
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
  
  private func saveTask(text: String, in list: Bucket) {
    let store = Store(testing: false)
    var task: String = text
    var repeating = false
    var priority = false
    var color: String?
    
    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      stopEditing()
      return
    }
    
    if IAPStore.shared.isProUser() {
      if let result = TaskTextParser.isRepeatingTask(from: task) {
        repeating = result.repeating
        task = result.text
      }
      if let result = TaskTextParser.isPriorityTask(from: task) {
        priority = result.priority
        task = result.text
      }
    }
    
    // testing color tagging
    if let result = TaskTextParser.hasColorTag(from: task) {
      color = result.color
      task = result.text
    }
    // end test
    
    if let item = editingExistingItem {
      item.repeating = repeating
      item.priority = priority
      item.colorTag = color
      store.updateExisting(item: item, withTitle: task, in: list)
    } else {
      store.addNewItem(text: task, in: list, repeating: repeating, priority: priority, color: color)
    }
    store.save()
    stopEditing()
    toastTask(in: list)
  }
  
  @objc func bucketSelectTapped(sender: UIBarButtonItem) {
    guard let text = self.entryField.text else {
      stopEditing()
      return
    }
    guard let bucket = Bucket(rawValue: sender.title!.lowercased()) else { return }
    saveTask(text: text, in: bucket)
  }
  
  func toastTask(in list: Bucket) {
    let currentBucket = Bucket(rawValue: self.title!.lowercased())
    if currentBucket != list {
      showToast(from: .bottom, with: "Scheduled for \(list.rawValue.capitalized)")
    }
    if list == Bucket.today {
      requestBadgeAuthorization()
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
  
  func doneTapped(with text: String) {
    var bucket: Bucket = Bucket(rawValue: self.title!.lowercased())!
    var task: String = text
    if let result = TaskTextParser.parseEntry(from: task) {
      bucket = Bucket(rawValue: result.list)!
      task = result.task
    }
    saveTask(text: task, in: bucket)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text {
      doneTapped(with: text)
    }
    return true
  }
}
