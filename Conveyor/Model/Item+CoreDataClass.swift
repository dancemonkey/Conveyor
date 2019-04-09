//
//  Item+CoreDataClass.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//
//

import UIKit
import CoreData

enum Bucket: String {
  case today
  case tomorrow
  case later
}

@objc(Item)
public class Item: NSManagedObject {
  
  //  var isOverdue: Bool {
  //    get {
  //      guard let bucket = Bucket(rawValue: self.bucket ?? "") else { return false }
  //      if bucket == .today {
  //        guard let changeDate = Store().getNextBucketChange() else { return false }
  //        if changeDate < Date() {
  //          return true
  //        }
  //      }
  //      return false
  //    }
  //  }
  
  //  var isOverDue: Bool = false
  
  func complete() {
    self.bucket = Bucket.today.rawValue
    self.state = ItemState.done.rawValue
  }
  
  func unComplete() {
    self.state = ItemState.none.rawValue
  }
  
  func change(to newBucket: Bucket) {
    self.bucket = newBucket.rawValue
    self.change(to: .none)
  }
  
  func change(to newState: ItemState) {
    self.state = newState.rawValue
  }
  
  func hold(forever: Bool, or days: Int?) {
    self.bucket = Bucket.later.rawValue
    self.state = ItemState.held.rawValue
    self.holdForever = forever
    if let holdDays = days {
      self.holdDays = Int16(holdDays)
    } else {
      self.holdDays = 0
    }
  }
  
  func unHold() {
    self.state = ItemState.none.rawValue
  }
  
  func changeBuckets() {
    guard let currentBucket = Bucket(rawValue: self.bucket ?? "") else { return }
    guard let currentState = ItemState(rawValue: self.state ?? "") else { return }
    switch currentBucket {
    case .today where currentState == .none || currentState == .overdue:
      self.state = ItemState.overdue.rawValue
    case .today where currentState == .done:
      self.managedObjectContext?.delete(self)
    case .tomorrow:
      self.bucket = Bucket.today.rawValue
      self.state = ItemState.none.rawValue
    case .later where currentState != .held:
      self.bucket = Bucket.tomorrow.rawValue
      self.state = ItemState.none.rawValue
    case .later where currentState == .held:
      if self.holdForever == true {
        self.bucket = currentBucket.rawValue
        self.state = currentState.rawValue
      } else if self.holdForever == false {
        if self.holdDays > 0 {
          self.holdDays = self.holdDays - 1
          if self.holdDays == 0 {
            self.state = ItemState.none.rawValue
          }
        } else if self.holdDays <= 0 {
          self.state = ItemState.none.rawValue
          self.holdDays = 0
        }
      }
    default:
      self.bucket = currentBucket.rawValue
      self.state = currentState.rawValue
    }
    do {
      try self.managedObjectContext?.save()
    } catch {
      print(error)
    }
  }
}
