//
//  EditDateViewController.swift
//  Tasks
//
//  Created by 刘文奇 on 16/4/14.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData

class EditDateViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var managedObject:Task?
    var context:NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker)
    {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //add a save button
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(EditDateViewController.saveButtonPressed))
        self.navigationItem.rightBarButtonItem = saveButton
        
        //set up the date picker
        if let date = self.managedObject?.dueDate{
            self.datePicker.date = NSDate(timeIntervalSinceReferenceDate:date)
        }else{
            self.datePicker.date = NSDate()
        }
        
        //print("view did load done");
    }
    
    func saveButtonPressed()
    {
        let date = self.datePicker.date.timeIntervalSinceReferenceDate
        self.managedObject?.dueDate = date
        
        //save the context
        do{
            try self.context.save()
        }catch{
            abort()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("in the numberOfRowsInSection, section = \(section)")
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell");
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell");
        }
        
        //constrct the label text
 
        let date = self.datePicker.date
        let dataformatter = NSDateFormatter()
        dataformatter.dateStyle = .LongStyle
        
        let dateString = dataformatter.stringFromDate(date)
        cell?.textLabel?.text = dateString
    
       
        
        return cell!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
