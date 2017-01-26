//
//  DashModel.swift
//  ZohoKeep
//
//  Created by Bala on 1/26/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class DashModel: NSObject {
    
    lazy var taskModel: TaskModel = {
        
        return TaskModel()
    }()
    
    func updateEvent(task:TaskSaveModel,ID:Int, complitionHandler:@escaping(Bool,String,Int)->()) {
        var compltionStatus = false
        var complitionMessage = "Please Enter Task title"
        
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

}
