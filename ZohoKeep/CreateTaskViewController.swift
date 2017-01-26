//
//  CreateTaskViewController.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class CreateTaskViewController: BaseViewController {
    //MARK:- Declarations
    
    @IBOutlet weak var addGroupView :UIView!
    @IBOutlet weak var gradientView :UIView!
    
    @IBOutlet weak var groupTextField :UITextField!
    
    @IBOutlet weak var groupTableView :UITableView!
    @IBOutlet weak var selectedGroupButton :UIButton!
    
    @IBOutlet weak var saveTaskButton :UIButton!
    
    @IBOutlet weak var placeHolderLabel : UILabel!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var CalenderView : UIView!
    
    @IBOutlet weak var taskTextField :UITextField!
    @IBOutlet weak var descriptionTextView :UITextView!
    
    @IBOutlet weak var dueDateView : UIView!
    @IBOutlet weak var dueDateLabel : UILabel!
    
    @IBOutlet weak var dueDateHeight : NSLayoutConstraint!
    
    var groupArray = [GroupDataModel]()
    
    var selectedGroupID = 0
    var selectedTaskID = 0
    var selectedGroupName = ""
    var selectedDate = Date()
    var createdDate = Date()
    var selectedTitle = ""
    var selectedDescription = ""
    var isEvent = false
    
    lazy var groupModel: GroupModel = {
        
        return GroupModel()
    }()
    
    lazy var taskSaveClass : TaskSaveModel =
        {
            return TaskSaveModel()
    }()
    
    let createTaskModel = CreateTaskModel()
    let event = Event()

    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dueDateView.isHidden = true
        event.reminderPeremission()
        setData()
    }
    
    func setData() {
        taskTextField.text = selectedTitle
        descriptionTextView.text = selectedDescription
        if selectedGroupID > 0{
            placeHolderLabel.isHidden = true
            saveTaskButton.tag = 1
            selectedGroupButton.setTitle(selectedGroupName, for: .normal)
            saveTaskButton.setTitle("Update Task", for: .normal)
        }
        if selectedDate > Date() {
            dueDateLabel.text = formatteDate(date: selectedDate)
            dueDateView.isHidden = false
        }
    }
    
    func removePopUp() {
        gradientView.isHidden = true
        CalenderView.removeFromSuperview()
        groupTableView.removeFromSuperview()
        addGroupView.removeFromSuperview()
    }
    
    func ShowPopupView(popView:UIView) {
        gradientView.isHidden = false
        popView.center = view.center
        view.addSubview(popView)
    }
    
    func showGroup() {
        groupModel.fetchLastGroupID(complitionHandler: {(status,array) in
            switch status{
            case .success:
                self.groupArray = array
                self.groupTableView.reloadData()
                self.ShowPopupView(popView: self.groupTableView)
            case.failed:
                self.alert("Alert", message: "Cant able to fetch", okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)
            case.others:
                self.groupTextField.text = ""
                self.ShowPopupView(popView: self.addGroupView)
            }
        })
    }
    
    
    func addValueIntoModelClass() -> TaskSaveModel {
        taskSaveClass.contact = ""
        taskSaveClass.createdDate = createdDate
        taskSaveClass.descreption = descriptionTextView.text
        taskSaveClass.duDate = selectedDate
        taskSaveClass.groupId = selectedGroupID
        taskSaveClass.groupName = selectedGroupName
        taskSaveClass.latitude = 8.7139
        taskSaveClass.longitude = 77.7567
        taskSaveClass.TaskID = selectedTaskID
        taskSaveClass.TaskName = taskTextField.text
        taskSaveClass.UpdatedDate = Date()
        taskSaveClass.isEvent = isEvent
        
        return taskSaveClass
    }
    
    //MARK: - IBAction methods
    @IBAction func calenderChanged(_ sender: Any) {
        taskDatePicker.minimumDate = Date()
    }
    
    @IBAction func selectGroup(_ sender: UIButton) {
        showGroup()
    }
    
    @IBAction func gestureAction(_ sender: UITapGestureRecognizer) {
        removePopUp()
    }
    
    @IBAction func showCalenderView(_ sender: UIButton) {
        taskDatePicker.minimumDate = Date()
        ShowPopupView(popView: CalenderView)
    }
    
    @IBAction func addDueDate(_ sender: UIButton) {
        selectedDate = taskDatePicker.date
        dueDateLabel.text = formatteDate(date: selectedDate)
        dueDateView.isHidden = false
        removePopUp()
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        createTaskModel.addTask(task: addValueIntoModelClass(),isAdd: sender.tag,ID: selectedTaskID, complitionHandler: {(status,message,ID) in
            if status{
                self.selectedTaskID = ID
                self.saveTaskButton.tag = 1
                self.saveTaskButton.setTitle("Update Task", for: .normal)
            }
            self.alert("Alert", message: message, okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)
        })
    }

    
    @IBAction func setReminder(_ sender: UIButton) {
        event.addReminder(eventTitle: taskTextField.text!,date: selectedDate, group:selectedGroupID, complitionHandler: {(message,status) in
            self.alert("Alert", message: message, okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)
        })
    }
    
    @IBAction func showAddGroupPopup(_ sender: UIButton) {
        groupTextField.text = ""
        ShowPopupView(popView: addGroupView)
    }
    
    @IBAction func back(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addGroup(_ sender: UIButton) {
        createTaskModel.addGroupValue(name: groupTextField.text!, complitionHandler: {(status,message) in
            if status{
                self.removePopUp()
            }
            self.alert("Alert", message: message, okTitle: "Ok", okCallBack: nil, cancelTitle: nil, cancelCallBack: nil)
        })
    }
}

//MARK: - UITableViewDelegate
extension CreateTaskViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroupID = groupArray[indexPath.row].groupID
        selectedGroupName = groupArray[indexPath.row].groupName
        selectedGroupButton.setTitle(groupArray[indexPath.row].groupName, for: .normal)
        removePopUp()
    }
}

//MARK: - UITableViewDataSource
extension CreateTaskViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "groupTableViewCell",for: indexPath) as! GroupTableViewCell
        cell.groupNameLabel.text = groupArray[indexPath.row].groupName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    //UIResponder delegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }    
    
}

//MARK: - UITextFieldDelegate
extension CreateTaskViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UITextViewDelegate
extension CreateTaskViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let text = textView.text else { return true }
        let newLength = text.characters.count + 1 - range.length
        return newLength <= 80
    }
}
