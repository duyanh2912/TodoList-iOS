//
//  TodoController.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation

class TodoController {
    var todos: [Todo]
    
    init() {
        todos = TodoController.loadLocalTodos() ?? TodoController.loadSampleTodos()
    }
    
    func deleteTodo(at index: Int) -> [Todo] {
        todos.remove(at: index)
        return todos
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
