//
//  GroupModel.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class GroupModel
{
    var entityName = {
        return "Group"
    }
    
    lazy var appdelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func addGroup(groupName: String, complitionHandler: @escaping (Status) -> ()) {
        
        let context = self.appdelegate().persistentContainer.viewContext
        let groupTabel = NSEntityDescription.insertNewObject(forEntityName: entityName(), into: context)
        print(getID())
        groupTabel.setValue(Int16(getID()) , forKey: GroupParmeter.Id)
        groupTabel.setValue(groupName, forKey: GroupParmeter.Name)
        
        var responseStatus = Status.others;
        
        do {
            try context.save()
            responseStatus = .success
        } catch  {
            responseStatus = .failed
        }
        
        complitionHandler(responseStatus)
    }
    
    func fetchLastGroupID(complitionHandler: @escaping (Status,[GroupDataModel]) -> ())
    {
        let context = appdelegate().persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName())
        request.returnsObjectsAsFaults = false
        
        var responseStatus = Status.others
        var groupArray = [GroupDataModel]()
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                responseStatus = .success
                for dataDictionary in result as! [NSManagedObject]
                {
                    let Group = GroupDataModel(dictionary: dataDictionary)
                    groupArray.append(Group)
                }
                print(groupArray)
            }
        }
        catch  {
            responseStatus = .failed
        }
        complitionHandler(responseStatus, groupArray)
    }
    
    func getID() -> Int {
        var value = 1
        
        fetchLastGroupID(complitionHandler: {(status,array) in
            switch status{
            case .success:
                value = array[array.count-1].groupID + 1
            case .failed:
                value = 1
            case.others:
                value = 1
            }
        })
        return value
    }
}
