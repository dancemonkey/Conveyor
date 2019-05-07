//
//  TaskContext.swift
//  WatchApp Extension
//
//  Created by Drew Lanning on 5/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

protocol Context {
  associatedtype DelegateType
  associatedtype ObjectType
  var delegate: DelegateType? { get set }
  var object: ObjectType? { get set }
}

class TaskContext: Context {
  typealias DelegateType = ItemUpdateDelegate
  typealias ObjectType = WatchTask
  var delegate: ItemUpdateDelegate?
  var object: WatchTask?
}
