//
//  SettingsCells.swift
//  ToToLa
//
//  Created by Drew Lanning on 4/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
// THIS CONTAINS ALL 3 SETTING CELL SUBCLASSES
// MARK: DONE CELL

class DoneCell: UITableViewCell, SettingsCell {
  
  @IBOutlet weak var doneSettingSegmented: UISegmentedControl!
  @IBOutlet weak var helpTextLbl: UILabel!
  @IBOutlet weak var background: UIView!
  
  enum SelectedSegment: Int {
    case strikethrough = 0, delete
  }

  enum HelpText: String {
    case delete = #"Items are deleted as soon as you mark them as "Complete"."#
    case strikethrough = #"Completed items are kept but struck through, then deleted automatically during the "Bucket Change" each night."#
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configure()
  }
  
  func configure() {
    let doneSetting = Settings.defaults.integer(forKey: UserDefaultKeys.doneSetting.rawValue)
    doneSettingSegmented.selectedSegmentIndex = doneSetting
    setHelpText()
    styleViews()
  }
  
  func styleViews() {
    self.background.layer.cornerRadius = 4.0
    self.background.backgroundColor = ColorStyles.secondary.withAlphaComponent(0.1)
  }
  
  func updateSettings() {
    Settings.defaults.set(doneSettingSegmented.selectedSegmentIndex, forKey: UserDefaultKeys.doneSetting.rawValue)
  }
  
  internal func setHelpText() {
    if doneSettingSegmented.selectedSegmentIndex == SelectedSegment.delete.rawValue {
      helpTextLbl.text = HelpText.delete.rawValue
    } else {
      helpTextLbl.text = HelpText.strikethrough.rawValue
    }
  }
  
  @IBAction func selectionChanged(sender: UISegmentedControl) {
    updateSettings()
    setHelpText()
  }
}

// MARK: BADGE CELL
class BadgeCell: UITableViewCell, SettingsCell {
  
  @IBOutlet weak var badgeSettingSegmented: UISegmentedControl!
  @IBOutlet weak var helpTextLbl: UILabel!
  @IBOutlet weak var background: UIView!
  
  enum SelectedSegment: Int {
    case all = 0, overdue, none
  }
  
  enum HelpText: String {
    case all = #"All incomplete "Today" items are included in badge count."#
    case overdue = #"Only "Overdue" items show up in badge count."#
    case none = "No badge."
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configure()
  }
  
  func configure() {
    let badgeSetting = Settings.defaults.integer(forKey: UserDefaultKeys.badgeSetting.rawValue)
    badgeSettingSegmented.selectedSegmentIndex = badgeSetting
    setHelpText()
    styleViews()
  }
  
  func styleViews() {
    self.background.layer.cornerRadius = 4.0
    self.background.backgroundColor = ColorStyles.secondary.withAlphaComponent(0.1)
  }
  
  func updateSettings() {
    Settings.defaults.set(badgeSettingSegmented.selectedSegmentIndex, forKey: UserDefaultKeys.badgeSetting.rawValue)
  }
  
  internal func setHelpText() {
    let index = badgeSettingSegmented.selectedSegmentIndex
    if index == SelectedSegment.all.rawValue {
      helpTextLbl.text = HelpText.all.rawValue
    } else if index == SelectedSegment.overdue.rawValue {
      helpTextLbl.text = HelpText.overdue.rawValue
    } else {
      helpTextLbl.text = HelpText.none.rawValue
    }
  }
  
  @IBAction func selectionChanged(sender: UISegmentedControl) {
    updateSettings()
    setHelpText()
  }
}

// MARK: HOLD CELL
class HoldCell: UITableViewCell, SettingsCell {
  
  @IBOutlet weak var alwaysAskSwitch: UISwitch!
  @IBOutlet weak var holdSettingSegmented: UISegmentedControl!
  @IBOutlet weak var helpTextLbl: UILabel!
  @IBOutlet weak var background: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configure()
  }
  
  func configure() {
    let alwaysAsk = Settings.defaults.bool(forKey: UserDefaultKeys.alwaysAsk.rawValue)
    alwaysAskSwitch.isOn = alwaysAsk
    holdSettingSegmented.isEnabled = !alwaysAsk
    if !alwaysAsk {
      let badgeSetting = Settings.defaults.integer(forKey: UserDefaultKeys.holdSetting.rawValue)
      holdSettingSegmented.selectedSegmentIndex = badgeSetting
    }
    setHelpText()
    styleViews()
  }
  
  func styleViews() {
    self.background.layer.cornerRadius = 4.0
    self.background.backgroundColor = ColorStyles.secondary.withAlphaComponent(0.1)
  }
  
  func updateSettings() {
    let defaults = Settings.defaults
    defaults.set(alwaysAskSwitch.isOn, forKey: UserDefaultKeys.alwaysAsk.rawValue)
    holdSettingSegmented.isEnabled = !alwaysAskSwitch.isOn
    if alwaysAskSwitch.isOn == false {
      defaults.set(holdSettingSegmented.selectedSegmentIndex, forKey: UserDefaultKeys.holdSetting.rawValue)
    }
  }
  
  internal func setHelpText() {
    if alwaysAskSwitch.isOn {
      helpTextLbl.text = #"Always ask how long to lock an item."#
    } else if holdSettingSegmented.selectedSegmentIndex == 5 {
      helpTextLbl.text = #""Locked" items stay locked until I unlock them."#
    } else {
      let days = holdSettingSegmented.selectedSegmentIndex + 1
      helpTextLbl.text = #""Locked" items stay locked for \#(days) day\#(days > 1 ? "s" : "")."#
    }
  }
  
  @IBAction func switchChanged(sender: UISwitch) {
    updateSettings()
    setHelpText()
  }
  
  @IBAction func selectionChanged(sender: UISegmentedControl) {
    updateSettings()
    setHelpText()
  }
}
