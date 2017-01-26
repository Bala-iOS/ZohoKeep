//
//  TaskDataModel.swift
//  ZohoKeep
//
//  Created by Bala on 1/26/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import Foundation
import CoreData

struct TaskDataModel {
    var TaskID = 0
    var TaskName = ""
    var groupName = ""
    var UpdatedDate = Date()
    var createdDate = Date()
    var contact = ""
    var descreption = ""
    var longitude = 0.0
    var latitude = 0.0
    var image = Data()
    var groupId = 0
    var duDate = Date()
    var isEvent = false
    
    init(dictionary:NSManagedObject) {
        TaskID = dictionary.value(forKey:TaskParmeter.Id) as? Int ?? 0
        TaskName = dictionary.value(forKey:TaskParmeter.Name) as? String ?? ""
        groupName = dictionary.value(forKey:TaskParmeter.group_name) as? String ?? ""
        UpdatedDate = dictionary.value(forKey:TaskParmeter.updated_date) as? Date ?? Date()
        createdDate = dictionary.value(forKey:TaskParmeter.created_date) as? Date ?? Date()
        contact = dictionary.value(forKey:TaskParmeter.contact) as? String ?? ""
        descreption = dictionary.value(forKey:TaskParmeter.descreption) as? String ?? ""
        longitude = dictionary.value(forKey:TaskParmeter.longitude) as? Double ?? 0.0
        latitude = dictionary.value(forKey:TaskParmeter.latitude) as? Double ?? 0.0
        image = dictionary.value(forKey:TaskParmeter.image) as? Data ?? Data()
        groupId = dictionary.value(forKey:TaskParmeter.group_id) as? Int ?? 0
        duDate = dictionary.value(forKey:TaskParmeter.due_date) as? Date ?? Date()
        isEvent = dictionary.value(forKey:TaskParmeter.due_date) as? Bool ?? false
    }
}

public class TaskSaveModel {
    
    var TaskID : Int? = nil
    var TaskName : String? = nil
    var groupName : String? = nil
    var UpdatedDate : Date? = nil
    var createdDate : Date? = nil
    var contact : String? = nil
    var descreption : String? = nil
    var longitude : Double? = nil
    var latitude : Double? = nil
    var image : Data? = nil
    var groupId : Int? = nil
    var duDate : Date? = nil
    var isEvent : Bool? = nil
}

struct TaskParmeter {
    static var Id = "id"
    static var Name = "name"
    static var group_name = "group_name"
    static var updated_date = "updated_date"
    static var created_date = "created_date"
    static var contact = "contact"
    static var descreption = "descreption"
    static var longitude = "longitude"
    static var latitude = "latitude"
    static var image = "image"
    static var group_id = "group_id"
    static var due_date = "due_date"
    static var is_event = "is_event"
    
    
}
