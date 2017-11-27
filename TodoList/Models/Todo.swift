//
//  Todo.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import RxDataSources

struct Todo: Codable {
    let id = UUID().uuidString
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let dueDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
}

extension Todo: IdentifiableType, Equatable {
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id && lhs.isComplete == rhs.isComplete
    }
    
    var identity: String { return id }
    typealias Identity = String
}

typealias TodoSection = AnimatableSectionModel<Int,Todo>
