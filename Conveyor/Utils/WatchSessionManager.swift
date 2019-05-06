//
//  WatchSessionManager.swift
//  Conveyor
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
  private let session : WCSession? = WCSession.isSupported() ? WCSession.default : nil
  private var validSession : WCSession? {
    if let session = self.session, session.isPaired && session.isWatchAppInstalled {
      return session
    }
    return nil
  }
  func startSession() {
    session?.delegate = self
    session?.activate()
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if activationState == .activated {
      DispatchQueue.main.async {
        do {
          try self.updateApplicationContext(context: self.buildContext())
        } catch {
          print(error)
        }
      }
    }
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) { }
  
  func sessionDidDeactivate(_ session: WCSession) { }
}

extension WatchSessionManager {
  func buildContext() -> [String: Any] {
    let store = Store(testing: false)
    let today = store.getTodaysTasks()
    var context: [String: Any] = [:]
    for (index, item) in today.enumerated() {
      context["item\(index)"] = item.getContextItem()
    }
    return context
  }
  
  func updateApplicationContext(context: [String: Any]) throws {
    if let session = validSession {
      do {
        try session.updateApplicationContext(context)
      } catch {
        throw error
      }
    }
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    if message[Constants.WatchMessageKeys.completedTask.rawValue] != nil {
      if let taskId = message[Constants.WatchMessageKeys.completedTask.rawValue] as? String {
        DispatchQueue.main.async {
          let store = Store(testing: false)
          store.completeTask(byId: taskId)
        }
      }
    }
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    if message[Constants.WatchMessageKeys.request.rawValue] != nil {
      DispatchQueue.main.async {
        let fullContext: [String: Any] = self.buildContext()
        replyHandler(fullContext)
      }
    }
  }
}
