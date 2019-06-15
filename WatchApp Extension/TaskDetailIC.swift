//
//  TaskDetailIC.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchKit
import Foundation

class TaskDetailIC: WKInterfaceController {

  @IBOutlet var taskTitleLbl: WKInterfaceLabel!
  var task: WatchTask?
  var updateDelegate: ItemUpdateDelegate?
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    guard let cxt = context as? TaskContext else {
      print("did not find context")
      return
    }
    self.task = cxt.object
    self.updateDelegate = cxt.delegate
    taskTitleLbl.setText(task?.title ?? "NO TASK THIS IS AWFUL")
  }
  
  @IBAction func reschedule(sender: WKInterfaceButton) {
    let tomorrow = WKAlertAction(title: "Tomorrow", style: .default) {
      self.updateDelegate?.reschedule(item: self.task, newList: .tomorrow)
      self.pop()
    }
    let later = WKAlertAction(title: "Later", style: .default) {
      self.updateDelegate?.reschedule(item: self.task, newList: .later)
      self.pop()
    }
    presentAlert(withTitle: "Reschedule Task", message: nil, preferredStyle: .actionSheet, actions: [tomorrow, later])
  }
  
  @IBAction func complete(sender: WKInterfaceButton) {
    task?.setDone()
    updateDelegate?.complete(item: task)
    self.pop()
  }
  
}
