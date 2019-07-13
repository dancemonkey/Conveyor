//
//  WatchTask.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation
import WatchKit

struct WatchTask {
  
  var title: String
  var status: ItemState
  var id: String?
  var priority: Bool = false
  var repeating: Bool = false
  var colorTag: String? = nil
  
  mutating func setDone() {
    if self.status == .none || self.status == .overdue {
      self.status = .done
    } else {
      self.status = .none
    }
  }
  
  func getContext() -> [String: String] {
    return [
      Constants.ItemContextFields.title.rawValue: self.title,
      Constants.ItemContextFields.state.rawValue: self.status.rawValue,
      Constants.ItemContextFields.id.rawValue: self.id ?? "",
      Constants.ItemContextFields.priority.rawValue: self.priority.description,
      Constants.ItemContextFields.repeating.rawValue: self.repeating.description
    ]
  }
  
  static func getItem(from context: [String: String]) -> WatchTask? {
    if
      let title = context[Constants.ItemContextFields.title.rawValue],
      let status = context[Constants.ItemContextFields.state.rawValue],
      let id = context[Constants.ItemContextFields.id.rawValue],
      let priority = Bool(context[Constants.ItemContextFields.priority.rawValue] ?? "false"),
      let repeating = Bool(context[Constants.ItemContextFields.repeating.rawValue] ?? "false"),
      let colorTag = context[Constants.ItemContextFields.colorTag.rawValue]
    {
      let stat = ItemState(rawValue: status)!
      return WatchTask(title: title, status: stat, id: id, priority: priority, repeating: repeating, colorTag: colorTag)
    } else {
      return nil
    }
  }
  
  func getColorTag() -> UIColor {
    guard let color = self.colorTag else { return .clear }
    switch color {
    case "@black":
      return .black
    case "@blue":
      return .blue
    case "@brown":
      return .brown
    case "@cyan":
      return .cyan
    case "@gray":
      return .gray
    case "@green":
      return .green
    case "@magenta":
      return .magenta
    case "@orange":
      return .orange
    case "@purple":
      return .purple
    case "@red":
      return .red
    case "@yellow":
      return .yellow
    case "@white":
      return .white
    default:
      return .clear
    }
  }
  
}
