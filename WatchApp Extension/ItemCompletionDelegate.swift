//
//  ItemCompletionDelegate.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

protocol ItemUpdateDelegate {
  func complete(item: WatchTask?)
  func reschedule(item: WatchTask?, newList: Bucket)
}
