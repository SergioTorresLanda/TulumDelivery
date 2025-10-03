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
    func deleteProducts(at offsets: IndexSet, in products: [Item])
    func getProducts(isFavorite: Bool) throws -> [Item]
}

class Repository: ProductRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol

    init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func deleteProducts(at offsets: IndexSet, in products: [Item]) {
        try? localDataSource.deleteAmiibos(at: offsets, in: products)
    }
    
    func getProducts(isFavorite: Bool) throws -> [Item] {
        return try localDataSource.getProducts(isFavorite: isFavorite)
     }
}
