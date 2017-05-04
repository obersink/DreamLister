//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Simon Zhen on 5/4/17.
//  Copyright © 2017 Simon Zhen. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
