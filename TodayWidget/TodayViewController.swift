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
  @IBOutlet weak var allDoneLbl: UILabel!
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
    frc.delegate = self
    fetch()
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    tableView.delegate = self
    tableView.dataSource = self
    allDoneLbl.font = FontStyles.mainTitleFont
    allDoneLbl.textColor = ColorStyles.extensionTextColor.withAlphaComponent(0.5)
  }
  
  func fetch() {
    do {
      try frc.performFetch()
    } catch {
      print(error)
    }
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    fetch()
    completionHandler(NCUpdateResult.newData)
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    switch activeDisplayMode {
    case .expanded:
      let items = frc?.fetchedObjects?.count ?? 0
      preferredContentSize = CGSize(width: 0, height: Int(tableView.rowHeight) * items)
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
    let incompletePredicate = NSPredicate(format: "state != %@", "done")
    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [todayPredicate, incompletePredicate])
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
    let count = frc.fetchedObjects?.count ?? 0
    if count == 0 {
      allDoneLbl.isHidden = false
      tableView.isHidden = true
    } else {
      allDoneLbl.isHidden = true
      tableView.isHidden = false
    }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell") as! WidgetCell
    cell.configure(with: frc.fetchedObjects![indexPath.row], and: self)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let url: URL = URL(string: "Conveyor://") {
      self.extensionContext?.open(url, completionHandler: nil)
    }
  }
  
}

extension TodayViewController: ItemCompleter {
  func complete(item: Item) {
    if Settings.doneOption() == .strikethrough {
      item.complete(fromExtension: true)
    } else if Settings.doneOption() == .delete {
      persistentContainer.viewContext.delete(item)
    }
    do {
      persistentContainer.viewContext.refreshAllObjects()
      try persistentContainer.viewContext.save()
      persistentContainer.viewContext.refreshAllObjects()
      Settings.didChangeObjectOn()
    } catch {
      print(error)
    }
    BadgeUpdater(context: persistentContainer.viewContext).sendBadgeUpdateNotification(forCompletedTask: true)
  }
}

extension TodayViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .move:
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.insertRows(at: [newIndexPath], with: .fade)
      }
    @unknown default:
      fatalError()
    }
  }
}
