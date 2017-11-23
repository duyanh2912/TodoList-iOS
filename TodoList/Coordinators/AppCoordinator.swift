//
//  AppCoordinator.swift
//  TechkidsHotGirl
//
//  Created by Duy Anh on 21/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import Foundation

class AppCoordinator {
    var window: UIWindow
    var rootVC: UINavigationController!
    var todoController: TodoController
    
    init(window: UIWindow) {
        self.window = window
        self.todoController = TodoController()
    }
    
    func start() {
        let todoListVC = TodoListViewController.instantiate()
        todoListVC.delegate = self
        
        let navigationVC = UINavigationController(rootViewController: todoListVC)
        navigationVC.navigationBar.prefersLargeTitles = true
        rootVC = navigationVC
        
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
        
        let todos = todoController.todos
        todoListVC.load(todos: todos)
    }
}

extension AppCoordinator: TodoListViewControllerDelegate {
    func addTodoButtonTapped(_ todoListViewController: TodoListViewController) {
        let todoVC = TodoViewController.instantiate()
        todoVC.delegate = self
        
        let navigationVC = UINavigationController(rootViewController: todoVC)
        rootVC.show(navigationVC, sender: nil)
    }
    
    func deleteTodo(_ todoListViewController: TodoListViewController, at index: Int, callback: (Bool,[Todo]) -> ()) {
        let todos = todoController.deleteTodo(at: index)
        callback(true,todos)
    }
}

extension AppCoordinator: TodoViewControllerDelegate {
    func cancelButtonTapped(todoListVC: TodoViewController) {
        rootVC.dismiss(animated: true)
    }
}
