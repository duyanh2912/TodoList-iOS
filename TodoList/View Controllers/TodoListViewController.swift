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

final class TodoListViewController: UIViewController, StoryboardInstantiable, UIGestureRecognizerDelegate {
    struct ReactiveEvents {
        var didTapAddButton = PublishSubject<Void>()
        var didDeleteTodo = PublishSubject<Int>()
        var didSelectTodo = PublishSubject<Int>()
    }
    
    static var storyboardName: AppStoryboard = .main
    private var cellIdentifier = "TodoCell"
    
    var events = ReactiveEvents()
    private var todos = Variable([Todo]())
    private var isTableViewEditing = Variable(false)
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addTodoButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        configTableView()
        bindAddTodoButton()
        bindEditTodoButton()
        bindTableViewEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func bindTableViewEditing() {
        let editing = isTableViewEditing.asObservable().share()
        editing
            .bind { [unowned self] in self.tableView.setEditing($0, animated: true) }
            .disposed(by: disposeBag)
        editing
            .map { return $0 ? "Done" : "Edit" }
            .bind(to: editButton.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func bindAddTodoButton() {
        addTodoButton.rx.tap.bind(to: events.didTapAddButton).disposed(by: disposeBag)
    }
    
    private func bindEditTodoButton() {
        editButton.rx.tap
            .bind { [unowned self] in self.isTableViewEditing.value = !self.isTableViewEditing.value }
            .disposed(by: disposeBag)
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
