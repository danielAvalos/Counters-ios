//
//  CreateItemExampleViewModel.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

final class CreateItemExampleViewModel {

    var title: String

    init(model: String) {
        title = model
    }
}

extension CreateItemExampleViewModel: Equatable {
    static func == (lhs: CreateItemExampleViewModel, rhs: CreateItemExampleViewModel) -> Bool {
        return lhs.title == lhs.title
    }
}
