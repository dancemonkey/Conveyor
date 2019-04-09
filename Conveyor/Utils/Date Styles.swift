//
//  Date Styles.swift
//  ToToLa
//
//  Created by Drew Lanning on 3/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

struct DateStyles {
  
  private var simpleDate: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
      return formatter
    }
  }
  
  static var headingDate: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("E MMMM dd")
      return formatter
    }
  }
  
  static func getTomorrow(from date: Date) -> Date {
    let cal = Calendar(identifier: .gregorian)
    return cal.date(byAdding: .day, value: 1, to: date)!
  }
  
  static func getLater() -> Date {
    return getTomorrow(from: getTomorrow(from: Date()))
  }
  
}
