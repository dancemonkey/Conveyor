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
      print("session active")
    }
  }
  
}

extension WatchSessionManager {
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    contextDelegate?.update(with: applicationContext)
  }
}
