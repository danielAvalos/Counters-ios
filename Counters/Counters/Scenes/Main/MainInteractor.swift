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
                _ = strongSelf.updateLocalCounter(model: model)
                strongSelf.presenter?.presentCounterListResponse(strongSelf.createMainResponse(counterModel: strongSelf.countersList))
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
                _ = strongSelf.updateLocalCounter(model: model)
                strongSelf.presenter?.presentCounterListResponse(strongSelf.createMainResponse(counterModel: strongSelf.countersList))
            } else {
            }
        }
    }

    func deleteSelected() {
        let dataToDelete = countersList.filter { $0.isSelected }
        guard let next = dataToDelete.first else {
            presenter?.presentCounterListResponse(createMainResponse(counterModel: countersList))
            return
        }
        deleteCounter(model: next)
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
            let messageModel = MessageModel(title: nil, description: "You must finish the edition to be able to refresh the list", action: nil)
            presenter?.presentToast(messageModel)
            return
        }
        isSearching = false
        if ReachabilityManager.shared.isConnected {
            service.fetchCounters { [weak self] (model, error) in
                guard let strongSelf = self else {
                    return
                }
                guard let error = error else {
                    strongSelf.countersList = model ?? []
                    strongSelf.saveServerDataInLocal(model: strongSelf.countersList)
                    guard let response = self?.createMainResponse(counterModel: strongSelf.countersList) else {
                        return
                    }
                    self?.presenter?.presentCounterListResponse(response)
                    return
                }
                let messageModel = MessageModel(title: error.title, description: error.description, action: .reloadData)
                self?.presenter?.presentMessage(messageModel)
            }
        } else {
            let errorModel = ErrorModel(code: .notConnection)
            let messageModel = MessageModel(title: errorModel.title, description: errorModel.description, action: .reloadData)
            presenter?.presentMessage(messageModel)
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
        return MainResponse(messageItemSelected: message, counters: counterModel, isSearching: isSearching)
    }

    func saveServerDataInLocal(model: [CounterModel]) {
        model.forEach {
            guard let title = $0.title else {
                return
            }
            _ = CounterCDManager.saveCounter(title: title, $0.id)
        }
    }

    func getLocalData() -> [CounterModel] {
        return CounterCDManager.getLocalData()
    }

    func updateLocalCounter(model: CounterModel) -> Bool {
        CounterCDManager.updateCounter(model: model)
    }

    func deleteLocalCounter(id: String) -> Bool {
        CounterCDManager.deleteCounter(id: id)
    }

    func deleteCounter(model: CounterModel) {
        service.deleteCounter(model: model) { [weak self] (_, error) in
            guard let strongSelf = self,
                  let id = model.id else {
                return
            }
            if error == nil {
                _ = strongSelf.deleteLocalCounter(id: id)
                if let index = strongSelf.countersList.firstIndex(where: { $0.isSelected }) {
                    strongSelf.countersList.remove(at: index)
                }
            }
            strongSelf.deleteSelected()
        }
    }
}
