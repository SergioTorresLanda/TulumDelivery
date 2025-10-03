//
//  LocalDataSource.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation
import SwiftData

protocol LocalDataSourceProtocol {
    func deleteAmiibos(at offsets: IndexSet, in products: [Item]) throws
    func getProducts(isFavorite: Bool) throws -> [Item]
}

class LocalDataSource: LocalDataSourceProtocol {
    
    private var modelContext: ModelContext
    //referencia del contexto. Capa entre el almacén de persistencia y los objetos en la memoria.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func insertOrUpdate(products: [Item]) throws {
        for product in products {
            // Check if an item with this ID already exists
            let itemIdToMatch = product.id
            let predicate = #Predicate<Item> { $0.id == itemIdToMatch }
            var descriptor = FetchDescriptor(predicate: predicate)
            descriptor.fetchLimit = 1

            let existingItems = try modelContext.fetch(descriptor)

            if existingItems.first != nil {
                // Update existing item
             //   existingItem.name = product.name
           //     existingItem.image = product.image
                // You might choose to keep isFavorite as is, or update based on your logic
                // existingItem.isFavorite = product.isFavorite
             //   print("Updated existing item: \(existingItem.name)")
            } else {
                // Insert new item
                modelContext.insert(product)
                print("Inserted new item: \(product.name)")
            }
        }
        // Save the context if you're not doing auto-save, or if you need to ensure persistence immediately
      // Note: In SwiftUI views with @Query, changes might be automatically saved.
      // For standalone operations, explicitly saving might be necessary depending on your setup.
        try modelContext.save() // Explicitly save changes
    }

    func addFavorite(_ product: Item) throws {
        if !product.isFavorite {
            product.isFavorite = true
        }
        product.selectedItems+=1
    }
    
    func deleteAmiibos(at offsets: IndexSet, in products: [Item]) throws {
        for index in offsets {
            modelContext.delete(products[index])
        }
        //try modelContext.save() no necesario
    }
    
    func getProducts(isFavorite: Bool) throws -> [Item] {
         let descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.isFavorite == isFavorite }, sortBy: [SortDescriptor(\.name)])
         return try modelContext.fetch(descriptor)
    }
}
