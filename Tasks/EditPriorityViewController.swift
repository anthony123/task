//
//  EditPriorityViewController.swift
//  Tasks
//
//  Created by 刘文奇 on 16/4/11.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData

class EditPriorityViewController: UITableViewController
{
    var managedObjectContext:NSManagedObjectContext!
    var taskObject:Task!
    
    @IBOutlet weak var nonePri: UITableViewCell!
    
    @IBOutlet weak var lowPri: UITableViewCell!
    
    @IBOutlet weak var mediumPri: UITableViewCell!
    
    @IBOutlet weak var highPri: UITableViewCell!
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.taskObject.priority = Int16(indexPath.row)
        
        //save the context
        do{
            try managedObjectContext.save()
        }catch{
            abort()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    func configureView()
    {
        if taskObject != nil{
            let pri:Int = Int(self.taskObject.priority)
            switch pri{
            case 0: nonePri.accessoryType = .Checkmark
            case 1: lowPri.accessoryType = .Checkmark
            case 2: mediumPri.accessoryType = .Checkmark
            case 3: highPri.accessoryType = .Checkmark
            default: break
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    
}
