//
//  TodoViewController.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

extension IndexPath {
    fileprivate static let dueDate = IndexPath(row: 1, section: 0)
    fileprivate static let notes = IndexPath(row: 0, section: 1)
}

final class TodoViewController: UITableViewController, StoryboardInstantiable {
    static var storyboardName: AppStoryboard = .main
    
    var todo: Todo?
    var isDatePickerHidden = true
    var dueDateIndexPath = IndexPath(row: 1, section: 0)
    var delegate: TodoViewControllerDelegate?
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            dueDatePicker.date = todo.dueDate
            isCompleteButton.isSelected = todo.isComplete
            notesTextView.text = todo.notes
        } else {
            dueDatePicker.date = Date().addingTimeInterval(86400)
        }
        
        navigationItem.largeTitleDisplayMode = .never
        updateDueDateLabel(date: dueDatePicker.date)
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func updateDueDateLabel(date: Date) {
        dueDateLabel.text = Todo.dueDateFormatter.string(from: date)
    }
    
    func getTodo() -> Todo {
        return Todo(title: titleTextField.text!, isComplete: isCompleteButton.isSelected, dueDate: dueDatePicker.date, notes: notesTextView.text)
    }
    
    @IBAction func textEditingChanged() {
        updateSaveButtonState()
    }
    
    @IBAction func returnButtonPressed() {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped() {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.cancelButtonTapped(todoListVC: self)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.saveButtonTapped(todoListVC: self, todo: getTodo())
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePicker.date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalHeight: CGFloat = 44
        let largeHeight: CGFloat = 200
        
        switch indexPath {
        case .dueDate:
            return isDatePickerHidden ? normalHeight : largeHeight
        case .notes:
            return largeHeight
        default:
            return normalHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == .dueDate {
            isDatePickerHidden = !isDatePickerHidden
            dueDateLabel.textColor = isDatePickerHidden ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

protocol TodoViewControllerDelegate {
    func cancelButtonTapped(todoListVC: TodoViewController)
    func saveButtonTapped(todoListVC: TodoViewController, todo: Todo)
}

