//
//  Settings.swift
//  ToToLa
//
//  Created by Drew Lanning on 4/5/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

enum BadgeOption: Int, CaseIterable {
  case all = 0, overdue, none
}

enum LockOption: Int, CaseIterable {
  case one = 0, two, three, four, five, forever, ask
}

enum DoneOption: Int, CaseIterable {
  case strikethrough = 0, delete
}

enum UserDefaultKeys: String {
  case doneSetting, badgeSetting, alwaysAsk, holdSetting, everLaunched, didChangeObject
}

struct Settings {
  
  enum GeneralSettingsOptions: CaseIterable {
    case badge, lockingItems, completedItems, colorTags, darkMode
    
    func getTitle() -> String {
      switch self {
      case .badge:
        return "Badge Options"
      case .lockingItems:
        return "Task Lock Options"
      case .completedItems:
        return "Task Completion Options"
      case .colorTags:
        return "Color Tag Options"
      case .darkMode:
        return "Dark Mode"
      }
    }
    
    func getSegueId() -> String {
      switch self {
      case .badge:
        return "showBadgeOptions"
      case .lockingItems:
        return "showLockOptions"
      case .completedItems:
        return "showCompletionOptions"
      case .colorTags:
        return "showColorTagOptions"
      case .darkMode:
        return ""
      }
    }
  }
  
  enum InfoSettingsOptions: CaseIterable {
    case support, review, help, upgrade
    
    func getTitle() -> String {
      switch self {
      case .support:
        return "Email \(Constants.supportEmail)"
      case .review:
        return "Review on App Store"
      case .upgrade:
        return "Go Pro for new features!"
      case .help:
        return "Help"
      }
    }
    
    func getSegueId() -> String {
      switch self {
      case .support:
        return "showSupport"
      case .review:
        return "showReview"
      case .upgrade:
        return "showIAP"
      case .help:
        return "showHelp"
      }
    }
  }
  
  static var defaults: UserDefaults {
    get {
      return {
        UserDefaults(suiteName: Constants.GroupName.value.rawValue)!
        }()
    }
  }
  
  static var darkModeActive: Bool {
    get {
      return self.defaults.bool(forKey: Constants.DefaultKeys.darkModeActive.rawValue)
    }
  }
  
  static func setDarkMode(active: Bool) {
    self.defaults.set(active, forKey: Constants.DefaultKeys.darkModeActive.rawValue)
    NotificationCenter.default.post(name: .onDarkModeSelected, object: nil)
  }
  
  static var getUserColors: [String: String]? {
    get {
      return self.defaults.object(forKey: Constants.DefaultKeys.userDefinedColors.rawValue) as? [String: String]
    }
  }
  
  static func setAllUserColors(to value: [String: String]) {
    self.defaults.set(value, forKey: Constants.DefaultKeys.userDefinedColors.rawValue)
  }
 
  static func setUserColor(to value: (color: String, tag: String)) {
    var colors = self.getUserColors
    if colors != nil {
      colors![value.color] = value.tag
      setAllUserColors(to: colors!)
    } else {
      setAllUserColors(to: [value.color: value.tag])
    }
  }
  
  static var didChangeObject: Bool {
    return defaults.bool(forKey: UserDefaultKeys.didChangeObject.rawValue)
  }
  
  static func setFirstLaunchDefaults() {
    defaults.set(true, forKey: UserDefaultKeys.alwaysAsk.rawValue)
  }
  
  static func badgeOption() -> BadgeOption {
    let badgeSetting = defaults.integer(forKey: UserDefaultKeys.badgeSetting.rawValue)
    let badge = BadgeOption(rawValue: badgeSetting) ?? .all
    return badge
  }
  
  static func lockOption() -> LockOption {
    let askSetting = defaults.bool(forKey: UserDefaultKeys.alwaysAsk.rawValue)
    if askSetting {
      return .ask
    } else {
      let lockSetting = defaults.integer(forKey: UserDefaultKeys.holdSetting.rawValue)
      let lock = LockOption(rawValue: lockSetting) ?? .one
      return lock
    }
  }
  
  static func doneOption() -> DoneOption {
    let doneSetting = defaults.integer(forKey: UserDefaultKeys.doneSetting.rawValue)
    let done = DoneOption(rawValue: doneSetting) ?? .strikethrough
    return done
  }
  
  static func everLaunched() -> Bool {
    let launchedEver = defaults.bool(forKey: UserDefaultKeys.everLaunched.rawValue)
    if launchedEver == false {
      defaults.set(true, forKey: UserDefaultKeys.everLaunched.rawValue)
      return false
    }
    return true
  }
  
  static func didChangeObjectOn() {
    defaults.set(true, forKey: UserDefaultKeys.didChangeObject.rawValue)
  }
  
  static func didChangeObjectOff() {
    defaults.set(false, forKey: UserDefaultKeys.didChangeObject.rawValue)
  }
  
}
