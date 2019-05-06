//
//  WatchSessionManager.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
  
  static let shared = WatchSessionManager()
  private override init() {
    super.init()
  }
  private let session : WCSession = WCSession.default
  func startSession() {
    session.delegate = self
    session.activate()
  }
  var contextDelegate: ContextUpdater?
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if activationState == .activated {
      requestContext { (reply) in
        WatchStore.shared.updateData(with: reply)
        self.contextDelegate?.refresh()
      }
    }
  }
  
}

extension WatchSessionManager {
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    print("received context")
//    contextDelegate?.update(with: applicationContext)
    WatchStore.shared.updateData(with: applicationContext)
    contextDelegate?.refresh()
  }
  
  func requestContext(handle: @escaping (_ reply: [String: Any]) -> ()) {
    self.session.sendMessage([Constants.WatchMessageKeys.request.rawValue : "fullContext"], replyHandler: { (reply) in
      print("sending message to get full context from device")
      handle(reply)
    }) { (error) in
      print(error)
    }
  }
  
  func sendTaskCompletion(for task: WatchTask) {
    let message: [String: Any] = [Constants.WatchMessageKeys.completedTask.rawValue: task.id]
    print("sending task completion: \(message)")
    self.session.sendMessage(message, replyHandler: nil) { (error) in
      print(error)
    }
  }
  
}
