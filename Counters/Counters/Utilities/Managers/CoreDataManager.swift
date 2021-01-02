//
//  CoreDataManager.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import CoreData
import UIKit

struct CoreDataManager {

    static var isDataChanged = false

    static func saveCounter(title: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let counterEntity = NSEntityDescription.entity(forEntityName: CounterModel.entityName, in: managedContext) else {
            return false
        }
        let counter = NSManagedObject(entity: counterEntity, insertInto: managedContext)
        counter.setValue("\(title)", forKey: "id")
        counter.setValue("\(title)", forKey: "title")
        counter.setValue(0, forKey: "count")
        do {
            try managedContext.save()
            isDataChanged = true
            return true
        } catch let error {
            print("could not save \(error.localizedDescription)")
            return false
        }
    }

    static func getLocalData() -> [CounterModel] {
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
        isDataChanged = false
        return counterModelListResult
    }

    static func updateCounter(model: CounterModel) -> Bool {
        guard let id = model.id else {
            return false
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CounterModel.entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let objectToUpdate = result[0] as? NSManagedObject else {
                return false
            }
            objectToUpdate.setValue(model.count, forKey: "count")
            do {
                try managedContext.save()
                return true
            } catch let error {
                print("could not update \(error.localizedDescription)")
                return false
            }
        } catch let error {
            print("could not update \(error.localizedDescription)")
            return false
        }
    }

    static func deleteCounter(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CounterModel.entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let objectToDelete = result[0] as? NSManagedObject else {
                return false
            }
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
                return true
            } catch let error {
                print("could not save \(error.localizedDescription)")
                return false
            }
        } catch let error {
            print("could not save \(error.localizedDescription)")
            return false
        }
    }
}
