//
//  ViewController.swift
//  MAPD714_VitaliiPielievin_300885108_Assignment5
//
//  Created by vitalii on 2020-11-29.
//  Copyright © 2020 vitalii. All rights reserved.
//
//  To Do App Assignment 5 - To Do List App UI Part 2
//  Version: 2.0 - Functionality with Data Persistence (Core Data)
//
//  Student Name: Vitalii Pielievin
//  Student ID:   300885108
//  Date Started: 2020/11/29
//
//  To Do App allows us to add tasks, select time and add notes, by pressing Save button that task would be visible in TableView,
//  if the task is completed, we can press check button and it will be greyed out, there are also buttons for update(edit) and remove tasks.
//

import UIKit
import CoreData

class ViewController: UITableViewController, TaskViewCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func taskViewCellChkBoxTapped(_ sender: TaskViewCell) {
        
        guard let tapIndexPath = tableView.indexPath(for: sender) else { return}
        selectedTaskIndex = tapIndexPath.row
        let isCompleted = tasksList[selectedTaskIndex!].value(forKey: "isCompleted") as! Bool
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        tasksList[selectedTaskIndex!].setValue(!isCompleted, forKey: "isCompleted")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func taskViewCellEditBtnTapped(_ sender: TaskViewCell) {
        guard let tapIndexPath = tableView.indexPath(for: sender) else { return}
        selectedTaskIndex = tapIndexPath.row
        let isCompleted = tasksList[selectedTaskIndex!].value(forKey: "isCompleted") as! Bool
        if !isCompleted {
            selectedTask = tasksList[selectedTaskIndex!]
            self.performSegue(withIdentifier: "DisplayTaskInfo", sender: nil)
        }
    }
    
    func taskViewCellDelBtnTapped(_ sender: TaskViewCell) {
        guard let tapIndexPath = tableView.indexPath(for: sender) else { return}
        selectedTaskIndex = tapIndexPath.row
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(tasksList[selectedTaskIndex!])
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Saving error: \(error)")
        }
        tasksList.remove(at: selectedTaskIndex!)
        
        tableView.reloadData()
    }
    

    var tasksList: [NSManagedObject] = []
    var selectedTask = NSManagedObject()
    var selectedTaskIndex: Int?
    var sortByList = ["Name", "Date"]
    var selectedSortType: Int?
    var sortPicker = UIPickerView()
    
    @IBOutlet weak var sortItem: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortPicker.delegate = self
        sortPicker.dataSource = self
        sortItem.inputView = sortPicker
        sortItem.placeholder = "Sort by: "
        selectedSortType = -1
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sortByList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sortByList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sortItem.text = "Sort by: " + sortByList[row]
        selectedSortType = row
        self.sortItem.resignFirstResponder()
        sortData()
    }
    
    func sortData () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        if (selectedSortType! != -1) {
            var sortDescriptor = NSSortDescriptor()
            
            switch selectedSortType! as Int {
            case 0:
                sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            case 1:
                sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            default:
                break
            }
            
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        do {
            tasksList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //Load data from Core Data DB
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        if (selectedSortType! != -1) {
            var sortDescriptor = NSSortDescriptor()
            
            switch selectedSortType! as Int {
            case 0:
                sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            case 1:
                sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            default:
                break
            }
            
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        do {
            tasksList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch error: \(error)")
        }
    }

    // Opens dialog window to enter new task
    // Get string value from task text field and save it
    // Add task to task list
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "To Do Task",
                                      message: "Add new task",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add",
                                       style: .default) {
                                        [weak self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameOfTask = textField.text else {
                                                return
                                        }
                                        
                                        self?.saveTask(name: nameOfTask)
                                        self?.tableView.reloadData()
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Save task to Core Data DB
    func saveTask(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        let date = Date()
        
        task.setValue(date, forKey: "createdAt")
        
        task.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            tasksList.append(task)
        } catch let error as NSError {
            print("Saving error: \(error)")
        }
        
    }
    
    func customDateFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
    
    //TableView function, assigns cell text, greys out task if completed, etc.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! TaskViewCell
        let isCompleted = tasksList[indexPath.row].value(forKey: "isCompleted") as! Bool
        cell.taskName.text = tasksList[indexPath.row].value(forKey: "name") as? String
        cell.taskName.textColor = isCompleted ? UIColor.lightGray : UIColor.black
        cell.taskDate.text = customDateFormat(date: tasksList[indexPath.row].value(forKey: "createdAt") as! Date)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTaskIndex = indexPath.row
        let isCompleted = tasksList[selectedTaskIndex!].value(forKey: "isCompleted") as! Bool
        if !isCompleted {
            selectedTask = tasksList[selectedTaskIndex!]
            self.performSegue(withIdentifier: "DisplayTaskInfo", sender: nil)
        }
    }
    
    @IBAction func unwindFromDetailsVC(_ sender: UIStoryboardSegue) {
        if sender.source is DetailsViewViewController {
            if let senderVC = sender.source as? DetailsViewViewController {
                if senderVC.action_type == "Save" {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    tasksList[selectedTaskIndex!] = senderVC.taskInfo!
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Saving error: \(error)")
                    }
                    
                }
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailsViewViewController
        vc.taskInfo = selectedTask
    }

}

