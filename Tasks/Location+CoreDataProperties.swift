//
//  Location+CoreDataProperties.swift
//  Tasks
//
//  Created by 刘文奇 on 16/4/14.
//  Copyright © 2016年 liuwq. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var name: String?
    @NSManaged var tasks: NSSet?

}
