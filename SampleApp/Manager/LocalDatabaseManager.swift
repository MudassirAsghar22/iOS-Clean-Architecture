//
//  LocalDatabaseManager.swift
//  Sample App
//
//  Created by Mudassir Asghar on 25/07/2024.
//

import Foundation
import SwiftData

protocol LocalDatabaseCRUD {

    associatedtype Model

    func create(with object: Model)

    func read(finish: @escaping (Result<[Model], Error>) -> Void)

    func update(from oldObject: Model, updateTo newObject: Model)

    func delete(with object: Model)
}

final class LocalDatabaseManager {

    static let shared = LocalDatabaseManager()

    private var context: ModelContext?
    private var container: ModelContainer?

    var modelDidChangeListener: (() -> Void)? = nil

    init() {
        do {
            container = try ModelContainer(for: SwiftDataModel.self)
            if let container {
                context = ModelContext(container)
                print("Database context has been initialized")
            }
        } catch {
            fatalError("Can't initialize LocalDatabaseManager Object because occurs error. Error: \(error)")
        }
    }

    func resetContainer() {
        do {
            if let modelContext = context {
                try modelContext.delete(model: SwiftDataModel.self)
                print("Database context has been reset")
            }
        } catch {
            print("Failed to clear all Country and City data.")
        }
    }
}

extension LocalDatabaseManager: LocalDatabaseCRUD {

    func create(with object: SwiftDataModel) {
        if let context {
            let objectToBeSaved = SwiftDataModel(id: object.id)

            context.insert(objectToBeSaved)

            if let modelDidChangeListener {
                modelDidChangeListener()
            }
        }
    }

    func read(finish: @escaping (Result<[SwiftDataModel], Error>) -> Void) {
        let descriptor = FetchDescriptor<SwiftDataModel>()
        if let context {
            do {
                let objects = try context.fetch(descriptor)
                print("Database object has been fetched: \(objects.count)")
                finish(.success(objects))
            } catch {
                print("Database object could not be fetched: \(error)")
                finish(.failure(error))
            }
        }
    }

    func update(from oldObject: SwiftDataModel, updateTo newObject: SwiftDataModel) {
        var objectToBeUpdated = oldObject
        objectToBeUpdated = newObject
        if let modelDidChangeListener {
            modelDidChangeListener()
        }
    }

    func delete(with object: SwiftDataModel) {
        let objectToBeDeleted = object
        if let context {
            context.delete(objectToBeDeleted)
            if let modelDidChangeListener {
                modelDidChangeListener()
            }
        }
    }

    @MainActor func deleteAllData() {
        container?.mainContext.container.deleteAllData()
    }
}
