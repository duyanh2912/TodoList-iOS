//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

final class TodoListViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: AppStoryboard = .main
    var delegate: TodoListViewControllerDelegate?
    
    private var cellIdentifier = "TodoCell"
    private var todos = [Todo]()
    
    @IBOutlet weak var addTodoButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction private func addButtonTapped() {
        delegate?.addTodoButtonTapped(self)
    }
    
    func load(todos: [Todo]) {
        self.todos = todos
        if isViewLoaded {
            tableView.reloadData()
        }
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.deleteTodo(self, at: indexPath.row) { [weak self] success, todo in
                if success {
                    self?.todos = todo
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        return
    }
}

extension TodoListViewController: UITableViewDelegate {
    
}

protocol TodoListViewControllerDelegate {
    func deleteTodo(_ todoListViewController: TodoListViewController ,at index: Int, callback: (_ success: Bool, _ todos: [Todo]) -> ())
    func addTodoButtonTapped(_ todoListViewController: TodoListViewController)
}
