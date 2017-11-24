//
//  TodoController.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation
import RxSwift

class TodoController {
    var todos = Variable([Todo]())
    
    init() {
        todos.value = TodoController.loadLocalTodos() ?? TodoController.loadSampleTodos()
    }
    
    func deleteTodo(at index: Int) {
        todos.value.remove(at: index)
    }
    
    func addTodo(_ todo: Todo) {
        todos.value.append(todo)
    }
    
    func replaceTodo(_ todo: Todo, at index: Int) {
        todos.value[index] = todo
    }
    
    private static func loadLocalTodos() -> [Todo]? {
        return nil
    }
    
    private static func loadSampleTodos() -> [Todo] {
        let todo1 = Todo(title: "ToDo One", isComplete: false,
        dueDate: Date(), notes: "Notes 1")
        let todo2 = Todo(title: "ToDo Two", isComplete: false,
                         dueDate: Date(), notes: "Notes 2")
        let todo3 = Todo(title: "ToDo Three", isComplete: false,
                         dueDate: Date(), notes: "Notes 3")
        
        return [todo1, todo2, todo3]
    }
}
