//
//  TodoCell.swift
//  TodoList
//
//  Created by Duy Anh on 27/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TodoCell: UITableViewCell {
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    struct ReactiveEvents {
        var didSelect: ((TodoCell) -> ())? = nil
    }
    
    var events = ReactiveEvents()
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isCompleteButton.rx.tap
            .bind { [unowned self] in self.events.didSelect?(self) }
            .disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configWith(_ todo: Todo) {
        isCompleteButton.isSelected = todo.isComplete
        titleLabel.text = todo.title
    }
}
