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
  var data: [WatchTask] = []
  var watermarkImage: UIImage?
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    WatchSessionManager.shared.contextDelegate = self
    watermarkImage = UIImage(named: "watchWatermark")
//    WatchSessionManager.shared.startSession()
  }
  
  override func willActivate() {
    super.willActivate()
    WatchSessionManager.shared.contextDelegate = self
  }
  
  override func didDeactivate() {
    super.didDeactivate()
  }
  
  func refresh() {
    print("refreshing interface controller")
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
    table.setNumberOfRows(data.count, withRowType: "taskRow")
    for i in 0 ..< table.numberOfRows {
      guard let controller = table.rowController(at: i) as? RowController else { continue }
      controller.priorityIconGroup.setHidden(!data[i].priority)
      controller.repeatIconGroup.setHidden(!data[i].repeating)
      controller.itemLabel.setText(data[i].title)
      if data[i].status == .overdue {
        controller.itemLabel.setTextColor(.red)
      } else {
        controller.itemLabel.setTextColor(ColorStyles.textColor)
      }
    }
    
    if table.numberOfRows > 0 {
      tableGrp.setBackgroundImage(nil)
    } else {
      tableGrp.setBackgroundImage(watermarkImage)
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
