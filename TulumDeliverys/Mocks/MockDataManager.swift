//
//  MockDataManager.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 25/02/26.
//
import SwiftData
import SwiftUI

actor MockDataManager: DataManagerProtocol {
    
    
    // 1. In-Memory Storage (The "Fake DB")
    var storage: [String: any PersistentModel] = [:]
    var storageArr: [String: [any PersistentModel]] = [:]
    var didCallSave = false
    
    func save<T: PersistentModel>(_ item: T) async throws {
        didCallSave = true
        // Simulate saving by ID
        let id = item.persistentModelID.hashValue.description
        storage[id] = item
    }
    
    func save<T>(_ items: [T]) async throws where T : PersistentModel {
        didCallSave = true
        let id = UUID().uuidString
        storageArr[id] = items
    }
    
    func delete<T: PersistentModel>(_ item: T) async throws {
        let id = item.persistentModelID.hashValue.description
        storage.removeValue(forKey: id)
    }
    
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) async throws -> [T] {
        // Return everything in storage cast to T
        return storage.values.compactMap { $0 as? T }
    }
}
