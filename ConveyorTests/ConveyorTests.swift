//
//  ConveyorTests.swift
//  ConveyorTests
//
//  Created by Drew Lanning on 4/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import XCTest
@testable import Conveyor
import CoreData

class ModelTests: XCTestCase {
  
  var dataStore: Store?
  
  override func setUp() {
    dataStore = Store(testing: true)
    dataStore?.addNewItem(text: "Item 1", in: .today)
    dataStore?.addNewItem(text: "Item 2", in: .tomorrow)
    dataStore?.addNewItem(text: "Item 3", in: .later)
  }
  
  override func tearDown() {
  }
  
  func testExistingStore() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    XCTAssertNotNil(store)
  }
  
  func testThreeItemsExist() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    XCTAssert(items.count == 3)
  }
  
  func testMoveItem() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    let itemOne = items.first { (item) -> Bool in
      item.title == "Item 1"
    }
    itemOne?.change(to: .tomorrow)
    XCTAssert(itemOne?.bucket == "tomorrow")
  }
  
  func testCompleteItem() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    
    let itemTwo = items.first { (item) -> Bool in
      item.title == "Item 2"
    }
    itemTwo?.complete()
    XCTAssert(itemTwo?.state == "done")
  }
  
  func testItemHold() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    
    let itemThree = items.first { (item) -> Bool in
      item.title == "Item 3"
    }
    itemThree?.change(to: .later)
    itemThree?.hold(forever: true, or: nil)
    XCTAssert(itemThree?.bucket == "later" && itemThree?.state == "held")
  }
  
  func testHoldDays() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    
    let item1 = items[0]
    let item2 = items[1]
    let item3 = items[2]
    item1.hold(forever: true, or: 0)
    item2.hold(forever: false, or: 1)
    item3.hold(forever: false, or: 2)
    store.changeAllItemBuckets()
    XCTAssert(
      item1.state == "held" &&
        item2.state == "none" &&
        (item3.state == "held" && item3.holdDays == 1)
    )
  }
  
  func testChangeItemBuckets() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    store.changeAllItemBuckets()
    let item1 = items.first { (item) -> Bool in
      item.title == "Item 1"
    }
    let item2 = items.first { (item) -> Bool in
      item.title == "Item 2"
    }
    let item3 = items.first { (item) -> Bool in
      item.title == "Item 3"
    }
    XCTAssert(
      (item1?.state == "overdue" && item1?.bucket == "today") &&
        (item2?.bucket == "today" && item2?.state == "none") &&
        (item3?.bucket == "tomorrow" && item3?.state == "none")
    )
  }
  
  func testBadgeCount() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    store.changeAllItemBuckets()
    XCTAssert(store.getBadgeCount() == 2)
  }
  
  func testEditItem() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    let item3 = items.first { (item) -> Bool in
      item.title == "Item 3"
    }
    item3?.hold(forever: true, or: nil)
    store.updateExisting(item: item3!, withTitle: "new title", in: .tomorrow)
    XCTAssert(
      item3?.title == "new title" &&
        item3?.bucket == "tomorrow" &&
        item3?.state == "none"
    )
  }
  
  func testDeleteItem() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    let item1 = items.first { (item) -> Bool in
      item.title == "Item 1"
    }
    store.delete(item: item1!)
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    XCTAssert(items.count == 2)
  }
  
  func testStateChangeOnBucketChange() {
    guard let store = dataStore else {
      XCTFail()
      return
    }
    let itemFetch = NSFetchRequest<Item>(entityName: "Item")
    var items: [Item] = []
    do {
      items = try store.context.fetch(itemFetch) as [Item]
    } catch {
      XCTFail()
    }
    let item1 = items.first { (item) -> Bool in
      item.title == "Item 1"
    }
    let item3 = items.first { (item) -> Bool in
      item.title == "Item 3"
    }
    item1?.complete()
    item3?.hold(forever: true, or: nil)
    item1?.change(to: .tomorrow)
    item3?.change(to: .today)
    XCTAssert(
      (item1?.bucket == "tomorrow" && item1?.state == "none") &&
        (item3?.bucket == "today" && item3?.state == "none")
    )
  }
  
}
