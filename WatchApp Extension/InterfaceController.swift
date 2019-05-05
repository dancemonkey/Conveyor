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
  var didReceiveData: Bool = false
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    WatchSessionManager.shared.contextDelegate = self
    WatchSessionManager.shared.startSession()
    resetTable()
    if !didReceiveData {
      WatchSessionManager.shared.requestContext { (reply) in
        print("handling reply from device")
        self.update(with: reply)
        self.didReceiveData = true
      }
    }
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    WatchSessionManager.shared.contextDelegate = self
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
//    WatchSessionManager.shared.contextDelegate = nil
  }
  
  func refresh() {
    resetTable()
  }
  
  func resetTable() {
    print("setting the table with data: \(data)")
    table.setNumberOfRows(data.count, withRowType: "taskRow")
    for i in 0 ..< table.numberOfRows {
      guard let controller = table.rowController(at: i) as? RowController else { continue }
      controller.itemLabel.setText(data[i].title)
      if data[i].status == .overdue {
        controller.itemLabel.setTextColor(.red)
      } else {
        controller.itemLabel.setTextColor(ColorStyles.blackText)
      }
    }
  }
  
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    WatchSessionManager.shared.sendTaskCompletion(for: data[rowIndex])
    data.remove(at: rowIndex)
    resetTable()
  }
  
}

extension InterfaceController: ContextUpdater {
  func update(with context: [String : Any]) {
    print("updating context")
    didReceiveData = true
    var newData: [WatchTask] = []
    for (_, contextItem) in context {
      print("found item in context")
      if let item = WatchTask.getItem(from: contextItem as! [String : String]) {
        newData.append(item)
        print(item)
      }
    }
    print("newData: \(newData)")
    data = newData
    print("data: \(data)")
    resetTable()
  }
}
