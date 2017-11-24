//
//  AddTodoCoordinator.swift
//  TodoList
//
//  Created by Duy Anh on 24/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import RxSwift

enum AddTodoCoordinationResult {
    case cancel
    case save(Todo)
}

class AddTodoCoordinator: BaseCoordinator<AddTodoCoordinationResult> {
    var rootVC: UIViewController
    
    init(rootVC: UIViewController) {
        self.rootVC = rootVC
        super.init()
    }
    
    override func start() -> Observable<CoordinationResult> {
        let todoVC = TodoViewController.instantiate()
        let navigationVC = UINavigationController(rootViewController: todoVC)
        rootVC.show(navigationVC, sender: nil)
        
        let cancel = todoVC.events.didCancel.map { CoordinationResult.cancel }
        let save = todoVC.events.didSave.map { CoordinationResult.save($0) }
        
        return Observable.merge(cancel,save).take(1).do(onNext: { [unowned self] _ in
            self.rootVC.dismiss(animated: true)
        })
    }
}
