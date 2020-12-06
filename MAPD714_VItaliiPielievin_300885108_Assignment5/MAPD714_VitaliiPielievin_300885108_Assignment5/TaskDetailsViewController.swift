//
//  TaskDetailsViewController.swift
//  MAPD714_VitaliiPielievin_300885108_Assignment6
//
//  Created by vitalii on 2020-12-06.
//  Copyright © 2020 vitalii. All rights reserved.
//
//  To Do App Assignment 6 - To Do List App Part 3
//  Version: 3.0 - Gesture Control
//
//  Student Name: Vitalii Pielievin
//  Student ID:   300885108
//  Date Started: 2020/12/06
//
//  To Do App allows us to add tasks, select time and add notes, by pressing Save button that task would be visible in TableView,
//  if the task is completed, we can press check button and it will be greyed out, there are also buttons for update(edit) and remove tasks.
//


import UIKit
import CoreData

class DetailsViewViewController: UIViewController, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    var taskInfo: NSManagedObject?
    var action_type: String!


    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskNote: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        taskName.text = taskInfo?.value(forKey: "name") as? String
        taskNote.text = taskInfo?.value(forKey: "notes") as? String
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let actionBtn = sender as? UIBarButtonItem
        if (actionBtn?.title == "Save") {
            taskInfo?.setValue(taskName.text, forKey: "name")
            taskInfo?.setValue(taskNote.text, forKey: "notes")
            action_type = "Save"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
