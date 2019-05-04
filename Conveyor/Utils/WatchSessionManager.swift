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
    print("starting session")
    session?.delegate = self
    session?.activate()
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if activationState == .activated {
      print("session activated")
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
    print("building context")
    let store = Store(testing: false)
    let today = store.getTodaysTasks()
    var context: [String: Any] = [:]
    for (index, item) in today.enumerated() {
      context["item\(index)"] = item.getContextItem()
    }
    print("context:")
    print(context)
    return context
  }
  
  func updateApplicationContext(context: [String: Any]) throws {
    print("session is valid: \(validSession)")
    if let session = validSession {
      do {
        try session.updateApplicationContext(context)
        print("updating context")
      } catch {
        throw error
      }
    }
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    if message["request"] != nil {
      let fullContext: [String: Any] = self.buildContext()
      replyHandler(fullContext)
    }
  }
}
