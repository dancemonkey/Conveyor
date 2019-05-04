//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var table: WKInterfaceTable!
  @IBOutlet var todayLbl: WKInterfaceLabel!
  var data: [WatchTask] = []
  var sessionManager = WatchSessionManager.shared
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    sessionManager.contextDelegate = self
    sessionManager.startSession()
    // Configure interface objects here.
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
    sessionManager.contextDelegate = nil
  }
  
  func resetTable() {
    table.setNumberOfRows(data.count, withRowType: "taskRow")
    for i in 0 ..< table.numberOfRows {
      guard let controller = table.rowController(at: i) as? RowController else { continue }
      controller.itemLabel.setText(data[i].title)
      if data[i].status == .overdue {
        controller.itemLabel.setTextColor(.red)
      } else {
        controller.itemLabel.setTextColor(.white)
      }
    }
  }
  
}

extension InterfaceController: ContextUpdater {
  func update(with context: [String : Any]) {
    var newData: [WatchTask] = []
    for (_, contextItem) in context {
      if let item = WatchTask.getItem(from: contextItem as! [String : String]) {
        newData.append(item)
      }
      data = newData
    }
  }
}
