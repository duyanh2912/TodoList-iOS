//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoListViewController: UIViewController, StoryboardInstantiable {
    struct ReactiveEvents {
        var didTapAddButton = PublishSubject<Void>()
        var didDeleteTodo = PublishSubject<Int>()
        var didSelectTodo = PublishSubject<Int>()
    }
    
    static var storyboardName: AppStoryboard = .main
    var events = ReactiveEvents()
    
    private var cellIdentifier = "TodoCell"
    private var todos = Variable([Todo]())
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var addTodoButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        addTodoButton.rx.tap.bind(to: events.didTapAddButton).disposed(by: disposeBag)
    }
    
    private func configTableView() {
        // Cell for indexPath
        todos.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, todo, cell in
                cell.textLabel?.text = todo.title
            }
            .disposed(by: disposeBag)
        
        // Selected cell at indexPath
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: events.didSelectTodo)
            .disposed(by: disposeBag)
        
        // Commit delete at indexPath
        tableView.rx.itemDeleted
            .map { $0.row }
            .bind(to: events.didDeleteTodo)
            .disposed(by: disposeBag)
    }
    
    func load(todos: Variable<[Todo]>) {
        self.todos = todos
    }
    
    deinit {
        print("\(self) deinit")
    }
}
