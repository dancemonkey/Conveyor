//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Drew Lanning on 4/10/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var tableView: UITableView!
  var frc: NSFetchedResultsController<Item>!
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    frc = initializeFRC()
    do {
      try frc.performFetch()
    } catch {
      print(error)
    }
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    switch activeDisplayMode {
    case .expanded:
      let items = frc?.fetchedObjects?.count ?? 0
      preferredContentSize = CGSize(width: 0, height: Int(tableView.rowHeight) * items)
      print(preferredContentSize)
    case .compact:
      preferredContentSize = maxSize
    @unknown default:
      preferredContentSize = maxSize
    }
  }
  
  func initializeFRC() -> NSFetchedResultsController<Item> {
    let context = persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    // TODAY: settings option to configure if all buckets or just Today shows on extension
    let predicate = NSPredicate(format: "bucket == %@", "today")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "state", ascending: false), NSSortDescriptor(key: "holdDays", ascending: true), NSSortDescriptor(key: "creation", ascending: true)]
    fetchRequest.predicate = predicate
    let fetchedResultsController: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return frc.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell")!
    cell.textLabel?.text = frc.fetchedObjects![indexPath.row].title
    return cell
  }
  
}
