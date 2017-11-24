//
//  Coordinator.swift
//  TodoList
//
//  Created by Duy Anh on 24/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var children: [Coordinator] { get set }
    
    func start()
    func addChild(_ childCoordinator: Coordinator)
    func removeChild(_ childCoordinator: Coordinator)
}

extension Coordinator {
    func addChild(_ childCoordinator: Coordinator) {
        children.append(childCoordinator)
    }

    func removeChild(_ childCoordinator: Coordinator) {
        if let index = self.children.index(where: { $0 === childCoordinator }) {
            self.children.remove(at: index)
        }
    }
}
