//
//  EditLocationViewController.swift
//  Tasks
//
//  Created by 刘文奇 on 16/4/11.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData

class EditLocationViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    var context:NSManagedObjectContext!
    var taskObject:Task!
    var _fetchedResultController:NSFetchedResultsController?
    
    var fetchedResultController:NSFetchedResultsController{
        if _fetchedResultController != nil{
            return _fetchedResultController!
        }
        
        //create a fetch request for the entity
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)
        request.entity = entity
        
        
        //edit the sort key 
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        _fetchedResultController = aFetchedResultsController
        
        return _fetchedResultController!
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        let location = self.fetchedResultController.objectAtIndexPath(indexPath) as! Location
        
        //if the location in the task object is the same as the location object
        //draw the checkmark
        if self.taskObject.location == location{
            cell?.accessoryType = .Checkmark
        }
        
        cell?.textLabel?.text = location.name
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultController.sections![section]
        //print("the number of rows is \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultController.sections?.count ?? 0
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //deselect the currently selected row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Set the task's location to the chosen location
        self.taskObject.location = self.fetchedResultController.objectAtIndexPath(indexPath) as? Location
        
        //save the context
        do{
            try context.save()
        }catch{
            abort()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            //delete the object for the given index path
            let currentContext = self.fetchedResultController.managedObjectContext
            currentContext.deleteObject(self.fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            //save the context
            do{
                try currentContext.save()
            }catch{
                abort()
            }
            
        }
    }
    
    func addButtonPressed()
    {
        //create a new NSManagedObject
        let newContext = self.context
        let newLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: newContext)
        
        //pop up the editTextViewController
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        let etvc = storyBoard.instantiateViewControllerWithIdentifier("EditTextViewController") as! EditTextViewController
        etvc.managedObjectContext = newContext
        etvc.taskObject = newLocation
        etvc.keyString = "name"
        self.navigationController?.pushViewController(etvc, animated: true)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(EditLocationViewController.addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
        
        //fetche result
        do{
            try self.fetchedResultController.performFetch()
        }catch{
            abort()
        }
        
        //set the title
        self.title = "Location"
        
    }

    
}
