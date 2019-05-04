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
      let store = Store()
      let today = store.getTodayContext()
      var context: [String: Any] = [:]
      for (index, item) in today.enumerated() {
        context["item\(index)"] = item.getContextItem()
      }
      do {
        try updateApplicationContext(context: context)
      } catch {
        print(error)
      }
    }
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) { }
  
  func sessionDidDeactivate(_ session: WCSession) { }
}

extension WatchSessionManager {
  func updateApplicationContext(context: [String: Any]) throws {
    if let session = validSession {
      do {
        try session.updateApplicationContext(context)
      } catch {
        throw error
      }
    }
  }
}
