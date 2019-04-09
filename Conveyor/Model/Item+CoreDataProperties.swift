//
//  Item+CoreDataProperties.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var bucket: String?
    @NSManaged public var creation: NSDate?
    @NSManaged public var holdDays: Int16
    @NSManaged public var holdForever: Bool
    @NSManaged public var sortOrder: Int32
    @NSManaged public var state: String?
    @NSManaged public var title: String?

}
