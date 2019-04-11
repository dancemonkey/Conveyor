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
    fetch()
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func fetch() {
    do {
      try frc.performFetch()
    } catch {
      print(error)
    }
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
    let todayPredicate = NSPredicate(format: "bucket == %@", "today")
    if Settings.doneOption() == .delete {
      let incompletePredicate = NSPredicate(format: "state != %@", "done")
      let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [todayPredicate, incompletePredicate])
      fetchRequest.predicate = compoundPredicate
    } else if Settings.doneOption() == .strikethrough {
      fetchRequest.predicate = todayPredicate
    }
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "state", ascending: false), NSSortDescriptor(key: "holdDays", ascending: true), NSSortDescriptor(key: "creation", ascending: true)]
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell") as! WidgetCell
    cell.configure(with: frc.fetchedObjects![indexPath.row], and: self)
    return cell
  }
  
}

extension TodayViewController: ItemCompleter {
  func complete(item: Item) {
    if let state = item.state, let itemState = ItemState(rawValue: state) {
      if itemState == .none || itemState == .overdue {
        if Settings.doneOption() == .strikethrough {
          item.complete()
        } else if Settings.doneOption() == .delete {
          persistentContainer.viewContext.delete(item)
        }
      } else if itemState == .done {
        item.unComplete()
      }
    }
    do {
      try persistentContainer.viewContext.save()
    } catch {
      print(error)
    }
    fetch()
    tableView.reloadData()
  }
}
