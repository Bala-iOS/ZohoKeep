//
//  TaskModel.swift
//  ZohoKeep
//
//  Created by Bala on 1/26/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class TaskModel
{
    var entityName = {
        return "Task"
    }
    
    lazy var appdelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func addTask(task: TaskSaveModel, complitionHandler: @escaping (Status,Int) -> ()) {
        
        let ID = getID()
        
        let context = self.appdelegate().persistentContainer.viewContext
        let taskTabel = NSEntityDescription.insertNewObject(forEntityName: entityName(), into: context)
        taskTabel.setValue(Int16(ID) , forKey: TaskParmeter.Id)
        taskTabel.setValue(task.contact, forKey: TaskParmeter.contact)
        taskTabel.setValue(task.createdDate, forKey: TaskParmeter.created_date)
        taskTabel.setValue(task.descreption, forKey: TaskParmeter.descreption)
        taskTabel.setValue(task.duDate, forKey: TaskParmeter.due_date)
        taskTabel.setValue(task.groupId, forKey: TaskParmeter.group_id)
        taskTabel.setValue(task.groupName, forKey: TaskParmeter.group_name)
        taskTabel.setValue(task.image, forKey: TaskParmeter.image)
        taskTabel.setValue(task.latitude, forKey: TaskParmeter.latitude)
        taskTabel.setValue(task.longitude, forKey: TaskParmeter.longitude)
        taskTabel.setValue(task.TaskName, forKey: TaskParmeter.Name)
        taskTabel.setValue(task.UpdatedDate, forKey: TaskParmeter.updated_date)
        taskTabel.setValue(task.isEvent, forKey: TaskParmeter.is_event)
        
        var responseStatus = Status.others;
        
        do {
            try context.save()
            responseStatus = .success
        } catch  {
            responseStatus = .failed
        }
        
        complitionHandler(responseStatus,ID)
    }
    
    func fetchLastTaskID(complitionHandler: @escaping (Status,[TaskDataModel]) -> ())
    {
        let context = appdelegate().persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        request.returnsObjectsAsFaults = false
        
        var responseStatus = Status.others
        var taskArray = [TaskDataModel]()
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                responseStatus = .success
                for dataDictionary in result as! [NSManagedObject]
                {
                    let task = TaskDataModel(dictionary: dataDictionary)
                    taskArray.append(task)
                }
            }
        }
        catch  {
            responseStatus = .failed
        }
        complitionHandler(responseStatus, taskArray)
    }
    
    func getID() -> Int {
        var value = 1
        
        fetchLastTaskID(complitionHandler: {(status,array) in
            switch status{
            case .success:
                value = array[array.count-1].TaskID + 1
            case .failed:
                value = 1
            case.others:
                value = 1
            }
        })
        return value
    }
    
    func updateTask( taskId:Int,_ newTaskModel: TaskSaveModel, callBack: @escaping (Status,Int) -> Void) {
        
        let context = appdelegate().persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        
        let resultPredicate = NSPredicate(format: "id = %d", taskId)
        
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        var responseStatus = Status.others
        do {
            let result = try context.fetch(request) as? [Task]
            responseStatus = .success
            if result?.count != 0 {
                if let setting = result {
                    let tasks = setting[0]
                    tasks.latitude = newTaskModel.latitude!
                    tasks.longitude = newTaskModel.longitude!
                    
                    tasks.descreption = newTaskModel.descreption
                    tasks.name = newTaskModel.TaskName
                    tasks.updated_date = newTaskModel.UpdatedDate as NSDate?
                    tasks.is_event = newTaskModel.isEvent!
                    do {
                        try context.save()
                        responseStatus = .success
                        
                    } catch  {
                        responseStatus = .failed
                    }
                    callBack(responseStatus,taskId)
                }
            }
        } catch  {
            responseStatus = .failed
        }
        callBack(responseStatus,taskId)
    }
    
    func deleteTask(taskId:Int,callBack: @escaping (Status,_ list : [TaskDataModel]?) -> Void)
    {
        let context = appdelegate().persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        let resultPredicate = NSPredicate(format: "id = %d", taskId)
        
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        
        var serviceStatus = Status.others;
        
        do {
            let result = try context.fetch(request)
            
            if result.count > 0 {
                serviceStatus = .success
                for results in result as! [NSManagedObject]
                {
                    context.delete(results)
                    appdelegate().saveContext()
                }
                fetchLastTaskID(complitionHandler: {(status,array) in
                    callBack(serviceStatus,array)
                })
            }
            
        } catch  {
            serviceStatus = .failed
            callBack(serviceStatus,[TaskDataModel]())
        }
    }

}










