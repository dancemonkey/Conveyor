//
//  Store.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class Store {
  
  // MARK: Test Init
  convenience init(testing: Bool) {
    self.init()
    self.testing = testing
    if !testing {
      container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    } else {
      container = self.mockContainer
    }
    context = container.viewContext
    context.stalenessInterval = 0
  }
  private var testing: Bool = false
  private var testingModel: NSManagedObjectModel = {
    let model = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    return model
  }()
  private lazy var mockContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreDataUnitTesting", managedObjectModel: self.testingModel)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in }
    return container
  }()
  
  // MARK: CoreData stack properties
  private var container: NSPersistentContainer!
  var context: NSManagedObjectContext!
  
  // MARK: Store service functions
  
  func save() {
    do {
      try context.save()
    } catch {
      print(error)
    }
  }
  
  func getNextBucketChange() -> Date? {
    let defaults = Settings.defaults
    let nextChange = defaults.object(forKey: Constants.DefaultKeys.bucketChangeDate.rawValue)
    return nextChange as? Date
  }
  
  func setNextBucketChange() {
    let defaults = Settings.defaults
    let cal = Calendar.current
    let tomorrow = cal.date(byAdding: .day, value: 1, to: Date())!
    let nextBucketChange = Calendar.current.startOfDay(for: tomorrow)
    defaults.set(nextBucketChange, forKey: Constants.DefaultKeys.bucketChangeDate.rawValue)
  }
  
  @objc func changeAllItemBuckets() {
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    do {
      let items = try context.fetch(itemFetch) as [Item]
      for item in items {
        item.changeBuckets()
      }
    } catch {
      print(error)
    }
  }
  
  // MARK: Badges
  enum CountType {
    case today, overdue
  }
  
  func getBadgeCount() -> Int {
    let badgeSetting = Settings.badgeOption()
    switch badgeSetting {
    case .all:
      return itemCount(for: .today)
    case .overdue:
      return itemCount(for: .overdue)
    case .none:
      return 0
    }
  }
  
  private func itemCount(for countType: CountType) -> Int {
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try context.fetch(itemFetch) as [Item]
    } catch {
      print(error)
    }
    switch countType {
    case .today:
      return items.filter({ (item) -> Bool in
        return item.bucket == Bucket.today.rawValue && item.state != ItemState.done.rawValue
      }).count
    case .overdue:
      return items.filter({ (item) -> Bool in
        return item.state == ItemState.overdue.rawValue
      }).count
    }
  }
  
  // MARK: Item Creation
  func addNewItem(text: String?, in bucket: Bucket) {
    let item = Item(entity: NSEntityDescription.entity(forEntityName: "Item", in: context)!, insertInto: context)
    item.bucket = bucket.rawValue
    switch bucket {
    case .today:
      item.state = ItemState.none.rawValue
    case .later:
      item.state = ItemState.none.rawValue
    case .tomorrow:
      item.state = ItemState.none.rawValue
    }
    item.title = text
    item.creation = Date() as NSDate
  }
  
  func delete(item: Item) {
    context.delete(item)
  }
  
  func updateExisting(item: Item, withTitle title: String, in bucket: Bucket) {
    item.title = title
    let oldBucket = item.bucket!
    item.bucket = bucket.rawValue
    if oldBucket != bucket.rawValue {
      item.state = ItemState.none.rawValue
    }
  }
  
}
