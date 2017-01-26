//
//  EventModel.swift
//  ZohoKeep
//
//  Created by Bala on 1/26/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import Foundation
import  UIKit
import EventKit


public class Event{
    
    lazy var appdelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    var reminders = [EKReminder]()
    
    func fetchReminder(title: String,complitionHandler:@escaping(_ message:String, _ status:Bool)->()) {
        let predicate = self.appdelegate.eventStore?.predicateForReminders(in: nil)
        self.appdelegate.eventStore?.fetchReminders(matching: predicate!, completion: { (reminders: [EKReminder]?) -> Void in
            self.reminders = reminders!
            
            OperationQueue.main.addOperation({
                var isevent = true
                var successMessage = ""
                
                if self.reminders.count > 0 {
                    for case let event in self.reminders{
                        if event.title == title{
                            isevent = false
                            successMessage = "Event already Present"
                            break
                        }
                    }
                }
                complitionHandler(successMessage,isevent)
            })
        })
    }
    
    func completeReminder(title: String,complitionHandler:@escaping(_ message:String, _ status:Bool)->()) {
        let predicate = self.appdelegate.eventStore?.predicateForReminders(in: nil)
        self.appdelegate.eventStore?.fetchReminders(matching: predicate!, completion: { (reminders: [EKReminder]?) -> Void in
            self.reminders = reminders!
            
            OperationQueue.main.addOperation({
                var isevent = true
                var successMessage = "No reminders present"
                
                if self.reminders.count > 0 {
                    for case let event in self.reminders{
                        if event.title == title{
                            event.completionDate = Date()
                            event.calendar = (self.appdelegate.eventStore?.defaultCalendarForNewReminders())!
                            do {
                                try self.appdelegate.eventStore?.save(event, commit: true)
                                isevent = false
                                successMessage = "Event Completd"
                            }catch{
                                isevent = false
                                successMessage = "Event not completed"
                                print("Error creating and saving new reminder : \(error)")
                            }
                            complitionHandler(successMessage,isevent)
                            break
                        }
                    }
                }else{
                    complitionHandler(successMessage,isevent)
                }
            })
        })
    }
    
    func addReminder(eventTitle:String,date:Date,group:Int,complitionHandler:@escaping(_ message:String, _ status:Bool)->()) {
        var status = false
        var message = ""
        
        if group == 0 {
            complitionHandler("Please Select group",status)
        }else{
            if !eventTitle.isBlank {
                fetchReminder(title: eventTitle, complitionHandler: {(acceptMessage,isAccept) in
                    if isAccept{
                        if (self.appdelegate.eventStore != nil) {
                            let reminder = EKReminder(eventStore: self.appdelegate.eventStore!)
                            
                            reminder.title = eventTitle
                            reminder.calendar =
                                self.appdelegate.eventStore!.defaultCalendarForNewReminders()
                            let alarm = EKAlarm(absoluteDate: date)
                            reminder.priority = 1
                            reminder.addAlarm(alarm)
                            
                            do {
                                try self.appdelegate.eventStore?.save(reminder,
                                                                      commit: true)
                                status = true
                                message = "Reminder successfully set"
                            } catch let error {
                                message = "Reminder failed with error"
                                print("Reminder failed with error \(error.localizedDescription)")
                            }
                        }
                    }else{
                        message = acceptMessage
                    }
                    complitionHandler(message,status)
                })
            }else{
                message = "Enter title to set Reminder"
                complitionHandler("Enter title to set Reminder",status)
            }
        }
    }
    
    func reminderPeremission() {
        if appdelegate.eventStore == nil {
            appdelegate.eventStore = EKEventStore()
            
            appdelegate.eventStore?.requestAccess(
                to: EKEntityType.reminder, completion: {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                    } else {
                print("Access granted")
                    }
            })
        }
    }
    
    
}
