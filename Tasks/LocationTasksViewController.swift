//
//  LocationTasksViewController.swift
//  Tasks
//
//  Created by 刘文奇 on 16/4/15.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData

class LocationTasksViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var taskObject:Task?
    var context:NSManagedObjectContext?
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var fetchedResultController:NSFetchedResultsController{
        if _fetchedResultsController != nil{
            return _fetchedResultsController!
        }
        
        //get the fetchedRequest
        let fetchedRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.context!)
        fetchedRequest.entity = entity
        
        //set the sort description
        let description = NSSortDescriptor(key: "location.name", ascending: true)
        let descriptions = [description]
        fetchedRequest.sortDescriptors = descriptions
        
        
        let aFetchedResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: self.context!, sectionNameKeyPath: "location.name", cacheName: nil)
        
        aFetchedResultController.delegate = self
        //self.fetchedResultController = aFetchedResultController
        _fetchedResultsController = aFetchedResultController
        
        //fetch
        do{
            try _fetchedResultsController!.performFetch()
        }catch{
            abort()
        }
        
        return _fetchedResultsController!
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch the data
        do{
            try self.fetchedResultController.performFetch()
        }catch{
            abort()
        }
        
        //set title
        self.title = "Tasks by Location"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.fetchedResultController.sections!.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let objects = self.fetchedResultController.sections
        let aObject = objects![section]
        return aObject.numberOfObjects
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }

        // Configure the cell...
        self.configureCell(cell!, atIndexPath:indexPath)
        
        return cell!
    }
    
    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath)
    {
        let task = self.fetchedResultController.objectAtIndexPath(indexPath) as! Task
        cell.textLabel!.text = task.text
        
        if task.isOverdue == true{
            cell.textLabel?.textColor = UIColor.redColor()
        }else{
            cell.textLabel?.textColor = UIColor.blackColor()
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //deselect 
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        //generate a viewtaskcontroller
        let vtc = ViewTaskController();
        vtc.managedObjectContext = self.context
        vtc.managedTaskObject = self.taskObject
        
        self.navigationController?.pushViewController(vtc, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let objects = self.fetchedResultController.sections
        
        return objects![section].name
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support cononal rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
