//
//  MainViewModel.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

final class MainViewModel {

    var counter: CounterModel

    init(model: CounterModel) {
        counter = model
    }
}

extension MainViewModel: Equatable {
    static func == (lhs: MainViewModel, rhs: MainViewModel) -> Bool {
        return lhs.counter.id == lhs.counter.id
    }
}

protocol MainConfigurable {
    func configure(with viewModel: MainViewModel, parent: AnyObject)
}
