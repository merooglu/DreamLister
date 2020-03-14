//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Mehmet Eroğlu on 10.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate() as Date
    }
}
