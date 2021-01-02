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

// MARK: - CreateCounterBusinessLogic

final class CreateCounterInteractor: CreateCounterBusinessLogic {

    var presenter: CreateCounterPresentationLogic?

    func saveCounter(title: String) {
        guard !title.replacingOccurrences(of: " ", with: "").isEmpty else {
            let response = CreateCounterResponse(status: .error, message: "You must enter a valid name")
            presenter?.presentStatusSaved(response: response)
            return
        }
        if CoreDataManager.saveCounter(title: title) {
            let response = CreateCounterResponse(status: .successful, message: "Counter Created")
            presenter?.presentStatusSaved(response: response)
        } else {
            let response = CreateCounterResponse(status: .error, message: "The counter could not be created, try later")
            presenter?.presentStatusSaved(response: response)
        }
    }
}

// MARK: - Private functions

private extension CreateCounterInteractor {
}
