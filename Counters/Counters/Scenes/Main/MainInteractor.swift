//
//  MainInteractor.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

protocol MainBusinessLogic {
    func prepareCountersList()
    func filterContent(forQuery query: String?)
}

protocol MainDataStore {
    var isSearching: Bool { get set }
    //var countersList: [CounterModel] { get }
}

final class MainInteractor: MainDataStore {

    var presenter: MainPresentationLogic?

    //private let service: CategoryService

    // MARK: - HomeDataStore

    var isSearching: Bool = false
    //var countersList: [CounterModel] = []

    /*init(service: CategoryService) {
        self.service = service
    }*/
}

// MARK: - MainBusinessLogic

extension MainInteractor: MainBusinessLogic {

    func prepareCountersList() {
        isSearching = false
    }

    func filterContent(forQuery query: String?) {
        guard let query = query, !query.isEmpty else {
            return
        }
        isSearching = true
    }
}

// MARK: - Private functions

private extension MainInteractor {
}
