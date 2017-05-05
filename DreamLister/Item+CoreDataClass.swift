//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Simon Zhen on 5/4/17.
//  Copyright © 2017 Simon Zhen. All rights reserved.
//

import Foundation
import CoreData

public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
