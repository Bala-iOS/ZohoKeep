//
//  GroupDataModel.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import Foundation
import CoreData

struct GroupDataModel {
    var groupID = 0
    var groupName = ""
    
    init(dictionary:NSManagedObject) {
        groupID = dictionary.value(forKey:GroupParmeter.Id) as? Int ?? 0
        groupName = dictionary.value(forKey:GroupParmeter.Name) as? String ?? ""
    }
}

struct GroupParmeter {
    static var Id = "id"
    static var Name = "name"
}
