//
//  Repository.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation
import SwiftUI
import SwiftData

protocol ProductRepositoryProtocol {
    func fetchAndProcess() async throws -> ([Item], Set<String>)
}

actor Repository: ProductRepositoryProtocol {
    private let remote: RemoteDataSourceProtocol
    private let local: any DataManagerProtocol

    init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: any DataManagerProtocol) {
        self.remote = remoteDataSource
        self.local = localDataSource
    }
    
    // 2. This method runs on a background thread automatically!
    func fetchAndProcess() async throws -> ([Item], Set<String>) {
        
        // A. Fetch raw data
        let apiProducts = try await remote.fetchProductsFromAPI()
        
        // B. HEAVY WORK: The Loop happens here (Background)
        var items: [Item] = []
        var categories: Set<String> = []
        
        for prod in apiProducts {
            guard prod.active ?? true else { continue }
            
            let item = Item(
                id: prod.id ?? UUID().uuidString,
                name: prod.name ?? "--",
                image: prod.image ?? "--",
                price: prod.price ?? 0,
                category: prod.category ?? "--",
                active: true
            )
            
            categories.insert(prod.category ?? "ARTESANAL")
            items.append(item)
            // try await local.save(item)
        }
        // C. Persist all at once (Optional)
        try await addTransaction(items: items)
        
        return (items, categories)
    }
    
    func addTransaction(items: [Item]) async throws {
        // 3. We await the abstract protocol method
        try await local.save(items)
    }
    
    func fetchActiveProducts() async throws -> [Item] {
        // 1. Build the query configuration here
        var descriptor = FetchDescriptor<Item>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.name)]
        )
        
        // 2. Extra power! (You couldn't do this with Version A)
        descriptor.fetchLimit = 50
        
        return try await local.fetch(descriptor)
    }
}
