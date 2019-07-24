//
//  TaskTextParser.swift
//  Conveyor
//
//  Created by Drew Lanning on 6/30/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

class TaskTextParser {
  
  static func parseEntry(from text: String) -> (list: String, task: String)? {
    let lcComponents = text.lowercased().split(separator: " ")
    var origComponents = text.split(separator: " ")
    let listAssignment = lcComponents.first { (string) -> Bool in
      return string == "today" || string == "tomorrow" || string == "later"
    }
    guard let list = listAssignment else { return nil }
    let listLocation = lcComponents.firstIndex(of: list)!
    let _ = origComponents.remove(at: listLocation)
    let task = origComponents.joined(separator: " ")
    return (list: String(list), task: task)
  }
  
  static func isRepeatingTask(from text: String) -> (repeating: Bool, text: String)? {
    let lcComponents = text.lowercased().split(separator: " ")
    var origComponents = text.split(separator: " ")
    let repeating = lcComponents.first { (word) -> Bool in
      return word == Constants.TextParseKeywords.repeatTask.rawValue
    }
    guard repeating != nil else {
      return (repeating: false, text: text)
    }
    let repeatLocation = lcComponents.firstIndex(of: repeating!)!
    let _ = origComponents.remove(at: repeatLocation)
    let task = origComponents.joined(separator: " ")
    return (repeating: true, text: task)
  }
  
  static func isPriorityTask(from text: String) -> (priority: Bool, text: String)? {
    let lcComponents = text.lowercased().split(separator: " ")
    var origComponents = text.split(separator: " ")
    let priority = lcComponents.first { (word) -> Bool in
      return word == Constants.TextParseKeywords.priority.rawValue
    }
    guard priority != nil else {
      return (priority: false, text: text)
    }
    let priorityLoc = lcComponents.firstIndex(of: priority!)!
    let _ = origComponents.remove(at: priorityLoc)
    let task = origComponents.joined(separator: " ")
    return (priority: true, text: task)
  }
  
  static func hasColorTag(from text: String) -> (color: String?, text: String)? {
    let lcComponents = text.lowercased().split(separator: " ")
    var origComponents = text.split(separator: " ")
    for (index, word) in lcComponents.enumerated() {
      if let colors = Settings.getUserColors {
        for color in colors {
          if "\(word)" == "@\(color.value)" {
            let _ = origComponents.remove(at: index)
            let task = origComponents.joined(separator: " ")
            return (color: "@\(color.key)", text: task)
          } else {
            print("word does not match custom color tag")
          }
        }
      }
    }
    return (color: nil, text: text)
  }
  
}
