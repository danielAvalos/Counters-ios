//
//  CreateCounterInteractor.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import CoreData
import UIKit

protocol CreateCounterBusinessLogic {
    func saveCounter(title: String)
}

final class CreateCounterInteractor {

    var presenter: CreateCounterPresentationLogic?

    private let service: CountersService

    init(service: CountersService) {
        self.service = service
    }
}

// MARK: - CreateCounterBusinessLogic

extension CreateCounterInteractor: CreateCounterBusinessLogic {

    func saveCounter(title: String) {
        guard !title.replacingOccurrences(of: " ", with: "").isEmpty else {
            let response = CreateCounterResponse(status: .error, message: "You must enter a valid name")
            presenter?.presentStatusSaved(response: response)
            return
        }
        let counterModel = CounterModel(id: nil, title: title)
        service.createCounter(model: counterModel) { [weak self] (data, error) in
            CounterCDManager.isDataChanged = true
            guard let error = error else {
                _ = CounterCDManager.saveCounter(title: title, data?.last?.id)
                let response = CreateCounterResponse(status: .successful,
                                                     message: "Counter Created")
                self?.presenter?.presentStatusSaved(response: response)
                return
            }
            let response = CreateCounterResponse(status: .error,
                                                 message: error.description)
            self?.presenter?.presentStatusSaved(response: response)
        }
    }
}

// MARK: - Private functions

private extension CreateCounterInteractor {
}
