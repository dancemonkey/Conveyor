//
//  IntentHandler.swift
//  WatchIntents
//
//  Created by Drew Lanning on 5/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
}

extension IntentHandler: INAddTasksIntentHandling {
  
  func createTasks(fromTitles taskTitles: [INSpeakableString]) -> [INTask] {
    var tasks: [INTask] = []
    tasks = taskTitles.map { taskTitle -> INTask in
      let task = INTask(title: taskTitle,
                        status: .notCompleted,
                        taskType: .completable,
                        spatialEventTrigger: nil,
                        temporalEventTrigger: nil,
                        createdDateComponents: nil,
                        modifiedDateComponents: nil,
                        identifier: nil)
      return task
    }
    return tasks
  }
  
  func add(tasks: [INSpeakableString], to list: Bucket) {
    for task in tasks {
      let item = WatchTask(title: task.spokenPhrase, status: .none, id: nil)
      WatchSessionManager.shared.sendNew(task: item, in: list)
    }
    
  }
  
  public func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
    let list = intent.targetTaskList
    guard let title = list?.title else {
      print("no list title found")
      completion(INAddTasksIntentResponse(code: .failure, userActivity: nil))
      return
    }
    
    var tasks: [INTask] = []
    if let taskTitles = intent.taskTitles {
      print("found and creating tasks")
      tasks = createTasks(fromTitles: taskTitles)
      add(tasks: taskTitles, to: Bucket(rawValue: title.spokenPhrase)!)
      let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
      response.modifiedTaskList = list
      response.addedTasks = tasks
      completion(response)
    }
  }
  
}
