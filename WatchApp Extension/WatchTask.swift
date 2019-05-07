//
//  WatchTask.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

struct WatchTask {
  
  var title: String
  var status: ItemState
  var id: String
  
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
      Constants.ItemContextFields.id.rawValue: self.id
    ]
  }
  
  static func getItem(from context: [String: String]) -> WatchTask? {
    if
      let title = context[Constants.ItemContextFields.title.rawValue],
      let status = context[Constants.ItemContextFields.state.rawValue],
      let id = context[Constants.ItemContextFields.id.rawValue]
    {
      let stat = ItemState(rawValue: status)!
      return WatchTask(title: title, status: stat, id: id)
    } else {
      return nil
    }
  }
  
}
