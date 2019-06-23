//
//  WatchStore.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/6/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation
import WatchKit
import ClockKit

class WatchStore {
  static let shared = WatchStore()
  var data: [WatchTask] = []
  
  func updateData(with reply: [String: Any]) {
    var newData: [WatchTask] = []
    for (_, contextItem) in reply {
      if let item = WatchTask.getItem(from: contextItem as! [String: String]) {
        newData.append(item)
      }
    }
    newData.sort { (task1, task2) -> Bool in
      return task1.title < task2.title
    }
    self.data = newData.sorted(by: { (task1, task2) -> Bool in
      if task1.priority != task2.priority {
        return task1.priority == true && task2.priority == false
      } else {
        return task1.status == .overdue && task2.status != .overdue
      }
    })
    self.updateComplications()
  }
  
  func updateComplications() {
    let server = CLKComplicationServer.sharedInstance()
    guard let comps = server.activeComplications, comps.count > 0 else {
      return
    }
    for comp in comps {
      server.reloadTimeline(for: comp)
    }
  }
  
  func tasksDueToday() -> Int {
    return data.count
  }
  
  func nextTaskDue() -> WatchTask? {
    return data.first
  }
  
  func topThreeTasksDue() -> [WatchTask]? {
    guard tasksDueToday() > 0 else { return nil }
    return data
  }
}
