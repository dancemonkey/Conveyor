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
    case badge, lockingItems, completedItems
    
    func getTitle() -> String {
      switch self {
      case .badge:
        return "Badge Options"
      case .lockingItems:
        return "Item Lock Options"
      case .completedItems:
        return "Item Completion Options"
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
      }
    }
  }
  
  enum InfoSettingsOptions: CaseIterable {
//    case iap, support, review, onBoarding
    case support, review, help, upgrade
    
    func getTitle() -> String {
      switch self {
      case .support:
        return "Email \(Constants.supportEmail)"
//      case .iap:
//        return "Additional Features (IAP)"
      case .review:
        return "Review on App Store"
//      case .onBoarding:
//        return "See Onboarding Again"
      case .upgrade:
        return "Unlock / Pro Features!"
      case .help:
        return "Help"
      }
    }
    
    func getSegueId() -> String {
      switch self {
      case .support:
        return "showSupport"
//      case .iap:
//        return "showIAP"
      case .review:
        return "showReview"
//      case .onBoarding:
//        return ""
      case .upgrade:
        return "showIAP"
      case .help:
        return "showHelp"
      }
    }
  }
  
//  enum HelpOptionLinks: CaseIterable {
//    case faq, support, guide
//    
//    func getTitle() -> String {
//      switch self {
//      case .faq:
//        return "Frequently Asked Questions"
//      case .support:
//        return "Technical Support"
//      case .guide:
//        return "User Guide"
//      }
//    }
//    
//    func getSegueId() -> String {
//      switch self {
//      case .faq:
//        return "showFAQ"
//      case .support:
//        return "showSupport"
//      case .guide:
//        return "showGuide"
//      }
//    }
//  }
  
  static var defaults: UserDefaults {
    get {
      return {
        UserDefaults(suiteName: Constants.GroupName.value.rawValue)!
        }()
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
