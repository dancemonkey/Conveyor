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
  
  func sortData() {
    data.sort { (task1, task2) -> Bool in
      task1.priority == true && task2.priority == false
    }
  }
  
  func resetTable() {
    table.setNumberOfRows(data.count, withRowType: "taskRow")
    sortData()
    for i in 0 ..< table.numberOfRows {
      guard let controller = table.rowController(at: i) as? RowController else { continue }
      controller.itemLabel.setText(data[i].title)
      if data[i].status == .overdue {
        controller.itemLabel.setTextColor(.red)
      } else {
        controller.itemLabel.setTextColor(ColorStyles.textColor)
      }
  
      controller.priorityIconGroup.setHidden(!data[i].priority)
      controller.repeatIconGroup.setHidden(!data[i].repeating)
    }
  }
  
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    let context = TaskContext()
    context.object = data[rowIndex]
    context.delegate = self
    return context
  }
}

extension InterfaceController: ItemUpdateDelegate {
  func complete(item: WatchTask?) {
    guard let completeTask = item else { return }
    WatchSessionManager.shared.sendTaskCompletion(for: completeTask)
    WatchStore.shared.data.removeAll { (task) -> Bool in
      task.id == completeTask.id
    }
    refresh()
  }
  
  func reschedule(item: WatchTask?, newList: Bucket) {
    guard let updatedTask = item else { return }
    // create reschedule message in session manager
    WatchSessionManager.shared.sendTaskReschedule(for: item, newList: newList)
    WatchStore.shared.data.removeAll { (task) -> Bool in
      task.id == updatedTask.id
    }
    refresh()
  }
}
