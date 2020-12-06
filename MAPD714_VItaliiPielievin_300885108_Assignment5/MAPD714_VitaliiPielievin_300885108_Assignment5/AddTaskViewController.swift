//
//  AddTaskViewController.swift
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

protocol TaskViewCellDelegate: class {
    func taskViewCellChkBoxTapped(_ sender: TaskViewCell)
    func taskViewCellEditBtnTapped(_ sender: TaskViewCell)
    func taskViewCellDelBtnTapped(_ sender: TaskViewCell)
}

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var taskDoneCheckBox: UIButton!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskEditBtn: UIButton!
    @IBOutlet weak var taskDelBtn: UIButton!
    @IBOutlet weak var taskDate: UILabel!
    weak var delegate: TaskViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func chkBoxTap(_ sender: UIButton) {
        //
        delegate?.taskViewCellChkBoxTapped(self)
    }
    
    @IBAction func edtBtnTap(_ sender: UIButton) {
        //
        delegate?.taskViewCellEditBtnTapped(self)
    }
    
    @IBAction func delBtnTap(_ sender: UIButton) {
        //
        delegate?.taskViewCellDelBtnTapped(self)
    }
    
    
    
}
