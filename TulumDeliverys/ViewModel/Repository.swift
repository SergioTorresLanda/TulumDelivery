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
    func fetchAndPersistProducts() async throws
    func addFavorite(_ product: Item)
    func removeFavorite(_ product: Item)
    func deleteProducts(at offsets: IndexSet, in products: [Item])
    func deleteFavorite(id: String, in favs: [Item])
    func deleteFavorites(at offsets: IndexSet, in favs: [Item])
    func getProducts(isFavorite: Bool) throws -> [Item]
}

class Repository: ProductRepositoryProtocol {
    
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol

    private let url = URL(string: "https://www.amiiboapi.com/api/amiibo/")

    init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchAndPersistProducts() async throws {
        let api = try await remoteDataSource.fetchProductsFromAPI()
        var itemss: [Item] = []
        for prod in api {
            let item = Item(id: prod.id ?? UUID().uuidString,
                            name: prod.name,
                            image: prod.image,
                            price: prod.price,
                            category: prod.category
            )
            itemss.append(item)
        }
        
        try localDataSource.insertOrUpdate(products: itemss)
    }
    
    func deleteProducts(at offsets: IndexSet, in products: [Item]) {
        try? localDataSource.deleteAmiibos(at: offsets, in: products)
    }

    func addFavorite(_ product: Item) {
        try? localDataSource.addFavorite(product)
    }
    
    func removeFavorite(_ product: Item) {
        try? localDataSource.removeFavorite(product)
    }

    func deleteFavorite(id: String, in favs: [Item]) {
        try? localDataSource.deleteFavorite(id: id, in: favs)
    }

    func deleteFavorites(at offsets: IndexSet, in favs: [Item]) {
        try? localDataSource.deleteFavorites(at: offsets, in: favs)
    }

    func getProducts(isFavorite: Bool) throws -> [Item] {
        return try localDataSource.getProducts(isFavorite: isFavorite)
     }
}
