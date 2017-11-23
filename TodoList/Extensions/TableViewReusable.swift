//
//  TableViewReusable.swift
//  TodoList
//
//  Created by Duy Anh on 23/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

protocol TableViewReusable {
    static var cellIdentifier: String { get }
    static func register(forTableView tableView: UITableView)
}

extension TableViewReusable where Self: UITableViewCell {
    static var cellIdentifier: String { return "\(self)" }
    static func register(forTableView tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
}
