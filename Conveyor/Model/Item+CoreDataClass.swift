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

@objc(Item)
public class Item: NSManagedObject {
  
  let generator = UINotificationFeedbackGenerator()

  func complete(fromExtension: Bool = false) {
    if fromExtension && self.repeating {
      let context = self.managedObjectContext!
      let item = Item(entity: NSEntityDescription.entity(forEntityName: "Item", in: context)!, insertInto: context)
      item.bucket = Bucket.tomorrow.rawValue
      item.state = ItemState.none.rawValue
      item.title = self.title
      item.creation = self.creation
      item.repeating = true
      item.colorTag = self.colorTag
      do {
        try context.save()
      } catch {
        print(error)
      }
    }
    self.bucket = Bucket.today.rawValue
    self.state = ItemState.done.rawValue
    self.repeating = false
    generator.notificationOccurred(.success)
  }
  
  func unComplete() {
    self.state = ItemState.none.rawValue
    generator.notificationOccurred(.success)
  }
  
  func change(to newBucket: Bucket) {
    self.bucket = newBucket.rawValue
    self.change(to: .none)
    generator.notificationOccurred(.success)
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
    generator.notificationOccurred(.success)
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
  
  func getContextItem() -> [String: String] {
    return [
      Constants.ItemContextFields.title.rawValue: self.title ?? "",
      Constants.ItemContextFields.state.rawValue: self.state ?? "",
      Constants.ItemContextFields.id.rawValue: self.objectID.uriRepresentation().absoluteString,
      Constants.ItemContextFields.priority.rawValue: self.priority.description,
      Constants.ItemContextFields.repeating.rawValue: self.repeating.description,
      Constants.ItemContextFields.colorTag.rawValue: self.colorTag ?? "@clear"
    ]
  }
  
  func getColorTag() -> UIColor {
    guard let color = self.colorTag else { return .clear }
    switch color {
    case "@black":
      return .black
    case "@blue":
      return .blue
    case "@brown":
      return .brown
    case "@cyan":
      return .cyan
    case "@gray":
      return .gray
    case "@green":
      return .green
    case "@magenta":
      return .magenta
    case "@orange":
      return .orange
    case "@purple":
      return .purple
    case "@red":
      return .red
    case "@yellow":
      return .yellow
    case "@white":
      return .white
    default:
      return .clear
    }
  }
}
