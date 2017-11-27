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
import RxDataSources

final class TodoListViewController: UIViewController, StoryboardInstantiable, UIGestureRecognizerDelegate {
    struct ReactiveEvents {
        var didTapAddButton = PublishSubject<Void>()
        var didDeleteTodo = PublishSubject<Int>()
        var didSelectTodo = PublishSubject<Int>()
        var didToggleTodo = PublishSubject<Int>()
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        configTableView()
        bindAddTodoButton()
        bindEditTodoButton()
        bindTableViewEditing()
    }

    override func viewDidDisappear(_: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }

    private func bindTableViewEditing() {
        isTableViewEditing.asObservable()
            .bind { [unowned self] in self.toggleTableViewEditing($0) }
            .disposed(by: disposeBag)
    }

    private func toggleTableViewEditing(_ editing: Bool) {
        tableView.setEditing(editing, animated: true)
        let title = editing ? "Done" : "Edit"
        let font = editing ? UIFont.boldSystemFont(ofSize: 17) : UIFont.systemFont(ofSize: 17)
        editButton.title = title
        editButton.setTitleTextAttributes([.font: font], for: .normal)
    }

    private func bindAddTodoButton() {
        addTodoButton.rx.tap.bind(to: events.didTapAddButton).disposed(by: disposeBag)
    }

    private func bindEditTodoButton() {
        editButton.rx.tap
            .map { [unowned self] in !self.isTableViewEditing.value }
            .bind(to: isTableViewEditing)
            .disposed(by: disposeBag)
    }

    private func configTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<TodoSection>(configureCell: {
            [unowned self] (_, tableView, indexPath, todo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! TodoCell
            cell.configWith(todo)
            cell.events.didSelect = { [unowned self] in self.didSelect(cell: $0) }
            return cell
        })

        dataSource.canEditRowAtIndexPath = { _, _ in true }

        todos.asDriver()
            .map { [TodoSection(model: 0, items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
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
        
        // Forward delegate
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    func didSelect(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            events.didToggleTodo.onNext(indexPath.row)
        }
    }

    func load(todos: Variable<[Todo]>) {
        self.todos = todos
    }

    deinit {
        print("\(self) deinit")
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        isTableViewEditing.value = true
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        isTableViewEditing.value = false
    }
}
