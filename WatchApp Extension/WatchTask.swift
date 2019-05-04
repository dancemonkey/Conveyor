//
//  WatchTask.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

enum Status: String {
  case incomplete, complete, overdue
}

struct WatchTask {
  
  var title: String
  var status: Status
  var id: String?
  
  mutating func setDone() {
    if self.status == .incomplete || self.status == .overdue {
      self.status = .complete
    } else {
      self.status = .incomplete
    }
  }
  
  func getContext() -> (title: String, status: String, id: String?) {
    return (title: self.title, status: self.status.rawValue, id: self.id)
  }
  
  static func getItem(from context: [String: String]) -> WatchTask? {
    if let title = context[Constants.ItemContextFields.title.rawValue], let status = context[Constants.ItemContextFields.state.rawValue], let id = context[Constants.ItemContextFields.id.rawValue] {
      let stat = Status(rawValue: status)!
      return WatchTask(title: title, status: stat, id: id)
    } else {
      return nil
    }
  }
  
}
