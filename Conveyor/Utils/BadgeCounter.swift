//
//  BadgeCounter.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/13/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

class BadgeUpdater {
  
  var context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  enum CountType {
    case today, overdue
  }
  
  func sendBadgeUpdateNotification() {
    let content = UNMutableNotificationContent()
    content.badge = self.getBadgeCount() as NSNumber
    if self.getBadgeCount() == 0 {
      let title = "You did it!"
      let message = "You completed all of today's tasks. Way to go!"
      content.title = title
      content.body = message
    }
    
    let date = Date().addingTimeInterval(1)
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    let request = UNNotificationRequest(identifier: "todayBadge", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { (error) in
      print("notification scheduled")
    }
  }
  
  private func getBadgeCount() -> Int {
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
  
}
