//
//  IntentHandler.swift
//  SiriAddTasks
//
//  Created by Drew Lanning on 4/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Intents
import CoreData
//import Conveyor

class IntentHandler: INExtension {
  
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Conveyor")
  
      let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.DrewLanning.conveyor")!.appendingPathComponent("Conveyor.sqlite")
      let description = NSPersistentStoreDescription()
      description.shouldInferMappingModelAutomatically = true
      description.shouldMigrateStoreAutomatically = true
      description.url = storeURL
      container.persistentStoreDescriptions = [description]
  
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
  
  override func handler(for intent: INIntent) -> Any {
    print("handling intent")
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self
  }
  
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
      print("adding tasks to model")
      let context = persistentContainer.viewContext
      for task in tasks {
        let item = Item(context: context)
        item.title = task.spokenPhrase
        item.state = .none
        item.bucket = list.rawValue
        item.creation = Date() as NSDate
      }
      do {
        try context.save()
      } catch {
        print(error)
      }
    }
  
}

extension IntentHandler: INAddTasksIntentHandling {

  public func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
    print("handling addTasksIntent")
    let list = intent.targetTaskList
    guard let title = list?.title else {
      print("failed to find list title")
      completion(INAddTasksIntentResponse(code: .failure, userActivity: nil))
      return
    }

    var tasks: [INTask] = []
    if let taskTitles = intent.taskTitles {
      tasks = createTasks(fromTitles: taskTitles)
      add(tasks: taskTitles, to: Bucket(rawValue: title.spokenPhrase)!)
    }

    let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
    response.modifiedTaskList = list
    response.addedTasks = tasks
    print(response)
    completion(response)
  }

}