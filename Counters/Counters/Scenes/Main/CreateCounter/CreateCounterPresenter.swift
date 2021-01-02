//
//  CreateCounterPresenter.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import Foundation

protocol CreateCounterPresentationLogic {
    func presentStatusSaved(response: CreateCounterResponse)
}

final class CreateCounterPresenter {
    weak var viewController: CreateCounterDisplayLogic?
}

// MARK: - CreateCounterPresentationLogic

extension CreateCounterPresenter: CreateCounterPresentationLogic {
    func presentStatusSaved(response: CreateCounterResponse) {
        let createCounterViewModel = CreateCounterViewModel(title: response.status.rawValue,
                                                            message: response.message,
                                                            status: response.status)
        viewController?.displaySavedStatus(viewModel: createCounterViewModel)
    }
}
