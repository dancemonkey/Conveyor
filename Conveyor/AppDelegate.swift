//
//  AppDelegate.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import StoreKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var timer: Timer?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let store = Store(testing: false)
    
    guard let _ = store.getNextBucketChange() else {
      store.setNextBucketChange()
      return true
    }
    if shouldChangeBuckets() {
      changeAllItemBuckets()
    }
    application.setMinimumBackgroundFetchInterval(7200)
    
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { (settings) in
      if settings.authorizationStatus == .authorized {
        DispatchQueue.main.async {
          let store = Store(testing: false)
          application.applicationIconBadgeNumber = store.getBadgeCount()
        }
      }
    }
    
    if Settings.everLaunched() == false {
      Settings.setFirstLaunchDefaults()
    }
    
    DispatchQueue.main.async {
      self.showReviewRequest()
    }
    
    return true
  }
  
  func showReviewRequest() {
    let totalLaunches = UserDefaults.standard.integer(forKey: Constants.DefaultKeys.launchesThisVersion.rawValue)
    if totalLaunches > 0 {
      switch totalLaunches {
      case 14, 50:
        SKStoreReviewController.requestReview()
      case _ where totalLaunches % 100 == 0:
        SKStoreReviewController.requestReview()
      default:
        break
      }
    }
    UserDefaults.standard.set(totalLaunches + 1, forKey: Constants.DefaultKeys.launchesThisVersion.rawValue)
  }
  
  func shouldChangeBuckets() -> Bool {
    let store = Store(testing: false)
    guard let changeDate = store.getNextBucketChange() else {
      return false
    }
    let current = Calendar.current.startOfDay(for: Date())
    if changeDate <= current {
      store.setNextBucketChange()
      return true
    } else {
      return false
    }
  }
  
  func changeAllItemBuckets() {
    DispatchQueue.main.async {
      Store(testing: false).changeAllItemBuckets()
    }
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      if settings.authorizationStatus == .authorized {
        DispatchQueue.main.async {
          let store = Store(testing: false)
          application.applicationIconBadgeNumber = store.getBadgeCount()
        }
      }
    }
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if Settings.didChangeObject {
      persistentContainer.viewContext.refreshAllObjects()
      persistentContainer.viewContext.processPendingChanges()
      Settings.didChangeObjectOff()
    }
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if shouldChangeBuckets() {
      changeAllItemBuckets()
    }
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { (settings) in
      if settings.authorizationStatus == .authorized {
        DispatchQueue.main.async {
          let store = Store(testing: false)
          application.applicationIconBadgeNumber = store.getBadgeCount()
        }
      }
    }
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if shouldChangeBuckets() {
      changeAllItemBuckets()
      let store = Store(testing: false)
      DispatchQueue.main.async {
        application.applicationIconBadgeNumber = store.getBadgeCount()
      }
      do {
        let context = WatchSessionManager.shared.buildContext()
        try WatchSessionManager.shared.updateApplicationContext(context: context)
      } catch {
        print(error)
      }
      completionHandler(.newData)
    } else {
      completionHandler(.noData)
    }
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "Conveyor")
    
    // setting up group access
    let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.DrewLanning.conveyor")!.appendingPathComponent("Conveyor.sqlite")
    let description = NSPersistentStoreDescription()
    description.shouldInferMappingModelAutomatically = true
    description.shouldMigrateStoreAutomatically = true
    description.url = storeURL
    container.persistentStoreDescriptions = [description]
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // handle out of space error
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  
}

