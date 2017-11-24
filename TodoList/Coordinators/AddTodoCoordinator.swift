//
//  AddTodoCoordinator.swift
//  TodoList
//
//  Created by Duy Anh on 24/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

class AddTodoCoordinator: Coordinator {
    var rootVC: UIViewController
    var delegate: AddTodoCoordinatorDelegate?
    var children: [Coordinator] = []
    
    init(rootVC: UIViewController) {
        self.rootVC = rootVC
        self.children = []
    }
    
    func start() {
        let todoVC = TodoViewController.instantiate()
        todoVC.delegate = self
        
        let navigationVC = UINavigationController(rootViewController: todoVC)
        rootVC.show(navigationVC, sender: nil)
    }
}

extension AddTodoCoordinator: TodoViewControllerDelegate {
    func cancelButtonTapped(todoListVC: TodoViewController) {
        rootVC.dismiss(animated: true)
        delegate?.cancelled(coordinator: self)
    }
    
    func saveButtonTapped(todoListVC: TodoViewController, todo: Todo) {
        rootVC.dismiss(animated: true)
        delegate?.addedTodo(todo, coordinator: self)
    }
}

protocol AddTodoCoordinatorDelegate {
    func cancelled(coordinator: AddTodoCoordinator)
    func addedTodo(_ todo: Todo, coordinator: AddTodoCoordinator)
}
