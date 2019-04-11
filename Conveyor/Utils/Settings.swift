//
//  Settings.swift
//  ToToLa
//
//  Created by Drew Lanning on 4/5/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

enum BadgeOption: Int {
  case all = 0, overdue, none
}

enum LockOption: Int {
  case one = 0, two, three, four, five, forever, ask
}

enum DoneOption: Int {
  case strikethrough = 0, delete
}

enum UserDefaultKeys: String {
  case doneSetting, badgeSetting, alwaysAsk, holdSetting, everLaunched
}

class Settings {
  
  static var defaults: UserDefaults {
    get {
      return {
        UserDefaults(suiteName: GroupName.value.rawValue)!
        }()
    }
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
}
