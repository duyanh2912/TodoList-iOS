//
//  AppCoordinator.swift
//  TechkidsHotGirl
//
//  Created by Duy Anh on 21/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    var rootVC: UINavigationController
    var window: UIWindow
    var todoListVC: TodoListViewController
    var todoController: TodoController
    
    init(window: UIWindow) {
        self.window = window
        self.todoController = TodoController()
        self.todoListVC = TodoListViewController.instantiate()
        self.rootVC = UINavigationController(rootViewController: todoListVC)
    }
    
    override func start() -> Observable<Void> {
        rootVC.navigationBar.prefersLargeTitles = true
        
        let todos = todoController.todos
        todoListVC.load(todos: todos)
        
        todoListVC.events.didTapAddButton
            .flatMapLatest { [unowned self] in self.showAddTodo() }
            .unwrap()
            .bind { [unowned self] in self.todoController.addTodo($0) }
            .disposed(by: disposeBag)
        
        todoListVC.events.didSelectTodo
            .flatMapLatest { [unowned self] in self.showEditTodo(index: $0) }
            .unwrap()
            .bind { [unowned self] in self.todoController.replaceTodo($0.1, at: $0.0) }
            .disposed(by: disposeBag)
        
        todoListVC.events.didDeleteTodo
            .bind { [unowned self] in self.todoController.deleteTodo(at: $0) }
            .disposed(by: disposeBag)
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    func showAddTodo() -> Observable<Todo?> {
        let coordinator = AddTodoCoordinator(rootVC: rootVC)
        return coordinate(to: coordinator)
            .map { result in
                switch result {
                case .cancel: return nil
                case .save(let todo): return todo
                }
            }
    }
    
    func showEditTodo(index: Int) -> Observable<(Int,Todo)?> {
        let todo = todoController.todos.value[index]
        let coordinator = EditTodoCoordinator(navigationController: rootVC, todo: todo, todoIndex: index)
        return coordinate(to: coordinator)
            .map { result in
                switch result {
                case .cancelled: return nil
                case .edited(let index, let todo): return (index,todo)
                }
            }
    }
}
