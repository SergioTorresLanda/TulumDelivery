//
//  LocalDataSource.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation
import SwiftData

protocol LocalDataSourceProtocol {
    func insertOrUpdate(products: [Item]) throws
    func addFavorite(_ product: Item) throws
    func deleteAmiibos(at offsets: IndexSet, in products: [Item]) throws
    func deleteFavorite(id: String, in favs: [Item]) throws
    func deleteFavorites(at offsets: IndexSet, in favs: [Item]) throws
    func getProducts(isFavorite: Bool) throws -> [Item]
}

class LocalDataSource: LocalDataSourceProtocol {
    
    private var modelContext: ModelContext
    //referencia del contexto. Capa entre el almacén de persistencia y los objetos en la memoria.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func insertOrUpdate(products: [Item]) throws {
       // try products.forEach { api in
           // let existing = try modelContext.fetch(FetchDescriptor<Item>(predicate: #Predicate { $0.name == api.name }))
          //  if let existingProduct = existing.first {
                // Update logic here if needed
            //} else {
                //let newProduct = AmiiboObj(amiiboObj: apiAmiibo)
               // modelContext.insert(newAmiiboObj)
            //}
       // }
    }

    func addFavorite(_ product: Item) throws {
        product.isFavorite = true
        // No hay necesidad de insertar porque el elemento ya existe en el contexto, solo se modifica la propiedad y se guarda automaticamente. Si no se guardara se puede acudir a:
       // try modelContext.save() no necesario
    }
    
    func deleteAmiibos(at offsets: IndexSet, in products: [Item]) throws {
        for index in offsets {
            modelContext.delete(products[index])
        }
        //try modelContext.save() no necesario
    }
    
    func deleteFavorite(id: String, in favs: [Item]) throws {
        if let prodToDelete = favs.first(where: { $0.id == id }) {
        modelContext.delete(prodToDelete)
      }
    //try modelContext.save() no necesario
    }
    
    func deleteFavorites(at offsets: IndexSet, in favs: [Item]) throws {
        for index in offsets {
            modelContext.delete(favs[index])
        }
    //try modelContext.save() no necesario
    }
    
    func getProducts(isFavorite: Bool) throws -> [Item] {
         let descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.isFavorite == isFavorite }, sortBy: [SortDescriptor(\.name)])
         return try modelContext.fetch(descriptor)
     }
}
