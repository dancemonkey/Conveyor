//
//  ViewController.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    if INPreferences.siriAuthorizationStatus() == .notDetermined {
      INPreferences.requestSiriAuthorization { (status) in
        if status == .authorized {
          print("siri authorized")
        }
      }
    }
    // Do any additional setup after loading the view.
  }


}

