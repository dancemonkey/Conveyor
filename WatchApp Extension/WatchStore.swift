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
  var didReceiveData: Bool = false
  
  func updateData(with reply: [String: Any]) {
    didReceiveData = true
    print("updating data")
    var newData: [WatchTask] = []
    for (_, contextItem) in reply {
      if let item = WatchTask.getItem(from: contextItem as! [String: String]) {
        newData.append(item)
      }
    }
    self.data = newData.sorted(by: { (task1, task2) -> Bool in
      task1.priority == true && task2.priority == false
    })
//    self.updateComplications()
  }
  
  func updateComplications() {
    print("updating complications")
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
}
