//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, ContextUpdater {
  
  @IBOutlet var table: WKInterfaceTable!
  @IBOutlet var todayLbl: WKInterfaceLabel!
  var data: [WatchTask] = []
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    WatchSessionManager.shared.contextDelegate = self
    WatchSessionManager.shared.startSession()
  }
  
  override func willActivate() {
    super.willActivate()
    WatchSessionManager.shared.contextDelegate = self
  }
  
  override func didDeactivate() {
    super.didDeactivate()
  }
  
  func refresh() {
    self.data = WatchStore.shared.data
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
