//
//  Task+CoreDataProperties.swift
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

extension Task {

    @NSManaged var dueDate: NSTimeInterval
    var isOverdue: Bool{
        let today = NSDate();
        
        if NSDate(timeIntervalSinceReferenceDate: self.dueDate).compare(today) == NSComparisonResult.OrderedAscending{
            return true
        }else{
            return false
        }
        
        
    }
    @NSManaged var priority: Int16
    @NSManaged var text: String?
    @NSManaged var location: Location?
    @NSManaged var highPriTasks:NSArray?

}
