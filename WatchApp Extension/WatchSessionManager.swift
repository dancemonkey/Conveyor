//
//  WatchSessionManager.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchConnectivity
import ClockKit

class WatchSessionManager: NSObject, WCSessionDelegate {
  
  static let shared = WatchSessionManager()
  
  private override init() {
    super.init()
  }
  
  private let session : WCSession = WCSession.default
  
  var contextDelegate: ContextUpdater?
  
  func startSession() {
    session.delegate = self
    session.activate()
    print("session activated")
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if activationState == .activated {
      requestContext { (reply) in
        WatchStore.shared.updateData(with: reply)
//        self.updateComplications()
      }
    }
  }
  
//  func updateComplications() {
//    print("updating complications")
//    let server = CLKComplicationServer.sharedInstance()
//    guard let comps = server.activeComplications, comps.count > 0 else {
//      return
//    }
//    for comp in comps {
//      server.reloadTimeline(for: comp)
//    }
//  }
  
}

extension WatchSessionManager {
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    print("received new context")
    WatchStore.shared.updateData(with: applicationContext)
    contextDelegate?.refresh()
//    self.updateComplications()
  }
  
  func requestContext(handle: @escaping (_ reply: [String: Any]) -> ()) {
    self.session.sendMessage([Constants.WatchMessageKeys.request.rawValue : "fullContext"], replyHandler: { (reply) in
      handle(reply)
    }) { (error) in
      print(error)
    }
  }
  
  func sendTaskCompletion(for task: WatchTask?) {
    guard let completedTask = task else { return }
    let message: [String: Any] = [Constants.WatchMessageKeys.completedTask.rawValue: completedTask.id as Any]
    self.session.sendMessage(message, replyHandler: nil) { (error) in
      print(error)
    }
  }
  
  func sendTaskReschedule(for task: WatchTask?, newList: Bucket) {
    guard let updatedTask = task else { return }
    let message: [String: Any] = [Constants.WatchMessageKeys.rescheduledTask.rawValue: updatedTask.id as Any, Constants.WatchMessageKeys.newTaskList.rawValue: newList.rawValue]
    self.session.sendMessage(message, replyHandler: nil) { (error) in
      print(error)
    }
  }
  
  func sendNew(task: WatchTask?, in list: Bucket) {
    guard let newTask = task else {
      print("no new task to send")
      return
    }
    let message: [String: Any] = [Constants.WatchMessageKeys.newTask.rawValue: newTask.title, Constants.WatchMessageKeys.newTaskList.rawValue: list.rawValue]
    print("message sending: \(message)")
    self.session.sendMessage(message, replyHandler: nil) { (error) in
      print(error)
    }
  }
  
}
