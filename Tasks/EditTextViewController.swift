//
//  EditTextViewController.swift
//  Tasks
//
//  Created by 刘文奇 on 16/4/11.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import UIKit
import CoreData

class EditTextViewController: UITableViewController
{
    var managedObjectContext:NSManagedObjectContext!
    var taskObject:NSManagedObject!
    var keyString:String!
    
    @IBOutlet weak var textField: UITextField!
    
    func configureView()
    {
        if self.taskObject != nil{
            self.textField.text = self.taskObject.valueForKey(self.keyString) as? String
        }
    }
    
    func saveButtonPressed()
    {
        self.taskObject.setValue(textField.text, forKey: self.keyString)
        
        //save
        do{
            try managedObjectContext.save()
        }catch{
            abort()
        }
        
        
        //pop up the EditTaskView
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add a save button
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(EditTextViewController.saveButtonPressed))
        self.navigationItem.rightBarButtonItem = saveButton
        self.configureView()
        
    }
    
   
}
