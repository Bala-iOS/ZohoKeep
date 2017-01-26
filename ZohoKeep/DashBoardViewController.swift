//
//  DashBoardViewController.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class DashBoardViewController: BaseViewController {
    
    @IBOutlet weak var dashBoardTableView :UITableView!
    @IBOutlet weak var addTaskButton :UIButton!
    
    @IBOutlet var taskSearchBar: UISearchBar!
    @IBOutlet var searchBarHeight: NSLayoutConstraint!
    
    var selectedItem = -1
    
    let model = DashModel()
    
    let event = Event()
    
    var taskArray = [TaskDataModel]()
    
    lazy var taskSaveClass : TaskSaveModel =
        {
            return TaskSaveModel()
    }()
    
    lazy var taskModel: TaskModel = {
        
        return TaskModel()
    }()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarHeight.constant = 0
        dashBoardTableView?.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchTask()
    }
    
    // MARK: - Actions
    
    func fetchTask() {
        taskModel.fetchLastTaskID(complitionHandler: {(status,array) in
            switch status{
            case .success:
                self.addTaskButton.isHidden = true
                self.dashBoardTableView.isHidden = false
                self.taskArray = array.sorted(by: {$0.createdDate.compare($1.createdDate) == ComparisonResult.orderedAscending})
                self.dashBoardTableView.reloadData()
            case.failed:
                self.addTaskButton.isHidden = false
                self.dashBoardTableView.isHidden = true
                self.alert("Alert", message: "Cant able to fetch", okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)
            case.others:
                self.addTaskButton.isHidden = false
                self.dashBoardTableView.isHidden = true
                print("No Tasks")
            }
        })
    }
    
    func deleteDashBoardTask(ID:Int) {
        taskModel.deleteTask(taskId: ID, callBack: {(status,array) in
            switch status{
            case .success:
                self.addTaskButton.isHidden = true
                self.dashBoardTableView.isHidden = false
                self.taskArray = (array?.sorted(by: {$0.createdDate.compare($1.createdDate) == ComparisonResult.orderedAscending}))!
                self.dashBoardTableView.reloadData()
            case.failed:
                self.addTaskButton.isHidden = false
                self.dashBoardTableView.isHidden = true
                self.alert("Alert", message: "Cant able to delete", okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)
            case.others:
                self.addTaskButton.isHidden = false
                self.dashBoardTableView.isHidden = true
                print("No Tasks")
            }
        })
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        selectedItem = -1
        self.performSegue(withIdentifier: "ToCreateTask", sender: self)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchBarHeight.constant = 44
    }
    
    @IBAction func completTask(_ sender: UIButton) {
        self.model.updateEvent(task: self.addValueIntoModelClass(index:sender.tag),ID: self.taskArray[sender.tag].TaskID, complitionHandler: {(status,message,ID) in
            
            if status{
                self.fetchTask()
            }else{
                
            }
        })
    }
    
    func addValueIntoModelClass(index:Int) -> TaskSaveModel {
        taskSaveClass.contact = ""
        taskSaveClass.createdDate = taskArray[index].createdDate
        taskSaveClass.descreption = taskArray[index].descreption
        taskSaveClass.duDate = taskArray[index].duDate
        taskSaveClass.groupId = taskArray[index].groupId
        taskSaveClass.groupName = taskArray[index].groupName
        taskSaveClass.latitude = taskArray[index].latitude
        taskSaveClass.longitude = taskArray[index].longitude
        taskSaveClass.TaskID = taskArray[index].groupId
        taskSaveClass.TaskName = taskArray[index].TaskName
        taskSaveClass.UpdatedDate = taskArray[index].UpdatedDate
        taskSaveClass.isEvent = true
        
        return taskSaveClass
    }
    
    @IBAction func deleteTask(_ sender: UIButton) {
        deleteDashBoardTask(ID: taskArray[sender.tag].TaskID)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedItem > -1{
            if segue.identifier == "ToCreateTask"{
                let CreateTask = segue.destination as! CreateTaskViewController
                CreateTask.selectedGroupID = taskArray[selectedItem].groupId
                CreateTask.selectedGroupName = taskArray[selectedItem].groupName
                CreateTask.selectedDate = taskArray[selectedItem].duDate
                CreateTask.selectedDescription = taskArray[selectedItem].descreption
                CreateTask.selectedTitle = taskArray[selectedItem].TaskName
                CreateTask.selectedTaskID = taskArray[selectedItem].TaskID
                CreateTask.createdDate = taskArray[selectedItem].createdDate
                CreateTask.selectedDate = taskArray[selectedItem].duDate
                CreateTask.isEvent = taskArray[selectedItem].isEvent
            }
        }
    }
}

extension DashBoardViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        self.performSegue(withIdentifier: "ToCreateTask", sender: self)
    }
}

extension DashBoardViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "taskTableViewCell",for: indexPath) as! TaskTableViewCell
        cell.taskLabel.text = taskArray[indexPath.row].TaskName
        cell.groupName.text = taskArray[indexPath.row].groupName
        cell.dateLabel.text = formatteDate(date: taskArray[indexPath.row].createdDate)
        cell.deleteButton.tag = indexPath.row
        cell.completedButton.tag = indexPath.row
        
        if taskArray[indexPath.row].isEvent {
            cell.completedButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        }else{
            cell.completedButton.setImage(#imageLiteral(resourceName: "unComplete"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
}
