//
//  EditTodoCoordinator.swift
//  TodoList
//
//  Created by Duy Anh on 24/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import RxSwift

enum EditTodoCoordinationResult {
    case cancelled
    case edited(Int,Todo)
}

class EditTodoCoordinator: BaseCoordinator<EditTodoCoordinationResult> {
    var todoIndex: Int
    var todo: Todo
    var navigationController: UINavigationController
   
    init(navigationController: UINavigationController, todo: Todo, todoIndex index: Int) {
        self.navigationController = navigationController
        self.todoIndex = index
        self.todo = todo
        super.init()
    }
   
    override func start() -> Observable<CoordinationResult> {
        let todoVC = TodoViewController.instantiate()
        todoVC.todo = todo
        navigationController.pushViewController(todoVC, animated: true)
        
        let cancel = todoVC.events.didCancel.map { CoordinationResult.cancelled }
        let add = todoVC.events.didSave.map { [unowned self] in CoordinationResult.edited(self.todoIndex, $0) }
        
        return Observable.merge(cancel,add).take(1).do(onNext: { [unowned self] _ in
            self.navigationController.popViewController(animated: true)
        })
    }
}
