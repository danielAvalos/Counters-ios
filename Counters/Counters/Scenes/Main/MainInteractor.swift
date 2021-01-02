//
//  MainInteractor.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit
import CoreData

protocol MainBusinessLogic {
    func prepareCountersList()
    func filterContent(forQuery query: String?)
    func select(isSelectAll: Bool)
    func select(counterModel: CounterModel)
    func deleteSelected()
    func shareCountersSelected()
    func incrementCounter(counter: CounterModel)
    func decrementCounter(counter: CounterModel)
}

protocol MainDataStore {
    var isSearching: Bool { get set }
    var isEditing: Bool { get set }
    var countersList: [CounterModel] { get }
}

final class MainInteractor: MainDataStore {

    var presenter: MainPresentationLogic?

    //private let service: CategoryService

    // MARK: - MainDataStore

    var isSearching: Bool = false
    var isEditing: Bool = false
    var countersList: [CounterModel] = []

    /*init(service: CategoryService) {
        self.service = service
    }*/
}

// MARK: - MainBusinessLogic

extension MainInteractor: MainBusinessLogic {
    func incrementCounter(counter: CounterModel) {
        guard let index = countersList.firstIndex(where: { $0.id == counter.id && $0.title == counter.title }) else {
            return
        }
        countersList[index].count += 1
        if updateLocalCounter(model: countersList[index]) {
            presenter?.presentCounterListResponse(createMainResponse(counterModel: countersList))
        }
    }

    func decrementCounter(counter: CounterModel) {
        guard let index = countersList.firstIndex(where: { $0.id == counter.id && $0.title == counter.title }) else {
            return
        }
        countersList[index].count = counter.count > 1 ? counter.count - 1 : 0
        if updateLocalCounter(model: countersList[index]) {
            presenter?.presentCounterListResponse(createMainResponse(counterModel: countersList))
        }
    }

    func deleteSelected() {
        let dataToDelete = countersList.filter { $0.isSelected }
        dataToDelete.forEach { (counterModel) in
            guard let id = counterModel.id else {
                return
            }
            if deleteLocalCounter(id: id) {
                countersList.removeAll { $0.id == id }
            }
        }
        presenter?.presentCounterListResponse(createMainResponse(counterModel: countersList))
    }

    func filterContent(forQuery query: String?) {
        guard let query = query, !query.isEmpty else {
            return
        }
        isSearching = true
    }

    func prepareCountersList() {
        guard !isEditing else {
            return
        }
        isSearching = false
        countersList = getLocalData()
        presenter?.presentCounterListResponse(createMainResponse(counterModel: countersList))
    }

    func select(isSelectAll: Bool) {
        let counterSelectAllList: [CounterModel] = countersList.map {
            CounterModel(id: $0.id, title: $0.title, count: $0.count, isSelected: isSelectAll)
        }
        countersList.removeAll()
        countersList.append(contentsOf: counterSelectAllList)
        presenter?.presentCounterListResponse(createMainResponse(counterModel: countersList))
    }

    func shareCountersSelected() {
        let countersListSelected = countersList.filter { $0.isSelected }
        var textToShare = "counters:"
        countersListSelected.forEach {
            textToShare += $0.title ?? ""
        }
        guard textToShare.isEmpty else {
            presenter?.presentTextToShareResponse(textToShare)
            return
        }
    }

    func select(counterModel: CounterModel) {
        guard let index = countersList.firstIndex(where: { $0.id == counterModel.id && $0.title == counterModel.title }) else {
            return
        }
        countersList[index].isSelected = counterModel.isSelected
    }
}

// MARK: - Private functions

private extension MainInteractor {

    func createMainResponse(counterModel: [CounterModel]) -> MainResponse {
        var sumCount = 0
        let itemSelected = counterModel.filter {
            sumCount += $0.count
            return $0.count > 0
        }.count
        let message = "\(itemSelected) items · Counted \(sumCount) times"
        return MainResponse(messageItemSelected: message, counters: counterModel)
    }

    func getLocalData() -> [CounterModel] {
        return CoreDataManager.getLocalData()
    }

    func updateLocalCounter(model: CounterModel) -> Bool {
        CoreDataManager.updateCounter(model: model)
    }

    func deleteLocalCounter(id: String) -> Bool {
        CoreDataManager.deleteCounter(id: id)
    }
}
