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
    func getCountersSelected() -> Int
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

    private let service: CountersService

    // MARK: - MainDataStore

    var isSearching: Bool = false
    var isEditing: Bool = false
    var countersList: [CounterModel] = []

    init(service: CountersService) {
        self.service = service
    }
}

// MARK: - MainBusinessLogic

extension MainInteractor: MainBusinessLogic {
    func incrementCounter(counter: CounterModel) {
        guard let index = countersList.firstIndex(where: { $0.id == counter.id && $0.title == counter.title }) else {
            return
        }
        countersList[index].count += 1
        service.incrementCounter(model: countersList[index]) { [weak self] (model, error) in
            if error == nil {
                guard let strongSelf = self,
                      let model = self?.countersList[index] else {
                    return
                }
                if strongSelf.updateLocalCounter(model: model) {
                    strongSelf.presenter?.presentCounterListResponse(strongSelf.createMainResponse(counterModel: strongSelf.countersList))
                }
            } else {
            }
        }
    }

    func decrementCounter(counter: CounterModel) {
        guard let index = countersList.firstIndex(where: { $0.id == counter.id && $0.title == counter.title }) else {
            return
        }
        countersList[index].count = counter.count > 1 ? counter.count - 1 : 0
        service.decrementCounter(model: countersList[index]) { [weak self] (model, error) in
            if error == nil {
                guard let strongSelf = self,
                      let model = self?.countersList[index] else {
                    return
                }
                if strongSelf.updateLocalCounter(model: model) {
                    strongSelf.presenter?.presentCounterListResponse(strongSelf.createMainResponse(counterModel: strongSelf.countersList))
                }
            } else {
            }
        }
    }

    func deleteSelected() {
        let dataToDelete = countersList.filter { $0.isSelected }
        guard let firstToDelete = dataToDelete.first else {
            return
        }
        service.deleteCounter(model: firstToDelete) { [weak self] (_, error) in
            guard let strongSelf = self,
                  let id = firstToDelete.id else {
                return
            }
            if error == nil {
                if strongSelf.deleteLocalCounter(id: id) {
                    strongSelf.countersList.removeAll { $0.id == id }
                }
                strongSelf.presenter?.presentCounterListResponse(strongSelf.createMainResponse(counterModel: strongSelf.countersList))
            } else {
                strongSelf.presenter?.presentError(ErrorModel(code: .errorServer, descriptionLocalizable: error?.description))
            }
        }
    }

    func filterContent(forQuery query: String?) {
        guard let query = query, !query.isEmpty else {
            return
        }
        isSearching = true
        let searchResult = countersList.filter {
            $0.title?.lowercased().contains(query.lowercased()) == true
        }
        presenter?.presentCounterListResponse(createMainResponse(counterModel: searchResult))
    }

    func getCountersSelected() -> Int {
        countersList.filter { $0.isSelected }.count
    }

    func prepareCountersList() {
        guard !isEditing else {
            return
        }
        isSearching = false
        if ReachabilityManager.shared.isConnected {
            service.fetchCounters { [weak self] (model, error) in
                if error == nil {
                    guard let model = model, !model.isEmpty else {
                        self?.presenter?.presentTextToShareResponse("")
                        return
                    }
                    self?.countersList = model
                    guard let response = self?.createMainResponse(counterModel: model) else {
                        return
                    }
                    self?.presenter?.presentCounterListResponse(response)
                }
            }
        } else {
            presenter?.presentError(ErrorModel(code: .notConnection))
        }
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
        var textToShare = ""
        countersListSelected.forEach {
            if !textToShare.isEmpty {
                textToShare += ", "
            }
            textToShare += "\($0.count) x \($0.title ?? "")"
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
