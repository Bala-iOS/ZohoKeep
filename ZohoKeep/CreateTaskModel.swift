//
//  CreateTaskModel.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class CreateTaskModel: BaseNSObject {
    
    lazy var groupModel: GroupModel = {
        return GroupModel()
    }()
    
    lazy var taskModel: TaskModel = {
        return TaskModel()
    }()
    
    lazy var appdelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()

    func addGroupValue(name:String, complitionHandler:@escaping(Bool,String)->()) {
        var compltionStatus = false
        var complitionMessage = "Please Enter name"
        if !name.isBlank{
            groupModel.addGroup(groupName: name, complitionHandler: {(status) in
                switch status{
                case .success:
                    compltionStatus = true
                    complitionMessage = "Group Successfully added"
                case.failed:
                    compltionStatus = false
                    complitionMessage = "Group not saved"
                case.others:
                    compltionStatus = false
                    complitionMessage = "Group not saved"
                }
            })
        }
        complitionHandler(compltionStatus,complitionMessage)
    }
    
    func addTask(task:TaskSaveModel,isAdd:Int,ID:Int, complitionHandler:@escaping(Bool,String,Int)->()) {
        var compltionStatus = false
        var complitionMessage = "Please Enter Task title"
        if !(task.TaskName?.isBlank)!{
            if isAdd == 0{
                taskModel.addTask(task: task, complitionHandler: {(status,ID) in
                    switch status{
                    case .success:
                        compltionStatus = true
                        complitionMessage = "Task Successfully added"
                    case.failed:
                        compltionStatus = false
                        complitionMessage = "Task not saved"
                    case.others:
                        compltionStatus = false
                        complitionMessage = "Task not saved"
                    }
                    complitionHandler(compltionStatus,complitionMessage,ID)
                })
            }else{
                taskModel.updateTask(taskId: ID, task, callBack: {(status,ID) in
                    switch status{
                    case .success:
                        compltionStatus = true
                        complitionMessage = "Task Successfully updated"
                    case.failed:
                        compltionStatus = false
                        complitionMessage = "Task not updated"
                    case.others:
                        compltionStatus = false
                        complitionMessage = "Task not updated"
                    }
                    complitionHandler(compltionStatus,complitionMessage,ID)
                })
            }
            
        }else{
            complitionHandler(compltionStatus,complitionMessage,ID)
        }
    }
}
