//
//  LocalDataSource.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import SwiftData
import SwiftUI

// 1. Define the capabilities
protocol DataManagerProtocol: Sendable {
    func save<T: PersistentModel>(_ item: T) async throws
    func save<T: PersistentModel>(_ items: [T]) async throws
    func delete<T: PersistentModel>(_ item: T) async throws
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) async throws -> [T]}

// 1. The Actor enforces thread safety (Background work)
@ModelActor
actor DataManager: DataManagerProtocol {
    
    // The macro AUTOMATICALLY adds:
        // var modelContainer: ModelContainer
        // var modelExecutor: ModelExecutor
        // init(modelContainer: ModelContainer) <--- This is generated
    // T must conform to PersistentModel (the SwiftData protocol)
    func save<T: PersistentModel>(_ item: T) throws {
        // modelContext is automatically provided by @ModelActor
        modelContext.insert(item)
        try modelContext.save()
    }
    
    func save<T>(_ items: [T]) async throws where T : PersistentModel {
        for item in items {
            modelContext.insert(item)
        }
        try modelContext.save()
    }
    
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) async throws -> [T] {
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - Generic Delete
    func delete<T: PersistentModel>(_ item: T) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
    
    // MARK: - Batch Delete (Advanced)
    func deleteAll<T: PersistentModel>(_ modelType: T.Type) throws {
        try modelContext.delete(model: T.self)
    }
}
