//
//  ViewTaskController.swift
//  Tasks
//
//  Created by 刘文奇 on 16/4/11.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData

class ViewTaskController: UITableViewController
{
    var managedObjectContext:NSManagedObjectContext!
    var managedTaskObject:Task!
    var priorityString:String!
    
    @IBOutlet weak var taskLocation: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var taskPriority: UILabel!
    @IBOutlet weak var taskText: UILabel!
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //deselect 
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        //Hi-Pri task
        if indexPath.row == 4{
            let hiPris = self.managedTaskObject.highPriTasks
            
            
            let alert = UIAlertController(title: "high-pri tasks", message: nil, preferredStyle: .Alert)
            
            var alertMessages = ""
            for task in hiPris!{
                let priority = task as! Task
                let name = priority.text
                alertMessages += name!
                alertMessages += "\n"
            }
            
            alert.message = alertMessages
            
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        //sonner than this one
        if indexPath.row == 5{
            //get the managed object
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let model = appDelegate.managedObjectModel
            
            //get the stored fetch request
            let dic = Dictionary(dictionaryLiteral: ( "DUE_DATE",NSDate(timeIntervalSinceReferenceDate: self.managedTaskObject.dueDate)))
            
            let request = model.fetchRequestFromTemplateWithName("tasksDueSooner", substitutionVariables: dic)
            var alertMessages = ""
            do{
                let result = try self.managedObjectContext.executeFetchRequest(request!)
                
                for object in result{
                    let task = object as! Task
                    alertMessages += task.text!
                    alertMessages += "\n"
                }
                
            }catch{
                abort()
            }
            
            let alert = UIAlertController(title: "Tasks due sooner", message: alertMessages, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil);
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditTextViewController"{
            let etvc = segue.destinationViewController as! EditTextViewController
            etvc.managedObjectContext = self.managedObjectContext
            etvc.taskObject = self.managedTaskObject
            etvc.keyString = "Text"
        }else if segue.identifier == "showEditPriorityViewController"{
            let epvc = segue.destinationViewController as! EditPriorityViewController
            epvc.managedObjectContext = self.managedObjectContext
            epvc.taskObject = self.managedTaskObject
        }else if segue.identifier == "showEditLocationViewController"{
            let elvc = segue.destinationViewController as! EditLocationViewController
            elvc.taskObject = self.managedTaskObject
            elvc.context = self.managedObjectContext
        }else if segue.identifier == "showEditDateViewController"{
            let edvc = segue.destinationViewController as! EditDateViewController
            edvc.managedObject = self.managedTaskObject
            edvc.context = self.managedObjectContext
        }
    }
    
    func configureView()
    {
        if self.managedTaskObject != nil{
            //refresh the context
            self.managedObjectContext.refreshObject(self.managedTaskObject, mergeChanges: true)
            
            //set Task text
            self.taskText?.text = managedTaskObject.text
            
            //set the priority
            let pri:Int = Int(managedTaskObject.priority)
            switch pri{
            case 0: self.priorityString = "None"
            case 1: self.priorityString = "Low"
            case 2: self.priorityString = "Medium"
            case 3: self.priorityString = "High"
            default: break
            }
            
            self.taskPriority?.text = self.priorityString
            
            //set Due Date
            let df = NSDateFormatter()
            df.dateStyle = .LongStyle
            self.taskDueDate?.text = df.stringFromDate(NSDate(timeIntervalSinceReferenceDate: self.managedTaskObject.dueDate))
            
            //set Location
            if let location = self.managedTaskObject.location{
                self.taskLocation?.text = location.name
            }else{
                self.taskLocation?.text = "Not Set"
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Task Detail"
        //self.configureView()
    }
    
    
    
}
