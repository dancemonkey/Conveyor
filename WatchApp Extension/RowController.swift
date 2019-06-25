//
//  RowController.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/1/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import WatchKit

class RowController: NSObject {
  @IBOutlet weak var itemLabel: WKInterfaceLabel!
  @IBOutlet weak var priorityIcon: WKImage!
  @IBOutlet weak var repeatIcon: WKImage!
  @IBOutlet weak var repeatIconGroup: WKInterfaceGroup!
  @IBOutlet weak var priorityIconGroup: WKInterfaceGroup!
}
