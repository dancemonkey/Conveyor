//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchKit
import Foundation
import ClockKit

class InterfaceController: WKInterfaceController, ContextUpdater {
  
  @IBOutlet var table: WKInterfaceTable!
  @IBOutlet var todayLbl: WKInterfaceLabel!
  @IBOutlet var tableGrp: WKInterfaceGroup!
  @IBOutlet var newItemBtn: WKInterfaceButton!

  var data: [WatchTask] = []
  var watermarkImage: UIImage?
  var receivedRecentData = false
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    WatchSessionManager.shared.contextDelegate = self
    
    if data.isEmpty, receivedRecentData == false {
      WatchSessionManager.shared.requestContext { (context) in
        WatchStore.shared.updateData(with: context)
        self.receivedRecentData = true
      }
    }
    
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
    reloadComplications()
  }
  
  func reloadComplications() {
    let server = CLKComplicationServer.sharedInstance()
    guard let comps = server.activeComplications, comps.count > 0 else {
      return
    }
    for comp in comps {
      server.reloadTimeline(for: comp)
    }
  }
  
  func resetTable() {
    if data.count == 0 {
      table.setNumberOfRows(1, withRowType: "noTasksRow")
    } else {
      table.setNumberOfRows(data.count, withRowType: "taskRow")
      for i in 0 ..< table.numberOfRows {
        guard let controller = table.rowController(at: i) as? RowController else { continue }
        controller.priorityIconGroup.setHidden(!data[i].priority)
        controller.repeatIconGroup.setHidden(!data[i].repeating)
        controller.taskCompletion = {
          WatchSessionManager.shared.sendTaskCompletion(for: self.data[i])
          WatchStore.shared.data.removeAll { (task) -> Bool in
            task.id == self.data[i].id
          }
          self.refresh()
          self.reloadComplications()
        }
        controller.itemLabel.setText(data[i].title)
        if data[i].status == .overdue {
          controller.itemLabel.setTextColor(.red)
        } else {
          controller.itemLabel.setTextColor(ColorStyles.textColor)
        }
      }
    }
  }
  
  override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
    let context = TaskContext()
    context.object = data[rowIndex]
    context.delegate = self
    return context
  }
  
  @IBAction func addNewItem(sender: WKInterfaceButton) {
    presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji) { (input) in
      guard let taskText = input?.first else { return }
      if let result = TaskTextParser.parseEntry(from: taskText as! String) {
        let newTask = WatchTask(title: result.task, status: .none, id: nil, priority: false, repeating: false)
        let list = Bucket(rawValue: result.list)!
        WatchSessionManager.shared.sendNew(task: newTask, in: list)
      } else {
        let newTask = WatchTask(title: taskText as! String, status: .none, id: nil, priority: false, repeating: false)
        WatchSessionManager.shared.sendNew(task: newTask, in: .today)
      }
      self.dismissTextInputController()
    }
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
    reloadComplications()
  }
  
  func reschedule(item: WatchTask?, newList: Bucket) {
    guard let updatedTask = item else { return }
    WatchSessionManager.shared.sendTaskReschedule(for: item, newList: newList)
    WatchStore.shared.data.removeAll { (task) -> Bool in
      task.id == updatedTask.id
    }
    refresh()
    reloadComplications()
  }
}
