//
//  TodoViewController.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

final class TodoViewController: UITableViewController, StoryboardInstantiable {
    static var storyboardName: AppStoryboard = .main
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
        updateSaveButtonState()
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
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

protocol TodoViewControllerDelegate {
    func cancelButtonTapped(todoListVC: TodoViewController)
}
