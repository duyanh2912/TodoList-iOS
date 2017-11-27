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
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension(".plist")
    
    var todos = Variable([Todo]())
    
    init() {
        todos.value = TodoController.loadLocalTodos() ?? TodoController.loadSampleTodos()
    }
    
    func deleteTodo(at index: Int) {
        todos.value.remove(at: index)
        TodoController.save(todos: todos.value)
    }
    
    func addTodo(_ todo: Todo) {
        todos.value.append(todo)
        TodoController.save(todos: todos.value)
    }
    
    func replaceTodo(_ todo: Todo, at index: Int) {
        todos.value[index] = todo
        TodoController.save(todos: todos.value)
    }
    
    func toggleTodo(at index: Int) {
        todos.value[index].isComplete = !todos.value[index].isComplete
        TodoController.save(todos: todos.value)
    }
    
    private static func loadLocalTodos() -> [Todo]? {
        if let data = try? Data(contentsOf: archiveURL), let todos = try? PropertyListDecoder().decode([Todo].self, from: data) {
            return todos
        }
        return nil
    }
    
    private static func save(todos: [Todo]) {
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(todos)
        try? data?.write(to: archiveURL, options: .noFileProtection)
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
