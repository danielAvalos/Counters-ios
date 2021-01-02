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
}

protocol MainDataStore {
    var isSearching: Bool { get set }
    var countersList: [CounterModel] { get }
}

final class MainInteractor: MainDataStore {

    var presenter: MainPresentationLogic?

    //private let service: CategoryService

    // MARK: - HomeDataStore

    var isSearching: Bool = false
    var countersList: [CounterModel] = []

    /*init(service: CategoryService) {
        self.service = service
    }*/
}

// MARK: - MainBusinessLogic

extension MainInteractor: MainBusinessLogic {

    func prepareCountersList() {
        isSearching = false
        countersList = createLocalData()
        let mainResponse = MainResponse(counters: countersList)
        presenter?.presentResponse(mainResponse)
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

    func createLocalData() -> [CounterModel] {
        let counterModelListResult = getLocalData()
        if countersList.isEmpty {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return counterModelListResult }
            let managedContext = appDelegate.persistentContainer.viewContext
            guard let counterEntity = NSEntityDescription.entity(forEntityName: CounterModel.entityName, in: managedContext) else {
                return countersList
            }
            for index in 11...15 {
                let counter = NSManagedObject(entity: counterEntity, insertInto: managedContext)
                counter.setValue("\(index)", forKey: "id")
                counter.setValue("Number of times I’ve forgotten my mother’s name because I was high on Frugelés. \(index)", forKey: "title")
                counter.setValue(0, forKey: "count")
            }
            do {
                try managedContext.save()
            } catch let error {
                print("could not save \(error.localizedDescription)")
            }
        }
        return getLocalData()
    }

    func getLocalData() -> [CounterModel] {
        var counterModelListResult: [CounterModel] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return counterModelListResult }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CounterModel.entityName)
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return counterModelListResult
            }
            result.forEach { (data) in
                if let id = data.value(forKey: "id") as? String,
                      let title = data.value(forKey: "title") as? String,
                      let count = data.value(forKey: "count") as? Int {
                    let counterModel = CounterModel(id: id,
                                                    title: title,
                                                    count: count)
                    counterModelListResult.append(counterModel)
                }
            }
        } catch let error {
            print("could not save \(error.localizedDescription)")
            return []
        }
        return counterModelListResult
    }
}
