//
//  Constants.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/6/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

struct Constants {
  static var supportEmail: String = "appSupport@drewlanning.com"
  
  enum DefaultKeys: String {
    case bucketChangeDate, hasLaunchedBefore, launchesThisVersion, filename, darkModeActive, whatsNew140, whatsNew150, userDefinedColors
  }
  
  enum SegueID: String {
    case showProUserDescription, showColorTagSelect
  }
  
  enum TextParseKeywords: String {
    case priority = "@!", repeatTask = "@rpt"
  }
  
  enum TextColorKeywords: String, CaseIterable {
    case black = "@black",
    blue = "@blue",
    brown = "@brown",
    cyan = "@cyan",
    gray = "@gray",
    green = "@green",
    magenta = "@magenta",
    orange = "@orange",
    purple = "@purple",
    red = "@red",
    white = "@white",
    yellow = "@yellow"
  }
  
  enum IAPProductIds: String {
    case smallTip = "com.DrewLanning.Conveyor.small",
    mediumTip = "com.DrewLanning.Conveyor.medium",
    largeTip = "com.DrewLanning.Conveyor.large",
    proUpgrade = "com.DrewLanning.Conveyor.proUpgrade"
  }
  
  enum GroupName: String {
    case value = "group.com.DrewLanning.conveyor"
  }
  
  enum ItemContextFields: String {
    case title, state, id, priority, repeating, colorTag
  }
  
  enum WatchMessageKeys: String {
    case request, completedTask, rescheduledTask, newTaskList, newTask
  }
  
  enum WatchInterfaces: String {
    case taskDetail
  }
  
  enum TableCellID: String {
    case todayCell, tomorrowCell, laterCell, settingsCell, badgeOptionCell, doneOptionCell, lockOptionCell, helpOptionCell, iapCell, colorOptionCell
  }
  
  enum ItemActions: String {
    case hold, move, delete, complete
    
    func getImage() -> UIImage {
      return UIImage(named: "\(self.rawValue)")!
    }
    
    func getUnCompleteImage() -> UIImage {
      return UIImage(named: "unComplete")!
    }
    
    func getUnholdImage() -> UIImage {
      return UIImage(named: "unLock")!
    }
  }
}
