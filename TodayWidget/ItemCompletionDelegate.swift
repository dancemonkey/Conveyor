//
//  ItemCompletionDelegate.swift
//  TodayWidget
//
//  Created by Drew Lanning on 4/11/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

protocol ItemCompleter {
  func complete(item: Item)
}
