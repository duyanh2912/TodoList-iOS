//
//  AppCoordinator.swift
//  TechkidsHotGirl
//
//  Created by Duy Anh on 21/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import Foundation

class AppCoordinator: Coordinator {
    var rootVC: UINavigationController
    var children: [Coordinator] = []
    var window: UIWindow
    var todoListVC: TodoListViewController
    
    var todoController: TodoController
    
    init(window: UIWindow) {
        self.window = window
        self.todoController = TodoController()
        self.todoListVC = TodoListViewController.instantiate()
        self.rootVC = UINavigationController(rootViewController: todoListVC)
    }
    
    func start() {
        todoListVC.delegate = self
        rootVC.navigationBar.prefersLargeTitles = true
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        let todos = todoController.todos
        todoListVC.load(todos: todos)
    }
}

extension AppCoordinator: TodoListViewControllerDelegate {
    func addTodoButtonTapped(_ todoListViewController: TodoListViewController) {
        let coordinator = AddTodoCoordinator(rootVC: rootVC)
        coordinator.delegate = self
        coordinator.start()
        addChild(coordinator)
    }
    
    func deleteTodo(_ todoListViewController: TodoListViewController, at index: Int, callback: (Bool,[Todo]) -> ()) {
        let todos = todoController.deleteTodo(at: index)
        callback(true,todos)
    }
    
    func selectedTodo(_ todo: Todo) {
        let todoVC = TodoViewController.instantiate()
        todoVC.todo = todo
//        todoVC.delegate = self
        rootVC.show(todoVC, sender: nil)
    }
}

extension AppCoordinator: AddTodoCoordinatorDelegate {
    func cancelled(coordinator: AddTodoCoordinator) {
        removeChild(coordinator)
    }
    
    func addedTodo(_ todo: Todo, coordinator: AddTodoCoordinator) {
        let todos = todoController.addTodo(todo)
        todoListVC.load(todos: todos)
    }
}
